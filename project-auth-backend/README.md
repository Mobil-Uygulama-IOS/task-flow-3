# Task Flow Backend API

Express.js + MongoDB backend API for Task Flow project management application.

## 🚀 Features

- **Authentication**: JWT-based user authentication
- **User Management**: Register, login, profile updates
- **Projects**: CRUD operations for projects
- **Tasks**: CRUD operations for tasks
- **Comments**: Add comments to tasks
- **Team Management**: Assign team members and leaders

## 📋 Prerequisites

Before running this project, make sure you have:

- Node.js (v14 or higher)
- MongoDB (v4.4 or higher)
- npm or yarn

## 🛠️ Installation

### 1. Install Node.js (via Homebrew on macOS)

```bash
# Install Homebrew if not installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Node.js
brew install node
```

### 2. Install MongoDB

```bash
# Install MongoDB Community Edition
brew tap mongodb/brew
brew install mongodb-community

# Start MongoDB service
brew services start mongodb-community
```

### 3. Install Project Dependencies

```bash
cd project-auth-backend
npm install
```


## ⚙️ Configuration

1. Create a `.env` file (already created):
```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/taskflow
JWT_SECRET=your-super-secret-jwt-key-change-this-in-production
JWT_EXPIRE=7d
NODE_ENV=development
```

2. Update `JWT_SECRET` with a strong secret key for production

## 🏃 Running the Server

### Development Mode (with auto-reload)
```bash
npm run dev
```

### Production Mode
```bash
npm start
```

The server will start on `http://localhost:3000`

## 📚 API Endpoints

### Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/register` | Register new user | No |
| POST | `/api/auth/login` | Login user | No |
| GET | `/api/auth/me` | Get current user | Yes |
| PUT | `/api/auth/update` | Update profile | Yes |

### Projects

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/projects` | Get all projects | Yes |
| GET | `/api/projects/:id` | Get single project | Yes |
| POST | `/api/projects` | Create project | Yes |
| PUT | `/api/projects/:id` | Update project | Yes |
| DELETE | `/api/projects/:id` | Delete project | Yes |

### Tasks

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/tasks` | Get all tasks | Yes |
| GET | `/api/tasks/:id` | Get single task | Yes |
| POST | `/api/tasks` | Create task | Yes |
| PUT | `/api/tasks/:id` | Update task | Yes |
| DELETE | `/api/tasks/:id` | Delete task | Yes |
| POST | `/api/tasks/:id/comments` | Add comment | Yes |
| PUT | `/api/tasks/:id/toggle` | Toggle completion | Yes |

### Health Check

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/health` | Check API status | No |

## 📝 Request/Response Examples

### Register User
```bash
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "displayName": "John Doe"
}
```

### Login
```bash
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

### Create Project
```bash
POST /api/projects
Authorization: Bearer <your-jwt-token>
Content-Type: application/json

{
  "title": "New Project",
  "description": "Project description",
  "status": "Yapılacaklar",
  "dueDate": "2025-12-31",
  "teamMembers": []
}
```

### Create Task
```bash
POST /api/tasks
Authorization: Bearer <your-jwt-token>
Content-Type: application/json

{
  "title": "New Task",
  "description": "Task description",
  "projectId": "project-id-here",
  "priority": "Yüksek",
  "dueDate": "2025-11-30"
}
```

## 🗂️ Project Structure

```
project-auth-backend/
├── models/
│   ├── User.js          # User model
│   ├── Project.js       # Project model
│   └── Task.js          # Task model
├── routes/
│   ├── auth.js          # Authentication routes
│   ├── projects.js      # Project routes
│   └── tasks.js         # Task routes
├── middleware/
│   └── auth.js          # JWT authentication middleware
├── .env                 # Environment variables
├── .gitignore          # Git ignore file
├── server.js           # Main server file
├── package.json        # Dependencies
└── README.md           # This file
```

## 🔒 Security

- Passwords are hashed using bcrypt
- JWT tokens for secure authentication
- Protected routes require valid JWT token
- CORS enabled for cross-origin requests

## 🧪 Testing the API

You can test the API using:

- **Postman**: Import endpoints and test
- **cURL**: Command line testing
- **iOS App**: Connect your Swift app

### Example cURL Request
```bash
# Register
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123","displayName":"Test User"}'

# Login
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'
```

## 🐛 Troubleshooting

### MongoDB Connection Issues
```bash
# Check if MongoDB is running
brew services list | grep mongodb

# Restart MongoDB
brew services restart mongodb-community
```

### Port Already in Use
```bash
# Change PORT in .env file or kill process
lsof -ti:3000 | xargs kill -9
```

## 📦 Dependencies

- **express**: Web framework
- **mongoose**: MongoDB ODM
- **bcryptjs**: Password hashing
- **jsonwebtoken**: JWT authentication
- **cors**: Enable CORS
- **dotenv**: Environment variables

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

ISC License

## 👨‍💻 Author

Task Flow Backend API

---

Made with ❤️ for Task Flow iOS App
