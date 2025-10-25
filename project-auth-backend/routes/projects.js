const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/auth');
const Project = require('../models/Project');
const Task = require('../models/Task');

// @route   GET /api/projects
// @desc    Get all projects for logged in user
// @access  Private
router.get('/', protect, async (req, res) => {
  try {
    const projects = await Project.find({
      $or: [
        { createdBy: req.user._id },
        { teamMembers: req.user._id },
        { teamLeader: req.user._id }
      ]
    })
    .populate('teamLeader', 'uid email displayName photoUrl')
    .populate('teamMembers', 'uid email displayName photoUrl')
    .sort('-createdAt');

    // Get task counts for each project
    const projectsWithTasks = await Promise.all(
      projects.map(async (project) => {
        const tasks = await Task.find({ projectId: project._id });
        const completedTasks = tasks.filter(task => task.isCompleted);
        
        return {
          ...project.toObject(),
          tasksCount: tasks.length,
          completedTasksCount: completedTasks.length,
          tasks: tasks
        };
      })
    );

    res.status(200).json({
      success: true,
      count: projectsWithTasks.length,
      data: projectsWithTasks
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching projects',
      error: error.message
    });
  }
});

// @route   GET /api/projects/:id
// @desc    Get single project
// @access  Private
router.get('/:id', protect, async (req, res) => {
  try {
    const project = await Project.findById(req.params.id)
      .populate('teamLeader', 'uid email displayName photoUrl')
      .populate('teamMembers', 'uid email displayName photoUrl');

    if (!project) {
      return res.status(404).json({
        success: false,
        message: 'Project not found'
      });
    }

    // Get tasks for this project
    const tasks = await Task.find({ projectId: project._id })
      .populate('assignee', 'uid email displayName photoUrl')
      .populate('comments.author', 'uid email displayName photoUrl');

    res.status(200).json({
      success: true,
      data: {
        ...project.toObject(),
        tasks: tasks
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching project',
      error: error.message
    });
  }
});

// @route   POST /api/projects
// @desc    Create new project
// @access  Private
router.post('/', protect, async (req, res) => {
  try {
    const { title, description, iconName, iconColor, status, dueDate, teamMembers } = req.body;

    if (!title) {
      return res.status(400).json({
        success: false,
        message: 'Project title is required'
      });
    }

    const project = await Project.create({
      title,
      description,
      iconName,
      iconColor,
      status,
      dueDate,
      teamLeader: req.user._id,
      teamMembers: teamMembers || [],
      createdBy: req.user._id
    });

    const populatedProject = await Project.findById(project._id)
      .populate('teamLeader', 'uid email displayName photoUrl')
      .populate('teamMembers', 'uid email displayName photoUrl');

    res.status(201).json({
      success: true,
      message: 'Project created successfully',
      data: populatedProject
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error creating project',
      error: error.message
    });
  }
});

// @route   PUT /api/projects/:id
// @desc    Update project
// @access  Private
router.put('/:id', protect, async (req, res) => {
  try {
    let project = await Project.findById(req.params.id);

    if (!project) {
      return res.status(404).json({
        success: false,
        message: 'Project not found'
      });
    }

    // Check if user is project creator or team leader
    if (project.createdBy.toString() !== req.user._id.toString() && 
        project.teamLeader.toString() !== req.user._id.toString()) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to update this project'
      });
    }

    project = await Project.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    )
    .populate('teamLeader', 'uid email displayName photoUrl')
    .populate('teamMembers', 'uid email displayName photoUrl');

    res.status(200).json({
      success: true,
      message: 'Project updated successfully',
      data: project
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating project',
      error: error.message
    });
  }
});

// @route   DELETE /api/projects/:id
// @desc    Delete project
// @access  Private
router.delete('/:id', protect, async (req, res) => {
  try {
    const project = await Project.findById(req.params.id);

    if (!project) {
      return res.status(404).json({
        success: false,
        message: 'Project not found'
      });
    }

    // Check if user is project creator
    if (project.createdBy.toString() !== req.user._id.toString()) {
      return res.status(403).json({
        success: false,
        message: 'Not authorized to delete this project'
      });
    }

    // Delete all tasks associated with this project
    await Task.deleteMany({ projectId: project._id });

    await project.deleteOne();

    res.status(200).json({
      success: true,
      message: 'Project and associated tasks deleted successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error deleting project',
      error: error.message
    });
  }
});

module.exports = router;
