// require('dotenv').config();
// const express = require('express');
// const mongoose = require('mongoose');
// const cors = require('cors');

// // Import routes
// const authRoutes = require('./routes/auth');
// const courseRoutes = require('./routes/courses');
// const quizRoutes = require('./routes/quizzes');
// const progressRoutes = require('./routes/progress');
// const whatsappRoutes = require('./routes/whatsapp');

// const app = express();

// // ── Middleware ────────────────────────────────────────────────
// app.use(cors());
// app.use(express.json());
// app.use(express.urlencoded({ extended: true }));

// // ── Request logger (development) ──────────────────────────────
// if (process.env.NODE_ENV === 'development') {
//   app.use((req, res, next) => {
//     console.log(`${new Date().toISOString()} | ${req.method} ${req.path}`);
//     next();
//   });
// }

// // ── Routes ────────────────────────────────────────────────────
// app.use('/api', authRoutes);
// app.use('/api', courseRoutes);
// app.use('/api', quizRoutes);
// app.use('/api/progress', progressRoutes);   // ← FIXED: was /api, now /api/progress
// app.use('/api/whatsapp', whatsappRoutes);

// // ── Health check ──────────────────────────────────────────────
// app.get('/health', (req, res) => {
//   res.json({
//     status: 'OK',
//     service: 'Andragogy Backend',
//     version: '1.0.0',
//     timestamp: new Date().toISOString(),
//     database: mongoose.connection.readyState === 1 ? 'Connected' : 'Disconnected',
//   });
// });

// // ── 404 handler ───────────────────────────────────────────────
// app.use((req, res) => {
//   res.status(404).json({ success: false, message: `Route ${req.method} ${req.path} not found.` });
// });

// // ── Error handler ─────────────────────────────────────────────
// app.use((err, req, res, next) => {
//   console.error(err.stack);
//   res.status(500).json({ success: false, message: 'Internal server error.' });
// });

// // ── Connect to MongoDB and start server ───────────────────────
// const PORT = process.env.PORT || 5000;

// mongoose.connect(process.env.MONGODB_URI)
//   .then(() => {
//     console.log('✅ MongoDB Atlas connected');
//     app.listen(PORT, () => {
//       console.log(`🚀 Andragogy Backend running on port ${PORT}`);
//       console.log(`📡 WhatsApp simulation: POST http://localhost:${PORT}/api/whatsapp/message`);
//       console.log(`🏥 Health check: http://localhost:${PORT}/health`);
//     });
//   })
//   .catch((err) => {
//     console.error('❌ MongoDB connection failed:', err.message);
//     process.exit(1);
//   });

// module.exports = app;








// // require('dotenv').config();
// // const express  = require('express');
// // const mongoose = require('mongoose');
// // const cors     = require('cors');

// // const authRoutes      = require('./routes/auth');
// // const courseRoutes    = require('./routes/courses');
// // const quizRoutes      = require('./routes/quizzes');
// // const progressRoutes  = require('./routes/progress');
// // const whatsappRoutes  = require('./routes/whatsapp');

// // const app = express();

// // // ── CORS — allow ALL origins (needed for HTML file & Flutter web) ──
// // app.use(cors({
// //   origin: '*',
// //   methods: ['GET','POST','PUT','DELETE','OPTIONS'],
// //   allowedHeaders: ['Content-Type','Authorization'],
// // }));
// // app.options('*', cors()); // handle preflight

// // app.use(express.json());
// // app.use(express.urlencoded({ extended: true }));

// // // ── Logger ─────────────────────────────────────────────────────
// // app.use((req, res, next) => {
// //   console.log(`${new Date().toISOString().slice(11,19)} | ${req.method} ${req.path}`);
// //   next();
// // });

// // // ── Routes ─────────────────────────────────────────────────────
// // app.use('/api', authRoutes);
// // app.use('/api', courseRoutes);
// // app.use('/api', quizRoutes);
// // app.use('/api', progressRoutes);
// // app.use('/api/whatsapp', whatsappRoutes);

// // // ── Health check ───────────────────────────────────────────────
// // app.get('/health', (req, res) => {
// //   res.json({
// //     status: 'OK',
// //     service: 'Andragogy Backend',
// //     database: mongoose.connection.readyState === 1 ? 'Connected' : 'Disconnected',
// //     timestamp: new Date().toISOString(),
// //   });
// // });

// // // ── 404 ────────────────────────────────────────────────────────
// // app.use((req, res) => {
// //   res.status(404).json({ success: false, message: `Route ${req.method} ${req.path} not found.` });
// // });

// // // ── Error handler ──────────────────────────────────────────────
// // app.use((err, req, res, next) => {
// //   console.error(err.stack);
// //   res.status(500).json({ success: false, message: 'Internal server error.' });
// // });

// // // ── Connect DB + start server ──────────────────────────────────
// // const PORT = process.env.PORT || 5000;

// // mongoose.connect(process.env.MONGODB_URI)
// //   .then(() => {
// //     console.log('✅ MongoDB Atlas connected');
// //     app.listen(PORT, () => {
// //       console.log(`🚀 Backend running on http://localhost:${PORT}`);
// //       console.log(`📡 WhatsApp endpoint: POST http://localhost:${PORT}/api/whatsapp/message`);
// //       console.log(`🏥 Health check:      http://localhost:${PORT}/health`);
// //     });
// //   })
// //   .catch(err => {
// //     console.error('❌ MongoDB connection failed:', err.message);
// //     process.exit(1);
// //   });

// // module.exports = app;


















require('dotenv').config();
const express  = require('express');
const mongoose = require('mongoose');
const cors     = require('cors');

// ── Routes ────────────────────────────────────────────────────
const authRoutes      = require('./routes/auth');
const courseRoutes    = require('./routes/courses');
const quizRoutes      = require('./routes/quizzes');
const progressRoutes  = require('./routes/progress');
const whatsappRoutes  = require('./routes/whatsapp');
const broadcastRoutes = require('./routes/broadcast');
const pollRoutes      = require('./routes/polls');
const alertRoutes     = require('./routes/alerts');

const app = express();

// ── Middleware ────────────────────────────────────────────────
app.use(cors({ origin: '*', methods: ['GET','POST','PUT','DELETE','OPTIONS'] }));
app.options('*', cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ── Logger ────────────────────────────────────────────────────
app.use((req, res, next) => {
  console.log(`${new Date().toISOString()} | ${req.method} ${req.path}`);
  next();
});

// ── Register all routes ───────────────────────────────────────
app.use('/api', authRoutes);
app.use('/api', courseRoutes);
app.use('/api', quizRoutes);
app.use('/api', progressRoutes);   // ← /api/progress
app.use('/api', broadcastRoutes);  // ← /api/broadcast
app.use('/api', pollRoutes);       // ← /api/polls
app.use('/api', alertRoutes);      // ← /api/alerts
app.use('/api/whatsapp', whatsappRoutes);

// ── Health check ──────────────────────────────────────────────
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    service: 'Andragogy Backend',
    version: '1.0.0',
    timestamp: new Date().toISOString(),
    database: mongoose.connection.readyState === 1 ? 'Connected' : 'Disconnected',
  });
});

// ── 404 handler ───────────────────────────────────────────────
app.use((req, res) => {
  res.status(404).json({ success: false, message: `Route ${req.method} ${req.path} not found.` });
});

// ── Error handler ─────────────────────────────────────────────
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ success: false, message: 'Internal server error.' });
});

// ── Connect MongoDB + start server ────────────────────────────
const PORT = process.env.PORT || 5000;

mongoose.connect(process.env.MONGODB_URI)
  .then(() => {
    console.log('✅ MongoDB Atlas connected');
    app.listen(PORT, () => {
      console.log(`🚀 Andragogy Backend running on port ${PORT}`);
      console.log(`📡 WhatsApp webhook: POST http://localhost:${PORT}/api/whatsapp/message`);
      console.log(`🏥 Health check: http://localhost:${PORT}/health`);
    });
  })
  .catch((err) => {
    console.error('❌ MongoDB connection failed:', err.message);
    process.exit(1);
  });

module.exports = app;