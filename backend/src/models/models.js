// const mongoose = require('mongoose');

// // ── Course ────────────────────────────────────────────────────
// const courseSchema = new mongoose.Schema({
//   title:       { type: String, required: true, trim: true },
//   description: { type: String, required: true },
//   facilitator: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
//   is_active:   { type: Boolean, default: true },
//   category:             { type: String, default: 'General' },
//   tags:                 { type: [String], default: [] },
//   thumbnail_color_index:{ type: Number, default: 0 },
//   created_at: { type: Date, default: Date.now },
// });
// const Course = mongoose.model('Course', courseSchema);

// // ── Module ────────────────────────────────────────────────────
// const moduleSchema = new mongoose.Schema({
//   course_id:   { type: mongoose.Schema.Types.ObjectId, ref: 'Course', required: true },
//   title:       { type: String, required: true, trim: true },
//   description: { type: String, required: true },
//   pdf_link:    { type: String, default: '' },
//   video_link:  { type: String, default: '' },
//   order:       { type: Number, default: 1 },
//   created_at:  { type: Date, default: Date.now },
// });
// const Module = mongoose.model('Module', moduleSchema);

// // ── QuizQuestion ──────────────────────────────────────────────
// const quizQuestionSchema = new mongoose.Schema({
//   course_id:  { type: mongoose.Schema.Types.ObjectId, ref: 'Course', required: true },
//   module_id:  { type: mongoose.Schema.Types.ObjectId, ref: 'Module' },
//   question:   { type: String, required: true },
//   options: {
//     A: { type: String, required: true },
//     B: { type: String, required: true },
//     C: { type: String, required: true },
//     D: { type: String, required: true },
//   },
//   correct_answer: { type: String, enum: ['A', 'B', 'C', 'D'], required: true },
//   created_at: { type: Date, default: Date.now },
// });
// const QuizQuestion = mongoose.model('QuizQuestion', quizQuestionSchema);

// // ── QuizResult ────────────────────────────────────────────────
// const quizResultSchema = new mongoose.Schema({
//   phone_number:    { type: String, required: true, trim: true },
//   learner_name:    { type: String, default: 'Learner' },
//   course_id:       { type: mongoose.Schema.Types.ObjectId, ref: 'Course', required: true },
//   module_id:       { type: mongoose.Schema.Types.ObjectId, ref: 'Module' },
//   score:           { type: Number, required: true },
//   total_questions: { type: Number, required: true },
//   correct_answers: { type: Number, required: true },
//   attempt_number:  { type: Number, default: 1 },
//   answers_given: [{
//     question_id: { type: mongoose.Schema.Types.ObjectId, ref: 'QuizQuestion' },
//     answer:      { type: String },
//     is_correct:  { type: Boolean },
//   }],
//   submitted_at: { type: Date, default: Date.now },
// });
// const QuizResult = mongoose.model('QuizResult', quizResultSchema);

// // ── Enrollment ────────────────────────────────────────────────
// const enrollmentSchema = new mongoose.Schema({
//   phone_number: { type: String, required: true, trim: true },
//   learner_name: { type: String, default: 'Learner' },
//   course_id:    { type: mongoose.Schema.Types.ObjectId, ref: 'Course', required: true },
//   enrolled_at:  { type: Date, default: Date.now },
//   status:       { type: String, enum: ['active', 'completed', 'dropped'], default: 'active' },
// });
// enrollmentSchema.index({ phone_number: 1, course_id: 1 }, { unique: true });
// const Enrollment = mongoose.model('Enrollment', enrollmentSchema);

// // ── LearnerProgress ───────────────────────────────────────────
// const learnerProgressSchema = new mongoose.Schema({
//   phone_number:      { type: String, required: true, trim: true },
//   course_id:         { type: mongoose.Schema.Types.ObjectId, ref: 'Course', required: true },
//   modules_completed: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Module' }],
//   current_module:    { type: mongoose.Schema.Types.ObjectId, ref: 'Module' },
//   updated_at:        { type: Date, default: Date.now },
// });
// const LearnerProgress = mongoose.model('LearnerProgress', learnerProgressSchema);

// // ── QuizAttempt ───────────────────────────────────────────────
// const quizAttemptSchema = new mongoose.Schema({
//   phone_number:    { type: String, required: true },
//   learner_name:    { type: String, default: 'Learner' },
//   course_id:       { type: String, required: true },
//   score:           { type: Number, required: true },
//   correct_answers: { type: Number, required: true },
//   total_questions: { type: Number, required: true },
//   attempt_number:  { type: Number, default: 1 },
//   submitted_at:    { type: Date, default: Date.now },
// });
// const QuizAttempt = mongoose.model('QuizAttempt', quizAttemptSchema);

// module.exports = { Course, Module, QuizQuestion, QuizResult, Enrollment, LearnerProgress, QuizAttempt };








const mongoose = require('mongoose');

// ── Course ────────────────────────────────────────────────────
const courseSchema = new mongoose.Schema({
  title:                { type: String, required: true, trim: true },
  description:          { type: String, required: true },
  facilitator:          { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  is_active:            { type: Boolean, default: true },
  category:             { type: String, default: 'General' },
  tags:                 { type: [String], default: [] },
  thumbnail_color_index:{ type: Number, default: 0 },
  created_at:           { type: Date, default: Date.now },
});
const Course = mongoose.model('Course', courseSchema);

// ── Module ────────────────────────────────────────────────────
const moduleSchema = new mongoose.Schema({
  course_id:   { type: mongoose.Schema.Types.ObjectId, ref: 'Course', required: true },
  title:       { type: String, required: true, trim: true },
  description: { type: String, required: true },
  pdf_link:    { type: String, default: '' },
  video_link:  { type: String, default: '' },
  order:       { type: Number, default: 1 },
  created_at:  { type: Date, default: Date.now },
});
const Module = mongoose.model('Module', moduleSchema);

// ── QuizQuestion ──────────────────────────────────────────────
const quizQuestionSchema = new mongoose.Schema({
  course_id:  { type: mongoose.Schema.Types.ObjectId, ref: 'Course', required: true },
  module_id:  { type: mongoose.Schema.Types.ObjectId, ref: 'Module' },
  question:   { type: String, required: true },
  options: {
    A: { type: String, required: true },
    B: { type: String, required: true },
    C: { type: String, required: true },
    D: { type: String, required: true },
  },
  correct_answer: { type: String, enum: ['A', 'B', 'C', 'D'], required: true },
  created_at: { type: Date, default: Date.now },
});
const QuizQuestion = mongoose.model('QuizQuestion', quizQuestionSchema);

// ── LearnerProgress ───────────────────────────────────────────
const learnerProgressSchema = new mongoose.Schema({
  phone_number:       { type: String, required: true },
  course_id:          { type: mongoose.Schema.Types.ObjectId, ref: 'Course', required: true },
  current_module:     { type: mongoose.Schema.Types.ObjectId, ref: 'Module' },
  modules_completed:  [{ type: mongoose.Schema.Types.ObjectId, ref: 'Module' }],
  enrolled_at:        { type: Date, default: Date.now },
  last_active:        { type: Date, default: Date.now },
});
const LearnerProgress = mongoose.model('LearnerProgress', learnerProgressSchema);

// ── QuizResult ────────────────────────────────────────────────
const quizResultSchema = new mongoose.Schema({
  phone_number:    { type: String, required: true },
  course_id:       { type: mongoose.Schema.Types.ObjectId, ref: 'Course' },
  score:           { type: Number, required: true },
  total_questions: { type: Number },
  correct_answers: { type: Number },
  answers_given:   [{ question_id: String, answer: String, is_correct: Boolean }],
  date:            { type: Date, default: Date.now },
});
const QuizResult = mongoose.model('QuizResult', quizResultSchema);

module.exports = { Course, Module, QuizQuestion, LearnerProgress, QuizResult };