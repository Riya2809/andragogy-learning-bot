// const mongoose = require('mongoose');
// const bcrypt = require('bcryptjs');

// const userSchema = new mongoose.Schema({
//   name: {
//     type: String,
//     required: [true, 'Name is required'],
//     trim: true,
//   },
//   email: {
//     type: String,
//     required: function () { return this.role === 'facilitator'; },
//     unique: true,
//     sparse: true,
//     lowercase: true,
//   },
//   phone_number: {
//     type: String,
//     required: [true, 'Phone number is required'],
//     unique: true,
//     trim: true,
//   },
//   password: {
//     type: String,
//     required: function () { return this.role === 'facilitator'; },
//     minlength: 6,
//     select: false,
//   },
//   role: {
//     type: String,
//     enum: ['facilitator', 'learner'],
//     default: 'learner',
//   },
//   courses_enrolled: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Course' }],
//   is_active: { type: Boolean, default: true },
//   created_at: { type: Date, default: Date.now },
// });

// // Hash password before save
// userSchema.pre('save', async function (next) {
//   if (!this.isModified('password') || !this.password) return next();
//   this.password = await bcrypt.hash(this.password, 12);
//   next();
// });

// // Compare passwords
// userSchema.methods.comparePassword = async function (candidatePassword) {
//   return bcrypt.compare(candidatePassword, this.password);
// };

// module.exports = mongoose.model('User', userSchema);








// const mongoose = require('mongoose');
// const bcrypt = require('bcryptjs');

// const userSchema = new mongoose.Schema({
//   name:         { type: String, required: true, trim: true },
//   email:        { type: String, sparse: true, lowercase: true, trim: true },
//   phone_number: { type: String, required: true, unique: true },
//   password:     { type: String },
//   role:         { type: String, enum: ['facilitator', 'learner'], default: 'learner' },

//   // ── NEW: Learner profile fields ──────────────────────────
//   job_role:     { type: String, default: '' },
//   department:   { type: String, default: '' },
//   employee_id:  { type: String, default: '' },
//   // ─────────────────────────────────────────────────────────

//   created_at:   { type: Date, default: Date.now },
//   updated_at:   { type: Date, default: Date.now },
// });

// // Hash password before save
// userSchema.pre('save', async function (next) {
//   if (!this.isModified('password') || !this.password) return next();
//   this.password = await bcrypt.hash(this.password, 10);
//   next();
// });

// userSchema.methods.matchPassword = async function (enteredPassword) {
//   if (!this.password) return false;
//   return await bcrypt.compare(enteredPassword, this.password);
// };

// module.exports = mongoose.model('User', userSchema);












const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  name:         { type: String, required: true, trim: true },
  email:        { type: String, sparse: true, lowercase: true, trim: true },
  phone_number: { type: String, required: true, unique: true },
  password:     { type: String },
  role:         { type: String, enum: ['facilitator', 'learner'], default: 'learner' },

  // ── NEW: Learner profile fields ──────────────────────────
  job_role:     { type: String, default: '' },
  department:   { type: String, default: '' },
  employee_id:  { type: String, default: '' },
  // ─────────────────────────────────────────────────────────

  created_at:   { type: Date, default: Date.now },
  updated_at:   { type: Date, default: Date.now },
});

// Hash password before save
userSchema.pre('save', async function (next) {
  if (!this.isModified('password') || !this.password) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

userSchema.methods.matchPassword = async function (enteredPassword) {
  if (!this.password) return false;
  return await bcrypt.compare(enteredPassword, this.password);
};

// Alias — some routes call comparePassword
userSchema.methods.comparePassword = async function (enteredPassword) {
  if (!this.password) return false;
  return await bcrypt.compare(enteredPassword, this.password);
};

module.exports = mongoose.model('User', userSchema);