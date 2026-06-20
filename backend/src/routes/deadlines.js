// backend/src/routes/deadlines.js
const express = require('express');
const { Course, QuizQuestion, LearnerProgress, QuizResult } = require('../models/models');
const User    = require('../models/User');
const { protect } = require('../middleware/auth');

const router = express.Router();

// In-memory deadline store (use MongoDB in production)
let deadlines = [];

// ── POST /api/deadlines ───────────────────────────────────────
router.post('/deadlines', protect, async (req, res) => {
  try {
    const { course_id, title, deadline_date, reminder_24h, reminder_1h } = req.body;
    if (!course_id || !title || !deadline_date) {
      return res.status(400).json({ success: false, message: 'course_id, title, deadline_date required' });
    }

    const course = await Course.findById(course_id);
    if (!course) return res.status(404).json({ success: false, message: 'Course not found' });

    const deadline = {
      id:           Date.now().toString(),
      course_id,
      course_title: course.title,
      title,
      deadline_date: new Date(deadline_date),
      reminder_24h: reminder_24h !== false,
      reminder_1h:  reminder_1h  !== false,
      created_at:   new Date(),
      reminders_sent: [],
      status: 'active',
    };
    deadlines.push(deadline);

    // Schedule reminders (in production use node-cron or agenda.js)
    const now   = Date.now();
    const ddTime = new Date(deadline_date).getTime();

    if (reminder_24h !== false) {
      const remind24 = ddTime - 24 * 60 * 60 * 1000;
      if (remind24 > now) {
        setTimeout(() => _sendReminder(deadline, '24h'), remind24 - now);
      }
    }
    if (reminder_1h !== false) {
      const remind1 = ddTime - 60 * 60 * 1000;
      if (remind1 > now) {
        setTimeout(() => _sendReminder(deadline, '1h'), remind1 - now);
      }
    }

    res.json({ success: true, data: deadline, message: 'Deadline scheduled!' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ── GET /api/deadlines ────────────────────────────────────────
router.get('/deadlines', protect, async (req, res) => {
  const sorted = [...deadlines].sort((a, b) =>
    new Date(a.deadline_date) - new Date(b.deadline_date));
  res.json({ success: true, data: sorted });
});

// ── DELETE /api/deadlines/:id ─────────────────────────────────
router.delete('/deadlines/:id', protect, (req, res) => {
  deadlines = deadlines.filter(d => d.id !== req.params.id);
  res.json({ success: true, message: 'Deadline removed' });
});

// ── Internal: send reminder ────────────────────────────────────
async function _sendReminder(deadline, type) {
  try {
    const enrolled = await LearnerProgress.find({ course_id: deadline.course_id }).distinct('phone_number');
    const completed = await QuizResult.find({ course_id: deadline.course_id }).distinct('phone_number');
    const pending   = enrolled.filter(p => !completed.includes(p));

    const timeLabel = type === '24h' ? '24 hours' : '1 hour';
    const msg = `⏰ *Deadline Reminder*\n\n` +
      `📚 *${deadline.course_title}*\n` +
      `📝 *${deadline.title}*\n\n` +
      `You have *${timeLabel}* remaining!\n\n` +
      `Type *QUIZ* to complete your assessment now.\n\n` +
      `_Andragogy Learning Platform_`;

    // Log the reminder
    const dl = deadlines.find(d => d.id === deadline.id);
    if (dl) {
      dl.reminders_sent.push({ type, sent_at: new Date(), recipients: pending.length });
    }

    console.log(`⏰ Reminder sent (${type}) to ${pending.length} learners for: ${deadline.title}`);
  } catch (err) {
    console.error('Reminder error:', err.message);
  }
}

module.exports = router;