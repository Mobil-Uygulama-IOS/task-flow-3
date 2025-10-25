const express = require('express');
const router = express.Router();
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const User = require('../models/User');

// Generate JWT Token
const generateToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRE
  });
};

// @route   POST /api/auth/register
// @desc    Register a new user
// @access  Public
router.post('/register', async (req, res) => {
  try {
    const { email, password, username, displayName } = req.body;

    // Validation
    if (!email || !password || !username) {
      return res.status(400).json({
        success: false,
        message: 'Please provide email, password and username'
      });
    }

    // Check if user exists (email or username)
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

    // Create user
    const user = await User.create({
      uid: uuidv4(),
      username,
      email,
      password,
      displayName: displayName || username
    });

    // Generate token
    const token = generateToken(user._id);

    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      data: {
        uid: user.uid,
        username: user.username,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl
      },
      token
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error registering user',
      error: error.message
    });
  }
});

// @route   POST /api/auth/login
// @desc    Login user
// @access  Public
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validation
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Please provide email/username and password'
      });
    }

    // Check if user exists (by email or username)
    const user = await User.findOne({ 
      $or: [{ email }, { username: email }] 
    }).select('+password');
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    // Check password
    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    // Generate token
    const token = generateToken(user._id);

    res.status(200).json({
      success: true,
      message: 'Login successful',
      data: {
        uid: user.uid,
        username: user.username,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl
      },
      token
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error logging in',
      error: error.message
    });
  }
});

// @route   GET /api/auth/me
// @desc    Get current user
// @access  Private
const { protect } = require('../middleware/auth');

router.get('/me', protect, async (req, res) => {
  try {
    const user = await User.findById(req.user._id);

    res.status(200).json({
      success: true,
      data: {
        uid: user.uid,
        username: user.username,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error fetching user data',
      error: error.message
    });
  }
});

// @route   PUT /api/auth/update
// @desc    Update user profile
// @access  Private
router.put('/update', protect, async (req, res) => {
  try {
    const { displayName, photoUrl } = req.body;

    const user = await User.findByIdAndUpdate(
      req.user._id,
      { displayName, photoUrl },
      { new: true, runValidators: true }
    );

    res.status(200).json({
      success: true,
      message: 'Profile updated successfully',
      data: {
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoUrl
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error updating profile',
      error: error.message
    });
  }
});

module.exports = router;
