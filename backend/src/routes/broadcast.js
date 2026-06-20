// // backend/src/routes/broadcast.js
// const express = require('express');
// const { Course, LearnerProgress, QuizResult } = require('../models/models');
// const User    = require('../models/User');
// const { protect } = require('../middleware/auth');

// const router = express.Router();

// // In-memory broadcast log (replace with DB collection in production)
// const broadcastLog = [];

// // ── POST /api/broadcast ───────────────────────────────────────
// // Send a message to all learners (or filtered subset)
// router.post('/broadcast', protect, async (req, res) => {
//   try {
//     const { message, course_id, filter } = req.body;
//     // filter: 'all' | 'enrolled' | 'inactive' | 'low_score'

//     if (!message?.trim()) {
//       return res.status(400).json({ success: false, message: 'Message is required' });
//     }

//     // Build recipient list based on filter
//     let query = { role: 'learner' };
//     let learners = await User.find(query).lean();

//     if (filter === 'enrolled' && course_id) {
//       const enrolled = await LearnerProgress.find({ course_id }).distinct('phone_number');
//       learners = learners.filter(l => enrolled.includes(l.phone_number));
//     } else if (filter === 'inactive') {
//       // Inactive = no activity in last 7 days
//       const cutoff = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
//       const active = await LearnerProgress.find({ last_active: { $gte: cutoff } }).distinct('phone_number');
//       learners = learners.filter(l => !active.includes(l.phone_number));
//     } else if (filter === 'low_score') {
//       // Low score = avg below 60%
//       const results = await QuizResult.aggregate([
//         { $group: { _id: '$phone_number', avg: { $avg: '$score' } } },
//         { $match: { avg: { $lt: 60 } } }
//       ]);
//       const lowPhones = results.map(r => r._id);
//       learners = learners.filter(l => lowPhones.includes(l.phone_number));
//     }

//     // Log the broadcast
//     const log = {
//       id:         Date.now().toString(),
//       message:    message.trim(),
//       filter:     filter || 'all',
//       course_id:  course_id || null,
//       recipients: learners.length,
//       phones:     learners.map(l => l.phone_number),
//       sent_at:    new Date(),
//       sent_by:    req.user?.name || 'Facilitator',
//       status:     'sent',
//     };
//     broadcastLog.unshift(log);

//     // In real deployment: call Twilio/Meta API here for each phone
//     // For now: simulate sending (backend processes the message for each learner)
//     // The whatsapp.js route handles actual bot responses

//     res.json({
//       success:    true,
//       message:    `Broadcast sent to ${learners.length} learner(s)`,
//       recipients: learners.length,
//       log_id:     log.id,
//     });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // ── GET /api/broadcast/logs ───────────────────────────────────
// router.get('/broadcast/logs', protect, async (req, res) => {
//   res.json({ success: true, data: broadcastLog.slice(0, 20) });
// });

// // ── GET /api/broadcast/recipients ────────────────────────────
// router.get('/broadcast/recipients', protect, async (req, res) => {
//   try {
//     const { filter, course_id } = req.query;
//     let learners = await User.find({ role: 'learner' }).lean();

//     if (filter === 'enrolled' && course_id) {
//       const enrolled = await LearnerProgress.find({ course_id }).distinct('phone_number');
//       learners = learners.filter(l => enrolled.includes(l.phone_number));
//     } else if (filter === 'inactive') {
//       const cutoff = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
//       const active = await LearnerProgress.find({ last_active: { $gte: cutoff } }).distinct('phone_number');
//       learners = learners.filter(l => !active.includes(l.phone_number));
//     } else if (filter === 'low_score') {
//       const results = await QuizResult.aggregate([
//         { $group: { _id: '$phone_number', avg: { $avg: '$score' } } },
//         { $match: { avg: { $lt: 60 } } }
//       ]);
//       const lowPhones = results.map(r => r._id);
//       learners = learners.filter(l => lowPhones.includes(l.phone_number));
//     }

//     res.json({ success: true, count: learners.length, data: learners.map(l => ({
//       name: l.name, phone: l.phone_number, department: l.department, job_role: l.job_role
//     })) });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// module.exports = router;



















// // backend/src/routes/broadcast.js
// const express = require('express');
// const { LearnerProgress } = require('../models/models');
// const User    = require('../models/User');
// const { protect } = require('../middleware/auth');
// const whatsappService = require('../services/whatsappService');

// const router = express.Router();
// const logs   = [];

// // ── POST /api/broadcast ────────────────────────────────────────
// router.post('/broadcast', protect, async (req, res) => {
//   try {
//     const { message, filter = 'all', course_id } = req.body;
//     if (!message) {
//       return res.status(400).json({ success: false, message: 'message is required' });
//     }

//     // Get learner phone numbers based on filter
//     let phones = [];

//     if (filter === 'all') {
//       const learners = await User.find({ role: 'learner', is_active: true });
//       phones = learners.map(l => l.phone_number).filter(Boolean);

//     } else if (filter === 'enrolled' && course_id) {
//       const progress = await LearnerProgress.find({ course_id });
//       phones = [...new Set(progress.map(p => p.phone_number))];

//     } else if (filter === 'active') {
//       const progress = await LearnerProgress.find({ quizzes_taken: { $gt: 0 } });
//       phones = [...new Set(progress.map(p => p.phone_number))];

//     } else if (filter === 'inactive') {
//       const allLearners = await User.find({ role: 'learner' });
//       const activeProg  = await LearnerProgress.find({ quizzes_taken: { $gt: 0 } });
//       const activePhones = new Set(activeProg.map(p => p.phone_number));
//       phones = allLearners
//         .map(l => l.phone_number)
//         .filter(p => p && !activePhones.has(p));

//     } else if (filter === 'not_started') {
//       const allLearners = await User.find({ role: 'learner' });
//       const started     = await LearnerProgress.distinct('phone_number');
//       const startedSet  = new Set(started);
//       phones = allLearners
//         .map(l => l.phone_number)
//         .filter(p => p && !startedSet.has(p));
//     }

//     if (phones.length === 0) {
//       return res.json({
//         success: true,
//         message: 'No learners found for this filter',
//         sent: 0,
//       });
//     }

//     // Send via Route Mobile
//     const results = await whatsappService.sendBulkMessages(phones, message);
//     const sent    = results.filter(r => r.success).length;
//     const failed  = results.filter(r => !r.success).length;

//     // Log it
//     logs.unshift({
//       id:              Date.now().toString(),
//       message:         message.substring(0, 100),
//       filter,
//       recipient_count: phones.length,
//       sent,
//       failed,
//       type:            req.body.type || 'broadcast',
//       created_at:      new Date().toISOString(),
//     });

//     console.log(`📣 Broadcast: ${sent}/${phones.length} sent successfully`);

//     res.json({
//       success: true,
//       message: `Sent to ${sent} of ${phones.length} learners`,
//       sent, failed,
//       recipients: phones.length,
//     });

//   } catch (err) {
//     console.error('Broadcast error:', err);
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // ── GET /api/broadcast/logs ────────────────────────────────────
// router.get('/broadcast/logs', protect, (req, res) => {
//   res.json({ success: true, data: logs });
// });

// module.exports = router;
























// backend/src/routes/broadcast.js
const express = require('express');
const { LearnerProgress } = require('../models/models');
const User    = require('../models/User');
const { protect } = require('../middleware/auth');
const whatsappService = require('../services/whatsappService');

const router = express.Router();
const logs   = [];

// ── POST /api/broadcast ────────────────────────────────────────
router.post('/broadcast', protect, async (req, res) => {
  try {
    const { message, filter = 'all', course_id } = req.body;
    if (!message) {
      return res.status(400).json({ success: false, message: 'message is required' });
    }

    let phones = [];

    if (filter === 'all') {
      const learners = await User.find({ role: 'learner' });
      phones = learners.map(l => l.phone_number).filter(Boolean);

    } else if (filter === 'enrolled' && course_id) {
      const progress = await LearnerProgress.find({ course_id: course_id });
      phones = [...new Set(progress.map(p => p.phone_number))];

    } else if (filter === 'active') {
      const progress = await LearnerProgress.find({ quizzes_taken: { $gt: 0 } });
      phones = [...new Set(progress.map(p => p.phone_number))];

    } else if (filter === 'inactive') {
      const all     = await User.find({ role: 'learner' });
      const active  = await LearnerProgress.find({ quizzes_taken: { $gt: 0 } });
      const activeSet = new Set(active.map(p => p.phone_number));
      phones = all.map(l => l.phone_number).filter(p => p && !activeSet.has(p));

    } else if (filter === 'not_started') {
      const all     = await User.find({ role: 'learner' });
      const started = await LearnerProgress.distinct('phone_number');
      const startedSet = new Set(started);
      phones = all.map(l => l.phone_number).filter(p => p && !startedSet.has(p));
    }

    console.log(`📣 Broadcasting to ${phones.length} learners:`, phones);

    if (phones.length === 0) {
      return res.json({
        success: true,
        message: 'No learners found for this filter',
        sent: 0, recipients: 0,
      });
    }

    // Send via Twilio WhatsApp
    const results = await whatsappService.sendBulkMessages(phones, message);
    const sent    = results.filter(r => r.success).length;
    const failed  = results.filter(r => !r.success).length;

    // Log
    logs.unshift({
      id:              Date.now().toString(),
      message:         message.substring(0, 100),
      filter,
      recipient_count: phones.length,
      sent, failed,
      type:            req.body.type || 'broadcast',
      created_at:      new Date().toISOString(),
    });

    console.log(`✅ Broadcast: ${sent}/${phones.length} sent`);

    res.json({
      success: true,
      message: `Sent to ${sent} of ${phones.length} learners`,
      sent, failed, recipients: phones.length,
    });

  } catch (err) {
    console.error('Broadcast error:', err);
    res.status(500).json({ success: false, message: err.message });
  }
});

// ── GET /api/broadcast/logs ────────────────────────────────────
router.get('/broadcast/logs', protect, (req, res) => {
  res.json({ success: true, data: logs });
});

module.exports = router;