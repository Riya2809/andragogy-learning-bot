// backend/src/routes/progress.js
const express = require('express');
const { Course, LearnerProgress, QuizResult } = require('../models/models');
const User    = require('../models/User');
const { protect } = require('../middleware/auth');

const router = express.Router();

// ── GET /api/progress/course-stats ── MUST BE BEFORE /:phoneNumber ──
router.get('/progress/course-stats', protect, async (req, res) => {
  try {
    const courses = await Course.find({ is_active: true });
    console.log('Course stats: found', courses.length, 'courses');

    const stats = await Promise.all(courses.map(async (course) => {
      const enrolled  = await LearnerProgress.countDocuments({ course_id: course._id });
      const results   = await QuizResult.find({ course_id: course._id });
      const completed = results.filter(r => r.score >= 60).length;
      const rate      = enrolled > 0 ? Math.round((completed / enrolled) * 100) : 0;
      console.log(`  ${course.title}: enrolled=${enrolled}, completed=${completed}`);
      return {
        course_id:       course._id.toString(),
        course_title:    course.title,
        enrolled,
        completed,
        completion_rate: rate,
      };
    }));

    res.json({ success: true, data: stats });
  } catch (err) {
    console.error('Course stats error:', err);
    res.status(500).json({ success: false, message: err.message });
  }
});

// ── GET /api/progress — all learners ──────────────────────────
router.get('/progress', protect, async (req, res) => {
  try {
    const learners = await User.find({ role: 'learner' })
      .select('name phone_number department job_role location experience_years education_level created_at');

    const result = await Promise.all(learners.map(async (learner) => {
      const quizResults     = await QuizResult.find({ phone_number: learner.phone_number });
      const progressRecords = await LearnerProgress.find({ phone_number: learner.phone_number })
        .populate('course_id', 'title');

      const quizzesTaken     = quizResults.length;
      const coursesTaken     = progressRecords.length;
      const modulesCompleted = progressRecords.reduce((sum, p) => sum + (p.modules_completed?.length || 0), 0);
      const averageScore     = quizzesTaken > 0
        ? Math.round(quizResults.reduce((sum, r) => sum + r.score, 0) / quizzesTaken)
        : 0;

      return {
        name:              learner.name,
        phone_number:      learner.phone_number,
        department:        learner.department || '',
        job_role:          learner.job_role || '',
        location:          learner.location || '',
        experience_years:  learner.experience_years || 0,
        education_level:   learner.education_level || '',
        courses_taken:     coursesTaken,
        quizzes_taken:     quizzesTaken,
        average_score:     averageScore,
        modules_completed: modulesCompleted,
        joined_at:         learner.created_at,
        enrolled_courses:  progressRecords.map(p => ({
          course_id:    p.course_id?._id || p.course_id,
          course_title: p.course_id?.title || 'Unknown Course',
          modules_done: p.modules_completed?.length || 0,
        })),
        quiz_results: quizResults.map(r => ({
          course_id:    r.course_id?._id || r.course_id,
          course_title: r.course_id?.title || 'Unknown Course',
          score:        r.score,
        })),
      };
    }));

    res.json({ success: true, count: result.length, data: result });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ── GET /api/progress/:phoneNumber — single learner ───────────
router.get('/progress/:phoneNumber', protect, async (req, res) => {
  try {
    const phone   = req.params.phoneNumber;
    const learner = await User.findOne({ phone_number: phone, role: 'learner' });

    if (!learner) {
      return res.status(404).json({ success: false, message: 'Learner not found' });
    }

    const quizResults     = await QuizResult.find({ phone_number: phone }).populate('course_id', 'title');
    const progressRecords = await LearnerProgress.find({ phone_number: phone }).populate('course_id', 'title');

    res.json({
      success: true,
      data: {
        name:              learner.name,
        phone_number:      learner.phone_number,
        department:        learner.department || '',
        job_role:          learner.job_role || '',
        courses_taken:     progressRecords.length,
        quizzes_taken:     quizResults.length,
        average_score:     quizResults.length > 0
          ? Math.round(quizResults.reduce((s, r) => s + r.score, 0) / quizResults.length)
          : 0,
        modules_completed: progressRecords.reduce((s, p) => s + (p.modules_completed?.length || 0), 0),
        quiz_results:      quizResults.map(r => ({
          course:  r.course_id?.title || 'Unknown',
          score:   r.score,
          date:    r.createdAt,
        })),
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;















