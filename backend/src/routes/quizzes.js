// const express = require('express');
// const { QuizQuestion, QuizResult, LearnerProgress, Course } = require('../models/models');
// const { protect, facilitatorOnly } = require('../middleware/auth');

// const router = express.Router();

// // POST /api/quizzes  — create quiz question
// router.post('/quizzes', protect, facilitatorOnly, async (req, res) => {
//   try {
//     const { course_id, module_id, question, options, correct_answer } = req.body;
//     if (!course_id || !question || !options || !correct_answer) {
//       return res.status(400).json({ success: false, message: 'course_id, question, options, correct_answer are required.' });
//     }
//     if (!['A', 'B', 'C', 'D'].includes(correct_answer)) {
//       return res.status(400).json({ success: false, message: 'correct_answer must be A, B, C, or D.' });
//     }
//     const quiz = await QuizQuestion.create({ course_id, module_id, question, options, correct_answer });
//     res.status(201).json({ success: true, data: quiz });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // GET /api/quizzes/:courseId  — get all quiz questions for a course
// router.get('/quizzes/:courseId', protect, async (req, res) => {
//   try {
//     const questions = await QuizQuestion.find({ course_id: req.params.courseId });
//     res.json({ success: true, count: questions.length, data: questions });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // DELETE /api/quizzes/:id
// router.delete('/quizzes/:id', protect, facilitatorOnly, async (req, res) => {
//   try {
//     await QuizQuestion.findByIdAndDelete(req.params.id);
//     res.json({ success: true, message: 'Quiz question deleted.' });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // POST /api/submitQuiz  — submit quiz answers and calculate score
// router.post('/submitQuiz', async (req, res) => {
//   try {
//     const { phone_number, course_id, module_id, answers } = req.body;
//     // answers: [{ question_id: '...', answer: 'A' }, ...]
//     if (!phone_number || !course_id || !answers || !Array.isArray(answers)) {
//       return res.status(400).json({ success: false, message: 'phone_number, course_id, answers[] are required.' });
//     }

//     const questionIds = answers.map(a => a.question_id);
//     const questions = await QuizQuestion.find({ _id: { $in: questionIds } });

//     let correct = 0;
//     const answersGiven = answers.map(a => {
//       const q = questions.find(q => q._id.toString() === a.question_id);
//       const is_correct = q && q.correct_answer === a.answer;
//       if (is_correct) correct++;
//       return { question_id: a.question_id, answer: a.answer, is_correct: !!is_correct };
//     });

//     const total = questions.length;
//     const score = total > 0 ? Math.round((correct / total) * 100) : 0;

//     const result = await QuizResult.create({
//       phone_number, course_id, module_id,
//       score, total_questions: total, correct_answers: correct,
//       answers_given: answersGiven,
//     });

//     res.json({
//       success: true,
//       data: { score, correct_answers: correct, total_questions: total, result_id: result._id },
//       message: `You scored ${score}% (${correct}/${total} correct)`,
//     });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// module.exports = router;


const express = require('express');
const { QuizQuestion, QuizResult } = require('../models/models');
const { protect, facilitatorOnly } = require('../middleware/auth');

const router = express.Router();

// ─────────────────────────────────────────────────────────────
// POST /api/quizzes  — create quiz question (facilitator only)
// ─────────────────────────────────────────────────────────────
router.post('/quizzes', protect, facilitatorOnly, async (req, res) => {
  try {
    const { course_id, module_id, question, options, correct_answer } = req.body;
    if (!course_id || !question || !options || !correct_answer) {
      return res.status(400).json({ success: false, message: 'course_id, question, options, correct_answer are required.' });
    }
    if (!['A', 'B', 'C', 'D'].includes(correct_answer)) {
      return res.status(400).json({ success: false, message: 'correct_answer must be A, B, C, or D.' });
    }
    const quiz = await QuizQuestion.create({ course_id, module_id, question, options, correct_answer });
    res.status(201).json({ success: true, data: quiz });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ─────────────────────────────────────────────────────────────
// GET /api/quizzes/:courseId  — get all questions for a course
// ─────────────────────────────────────────────────────────────
router.get('/quizzes/:courseId', protect, async (req, res) => {
  try {
    const questions = await QuizQuestion.find({ course_id: req.params.courseId });
    res.json({ success: true, count: questions.length, data: questions });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ─────────────────────────────────────────────────────────────
// DELETE /api/quizzes/:id
// ─────────────────────────────────────────────────────────────
router.delete('/quizzes/:id', protect, facilitatorOnly, async (req, res) => {
  try {
    await QuizQuestion.findByIdAndDelete(req.params.id);
    res.json({ success: true, message: 'Quiz question deleted.' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ─────────────────────────────────────────────────────────────
// POST /api/submitQuiz
// Body: { phone_number, learner_name, course_id, module_id?, answers: [{question_id, answer}] }
//
// Returns:
//   score, correct_answers, total_questions,
//   review: [{question, options, correct_answer, learner_answer, is_correct}]
//   attempt_number (so client knows if this is a retry)
// ─────────────────────────────────────────────────────────────
router.post('/submitQuiz', async (req, res) => {
  try {
    const { phone_number, learner_name, course_id, module_id, answers } = req.body;

    if (!phone_number || !course_id || !answers || !Array.isArray(answers)) {
      return res.status(400).json({ success: false, message: 'phone_number, course_id, answers[] are required.' });
    }

    // Fetch all questions in one query
    const questionIds = answers.map(a => a.question_id);
    const questions = await QuizQuestion.find({ _id: { $in: questionIds } });

    let correct = 0;
    const answersGiven = answers.map(a => {
      const q = questions.find(q => q._id.toString() === a.question_id);
      const is_correct = q ? q.correct_answer === a.answer : false;
      if (is_correct) correct++;
      return { question_id: a.question_id, answer: a.answer, is_correct };
    });

    const total = questions.length;
    const score = total > 0 ? Math.round((correct / total) * 100) : 0;

    // Determine attempt number (how many times this learner has tried this course)
    const prevAttempts = await QuizResult.countDocuments({ phone_number, course_id });
    const attempt_number = prevAttempts + 1;

    // Save result
    const result = await QuizResult.create({
      phone_number,
      learner_name: learner_name || 'Learner',
      course_id,
      module_id,
      score,
      total_questions: total,
      correct_answers: correct,
      attempt_number,
      answers_given: answersGiven,
    });

    // Build answer review — show each question with correct answer & what learner chose
    const review = questions.map(q => {
      const given = answersGiven.find(a => a.question_id === q._id.toString());
      return {
        question_id:    q._id,
        question:       q.question,
        options:        q.options,
        correct_answer: q.correct_answer,
        learner_answer: given?.answer ?? null,
        is_correct:     given?.is_correct ?? false,
      };
    });

    res.json({
      success: true,
      data: {
        score,
        correct_answers: correct,
        total_questions: total,
        attempt_number,
        result_id: result._id,
        review,                // ← full answer breakdown with correct answers
      },
      message: `You scored ${score}% (${correct}/${total} correct)`,
    });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ─────────────────────────────────────────────────────────────
// GET /api/quizzes/:courseId/leaderboard
// Returns top learners ranked by best score for a course.
// Query params:
//   limit (default 20)  — how many entries to return
// ─────────────────────────────────────────────────────────────
router.get('/quizzes/:courseId/leaderboard', protect, async (req, res) => {
  try {
    const { courseId } = req.params;
    const limit = parseInt(req.query.limit) || 20;

    // For each learner (phone_number), pick their BEST score on this course
    const leaderboard = await QuizResult.aggregate([
      { $match: { course_id: require('mongoose').Types.ObjectId(courseId) } },
      {
        $group: {
          _id:            '$phone_number',
          learner_name:   { $first: '$learner_name' },
          best_score:     { $max: '$score' },
          total_attempts: { $sum: 1 },
          last_attempt:   { $max: '$submitted_at' },
        },
      },
      { $sort: { best_score: -1, last_attempt: 1 } },   // highest score first; ties broken by earliest
      { $limit: limit },
      {
        $project: {
          _id:            0,
          phone_number:   '$_id',
          learner_name:   1,
          best_score:     1,
          total_attempts: 1,
          last_attempt:   1,
        },
      },
    ]);

    res.json({ success: true, count: leaderboard.length, data: leaderboard });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ─────────────────────────────────────────────────────────────
// GET /api/quizResults/:courseId/:phone  — past attempts for a learner
// Used by Flutter to show retry history
// ─────────────────────────────────────────────────────────────
router.get('/quizResults/:courseId/:phone', protect, async (req, res) => {
  try {
    const results = await QuizResult.find({
      course_id:    req.params.courseId,
      phone_number: req.params.phone,
    }).sort({ attempt_number: -1 });

    res.json({ success: true, count: results.length, data: results });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;