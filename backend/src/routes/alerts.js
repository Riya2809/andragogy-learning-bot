// backend/src/routes/alerts.js
const express = require('express');
const router  = express.Router();
const { protect } = require('../middleware/auth');

// In-memory store (upgrade to MongoDB collection for production)
let alerts = [];
let nextId  = 1;

// Auto-seed some system alerts on first load
function seedAlerts() {
  if (alerts.length === 0) {
    alerts = [
      {
        id: String(nextId++),
        type: 'info',
        title: 'Welcome to Andragogy!',
        message: 'Your facilitator dashboard is ready. Start by creating a course.',
        is_read: false,
        created_at: new Date(Date.now() - 60000 * 5).toISOString(),
      },
    ];
  }
}

// ── GET /api/alerts — get all alerts ─────────────────────────
router.get('/alerts', protect, (req, res) => {
  seedAlerts();
  const sorted = [...alerts].sort(
    (a, b) => new Date(b.created_at) - new Date(a.created_at));
  res.json({
    success: true,
    data: sorted,
    unread_count: alerts.filter(a => !a.is_read).length,
  });
});

// ── POST /api/alerts — create an alert (system use) ──────────
router.post('/alerts', protect, (req, res) => {
  const { type = 'info', title, message } = req.body;
  if (!title || !message) {
    return res.status(400).json({ success: false, message: 'title and message required' });
  }
  const alert = {
    id: String(nextId++),
    type,   // 'info' | 'success' | 'warning' | 'error'
    title,
    message,
    is_read: false,
    created_at: new Date().toISOString(),
  };
  alerts.unshift(alert);
  res.status(201).json({ success: true, data: alert });
});

// ── PUT /api/alerts/:id/read — mark one as read ───────────────
router.put('/alerts/:id/read', protect, (req, res) => {
  const alert = alerts.find(a => a.id === req.params.id);
  if (!alert) return res.status(404).json({ success: false, message: 'Alert not found' });
  alert.is_read = true;
  res.json({ success: true, data: alert });
});

// ── PUT /api/alerts/read-all — mark all as read ───────────────
router.put('/alerts/read-all', protect, (req, res) => {
  alerts.forEach(a => a.is_read = true);
  res.json({ success: true, message: 'All alerts marked as read' });
});

// ── DELETE /api/alerts/:id — delete one alert ─────────────────
router.delete('/alerts/:id', protect, (req, res) => {
  alerts = alerts.filter(a => a.id !== req.params.id);
  res.json({ success: true, message: 'Alert deleted' });
});

// ── DELETE /api/alerts — clear all alerts ────────────────────
router.delete('/alerts', protect, (req, res) => {
  alerts = [];
  res.json({ success: true, message: 'All alerts cleared' });
});

// ── Internal helper — called by other routes to push alerts ──
router.createAlert = (type, title, message) => {
  seedAlerts();
  alerts.unshift({
    id: String(nextId++),
    type, title, message,
    is_read: false,
    created_at: new Date().toISOString(),
  });
};

module.exports = router;