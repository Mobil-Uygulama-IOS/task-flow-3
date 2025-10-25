const mongoose = require('mongoose');

const projectSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Project title is required'],
    trim: true
  },
  description: {
    type: String,
    trim: true
  },
  iconName: {
    type: String,
    default: 'folder.fill'
  },
  iconColor: {
    type: String,
    default: 'blue'
  },
  status: {
    type: String,
    enum: ['Yapılacaklar', 'Devam Ediyor', 'Tamamlandı'],
    default: 'Yapılacaklar'
  },
  dueDate: {
    type: Date
  },
  teamLeader: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  teamMembers: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  },
  updatedAt: {
    type: Date,
    default: Date.now
  }
});

// Update timestamp
projectSchema.pre('save', function(next) {
  this.updatedAt = Date.now();
  next();
});

module.exports = mongoose.model('Project', projectSchema);
