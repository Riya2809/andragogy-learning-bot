# Andragogy — WhatsApp-Based Mobile Learning App
## 70% Functional Prototype

---

## System Architecture

```
Learner (WhatsApp) → POST /api/whatsapp/message → Node.js Server
                                                        ↓
                                               MongoDB Atlas DB
                                                        ↓
Flutter Dashboard ← GET /api/progress ← Node.js Server
```

---

## Project Structure

```
andragogy_system/
├── backend/                  ← Node.js + Express server
│   ├── src/
│   │   ├── server.js         ← Main entry point
│   │   ├── models/
│   │   │   ├── User.js
│   │   │   └── models.js     ← Course, Module, Quiz, Progress
│   │   ├── routes/
│   │   │   ├── auth.js       ← POST /login, /register
│   │   │   ├── courses.js    ← CRUD /courses, /modules
│   │   │   ├── quizzes.js    ← CRUD /quizzes, /submitQuiz
│   │   │   ├── progress.js   ← GET /progress
│   │   │   └── whatsapp.js   ← POST /whatsapp/message (chatbot)
│   │   ├── middleware/
│   │   │   └── auth.js       ← JWT middleware
│   │   └── services/
│   │       └── nlpService.js ← Rule-based NLP engine
│   ├── .env                  ← Environment variables
│   └── package.json
│
└── flutter/                  ← Flutter facilitator dashboard
    ├── lib/
    │   ├── main.dart
    │   ├── models/models.dart
    │   ├── services/
    │   │   ├── api_service.dart
    │   │   └── app_theme.dart
    │   └── screens/
    │       ├── login_screen.dart
    │       ├── dashboard_screen.dart
    │       ├── courses_screen.dart
    │       ├── quiz_screen.dart
    │       ├── progress_screen.dart
    │       └── whatsapp_sim_screen.dart
    └── pubspec.yaml
```

---

## Step 1 — MongoDB Atlas Setup

1. Go to https://mongodb.com/atlas and create a free account
2. Create a free cluster (M0)
3. Create a database user (username + password)
4. Whitelist IP: 0.0.0.0/0 (allow all for development)
5. Click "Connect" → "Connect your application"
6. Copy the connection string — looks like:
   `mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/`

---

## Step 2 — Backend Setup

```bash
cd andragogy_system/backend

# Install dependencies
npm install

# Edit .env file — paste your MongoDB URI
# MONGODB_URI=mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/andragogy

# Start the server
npm run dev
```

Server starts at: **http://localhost:5000**

Check it's working: http://localhost:5000/health

---

## Step 3 — Flutter Setup

```bash
cd andragogy_system/flutter

# Install dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome

# OR run on Windows
flutter run -d windows
```

> **Note:** Make sure the backend is running before starting Flutter.
> The backend URL is set in `lib/services/api_service.dart` as `baseUrl`.

---

## API Reference

### Authentication
```
POST /api/register     { name, email, phone_number, password }
POST /api/login        { email, password }
```

### Courses
```
GET  /api/courses
POST /api/courses      { title, description }           [Auth required]
DELETE /api/courses/:id                                  [Auth required]
```

### Modules
```
GET  /api/modules/:courseId
POST /api/modules      { course_id, title, description, pdf_link, video_link, order }
```

### Quizzes
```
GET  /api/quizzes/:courseId
POST /api/quizzes      { course_id, question, options:{A,B,C,D}, correct_answer }
POST /api/submitQuiz   { phone_number, course_id, answers:[{question_id, answer}] }
```

### Progress
```
GET /api/progress                    ← All learners
GET /api/progress/:phoneNumber       ← Specific learner
```

### WhatsApp Simulation
```
POST /api/whatsapp/message   { phone: "9876543210", message: "START" }
```

---

## WhatsApp Chatbot Commands

| Command | Response |
|---------|----------|
| `START` or `HI` | Shows course list |
| `1`, `2`, `3`... | Selects a course |
| `NEXT` | Goes to next module |
| `QUIZ` | Starts the quiz |
| `A` / `B` / `C` / `D` | Answers a quiz question |
| `PROGRESS` | Shows learner's progress |
| `HELP` | Shows all commands |
| `What is the internet?` | NLP answer |
| `Explain cloud computing` | NLP answer |

---

## NLP Knowledge Base Topics

The rule-based NLP service handles questions about:
- Internet & networking
- Cloud computing
- Digital literacy
- Computers & hardware
- Email
- Password security
- Web browsers
- Social media
- Cybersecurity & viruses
- Wi-Fi
- Search engines
- Smartphones

---

## Testing the WhatsApp Bot (without Flutter)

Use any API tool (Postman, curl, Insomnia):

```bash
# Test START command
curl -X POST http://localhost:5000/api/whatsapp/message \
  -H "Content-Type: application/json" \
  -d '{"phone": "9876543210", "message": "START"}'

# Select course 1
curl -X POST http://localhost:5000/api/whatsapp/message \
  -H "Content-Type: application/json" \
  -d '{"phone": "9876543210", "message": "1"}'

# Ask NLP question
curl -X POST http://localhost:5000/api/whatsapp/message \
  -H "Content-Type: application/json" \
  -d '{"phone": "9876543210", "message": "What is cloud computing?"}'
```

---

## Replacing WhatsApp Simulation with Real API

When you get the real WhatsApp Business API:

1. Open `backend/src/routes/whatsapp.js`
2. The endpoint `POST /api/whatsapp/message` is already structured to receive messages
3. Point your WhatsApp webhook to: `POST https://yourdomain.com/api/whatsapp/message`
4. The request format stays the same: `{ phone, message }`

---

## What's Implemented (70%)

- ✅ Facilitator login / register with JWT
- ✅ Course creation & management
- ✅ Module creation with PDF & video links
- ✅ Quiz creation with A/B/C/D options
- ✅ WhatsApp chatbot simulation (full conversation flow)
- ✅ Learner enrollment via WhatsApp
- ✅ Quiz taking via WhatsApp with scoring
- ✅ Progress tracking per learner
- ✅ NLP question answering (12 topics)
- ✅ Flutter dashboard with all 5 screens
- ✅ Score distribution charts
- ✅ MongoDB Atlas integration

## Remaining 30%

- 🔲 Real WhatsApp Business API webhook
- 🔲 Push notifications to learners
- 🔲 File upload for PDFs/videos
- 🔲 Advanced AI (OpenAI/Claude API integration)
- 🔲 Facilitator can broadcast to all learners
- 🔲 Production deployment (Railway/Render + MongoDB Atlas)
