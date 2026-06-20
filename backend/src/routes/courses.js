// const express = require('express');
// const { Course, Module } = require('../models/models');
// const { protect, facilitatorOnly } = require('../middleware/auth');

// const router = express.Router();

// // ── COURSES ───────────────────────────────────────────────────

// // POST /api/courses
// router.post('/courses', protect, facilitatorOnly, async (req, res) => {
//   try {
//     const { title, description } = req.body;
//     if (!title || !description) {
//       return res.status(400).json({ success: false, message: 'Title and description are required.' });
//     }
//     const course = await Course.create({ title, description, facilitator: req.user._id });
//     res.status(201).json({ success: true, data: course });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // GET /api/courses
// router.get('/courses', protect, async (req, res) => {
//   try {
//     const courses = await Course.find({ is_active: true })
//       .populate('facilitator', 'name email')
//       .sort('-created_at');
//     res.json({ success: true, count: courses.length, data: courses });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // GET /api/courses/:id
// router.get('/courses/:id', protect, async (req, res) => {
//   try {
//     const course = await Course.findById(req.params.id).populate('facilitator', 'name email');
//     if (!course) return res.status(404).json({ success: false, message: 'Course not found.' });
//     res.json({ success: true, data: course });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // DELETE /api/courses/:id
// router.delete('/courses/:id', protect, facilitatorOnly, async (req, res) => {
//   try {
//     const course = await Course.findByIdAndUpdate(req.params.id, { is_active: false }, { new: true });
//     if (!course) return res.status(404).json({ success: false, message: 'Course not found.' });
//     res.json({ success: true, message: 'Course deleted successfully.' });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // ── MODULES ───────────────────────────────────────────────────

// // POST /api/modules
// router.post('/modules', protect, facilitatorOnly, async (req, res) => {
//   try {
//     const { course_id, title, description, pdf_link, video_link, order } = req.body;
//     if (!course_id || !title || !description) {
//       return res.status(400).json({ success: false, message: 'course_id, title, and description are required.' });
//     }
//     const course = await Course.findById(course_id);
//     if (!course) return res.status(404).json({ success: false, message: 'Course not found.' });
//     const mod = await Module.create({ course_id, title, description, pdf_link, video_link, order });
//     res.status(201).json({ success: true, data: mod });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // GET /api/modules/:courseId
// router.get('/modules/:courseId', protect, async (req, res) => {
//   try {
//     const modules = await Module.find({ course_id: req.params.courseId }).sort('order');
//     res.json({ success: true, count: modules.length, data: modules });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // DELETE /api/modules/:id
// router.delete('/modules/:id', protect, facilitatorOnly, async (req, res) => {
//   try {
//     await Module.findByIdAndDelete(req.params.id);
//     res.json({ success: true, message: 'Module deleted.' });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });






// module.exports = router;

// const express = require('express');
// const { Course, Module } = require('../models/models');
// const { protect, facilitatorOnly } = require('../middleware/auth');

// const router = express.Router();

// // ── COURSES ───────────────────────────────────────────────────

// // POST /api/courses
// router.post('/courses', protect, facilitatorOnly, async (req, res) => {
//   try {
//     const { title, description, category, tags, thumbnail_color_index } = req.body;
//     if (!title || !description) {
//       return res.status(400).json({ success: false, message: 'Title and description are required.' });
//     }
//     const course = await Course.create({
//       title,
//       description,
//       facilitator: req.user._id,
//       category: category || 'General',
//       tags: tags || [],
//       thumbnail_color_index: thumbnail_color_index || 0,
//     });
//     res.status(201).json({ success: true, data: course });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // GET /api/courses
// router.get('/courses', protect, async (req, res) => {
//   try {
//     const courses = await Course.find({ is_active: true })
//       .populate('facilitator', 'name email')
//       .sort('-created_at');
//     res.json({ success: true, count: courses.length, data: courses });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // GET /api/courses/:id
// router.get('/courses/:id', protect, async (req, res) => {
//   try {
//     const course = await Course.findById(req.params.id).populate('facilitator', 'name email');
//     if (!course) return res.status(404).json({ success: false, message: 'Course not found.' });
//     res.json({ success: true, data: course });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // ── NEW: PUT /api/courses/:id  — edit course ──────────────────
// router.put('/courses/:id', protect, facilitatorOnly, async (req, res) => {
//   try {
//     const { title, description, category, tags, thumbnail_color_index } = req.body;

//     if (!title || !description) {
//       return res.status(400).json({ success: false, message: 'Title and description are required.' });
//     }

//     const course = await Course.findById(req.params.id);
//     if (!course) {
//       return res.status(404).json({ success: false, message: 'Course not found.' });
//     }

//     // Only the facilitator who created it can edit
//     if (course.facilitator.toString() !== req.user._id.toString()) {
//       return res.status(403).json({ success: false, message: 'Not authorised to edit this course.' });
//     }

//     const updated = await Course.findByIdAndUpdate(
//       req.params.id,
//       {
//         title,
//         description,
//         category: category || 'General',
//         tags: tags || [],
//         thumbnail_color_index: thumbnail_color_index ?? 0,
//       },
//       { new: true, runValidators: true }
//     ).populate('facilitator', 'name email');

//     res.json({ success: true, data: updated });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // DELETE /api/courses/:id
// router.delete('/courses/:id', protect, facilitatorOnly, async (req, res) => {
//   try {
//     const course = await Course.findByIdAndUpdate(
//       req.params.id,
//       { is_active: false },
//       { new: true }
//     );
//     if (!course) return res.status(404).json({ success: false, message: 'Course not found.' });
//     res.json({ success: true, message: 'Course deleted successfully.' });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // ── MODULES ───────────────────────────────────────────────────

// // POST /api/modules
// router.post('/modules', protect, facilitatorOnly, async (req, res) => {
//   try {
//     const { course_id, title, description, pdf_link, video_link, order } = req.body;
//     if (!course_id || !title || !description) {
//       return res.status(400).json({ success: false, message: 'course_id, title, and description are required.' });
//     }
//     const course = await Course.findById(course_id);
//     if (!course) return res.status(404).json({ success: false, message: 'Course not found.' });

//     const mod = await Module.create({
//       course_id, title, description,
//       pdf_link: pdf_link || '',
//       video_link: video_link || '',
//       order: order || 1,
//     });
//     res.status(201).json({ success: true, data: mod });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // GET /api/modules/:courseId
// router.get('/modules/:courseId', protect, async (req, res) => {
//   try {
//     const modules = await Module.find({ course_id: req.params.courseId }).sort('order');
//     res.json({ success: true, count: modules.length, data: modules });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // ── NEW: PUT /api/modules/:id  — edit a single module ────────
// router.put('/modules/:id', protect, facilitatorOnly, async (req, res) => {
//   try {
//     const { title, description, pdf_link, video_link } = req.body;

//     if (!title || !description) {
//       return res.status(400).json({ success: false, message: 'Title and description are required.' });
//     }

//     const mod = await Module.findByIdAndUpdate(
//       req.params.id,
//       { title, description, pdf_link: pdf_link || '', video_link: video_link || '' },
//       { new: true, runValidators: true }
//     );

//     if (!mod) return res.status(404).json({ success: false, message: 'Module not found.' });

//     res.json({ success: true, data: mod });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // ── NEW: PUT /api/modules/:courseId/reorder  — save drag order ─
// router.put('/modules/:courseId/reorder', protect, facilitatorOnly, async (req, res) => {
//   try {
//     const { ordered_ids } = req.body;

//     if (!Array.isArray(ordered_ids) || ordered_ids.length === 0) {
//       return res.status(400).json({ success: false, message: 'ordered_ids array is required.' });
//     }

//     // Update each module's order field based on its position in the array
//     const updates = ordered_ids.map((id, index) =>
//       Module.findByIdAndUpdate(id, { order: index + 1 })
//     );
//     await Promise.all(updates);

//     res.json({ success: true, message: 'Module order updated successfully.' });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// // DELETE /api/modules/:id
// router.delete('/modules/:id', protect, facilitatorOnly, async (req, res) => {
//   try {
//     await Module.findByIdAndDelete(req.params.id);
//     res.json({ success: true, message: 'Module deleted.' });
//   } catch (err) {
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// module.exports = router;








const express = require('express');
const { Course, Module, Enrollment } = require('../models/models');
const User = require('../models/User');
const { protect, facilitatorOnly } = require('../middleware/auth');

const router = express.Router();

// ── COURSES ───────────────────────────────────────────────────

// POST /api/courses
router.post('/courses', protect, facilitatorOnly, async (req, res) => {
  try {
    const { title, description, category, tags, thumbnail_color_index } = req.body;
    if (!title || !description) {
      return res.status(400).json({ success: false, message: 'Title and description are required.' });
    }
    const course = await Course.create({
      title, description,
      facilitator: req.user._id,
      category: category || 'General',
      tags: tags || [],
      thumbnail_color_index: thumbnail_color_index || 0,
    });
    res.status(201).json({ success: true, data: course });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// GET /api/courses
router.get('/courses', protect, async (req, res) => {
  try {
    const courses = await Course.find({ is_active: true })
      .populate('facilitator', 'name email')
      .sort('-created_at');
    res.json({ success: true, count: courses.length, data: courses });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// GET /api/courses/:id
router.get('/courses/:id', protect, async (req, res) => {
  try {
    const course = await Course.findById(req.params.id).populate('facilitator', 'name email');
    if (!course) return res.status(404).json({ success: false, message: 'Course not found.' });
    res.json({ success: true, data: course });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// PUT /api/courses/:id — edit course
router.put('/courses/:id', protect, facilitatorOnly, async (req, res) => {
  try {
    const { title, description, category, tags, thumbnail_color_index } = req.body;
    if (!title || !description) {
      return res.status(400).json({ success: false, message: 'Title and description are required.' });
    }
    const course = await Course.findById(req.params.id);
    if (!course) return res.status(404).json({ success: false, message: 'Course not found.' });
    if (course.facilitator.toString() !== req.user._id.toString()) {
      return res.status(403).json({ success: false, message: 'Not authorised to edit this course.' });
    }
    const updated = await Course.findByIdAndUpdate(
      req.params.id,
      { title, description, category: category || 'General', tags: tags || [], thumbnail_color_index: thumbnail_color_index ?? 0 },
      { new: true, runValidators: true }
    ).populate('facilitator', 'name email');
    res.json({ success: true, data: updated });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// DELETE /api/courses/:id
router.delete('/courses/:id', protect, facilitatorOnly, async (req, res) => {
  try {
    const course = await Course.findByIdAndUpdate(req.params.id, { is_active: false }, { new: true });
    if (!course) return res.status(404).json({ success: false, message: 'Course not found.' });
    res.json({ success: true, message: 'Course deleted successfully.' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ── ENROLL ────────────────────────────────────────────────────

// POST /api/enroll — enroll a learner into a course
router.post('/enroll', protect, facilitatorOnly, async (req, res) => {
  try {
    const { phone_number, course_id } = req.body;
    if (!phone_number || !course_id) {
      return res.status(400).json({ success: false, message: 'phone_number and course_id are required.' });
    }

    // Check course exists
    const course = await Course.findById(course_id);
    if (!course) return res.status(404).json({ success: false, message: 'Course not found.' });

    // Get learner name if they exist in users collection
    const learner = await User.findOne({ phone_number, role: 'learner' });

    // Create enrollment (unique index prevents duplicates)
    const enrollment = await Enrollment.create({
      phone_number,
      learner_name: learner?.name || 'Learner',
      course_id,
    });

    res.status(201).json({
      success: true,
      message: `Enrolled ${learner?.name || phone_number} in ${course.title}`,
      data: enrollment,
    });
  } catch (err) {
    // Duplicate enrollment (unique index violation)
    if (err.code === 11000) {
      return res.status(409).json({ success: false, message: 'Learner is already enrolled in this course.' });
    }
    res.status(500).json({ success: false, message: err.message });
  }
});

// DELETE /api/enroll — unenroll a learner from a course
router.delete('/enroll', protect, facilitatorOnly, async (req, res) => {
  try {
    const { phone_number, course_id } = req.body;
    if (!phone_number || !course_id) {
      return res.status(400).json({ success: false, message: 'phone_number and course_id are required.' });
    }
    const result = await Enrollment.findOneAndDelete({ phone_number, course_id });
    if (!result) return res.status(404).json({ success: false, message: 'Enrollment not found.' });
    res.json({ success: true, message: 'Learner unenrolled successfully.' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// GET /api/enroll/:courseId — get all learners enrolled in a course
router.get('/enroll/:courseId', protect, async (req, res) => {
  try {
    const enrollments = await Enrollment.find({ course_id: req.params.courseId, status: 'active' })
      .sort('-enrolled_at');
    res.json({ success: true, count: enrollments.length, data: enrollments });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// GET /api/enroll/learner/:phoneNumber — get all courses a learner is enrolled in
router.get('/enroll/learner/:phoneNumber', protect, async (req, res) => {
  try {
    const enrollments = await Enrollment.find({ phone_number: req.params.phoneNumber, status: 'active' })
      .populate('course_id', 'title description category')
      .sort('-enrolled_at');
    res.json({ success: true, count: enrollments.length, data: enrollments });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// ── MODULES ───────────────────────────────────────────────────

// POST /api/modules
router.post('/modules', protect, facilitatorOnly, async (req, res) => {
  try {
    const { course_id, title, description, pdf_link, video_link, order } = req.body;
    if (!course_id || !title || !description) {
      return res.status(400).json({ success: false, message: 'course_id, title, and description are required.' });
    }
    const course = await Course.findById(course_id);
    if (!course) return res.status(404).json({ success: false, message: 'Course not found.' });
    const mod = await Module.create({
      course_id, title, description,
      pdf_link: pdf_link || '',
      video_link: video_link || '',
      order: order || 1,
    });
    res.status(201).json({ success: true, data: mod });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// GET /api/modules/:courseId
router.get('/modules/:courseId', protect, async (req, res) => {
  try {
    const modules = await Module.find({ course_id: req.params.courseId }).sort('order');
    res.json({ success: true, count: modules.length, data: modules });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// PUT /api/modules/:id — edit a module
router.put('/modules/:id', protect, facilitatorOnly, async (req, res) => {
  try {
    const { title, description, pdf_link, video_link } = req.body;
    if (!title || !description) {
      return res.status(400).json({ success: false, message: 'Title and description are required.' });
    }
    const mod = await Module.findByIdAndUpdate(
      req.params.id,
      { title, description, pdf_link: pdf_link || '', video_link: video_link || '' },
      { new: true, runValidators: true }
    );
    if (!mod) return res.status(404).json({ success: false, message: 'Module not found.' });
    res.json({ success: true, data: mod });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// PUT /api/modules/:courseId/reorder
router.put('/modules/:courseId/reorder', protect, facilitatorOnly, async (req, res) => {
  try {
    const { ordered_ids } = req.body;
    if (!Array.isArray(ordered_ids) || ordered_ids.length === 0) {
      return res.status(400).json({ success: false, message: 'ordered_ids array is required.' });
    }
    const updates = ordered_ids.map((id, index) =>
      Module.findByIdAndUpdate(id, { order: index + 1 })
    );
    await Promise.all(updates);
    res.json({ success: true, message: 'Module order updated successfully.' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

// DELETE /api/modules/:id
router.delete('/modules/:id', protect, facilitatorOnly, async (req, res) => {
  try {
    await Module.findByIdAndDelete(req.params.id);
    res.json({ success: true, message: 'Module deleted.' });
  } catch (err) {
    res.status(500).json({ success: false, message: err.message });
  }
});

module.exports = router;