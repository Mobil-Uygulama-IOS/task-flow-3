const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/auth');
const Task = require('../models/Task');
const Project = require('../models/Project');

// @route   GET /api/tasks
// @desc    Get all tasks for logged in user
// @access  Private
router.get('/', protect, async (req, res) => {
  try {
    const tasks = await Task.find({ createdBy: req.user._id })
      .populate('assignee', 'uid email displayName photoUrl')
      .populate('projectId', 'title')
      .populate('comments.author', 'uid email displayName photoUrl')
      .sort('-createdAt');

    res.status(200).json({
      success: true,
      count: tasks.length,
      data: tasks
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching tasks',
      error: error.message
    });
  }
});

// @route   GET /api/tasks/:id
// @desc    Get single task
// @access  Private
router.get('/:id', protect, async (req, res) => {
  try {
    const task = await Task.findById(req.params.id)
      .populate('assignee', 'uid email displayName photoUrl')
      .populate('projectId', 'title')
      .populate('comments.author', 'uid email displayName photoUrl');

    if (!task) {
      return res.status(404).json({
        success: false,
        message: 'Task not found'
      });
    }

    res.status(200).json({
      success: true,
      data: task
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching task',
      error: error.message
    });
  }
});

// @route   POST /api/tasks
// @desc    Create new task
// @access  Private
router.post('/', protect, async (req, res) => {
  try {
    const { title, description, projectId, assignee, priority, dueDate } = req.body;

    if (!title || !projectId) {
      return res.status(400).json({
        success: false,
        message: 'Task title and project ID are required'
      });
    }

    // Check if project exists
    const project = await Project.findById(projectId);
    if (!project) {
      return res.status(404).json({
        success: false,
        message: 'Project not found'
      });
    }

    const task = await Task.create({
      title,
      description,
      projectId,
      assignee,
      priority,
      dueDate,
      createdBy: req.user._id
    });

    const populatedTask = await Task.findById(task._id)
      .populate('assignee', 'uid email displayName photoUrl')
      .populate('projectId', 'title');

    res.status(201).json({
      success: true,
      message: 'Task created successfully',
      data: populatedTask
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error creating task',
      error: error.message
    });
  }
});

// @route   PUT /api/tasks/:id
// @desc    Update task
// @access  Private
router.put('/:id', protect, async (req, res) => {
  try {
    let task = await Task.findById(req.params.id);

    if (!task) {
      return res.status(404).json({
        success: false,
        message: 'Task not found'
      });
    }

    task = await Task.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true }
    )
    .populate('assignee', 'uid email displayName photoUrl')
    .populate('projectId', 'title')
    .populate('comments.author', 'uid email displayName photoUrl');

    res.status(200).json({
      success: true,
      message: 'Task updated successfully',
      data: task
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating task',
      error: error.message
    });
  }
});

// @route   DELETE /api/tasks/:id
// @desc    Delete task
// @access  Private
router.delete('/:id', protect, async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);

    if (!task) {
      return res.status(404).json({
        success: false,
        message: 'Task not found'
      });
    }

    await task.deleteOne();

    res.status(200).json({
      success: true,
      message: 'Task deleted successfully'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error deleting task',
      error: error.message
    });
  }
});

// @route   POST /api/tasks/:id/comments
// @desc    Add comment to task
// @access  Private
router.post('/:id/comments', protect, async (req, res) => {
  try {
    const { content } = req.body;

    if (!content) {
      return res.status(400).json({
        success: false,
        message: 'Comment content is required'
      });
    }

    const task = await Task.findById(req.params.id);

    if (!task) {
      return res.status(404).json({
        success: false,
        message: 'Task not found'
      });
    }

    task.comments.push({
      author: req.user._id,
      content
    });

    await task.save();

    const populatedTask = await Task.findById(task._id)
      .populate('assignee', 'uid email displayName photoUrl')
      .populate('comments.author', 'uid email displayName photoUrl');

    res.status(200).json({
      success: true,
      message: 'Comment added successfully',
      data: populatedTask
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error adding comment',
      error: error.message
    });
  }
});

// @route   PUT /api/tasks/:id/toggle
// @desc    Toggle task completion status
// @access  Private
router.put('/:id/toggle', protect, async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);

    if (!task) {
      return res.status(404).json({
        success: false,
        message: 'Task not found'
      });
    }

    task.isCompleted = !task.isCompleted;
    await task.save();

    const populatedTask = await Task.findById(task._id)
      .populate('assignee', 'uid email displayName photoUrl')
      .populate('projectId', 'title');

    res.status(200).json({
      success: true,
      message: 'Task status updated successfully',
      data: populatedTask
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating task status',
      error: error.message
    });
  }
});

module.exports = router;
