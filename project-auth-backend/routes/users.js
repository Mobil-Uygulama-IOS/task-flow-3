const express = require('express');
const router = express.Router();
const { v4: uuidv4 } = require('uuid');
const User = require('../models/User');

// @route   POST /api/users
// @desc    Create a new user
// @access  Public
router.post('/', async (req, res) => {
  try {
    const { username, email, password, displayName, photoUrl } = req.body;

    // Validation
    if (!username || !email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Please provide username, email and password'
      });
    }

    // Check if user already exists
    const existingUser = await User.findOne({
      $or: [{ email }, { username }]
    });

    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: existingUser.email === email 
          ? 'User already exists with this email'
          : 'Username is already taken'
      });
    }

    // Create new user
    const user = await User.create({
      uid: uuidv4(),
      username,
      email,
      password,
      displayName: displayName || username,
      photoUrl
    });

    res.status(201).json({
      success: true,
      message: 'User created successfully',
      data: {
        uid: user.uid,
        username: user.username,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error creating user',
      error: error.message
    });
  }
});

// @route   GET /api/users
// @desc    Get all users
// @access  Public
router.get('/', async (req, res) => {
  try {
    // Get all users (excluding password field)
    const users = await User.find().select('-password');

    res.status(200).json({
      success: true,
      count: users.length,
      data: users
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching users',
      error: error.message
    });
  }
});

module.exports = router;
