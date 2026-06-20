
// // backend/src/routes/polls.js
// const express = require('express');
// const router  = express.Router();
// const { protect } = require('../middleware/auth');
// const whatsappService = require('../services/whatsappService');
// const User = require('../models/User');

// let polls = [];
// let responses = [];

// // ── POST /api/polls — create and broadcast poll ──────────────
// router.post('/polls', protect, async (req, res) => {
//   const { question, options, multi_select } = req.body;
//   if (!question || !options || options.length < 2) {
//     return res.status(400).json({ success: false, message: 'Question and at least 2 options required' });
//   }

//   const poll = {
//     id:           Date.now().toString(),
//     question:     question.trim(),
//     options:      options.map(o => o.trim()).filter(Boolean),
//     multi_select: multi_select || false,
//     created_at:   new Date(),
//     created_by:   req.user?.name || 'Facilitator',
//     status:       'active',
//   };
//   polls.unshift(poll);

//   // Build WhatsApp message
//   let msg = '📊 *New Poll from Andragogy!*\n\n';
//   msg += `❓ *${poll.question}*\n\n`;
//   poll.options.forEach((opt, i) => {
//     msg += `${String.fromCharCode(65 + i)}. ${opt}\n`;
//   });
//   msg += '\n_Reply with your answer (A, B, C...)_';

//   // Broadcast to all learners
//   try {
//     const learners = await User.find({ role: 'learner' });
//     let sent = 0;
//     for (const learner of learners) {
//       try {
//         await whatsappService.sendTextMessage(learner.phone_number, msg);
//         sent++;
//       } catch (_) {}
//     }
//     console.log(`📊 Poll broadcast to ${sent}/${learners.length} learners`);
//     res.json({ success: true, data: poll, message: `Poll sent to ${sent} learners!` });
//   } catch (err) {
//     console.error('Poll broadcast error:', err.message);
//     res.json({ success: true, data: poll, message: 'Poll saved (broadcast failed)' });
//   }
// });

// // ── GET /api/polls — list all polls ──────────────────────────
// router.get('/polls', protect, (req, res) => {
//   const enriched = polls.map(p => {
//     const pollResponses = responses.filter(r => r.poll_id === p.id);
//     const counts = {};
//     p.options.forEach(o => counts[o] = 0);
//     pollResponses.forEach(r => {
//       const selected = Array.isArray(r.selected) ? r.selected : [r.selected];
//       selected.forEach(s => { if (counts[s] !== undefined) counts[s]++; });
//     });
//     return { ...p, response_count: pollResponses.length, counts };
//   });
//   res.json({ success: true, data: enriched });
// });

// // ── GET /api/polls/:id ────────────────────────────────────────
// router.get('/polls/:id', protect, (req, res) => {
//   const poll = polls.find(p => p.id === req.params.id);
//   if (!poll) return res.status(404).json({ success: false, message: 'Poll not found' });
//   const pollResponses = responses.filter(r => r.poll_id === poll.id);
//   const counts = {};
//   poll.options.forEach(o => counts[o] = 0);
//   pollResponses.forEach(r => {
//     const selected = Array.isArray(r.selected) ? r.selected : [r.selected];
//     selected.forEach(s => { if (counts[s] !== undefined) counts[s]++; });
//   });
//   res.json({ success: true, data: { ...poll, response_count: pollResponses.length, counts, responses: pollResponses } });
// });

// // ── POST /api/polls/:id/respond ───────────────────────────────
// router.post('/polls/:id/respond', (req, res) => {
//   const poll = polls.find(p => p.id === req.params.id);
//   if (!poll) return res.status(404).json({ success: false, message: 'Poll not found' });
//   const { phone_number, name, selected } = req.body;
//   if (!phone_number || !selected) {
//     return res.status(400).json({ success: false, message: 'phone_number and selected required' });
//   }
//   responses = responses.filter(r => !(r.poll_id === poll.id && r.phone_number === phone_number));
//   responses.push({
//     poll_id: poll.id, phone_number,
//     name: name || 'Learner',
//     selected: Array.isArray(selected) ? selected : [selected],
//     responded_at: new Date(),
//   });
//   res.json({ success: true, message: 'Response recorded!' });
// });

// // ── DELETE /api/polls/:id ─────────────────────────────────────
// router.delete('/polls/:id', protect, (req, res) => {
//   polls     = polls.filter(p => p.id !== req.params.id);
//   responses = responses.filter(r => r.poll_id !== req.params.id);
//   res.json({ success: true, message: 'Poll deleted' });
// });

// module.exports = router;
















// // backend/src/routes/polls.js
// const express = require('express');
// const router  = express.Router();
// const { protect } = require('../middleware/auth');
// const whatsappService = require('../services/whatsappService');
// const User = require('../models/User');

// let polls = [];
// let responses = [];

// // ── POST /api/polls — create and broadcast poll ──────────────
// router.post('/polls', protect, async (req, res) => {
//   const { question, options, multi_select } = req.body;
//   if (!question || !options || options.length < 2) {
//     return res.status(400).json({ success: false, message: 'Question and at least 2 options required' });
//   }

//   const poll = {
//     id:           Date.now().toString(),
//     question:     question.trim(),
//     options:      options.map(o => o.trim()).filter(Boolean),
//     multi_select: multi_select || false,
//     created_at:   new Date(),
//     created_by:   req.user?.name || 'Facilitator',
//     status:       'active',
//   };
//   polls.unshift(poll);

//   // Build WhatsApp message in live poll format
//   let msg = `📊 *Poll from Andragogy Insight!*\n\n`;
//   msg += `❓ *${poll.question}*\n\n`;
//   msg += `━━━━━━━━━━━━━━━━━━━━\n`;
//   poll.options.forEach((opt, i) => {
//     const letter = String.fromCharCode(65 + i);
//     msg += `  *${letter}.* ${opt}\n`;
//     msg += `   ░░░░░░░░░░ 0%  (0)\n\n`;
//   });
//   msg += `━━━━━━━━━━━━━━━━━━━━\n`;
//   msg += `👥 *Total: 0 votes*\n\n`;
//   msg += `_Reply with A, B, C... to vote!_`;

//   // Broadcast to all learners and set their session state
//   try {
//     const learners = await User.find({ role: 'learner' });
//     let sent = 0;
//     for (const learner of learners) {
//       try {
//         await whatsappService.sendTextMessage(learner.phone_number, msg);
//         sent++;
//       } catch (_) {}
//     }
//     console.log(`📊 Poll broadcast to ${sent}/${learners.length} learners`);

//     res.json({ success: true, data: poll, message: `Poll sent to ${sent} learners!`, poll_id: poll.id });
//   } catch (err) {
//     console.error('Poll broadcast error:', err.message);
//     res.json({ success: true, data: poll, message: 'Poll saved (broadcast failed)', poll_id: poll.id });
//   }
// });

// // ── GET /api/polls — list all polls ──────────────────────────
// router.get('/polls', protect, (req, res) => {
//   const enriched = polls.map(p => {
//     const pollResponses = responses.filter(r => r.poll_id === p.id);
//     const counts = {};
//     p.options.forEach(o => counts[o] = 0);
//     pollResponses.forEach(r => {
//       const selected = Array.isArray(r.selected) ? r.selected : [r.selected];
//       selected.forEach(s => { if (counts[s] !== undefined) counts[s]++; });
//     });
//     return { ...p, response_count: pollResponses.length, counts };
//   });
//   res.json({ success: true, data: enriched });
// });

// // ── GET /api/polls/:id ────────────────────────────────────────
// router.get('/polls/:id', protect, (req, res) => {
//   const poll = polls.find(p => p.id === req.params.id);
//   if (!poll) return res.status(404).json({ success: false, message: 'Poll not found' });
//   const pollResponses = responses.filter(r => r.poll_id === poll.id);
//   const counts = {};
//   poll.options.forEach(o => counts[o] = 0);
//   pollResponses.forEach(r => {
//     const selected = Array.isArray(r.selected) ? r.selected : [r.selected];
//     selected.forEach(s => { if (counts[s] !== undefined) counts[s]++; });
//   });
//   res.json({ success: true, data: { ...poll, response_count: pollResponses.length, counts, responses: pollResponses } });
// });

// // ── POST /api/polls/:id/respond ───────────────────────────────
// router.post('/polls/:id/respond', (req, res) => {
//   const poll = polls.find(p => p.id === req.params.id);
//   if (!poll) return res.status(404).json({ success: false, message: 'Poll not found' });
//   const { phone_number, name, selected } = req.body;
//   if (!phone_number || !selected) {
//     return res.status(400).json({ success: false, message: 'phone_number and selected required' });
//   }
//   responses = responses.filter(r => !(r.poll_id === poll.id && r.phone_number === phone_number));
//   responses.push({
//     poll_id: poll.id, phone_number,
//     name: name || 'Learner',
//     selected: Array.isArray(selected) ? selected : [selected],
//     responded_at: new Date(),
//   });
//   res.json({ success: true, message: 'Response recorded!' });
// });

// // ── DELETE /api/polls/:id ─────────────────────────────────────
// router.delete('/polls/:id', protect, (req, res) => {
//   polls     = polls.filter(p => p.id !== req.params.id);
//   responses = responses.filter(r => r.poll_id !== req.params.id);
//   res.json({ success: true, message: 'Poll deleted' });
// });

// module.exports = router;






















// // backend/src/routes/polls.js
// const express = require('express');
// const router  = express.Router();
// const { protect } = require('../middleware/auth');
// const whatsappService = require('../services/whatsappService');
// const User = require('../models/User');

// let polls = [];
// let responses = [];

// // ── POST /api/polls — create and broadcast poll ──────────────
// router.post('/polls', protect, async (req, res) => {
//   const { question, options, multi_select } = req.body;
//   if (!question || !options || options.length < 2) {
//     return res.status(400).json({ success: false, message: 'Question and at least 2 options required' });
//   }

//   const poll = {
//     id:           Date.now().toString(),
//     question:     question.trim(),
//     options:      options.map(o => o.trim()).filter(Boolean),
//     multi_select: multi_select || false,
//     created_at:   new Date(),
//     created_by:   req.user?.name || 'Facilitator',
//     status:       'active',
//   };
//   polls.unshift(poll);

//   // Build WhatsApp message in live poll format
//   let msg = `📊 *Poll from Andragogy Insight!*\n\n`;
//   msg += `❓ *${poll.question}*\n\n`;
//   msg += `━━━━━━━━━━━━━━━━━━━━\n`;
//   poll.options.forEach((opt, i) => {
//     const letter = String.fromCharCode(65 + i);
//     msg += `  *${letter}.* ${opt}\n`;
//     msg += `   ░░░░░░░░░░ 0%  (0)\n\n`;
//   });
//   msg += `━━━━━━━━━━━━━━━━━━━━\n`;
//   msg += `👥 *Total: 0 votes*\n\n`;
//   msg += `_Reply with A, B, C... to vote!_`;

//   // Broadcast to all learners and set their session state
//   try {
//     const learners = await User.find({ role: 'learner' });
//     let sent = 0;
//     for (const learner of learners) {
//       try {
//         await whatsappService.sendTextMessage(learner.phone_number, msg);
//         sent++;
//       } catch (_) {}
//     }
//     console.log(`📊 Poll broadcast to ${sent}/${learners.length} learners`);

//     res.json({ success: true, data: poll, message: `Poll sent to ${sent} learners!`, poll_id: poll.id });
//   } catch (err) {
//     console.error('Poll broadcast error:', err.message);
//     res.json({ success: true, data: poll, message: 'Poll saved (broadcast failed)', poll_id: poll.id });
//   }
// });

// // ── GET /api/polls — list all polls (no auth for internal bot calls)
// router.get('/polls', (req, res) => {
//   const enriched = polls.map(p => {
//     const pollResponses = responses.filter(r => r.poll_id === p.id);
//     const counts = {};
//     p.options.forEach(o => counts[o] = 0);
//     pollResponses.forEach(r => {
//       const selected = Array.isArray(r.selected) ? r.selected : [r.selected];
//       selected.forEach(s => { if (counts[s] !== undefined) counts[s]++; });
//     });
//     return { ...p, response_count: pollResponses.length, counts };
//   });
//   res.json({ success: true, data: enriched });
// });

// // ── GET /api/polls/:id ────────────────────────────────────────
// router.get('/polls/:id', (req, res) => {
//   const poll = polls.find(p => p.id === req.params.id);
//   if (!poll) return res.status(404).json({ success: false, message: 'Poll not found' });
//   const pollResponses = responses.filter(r => r.poll_id === poll.id);
//   const counts = {};
//   poll.options.forEach(o => counts[o] = 0);
//   pollResponses.forEach(r => {
//     const selected = Array.isArray(r.selected) ? r.selected : [r.selected];
//     selected.forEach(s => { if (counts[s] !== undefined) counts[s]++; });
//   });
//   res.json({ success: true, data: { ...poll, response_count: pollResponses.length, counts, responses: pollResponses } });
// });

// // ── POST /api/polls/:id/respond ───────────────────────────────
// router.post('/polls/:id/respond', (req, res) => {
//   const poll = polls.find(p => p.id === req.params.id);
//   if (!poll) return res.status(404).json({ success: false, message: 'Poll not found' });
//   const { phone_number, name, selected } = req.body;
//   if (!phone_number || !selected) {
//     return res.status(400).json({ success: false, message: 'phone_number and selected required' });
//   }
//   responses = responses.filter(r => !(r.poll_id === poll.id && r.phone_number === phone_number));
//   responses.push({
//     poll_id: poll.id, phone_number,
//     name: name || 'Learner',
//     selected: Array.isArray(selected) ? selected : [selected],
//     responded_at: new Date(),
//   });
//   res.json({ success: true, message: 'Response recorded!' });
// });

// // ── DELETE /api/polls/:id ─────────────────────────────────────
// router.delete('/polls/:id', protect, (req, res) => {
//   polls     = polls.filter(p => p.id !== req.params.id);
//   responses = responses.filter(r => r.poll_id !== req.params.id);
//   res.json({ success: true, message: 'Poll deleted' });
// });

// module.exports = router;















const express = require('express');
const router  = express.Router();
const mongoose = require('mongoose');
const { protect } = require('../middleware/auth');
const whatsappService = require('../services/whatsappService');
const User = require('../models/User');

// ── Poll Schema ───────────────────────────────────────────────
const pollSchema = new mongoose.Schema({
  question:     { type: String, required: true },
  options:      [String],
  multi_select: { type: Boolean, default: false },
  status:       { type: String, default: 'active' },
  created_by:   String,
  responses:    [{
    phone_number: String,
    name:         String,
    selected:     String,
    responded_at: { type: Date, default: Date.now }
  }]
}, { timestamps: true });

const Poll = mongoose.models.Poll || mongoose.model('Poll', pollSchema);

// ── POST /api/polls — create and broadcast ────────────────────
router.post('/polls', protect, async (req, res) => {
  try {
    const { question, options, multi_select } = req.body;
    if (!question || !options || options.length < 2) {
      return res.status(400).json({ success: false, message: 'Question and at least 2 options required' });
    }

    const poll = await Poll.create({
      question:     question.trim(),
      options:      options.map(o => o.trim()).filter(Boolean),
      multi_select: multi_select || false,
      created_by:   req.user?.name || 'Facilitator',
      status:       'active',
    });

    // Build poll message
    let msg = `📊 *Poll from Andragogy Insight!*\n\n`;
    msg += `❓ *${poll.question}*\n\n`;
    msg += `━━━━━━━━━━━━━━━━━━━━\n`;
    poll.options.forEach((opt, i) => {
      msg += `  *${String.fromCharCode(65 + i)}.* ${opt}\n`;
      msg += `   ░░░░░░░░░░ 0%  (0)\n\n`;
    });
    msg += `━━━━━━━━━━━━━━━━━━━━\n`;
    msg += `👥 *Total: 0 votes*\n\n`;
    msg += `_Reply with A, B, C... to vote!_`;

    // Broadcast to all learners
    const learners = await User.find({ role: 'learner' });
    let sent = 0;
    for (const learner of learners) {
      try {
        await whatsappService.sendTextMessage(learner.phone_number, msg);
        sent++;
      } catch (_) {}
    }
    console.log(`📊 Poll broadcast to ${sent}/${learners.length} learners`);
    res.json({ success: true, data: poll, message: `Poll sent to ${sent} learners!` });
  } catch (err) {
    console.error('Poll create error:', err);
    res.status(500).json({ success: false, message: err.message });
  }
});

// ── GET /api/polls — list all polls ──────────────────────────
router.get('/polls', async (req, res) => {
  try {
    const polls = await Poll.find().sort({ createdAt: -1 });
    const enriched = polls.map(p => {
      const counts = {};
      p.options.forEach(o => counts[o] = 0);
      p.responses.forEach(r => {
        if (counts[r.selected] !== undefined) counts[r.selected]++;
      });
      return {
        id:             p._id.toString(),
        question:       p.question,
        options:        p.options,
        multi_select:   p.multi_select,
        status:         p.status,
        created_by:     p.created_by,
        response_count: p.responses.length,
        counts,
      };
    });
    res.json({ success: true, data: enriched });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ── GET /api/polls/:id ────────────────────────────────────────
router.get('/polls/:id', async (req, res) => {
  try {
    const poll = await Poll.findById(req.params.id);
    if (!poll) return res.status(404).json({ success: false, message: 'Poll not found' });
    const counts = {};
    poll.options.forEach(o => counts[o] = 0);
    poll.responses.forEach(r => {
      if (counts[r.selected] !== undefined) counts[r.selected]++;
    });
    res.json({
      success: true,
      data: {
        id:             poll._id.toString(),
        question:       poll.question,
        options:        poll.options,
        status:         poll.status,
        response_count: poll.responses.length,
        counts,
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ── POST /api/polls/:id/respond ───────────────────────────────
router.post('/polls/:id/respond', async (req, res) => {
  try {
    const poll = await Poll.findById(req.params.id);
    if (!poll) return res.status(404).json({ success: false, message: 'Poll not found' });
    const { phone_number, name, selected } = req.body;
    if (!phone_number || !selected) {
      return res.status(400).json({ success: false, message: 'phone_number and selected required' });
    }
    // Remove previous response
    poll.responses = poll.responses.filter(r => r.phone_number !== phone_number);
    poll.responses.push({ phone_number, name: name || 'Learner', selected });
    await poll.save();
    console.log(`✅ Poll response: ${phone_number} voted "${selected}"`);
    res.json({ success: true, message: 'Response recorded!' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ── DELETE /api/polls/:id ─────────────────────────────────────
router.delete('/polls/:id', protect, async (req, res) => {
  try {
    await Poll.findByIdAndDelete(req.params.id);
    res.json({ success: true, message: 'Poll deleted' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;