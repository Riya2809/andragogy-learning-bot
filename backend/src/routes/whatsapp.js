// const express  = require('express');
// const { Course, Module, QuizQuestion, QuizResult, LearnerProgress } = require('../models/models');
// const User     = require('../models/User');
// const { processNLPQuery, isQuestion } = require('../services/nlpService');
// const whatsappService = require('../services/whatsappService');

// const router   = express.Router();
// const sessions = {};

// function reply(res, message) {
//   res.set('Content-Type', 'text/xml');
//   const safe = message
//     .replace(/&/g,'&amp;')
//     .replace(/</g,'&lt;')
//     .replace(/>/g,'&gt;');
//   return res.send(`<?xml version="1.0" encoding="UTF-8"?><Response><Message>${safe}</Message></Response>`);
// }

// async function ensureLearner(phone) {
//   let user = await User.findOne({ phone_number: phone, role: 'learner' });
//   if (!user) {
//     user = await User.create({ name: `Learner_${phone.slice(-4)}`, phone_number: phone, role: 'learner' });
//   }
//   return user;
// }

// router.post('/message', async (req, res) => {
//   try {
//     const phone   = req.body.From || req.body.phone || '';
//     const message = req.body.Body || req.body.message || '';

//     if (!phone || !message) {
//       return res.status(400).json({ success: false, message: 'phone and message required' });
//     }

//     const text      = message.trim();
//     const phone_str = String(phone).replace(/whatsapp:\+/i, '').replace(/\D/g, '');
//     await ensureLearner(phone_str);

//     if (!sessions[phone_str]) {
//       sessions[phone_str] = { state: 'IDLE', course_id: null, module_index: 0 };
//     }
//     const session = sessions[phone_str];

//     // NLP
//     if (isQuestion(text) && !['A','B','C','D'].includes(text.toUpperCase()) && session.state !== 'QUIZ') {
//       const nlpAnswer = processNLPQuery(text);
//       if (nlpAnswer) {
//         return reply(res, nlpAnswer + '\n\n_Reply MENU to return to courses._');
//       }
//     }

//     // HELP
//     if (text.toUpperCase() === 'HELP') {
//       return reply(res, 'HELP MENU\n\nSTART - Show courses\nMENU - Return to courses\nQUIZ - Take quiz\nNEXT - Next module\nPROGRESS - Your progress\nA/B/C/D - Answer quiz');
//     }

//     // PROGRESS
//     if (text.toUpperCase() === 'PROGRESS') {
//       const results  = await QuizResult.find({ phone_number: phone_str }).populate('course_id', 'title');
//       const progress = await LearnerProgress.find({ phone_number: phone_str });

//       if (results.length === 0 && progress.length === 0) {
//         return reply(res, 'No progress yet.\n\nType START to begin learning!');
//       }

//       let msg = 'YOUR LEARNING JOURNEY\n\n';
//       msg += `Courses Enrolled: ${progress.length}\n`;
//       msg += `Quizzes Taken: ${results.length}\n`;

//       if (results.length > 0) {
//         const avg = Math.round(results.reduce((s, r) => s + r.score, 0) / results.length);
//         msg += `Average Score: ${avg}%\n\nCourse Results:\n`;
//         results.forEach(r => {
//           msg += `${r.course_id?.title || 'Course'}: ${r.score}%\n`;
//         });
//       }
//       return reply(res, msg);
//     }

//     // START / MENU
//     if (['MENU','START','HI','HELLO'].includes(text.toUpperCase())) {
//       const existingUser = await User.findOne({ phone_number: phone_str, role: 'learner' });
//       const isRegistered = existingUser && existingUser.name && !existingUser.name.startsWith('Learner_');

//       if (!isRegistered) {
//         sessions[phone_str] = { state: 'REG_NAME' };
//       return reply(res, '👋 *Welcome to Andragogy Learning Platform!*\n\n🎓 Let\'s set up your profile first.\n\n*What is your full name?*\n\n_e.g. Riya Shinde_');
//       }

//       sessions[phone_str] = { state: 'COURSE_SELECTION', course_id: null, module_index: 0 };
//       const courses = await Course.find({ is_active: true });

//       if (courses.length === 0) {
//         return reply(res, 'Welcome back ' + existingUser.name + '!\n\nNo courses available yet.');
//       }

//       let msg = '👋 *Welcome back, ' + existingUser.name + '!* 🎓\n\n';
//       msg += '━━━━━━━━━━━━━━━━━━━━\n';
//       msg += '📚 *Available Courses:*\n\n';
//       courses.forEach((c, i) => { msg += `*${i + 1}.* ${c.title}\n`; });
//       msg += '\n━━━━━━━━━━━━━━━━━━━━\n';
//       msg += '_Reply with a number to begin your learning journey!_';
//       sessions[phone_str].courses = courses.map(c => c._id.toString());
//       return reply(res, msg);
//     }

//     // REGISTRATION
//     if (session.state === 'REG_NAME') {
//       sessions[phone_str].reg_name = text;
//       sessions[phone_str].state    = 'REG_DEPARTMENT';
//       return reply(res, '✅ *Nice to meet you, ' + text + '!*\n\n🏢 *What is your department?*\n\n_Choose one:_\n• IT\n• HR\n• Sales\n• Marketing\n• Finance\n• Operations\n• Development\n• Design\n• Management\n• Other\n\n_Or type your own department name_');
//     }

//     if (session.state === 'REG_DEPARTMENT') {
//       sessions[phone_str].reg_department = text;
//       sessions[phone_str].state          = 'REG_JOBROLE';
//       return reply(res, '✅ *Department noted!*\n\n💼 *What is your job role?*\n\n_Choose one:_\n• Developer\n• Analyst\n• Manager\n• Designer\n• Trainer\n• Executive\n• Other\n\n_Or type your own job role_');
//     }

//     if (session.state === 'REG_JOBROLE') {
//       const name       = sessions[phone_str].reg_name;
//       const department = sessions[phone_str].reg_department;
//       const jobRole    = text;

//       await User.findOneAndUpdate(
//         { phone_number: phone_str },
//         { name, department, job_role: jobRole, role: 'learner' },
//         { upsert: true, new: true }
//       );

//       sessions[phone_str] = { state: 'COURSE_SELECTION', course_id: null, module_index: 0 };
//       const courses = await Course.find({ is_active: true });

//       let msg = '🎉 *Registration Complete!*\n\n';
//       msg += '━━━━━━━━━━━━━━━━━━━━\n';
//       msg += '👤 *Name:* ' + name + '\n';
//       msg += '🏢 *Department:* ' + department + '\n';
//       msg += '💼 *Role:* ' + jobRole + '\n';
//       msg += '━━━━━━━━━━━━━━━━━━━━\n\n';
//       msg += '📚 *Available Courses:*\n\n';
//       courses.forEach((c, i) => { msg += `*${i + 1}.* ${c.title}\n`; });
//       msg += '\n_Reply with a number to begin your learning journey!_';
//       sessions[phone_str].courses = courses.map(c => c._id.toString());
//       return reply(res, msg);
//     }

//     // COURSE SELECTION
//     if (session.state === 'COURSE_SELECTION') {
//       const num       = parseInt(text);
//       const courseIds = session.courses || [];

//       if (isNaN(num) || num < 1 || num > courseIds.length) {
//         return reply(res, `Please reply with a number between 1 and ${courseIds.length}.\n\nType MENU to see courses again.`);
//       }

//       const courseId = courseIds[num - 1];
//       const course   = await Course.findById(courseId);
//       const modules  = await Module.find({ course_id: courseId }).sort('order');

//       if (modules.length === 0) {
//         return reply(res, course.title + '\n\nNo modules available yet.\n\nType MENU to choose another course.');
//       }

//       await LearnerProgress.findOneAndUpdate(
//         { phone_number: phone_str, course_id: courseId },
//         { current_module: modules[0]._id, last_active: new Date() },
//         { upsert: true, new: true }
//       );

//       sessions[phone_str] = {
//         state: 'MODULE_VIEW',
//         course_id: courseId,
//         course_title: course.title,
//         modules: modules.map(m => m._id.toString()),
//         module_index: 0,
//         courses: courseIds,
//       };

//       const mod = modules[0];
//       const cleanTitle0 = mod.title.replace(/^Module\s*\d+[:\s-]*/i, '').trim();
//       let msg = '✅ *Enrolled: ' + course.title + '*\n\n';
//       msg += '*📖 Module 1: ' + cleanTitle0 + '*\n\n';
//       msg += mod.description + '\n';
//       if (mod.pdf_link)   msg += '\n📄 *PDF:* ' + mod.pdf_link;
//       if (mod.video_link) msg += '\n🎥 *Video:* ' + mod.video_link;
//       msg += '\n\n_Reply *NEXT* when done, or *QUIZ* to take the quiz._';
//       return reply(res, msg);
//     }

//     // MODULE CONFIRM
//     if (session.state === 'MODULE_CONFIRM') {
//       if (text.toUpperCase() === 'YES') {
//         const nextIndex = session.next_module_index;
//         const mod = await Module.findById(session.modules[nextIndex]);
//         sessions[phone_str].module_index = nextIndex;
//         sessions[phone_str].state        = 'MODULE_VIEW';
//         delete sessions[phone_str].next_module_index;

//         await LearnerProgress.findOneAndUpdate(
//           { phone_number: phone_str, course_id: session.course_id },
//           { current_module: mod._id, last_active: new Date() }
//         );

//         const cleanTitle1 = mod.title.replace(/^Module\s*\d+[:\s-]*/i, '').trim();
//         let msg = '*📖 Module ' + (nextIndex + 1) + ': ' + cleanTitle1 + '*\n\n';
//         msg += mod.description + '\n';
//         if (mod.pdf_link)   msg += '\n📄 *PDF:* ' + mod.pdf_link;
//         if (mod.video_link) msg += '\n🎥 *Video:* ' + mod.video_link;
//         msg += '\n\n_Reply *NEXT* when done, *QUIZ* for quiz._';
//         return reply(res, msg);
//       }

//       if (text.toUpperCase() === 'QUIZ') {
//         sessions[phone_str].state = 'MODULE_VIEW';
//         // Fall through to QUIZ handling below
//       } else {
//         return reply(res, 'Reply YES to continue to next module\nReply QUIZ to take quiz first\nReply MENU to go back');
//       }
//     }

//     // MODULE VIEW
//     if (session.state === 'MODULE_VIEW') {
//       if (text.toUpperCase() === 'NEXT') {
//         const nextIndex = session.module_index + 1;
//         if (nextIndex >= session.modules.length) {
//           return reply(res, 'All Modules Complete!\n\nYou have finished all modules in ' + session.course_title + '!\n\nType QUIZ to take the final quiz.\nType PROGRESS to see your progress.');
//         }

//         sessions[phone_str].state = 'MODULE_CONFIRM';
//         sessions[phone_str].next_module_index = nextIndex;
//         const currentMod = await Module.findById(session.modules[session.module_index]);
//         const cleanTitleC = currentMod.title.replace(/^Module\s*\d+[:\s-]*/i, '').trim();
//         return reply(res, '✅ *Module ' + (session.module_index + 1) + ': ' + cleanTitleC + '* marked as read!\n\nReady for the next module?\n\nReply YES to continue to Module ' + (nextIndex + 1) + '\nReply QUIZ to take quiz first\nReply MENU to go back');
//       }

//       if (text.toUpperCase() === 'QUIZ') {
//         const questions = await QuizQuestion.find({ course_id: session.course_id });
//         if (questions.length === 0) {
//           return reply(res, 'No quiz questions yet.\n\nType NEXT to continue or MENU for another course.');
//         }

//         sessions[phone_str].state          = 'QUIZ';
//         sessions[phone_str].quiz_questions = questions.map(q => ({
//           id: q._id.toString(), question: q.question,
//           options: q.options, correct: q.correct_answer,
//         }));
//         sessions[phone_str].quiz_index   = 0;
//         sessions[phone_str].quiz_answers = [];

//         const q   = sessions[phone_str].quiz_questions[0];
//         let msg   = 'Quiz: ' + session.course_title + '\n';
//         msg += 'Question 1 of ' + questions.length + '\n\n';
//         msg += q.question + '\n\n';
//         msg += 'A. ' + q.options.A + '\nB. ' + q.options.B + '\nC. ' + q.options.C + '\nD. ' + q.options.D + '\n\n';
//         msg += 'Reply with A, B, C, or D';
//         return reply(res, msg);
//       }

//       return reply(res, 'You are studying ' + session.course_title + '.\n\nNEXT - Next module\nQUIZ - Take quiz\nPROGRESS - Your progress\nMENU - Course list');
//     }

//     // QUIZ
//     if (session.state === 'QUIZ') {
//       const answer = text.toUpperCase();
//       if (!['A','B','C','D'].includes(answer)) {
//         return reply(res, 'Please reply with A, B, C, or D.');
//       }

//       const qIndex    = session.quiz_index;
//       const questions = session.quiz_questions;
//       const current   = questions[qIndex];
//       const isCorrect = answer === current.correct;

//       session.quiz_answers.push({ question_id: current.id, answer, is_correct: isCorrect });

//       const nextIndex = qIndex + 1;

//       if (nextIndex >= questions.length) {
//         const correct = session.quiz_answers.filter(a => a.is_correct).length;
//         const total   = questions.length;
//         const score   = Math.round((correct / total) * 100);

//         await QuizResult.create({
//           phone_number: phone_str, course_id: session.course_id,
//           score, total_questions: total, correct_answers: correct,
//           answers_given: session.quiz_answers,
//         });

//         const moduleId = session.modules[session.module_index];
//         await LearnerProgress.findOneAndUpdate(
//           { phone_number: phone_str, course_id: session.course_id },
//           { $addToSet: { modules_completed: moduleId }, last_active: new Date() }
//         );

//         sessions[phone_str].state       = 'MODULE_VIEW';
//         sessions[phone_str].quiz_index  = 0;
//         sessions[phone_str].quiz_answers = [];

//         const feedbackFinal = isCorrect ? 'Correct!\n\n' : 'Last answer was ' + current.correct + '.\n\n';
//         const now  = new Date();
//         const date = now.getDate() + '/' + (now.getMonth()+1) + '/' + now.getFullYear();

//         let msg = feedbackFinal;
//         msg += 'Quiz Complete!\n\n';
//         msg += 'Your Score: ' + score + '%\n';
//         msg += 'Correct: ' + correct + '/' + total + '\n';
//         msg += (score >= 80 ? 'Outstanding!' : score >= 60 ? 'Good work!' : 'Keep going!') + '\n\n';

//         if (score >= 60) {
//           msg += 'CERTIFICATE OF COMPLETION\n';
//           msg += '------------------------\n';
//           msg += 'Name: ' + (sessions[phone_str]?.reg_name || 'Learner') + '\n';
//           msg += 'Course: ' + session.course_title + '\n';
//           msg += 'Score: ' + score + '%\n';
//           msg += 'Date: ' + date + '\n';
//           msg += 'Issued by Andragogy Learning Platform\n\n';
//         }

//         msg += 'What next?\nNEXT - Continue\nMENU - Courses\nPROGRESS - Your progress';
//         return reply(res, msg);
//       }

//       sessions[phone_str].quiz_index = nextIndex;
//       const nextQ        = questions[nextIndex];
//       const feedbackNext = isCorrect ? 'Correct!\n\n' : 'Incorrect. Answer was ' + current.correct + '.\n\n';

//       let msgNext = feedbackNext;
//       msgNext += 'Question ' + (nextIndex + 1) + ' of ' + questions.length + ':\n\n';
//       msgNext += nextQ.question + '\n\n';
//       msgNext += 'A. ' + nextQ.options.A + '\nB. ' + nextQ.options.B + '\nC. ' + nextQ.options.C + '\nD. ' + nextQ.options.D + '\n\n';
//       msgNext += 'Reply with A, B, C, or D';
//       return reply(res, msgNext);
//     }

//     // Default
//     const nlpAnswer = processNLPQuery(text);
//     if (nlpAnswer) {
//       return reply(res, nlpAnswer + '\n\nType START to begin a course.');
//     }

//     return reply(res, 'Andragogy Learning Bot\n\nType START to begin learning\nType HELP to see all commands');

//   } catch (err) {
//     console.error('WhatsApp route error:', err);
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// router.post('/webhook', async (req, res) => {
//   try {
//     const body    = req.body;
//     const phone   = body.from || body.source || body.phone;
//     const message = body.text?.body || body.message || body.msg;
//     if (phone && message) {
//       const fakeReq = { body: { phone, message } };
//       const fakeRes = { json: () => {}, set: () => {}, send: () => {} };
//       await router.handle(fakeReq, fakeRes, () => {});
//     }
//     res.json({ success: true });
//   } catch (err) {
//     console.error('Webhook error:', err);
//     res.status(500).json({ success: false });
//   }
// });

// router.get('/test', async (req, res) => {
//   const result = await whatsappService.testConnection();
//   res.json(result);
// });

// router.get('/sessions', (req, res) => {
//   res.json({ success: true, active_sessions: Object.keys(sessions).length });
// });

// module.exports = router;


















// const express  = require('express');
// const { Course, Module, QuizQuestion, QuizResult, LearnerProgress } = require('../models/models');
// const User     = require('../models/User');
// const { processNLPQuery, isQuestion } = require('../services/nlpService');
// const whatsappService = require('../services/whatsappService');

// const router   = express.Router();
// const sessions = {};

// function reply(res, message) {
//   res.set('Content-Type', 'text/xml');
//   const safe = message
//     .replace(/&/g,'&amp;')
//     .replace(/</g,'&lt;')
//     .replace(/>/g,'&gt;');
//   return res.send(`<?xml version="1.0" encoding="UTF-8"?><Response><Message>${safe}</Message></Response>`);
// }

// async function ensureLearner(phone) {
//   let user = await User.findOne({ phone_number: phone, role: 'learner' });
//   if (!user) {
//     user = await User.create({ name: `Learner_${phone.slice(-4)}`, phone_number: phone, role: 'learner' });
//   }
//   return user;
// }

// router.post('/message', async (req, res) => {
//   try {
//     const phone   = req.body.From || req.body.phone || '';
//     const message = req.body.Body || req.body.message || '';

//     if (!phone || !message) {
//       return res.status(400).json({ success: false, message: 'phone and message required' });
//     }

//     const text      = message.trim();
//     const phone_str = String(phone).replace(/whatsapp:\+/i, '').replace(/\D/g, '');
//     await ensureLearner(phone_str);

//     if (!sessions[phone_str]) {
//       sessions[phone_str] = { state: 'IDLE', course_id: null, module_index: 0 };
//     }
//     const session = sessions[phone_str];

//     // NLP
//     if (isQuestion(text) && !['A','B','C','D'].includes(text.toUpperCase()) && session.state !== 'QUIZ') {
//       const nlpAnswer = processNLPQuery(text);
//       if (nlpAnswer) {
//         return reply(res, nlpAnswer + '\n\n_Reply MENU to return to courses._');
//       }
//     }

//     // POLL RESPONSE — check active poll even if state is IDLE
//     const isPollAnswer = ['A','B','C','D','E','F'].includes(text.toUpperCase());
//     if (isPollAnswer && !session.state?.includes('QUIZ')) {
//       // Check if there's an active poll in memory
//       try {
//         const pollsResp = await fetch(`http://localhost:${process.env.PORT || 5000}/api/polls`);
//         const pollsData = await pollsResp.json();
//         const activePoll = pollsData.data?.find(p => p.status === 'active');
//         console.log('Active poll:', activePoll?.id, activePoll?.question);

//         if (activePoll) {
//           const answer = text.toUpperCase();
//           const idx    = answer.charCodeAt(0) - 65;

//           if (idx < activePoll.options.length) {
//             const selected = activePoll.options[idx];

//             // Record response
//             await fetch(`http://localhost:${process.env.PORT || 5000}/api/polls/${activePoll.id}/respond`, {
//               method: 'POST',
//               headers: { 'Content-Type': 'application/json' },
//               body: JSON.stringify({ phone_number: phone_str, name: sessions[phone_str]?.reg_name || 'Learner', selected })
//             });

//             // Fetch updated results
//             const updatedResp = await fetch(`http://localhost:${process.env.PORT || 5000}/api/polls/${activePoll.id}`);
//             const updatedData = await updatedResp.json();
//             const p      = updatedData.data;
//             const total  = p.response_count || 0;
//             const counts = p.counts || {};
//             const maxVotes = Math.max(...Object.values(counts).map(v => Number(v)));

//             let msg = `📊 *Live Results — ${p.question}*\n`;
//             msg += `━━━━━━━━━━━━━━━━━━━━\n`;
//             p.options.forEach((opt, i) => {
//               const letter   = String.fromCharCode(65 + i);
//               const count    = Number(counts[opt]) || 0;
//               const pct      = total > 0 ? Math.round((count / total) * 100) : 0;
//               const bars     = Math.round(pct / 10);
//               const bar      = '█'.repeat(bars) + '░'.repeat(10 - bars);
//               const isWinner = count === maxVotes && count > 0;
//               msg += `${isWinner ? '🏆' : '  '} *${letter}.* ${opt}\n`;
//               msg += `   ${bar} ${pct}%  (${count})\n\n`;
//             });
//             msg += `━━━━━━━━━━━━━━━━━━━━\n`;
//             msg += `👥 *Total: ${total} vote${total !== 1 ? 's' : ''}*`;

//             return reply(res, msg);
//           }
//         }
//       } catch(e) {
//         console.error('Poll response error:', e.message);
//       }
//     }

//     // HELP
//     if (text.toUpperCase() === 'HELP') {
//       return reply(res, 'HELP MENU\n\nSTART - Show courses\nMENU - Return to courses\nQUIZ - Take quiz\nNEXT - Next module\nPROGRESS - Your progress\nA/B/C/D - Answer quiz');
//     }

//     // PROGRESS
//     if (text.toUpperCase() === 'PROGRESS') {
//       const results  = await QuizResult.find({ phone_number: phone_str }).populate('course_id', 'title');
//       const progress = await LearnerProgress.find({ phone_number: phone_str });

//       if (results.length === 0 && progress.length === 0) {
//         return reply(res, 'No progress yet.\n\nType START to begin learning!');
//       }

//       let msg = 'YOUR LEARNING JOURNEY\n\n';
//       msg += `Courses Enrolled: ${progress.length}\n`;
//       msg += `Quizzes Taken: ${results.length}\n`;

//       if (results.length > 0) {
//         const avg = Math.round(results.reduce((s, r) => s + r.score, 0) / results.length);
//         msg += `Average Score: ${avg}%\n\nCourse Results:\n`;
//         results.forEach(r => {
//           msg += `${r.course_id?.title || 'Course'}: ${r.score}%\n`;
//         });
//       }
//       return reply(res, msg);
//     }

//     // START / MENU
//     if (['MENU','START','HI','HELLO'].includes(text.toUpperCase())) {
//       const existingUser = await User.findOne({ phone_number: phone_str, role: 'learner' });
//       const isRegistered = existingUser && existingUser.name && !existingUser.name.startsWith('Learner_');

//       if (!isRegistered) {
//         sessions[phone_str] = { state: 'REG_NAME' };
//       return reply(res, '👋 *Welcome to Andragogy Learning Platform!*\n\n🎓 Let\'s set up your profile first.\n\n*What is your full name?*\n\n_e.g. Riya Shinde_');
//       }

//       sessions[phone_str] = { state: 'COURSE_SELECTION', course_id: null, module_index: 0 };
//       const courses = await Course.find({ is_active: true });

//       if (courses.length === 0) {
//         return reply(res, 'Welcome back ' + existingUser.name + '!\n\nNo courses available yet.');
//       }

//       let msg = '👋 *Welcome back, ' + existingUser.name + '!* 🎓\n\n';
//       msg += '━━━━━━━━━━━━━━━━━━━━\n';
//       msg += '📚 *Available Courses:*\n\n';
//       courses.forEach((c, i) => { msg += `*${i + 1}.* ${c.title}\n`; });
//       msg += '\n━━━━━━━━━━━━━━━━━━━━\n';
//       msg += '_Reply with a number to begin your learning journey!_';
//       sessions[phone_str].courses = courses.map(c => c._id.toString());
//       return reply(res, msg);
//     }

//     // REGISTRATION
//     if (session.state === 'REG_NAME') {
//       sessions[phone_str].reg_name = text;
//       sessions[phone_str].state    = 'REG_DEPARTMENT';
//       return reply(res, '✅ *Nice to meet you, ' + text + '!*\n\n🏢 *What is your department?*\n\n_Choose one:_\n• IT\n• HR\n• Sales\n• Marketing\n• Finance\n• Operations\n• Development\n• Design\n• Management\n• Other\n\n_Or type your own department name_');
//     }

//     if (session.state === 'REG_DEPARTMENT') {
//       sessions[phone_str].reg_department = text;
//       sessions[phone_str].state          = 'REG_JOBROLE';
//       return reply(res, '✅ *Department noted!*\n\n💼 *What is your job role?*\n\n_Choose one:_\n• Developer\n• Analyst\n• Manager\n• Designer\n• Trainer\n• Executive\n• Other\n\n_Or type your own job role_');
//     }

//     if (session.state === 'REG_JOBROLE') {
//       const name       = sessions[phone_str].reg_name;
//       const department = sessions[phone_str].reg_department;
//       const jobRole    = text;

//       await User.findOneAndUpdate(
//         { phone_number: phone_str },
//         { name, department, job_role: jobRole, role: 'learner' },
//         { upsert: true, new: true }
//       );

//       sessions[phone_str] = { state: 'COURSE_SELECTION', course_id: null, module_index: 0 };
//       const courses = await Course.find({ is_active: true });

//       let msg = '🎉 *Registration Complete!*\n\n';
//       msg += '━━━━━━━━━━━━━━━━━━━━\n';
//       msg += '👤 *Name:* ' + name + '\n';
//       msg += '🏢 *Department:* ' + department + '\n';
//       msg += '💼 *Role:* ' + jobRole + '\n';
//       msg += '━━━━━━━━━━━━━━━━━━━━\n\n';
//       msg += '📚 *Available Courses:*\n\n';
//       courses.forEach((c, i) => { msg += `*${i + 1}.* ${c.title}\n`; });
//       msg += '\n_Reply with a number to begin your learning journey!_';
//       sessions[phone_str].courses = courses.map(c => c._id.toString());
//       return reply(res, msg);
//     }

//     // COURSE SELECTION
//     if (session.state === 'COURSE_SELECTION') {
//       const num       = parseInt(text);
//       const courseIds = session.courses || [];

//       if (isNaN(num) || num < 1 || num > courseIds.length) {
//         return reply(res, `Please reply with a number between 1 and ${courseIds.length}.\n\nType MENU to see courses again.`);
//       }

//       const courseId = courseIds[num - 1];
//       const course   = await Course.findById(courseId);
//       const modules  = await Module.find({ course_id: courseId }).sort('order');

//       if (modules.length === 0) {
//         return reply(res, course.title + '\n\nNo modules available yet.\n\nType MENU to choose another course.');
//       }

//       await LearnerProgress.findOneAndUpdate(
//         { phone_number: phone_str, course_id: courseId },
//         { current_module: modules[0]._id, last_active: new Date() },
//         { upsert: true, new: true }
//       );

//       sessions[phone_str] = {
//         state: 'MODULE_VIEW',
//         course_id: courseId,
//         course_title: course.title,
//         modules: modules.map(m => m._id.toString()),
//         module_index: 0,
//         courses: courseIds,
//       };

//       const mod = modules[0];
//       const cleanTitle0 = mod.title.replace(/^Module\s*\d+[:\s-]*/i, '').trim();
//       let msg = '✅ *Enrolled: ' + course.title + '*\n\n';
//       msg += '*📖 Module 1: ' + cleanTitle0 + '*\n\n';
//       msg += mod.description + '\n';
//       if (mod.pdf_link)   msg += '\n📄 *PDF:* ' + mod.pdf_link;
//       if (mod.video_link) msg += '\n🎥 *Video:* ' + mod.video_link;
//       msg += '\n\n_Reply *NEXT* when done, or *QUIZ* to take the quiz._';
//       return reply(res, msg);
//     }

//     // MODULE CONFIRM
//     if (session.state === 'MODULE_CONFIRM') {
//       if (text.toUpperCase() === 'YES') {
//         const nextIndex = session.next_module_index;
//         const mod = await Module.findById(session.modules[nextIndex]);
//         sessions[phone_str].module_index = nextIndex;
//         sessions[phone_str].state        = 'MODULE_VIEW';
//         delete sessions[phone_str].next_module_index;

//         await LearnerProgress.findOneAndUpdate(
//           { phone_number: phone_str, course_id: session.course_id },
//           { current_module: mod._id, last_active: new Date() }
//         );

//         const cleanTitle1 = mod.title.replace(/^Module\s*\d+[:\s-]*/i, '').trim();
//         let msg = '*📖 Module ' + (nextIndex + 1) + ': ' + cleanTitle1 + '*\n\n';
//         msg += mod.description + '\n';
//         if (mod.pdf_link)   msg += '\n📄 *PDF:* ' + mod.pdf_link;
//         if (mod.video_link) msg += '\n🎥 *Video:* ' + mod.video_link;
//         msg += '\n\n_Reply *NEXT* when done, *QUIZ* for quiz._';
//         return reply(res, msg);
//       }

//       if (text.toUpperCase() === 'QUIZ') {
//         sessions[phone_str].state = 'MODULE_VIEW';
//         // Fall through to QUIZ handling below
//       } else {
//         return reply(res, 'Reply YES to continue to next module\nReply QUIZ to take quiz first\nReply MENU to go back');
//       }
//     }

//     // MODULE VIEW
//     if (session.state === 'MODULE_VIEW') {
//       if (text.toUpperCase() === 'NEXT') {
//         const nextIndex = session.module_index + 1;
//         if (nextIndex >= session.modules.length) {
//           return reply(res, 'All Modules Complete!\n\nYou have finished all modules in ' + session.course_title + '!\n\nType QUIZ to take the final quiz.\nType PROGRESS to see your progress.');
//         }

//         sessions[phone_str].state = 'MODULE_CONFIRM';
//         sessions[phone_str].next_module_index = nextIndex;
//         const currentMod = await Module.findById(session.modules[session.module_index]);
//         const cleanTitleC = currentMod.title.replace(/^Module\s*\d+[:\s-]*/i, '').trim();
//         return reply(res, '✅ *Module ' + (session.module_index + 1) + ': ' + cleanTitleC + '* marked as read!\n\nReady for the next module?\n\nReply YES to continue to Module ' + (nextIndex + 1) + '\nReply QUIZ to take quiz first\nReply MENU to go back');
//       }

//       if (text.toUpperCase() === 'QUIZ') {
//         const questions = await QuizQuestion.find({ course_id: session.course_id });
//         if (questions.length === 0) {
//           return reply(res, 'No quiz questions yet.\n\nType NEXT to continue or MENU for another course.');
//         }

//         sessions[phone_str].state          = 'QUIZ';
//         sessions[phone_str].quiz_questions = questions.map(q => ({
//           id: q._id.toString(), question: q.question,
//           options: q.options, correct: q.correct_answer,
//         }));
//         sessions[phone_str].quiz_index   = 0;
//         sessions[phone_str].quiz_answers = [];

//         const q   = sessions[phone_str].quiz_questions[0];
//         let msg   = 'Quiz: ' + session.course_title + '\n';
//         msg += 'Question 1 of ' + questions.length + '\n\n';
//         msg += q.question + '\n\n';
//         msg += 'A. ' + q.options.A + '\nB. ' + q.options.B + '\nC. ' + q.options.C + '\nD. ' + q.options.D + '\n\n';
//         msg += 'Reply with A, B, C, or D';
//         return reply(res, msg);
//       }

//       return reply(res, 'You are studying ' + session.course_title + '.\n\nNEXT - Next module\nQUIZ - Take quiz\nPROGRESS - Your progress\nMENU - Course list');
//     }

//     // QUIZ
//     if (session.state === 'QUIZ') {
//       const answer = text.toUpperCase();
//       if (!['A','B','C','D'].includes(answer)) {
//         return reply(res, 'Please reply with A, B, C, or D.');
//       }

//       const qIndex    = session.quiz_index;
//       const questions = session.quiz_questions;
//       const current   = questions[qIndex];
//       const isCorrect = answer === current.correct;

//       session.quiz_answers.push({ question_id: current.id, answer, is_correct: isCorrect });

//       const nextIndex = qIndex + 1;

//       if (nextIndex >= questions.length) {
//         const correct = session.quiz_answers.filter(a => a.is_correct).length;
//         const total   = questions.length;
//         const score   = Math.round((correct / total) * 100);

//         await QuizResult.create({
//           phone_number: phone_str, course_id: session.course_id,
//           score, total_questions: total, correct_answers: correct,
//           answers_given: session.quiz_answers,
//         });

//         const moduleId = session.modules[session.module_index];
//         await LearnerProgress.findOneAndUpdate(
//           { phone_number: phone_str, course_id: session.course_id },
//           { $addToSet: { modules_completed: moduleId }, last_active: new Date() }
//         );

//         sessions[phone_str].state       = 'MODULE_VIEW';
//         sessions[phone_str].quiz_index  = 0;
//         sessions[phone_str].quiz_answers = [];

//         const feedbackFinal = isCorrect ? 'Correct!\n\n' : 'Last answer was ' + current.correct + '.\n\n';
//         const now  = new Date();
//         const date = now.getDate() + '/' + (now.getMonth()+1) + '/' + now.getFullYear();

//         let msg = feedbackFinal;
//         msg += 'Quiz Complete!\n\n';
//         msg += 'Your Score: ' + score + '%\n';
//         msg += 'Correct: ' + correct + '/' + total + '\n';
//         msg += (score >= 80 ? 'Outstanding!' : score >= 60 ? 'Good work!' : 'Keep going!') + '\n\n';

//         if (score >= 60) {
//           msg += 'CERTIFICATE OF COMPLETION\n';
//           msg += '------------------------\n';
//           msg += 'Name: ' + (sessions[phone_str]?.reg_name || 'Learner') + '\n';
//           msg += 'Course: ' + session.course_title + '\n';
//           msg += 'Score: ' + score + '%\n';
//           msg += 'Date: ' + date + '\n';
//           msg += 'Issued by Andragogy Learning Platform\n\n';
//         }

//         msg += 'What next?\nNEXT - Continue\nMENU - Courses\nPROGRESS - Your progress';
//         return reply(res, msg);
//       }

//       sessions[phone_str].quiz_index = nextIndex;
//       const nextQ        = questions[nextIndex];
//       const feedbackNext = isCorrect ? 'Correct!\n\n' : 'Incorrect. Answer was ' + current.correct + '.\n\n';

//       let msgNext = feedbackNext;
//       msgNext += 'Question ' + (nextIndex + 1) + ' of ' + questions.length + ':\n\n';
//       msgNext += nextQ.question + '\n\n';
//       msgNext += 'A. ' + nextQ.options.A + '\nB. ' + nextQ.options.B + '\nC. ' + nextQ.options.C + '\nD. ' + nextQ.options.D + '\n\n';
//       msgNext += 'Reply with A, B, C, or D';
//       return reply(res, msgNext);
//     }

//     // DEFAULT — check if there's an active poll the learner hasn't answered
//     const nlpAnswer = processNLPQuery(text);
//     if (nlpAnswer) {
//       return reply(res, nlpAnswer + '\n\nType START to begin a course.');
//     }

//     return reply(res, 'Andragogy Learning Bot\n\nType START to begin learning\nType HELP to see all commands');

//   } catch (err) {
//     console.error('WhatsApp route error:', err);
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// router.post('/webhook', async (req, res) => {
//   try {
//     const body    = req.body;
//     const phone   = body.from || body.source || body.phone;
//     const message = body.text?.body || body.message || body.msg;
//     if (phone && message) {
//       const fakeReq = { body: { phone, message } };
//       const fakeRes = { json: () => {}, set: () => {}, send: () => {} };
//       await router.handle(fakeReq, fakeRes, () => {});
//     }
//     res.json({ success: true });
//   } catch (err) {
//     console.error('Webhook error:', err);
//     res.status(500).json({ success: false });
//   }
// });

// router.get('/test', async (req, res) => {
//   const result = await whatsappService.testConnection();
//   res.json(result);
// });

// router.get('/sessions', (req, res) => {
//   res.json({ success: true, active_sessions: Object.keys(sessions).length });
// });

// module.exports = router;





















// const express  = require('express');
// const { Course, Module, QuizQuestion, QuizResult, LearnerProgress } = require('../models/models');
// const User     = require('../models/User');
// const { processNLPQuery, isQuestion } = require('../services/nlpService');
// const whatsappService = require('../services/whatsappService');

// const router   = express.Router();
// const sessions = {};

// function reply(res, message) {
//   res.set('Content-Type', 'text/xml');
//   const safe = message
//     .replace(/&/g,'&amp;')
//     .replace(/</g,'&lt;')
//     .replace(/>/g,'&gt;');
//   return res.send(`<?xml version="1.0" encoding="UTF-8"?><Response><Message>${safe}</Message></Response>`);
// }

// async function ensureLearner(phone) {
//   let user = await User.findOne({ phone_number: phone, role: 'learner' });
//   if (!user) {
//     user = await User.create({ name: `Learner_${phone.slice(-4)}`, phone_number: phone, role: 'learner' });
//   }
//   return user;
// }

// router.post('/message', async (req, res) => {
//   try {
//     const phone   = req.body.From || req.body.phone || '';
//     const message = req.body.Body || req.body.message || '';

//     if (!phone || !message) {
//       return res.status(400).json({ success: false, message: 'phone and message required' });
//     }

//     const text      = message.trim();
//     const phone_str = String(phone).replace(/whatsapp:\+/i, '').replace(/\D/g, '');
//     await ensureLearner(phone_str);

//     if (!sessions[phone_str]) {
//       sessions[phone_str] = { state: 'IDLE', course_id: null, module_index: 0 };
//     }
//     const session = sessions[phone_str];

//     // NLP
//     if (isQuestion(text) && !['A','B','C','D'].includes(text.toUpperCase()) && session.state !== 'QUIZ') {
//       const nlpAnswer = processNLPQuery(text);
//       if (nlpAnswer) {
//         return reply(res, nlpAnswer + '\n\n_Reply MENU to return to courses._');
//       }
//     }

//     // POLL RESPONSE — check active poll even if state is IDLE
//     const cleanText = text.toUpperCase().trim();
//     const isPollAnswer = ['A','B','C','D','E','F'].includes(cleanText) && cleanText.length === 1;

//     // If looks like multiple poll answers e.g. "B,C" or "BC"
//     if (!isPollAnswer && session.state === 'COURSE_SELECTION' &&
//         /^[A-F][,\s][A-F]$/i.test(text.trim())) {
//       return reply(res, '⚠️ Please reply with only *one* letter at a time.\n\nType *A*, *B*, *C* etc. to vote.');
//     }

//     if (isPollAnswer && !session.state?.includes('QUIZ')) {
//       // Check if there's an active poll in memory
//       try {
//         const pollsResp = await fetch(`http://localhost:${process.env.PORT || 5000}/api/polls`);
//         const pollsData = await pollsResp.json();
//         const activePoll = pollsData.data?.find(p => p.status === 'active');
//         console.log('Active poll:', activePoll?.id, activePoll?.question);

//         if (activePoll) {
//           const answer = text.toUpperCase();
//           const idx    = answer.charCodeAt(0) - 65;

//           if (idx < activePoll.options.length) {
//             const selected = activePoll.options[idx];

//             // Record response
//             await fetch(`http://localhost:${process.env.PORT || 5000}/api/polls/${activePoll.id}/respond`, {
//               method: 'POST',
//               headers: { 'Content-Type': 'application/json' },
//               body: JSON.stringify({ phone_number: phone_str, name: sessions[phone_str]?.reg_name || 'Learner', selected })
//             });

//             // Fetch updated results
//             const updatedResp = await fetch(`http://localhost:${process.env.PORT || 5000}/api/polls/${activePoll.id}`);
//             const updatedData = await updatedResp.json();
//             const p      = updatedData.data;
//             const total  = p.response_count || 0;
//             const counts = p.counts || {};
//             const maxVotes = Math.max(...Object.values(counts).map(v => Number(v)));

//             let msg = `📊 *Live Results — ${p.question}*\n`;
//             msg += `━━━━━━━━━━━━━━━━━━━━\n`;
//             p.options.forEach((opt, i) => {
//               const letter   = String.fromCharCode(65 + i);
//               const count    = Number(counts[opt]) || 0;
//               const pct      = total > 0 ? Math.round((count / total) * 100) : 0;
//               const bars     = Math.round(pct / 10);
//               const bar      = '█'.repeat(bars) + '░'.repeat(10 - bars);
//               const isWinner = count === maxVotes && count > 0;
//               msg += `${isWinner ? '🏆' : '  '} *${letter}.* ${opt}\n`;
//               msg += `   ${bar} ${pct}%  (${count})\n\n`;
//             });
//             msg += `━━━━━━━━━━━━━━━━━━━━\n`;
//             msg += `👥 *Total: ${total} vote${total !== 1 ? 's' : ''}*`;

//             return reply(res, msg);
//           }
//         }
//       } catch(e) {
//         console.error('Poll response error:', e.message);
//       }
//     }

//     // HELP
//     if (text.toUpperCase() === 'HELP') {
//       return reply(res, 'HELP MENU\n\nSTART - Show courses\nMENU - Return to courses\nQUIZ - Take quiz\nNEXT - Next module\nPROGRESS - Your progress\nA/B/C/D - Answer quiz');
//     }

//     // PROGRESS
//     if (text.toUpperCase() === 'PROGRESS') {
//       const results  = await QuizResult.find({ phone_number: phone_str }).populate('course_id', 'title');
//       const progress = await LearnerProgress.find({ phone_number: phone_str });

//       if (results.length === 0 && progress.length === 0) {
//         return reply(res, 'No progress yet.\n\nType START to begin learning!');
//       }

//       let msg = 'YOUR LEARNING JOURNEY\n\n';
//       msg += `Courses Enrolled: ${progress.length}\n`;
//       msg += `Quizzes Taken: ${results.length}\n`;

//       if (results.length > 0) {
//         const avg = Math.round(results.reduce((s, r) => s + r.score, 0) / results.length);
//         msg += `Average Score: ${avg}%\n\nCourse Results:\n`;
//         results.forEach(r => {
//           msg += `${r.course_id?.title || 'Course'}: ${r.score}%\n`;
//         });
//       }
//       return reply(res, msg);
//     }

//     // START / MENU
//     if (['MENU','START','HI','HELLO'].includes(text.toUpperCase())) {
//       const existingUser = await User.findOne({ phone_number: phone_str, role: 'learner' });
//       const isRegistered = existingUser && existingUser.name && !existingUser.name.startsWith('Learner_');

//       if (!isRegistered) {
//         sessions[phone_str] = { state: 'REG_NAME' };
//       return reply(res, '👋 *Welcome to Andragogy Learning Platform!*\n\n🎓 Let\'s set up your profile first.\n\n*What is your full name?*\n\n_e.g. Riya Shinde_');
//       }

//       sessions[phone_str] = { state: 'COURSE_SELECTION', course_id: null, module_index: 0 };
//       const courses = await Course.find({ is_active: true });

//       if (courses.length === 0) {
//         return reply(res, 'Welcome back ' + existingUser.name + '!\n\nNo courses available yet.');
//       }

//       let msg = '👋 *Welcome back, ' + existingUser.name + '!* 🎓\n\n';
//       msg += '━━━━━━━━━━━━━━━━━━━━\n';
//       msg += '📚 *Available Courses:*\n\n';
//       courses.forEach((c, i) => { msg += `*${i + 1}.* ${c.title}\n`; });
//       msg += '\n━━━━━━━━━━━━━━━━━━━━\n';
//       msg += '_Reply with a number to begin your learning journey!_';
//       sessions[phone_str].courses = courses.map(c => c._id.toString());
//       return reply(res, msg);
//     }

//     // REGISTRATION
//     if (session.state === 'REG_NAME') {
//       sessions[phone_str].reg_name = text;
//       sessions[phone_str].state    = 'REG_DEPARTMENT';
//       return reply(res, '✅ *Nice to meet you, ' + text + '!*\n\n🏢 *What is your department?*\n\n_Choose one:_\n• IT\n• HR\n• Sales\n• Marketing\n• Finance\n• Operations\n• Development\n• Design\n• Management\n• Other\n\n_Or type your own department name_');
//     }

//     if (session.state === 'REG_DEPARTMENT') {
//       sessions[phone_str].reg_department = text;
//       sessions[phone_str].state          = 'REG_JOBROLE';
//       return reply(res, '✅ *Department noted!*\n\n💼 *What is your job role?*\n\n_Choose one:_\n• Developer\n• Analyst\n• Manager\n• Designer\n• Trainer\n• Executive\n• Other\n\n_Or type your own job role_');
//     }

//     if (session.state === 'REG_JOBROLE') {
//       const name       = sessions[phone_str].reg_name;
//       const department = sessions[phone_str].reg_department;
//       const jobRole    = text;

//       await User.findOneAndUpdate(
//         { phone_number: phone_str },
//         { name, department, job_role: jobRole, role: 'learner' },
//         { upsert: true, new: true }
//       );

//       sessions[phone_str] = { state: 'COURSE_SELECTION', course_id: null, module_index: 0 };
//       const courses = await Course.find({ is_active: true });

//       let msg = '🎉 *Registration Complete!*\n\n';
//       msg += '━━━━━━━━━━━━━━━━━━━━\n';
//       msg += '👤 *Name:* ' + name + '\n';
//       msg += '🏢 *Department:* ' + department + '\n';
//       msg += '💼 *Role:* ' + jobRole + '\n';
//       msg += '━━━━━━━━━━━━━━━━━━━━\n\n';
//       msg += '📚 *Available Courses:*\n\n';
//       courses.forEach((c, i) => { msg += `*${i + 1}.* ${c.title}\n`; });
//       msg += '\n_Reply with a number to begin your learning journey!_';
//       sessions[phone_str].courses = courses.map(c => c._id.toString());
//       return reply(res, msg);
//     }

//     // COURSE SELECTION
//     if (session.state === 'COURSE_SELECTION') {
//       const num       = parseInt(text);
//       const courseIds = session.courses || [];

//       if (isNaN(num) || num < 1 || num > courseIds.length) {
//         return reply(res, `Please reply with a number between 1 and ${courseIds.length}.\n\nType MENU to see courses again.`);
//       }

//       const courseId = courseIds[num - 1];
//       const course   = await Course.findById(courseId);
//       const modules  = await Module.find({ course_id: courseId }).sort('order');

//       if (modules.length === 0) {
//         return reply(res, course.title + '\n\nNo modules available yet.\n\nType MENU to choose another course.');
//       }

//       await LearnerProgress.findOneAndUpdate(
//         { phone_number: phone_str, course_id: courseId },
//         { current_module: modules[0]._id, last_active: new Date() },
//         { upsert: true, new: true }
//       );

//       sessions[phone_str] = {
//         state: 'MODULE_VIEW',
//         course_id: courseId,
//         course_title: course.title,
//         modules: modules.map(m => m._id.toString()),
//         module_index: 0,
//         courses: courseIds,
//       };

//       const mod = modules[0];
//       const cleanTitle0 = mod.title.replace(/^Module\s*\d+[:\s-]*/i, '').trim();
//       let msg = '✅ *Enrolled: ' + course.title + '*\n\n';
//       msg += '*📖 Module 1: ' + cleanTitle0 + '*\n\n';
//       msg += mod.description + '\n';
//       if (mod.pdf_link)   msg += '\n📄 *PDF:* ' + mod.pdf_link;
//       if (mod.video_link) msg += '\n🎥 *Video:* ' + mod.video_link;
//       msg += '\n\n_Reply *NEXT* when done, or *QUIZ* to take the quiz._';
//       return reply(res, msg);
//     }

//     // MODULE CONFIRM
//     if (session.state === 'MODULE_CONFIRM') {
//       if (text.toUpperCase() === 'YES') {
//         const nextIndex = session.next_module_index;
//         const mod = await Module.findById(session.modules[nextIndex]);
//         sessions[phone_str].module_index = nextIndex;
//         sessions[phone_str].state        = 'MODULE_VIEW';
//         delete sessions[phone_str].next_module_index;

//         await LearnerProgress.findOneAndUpdate(
//           { phone_number: phone_str, course_id: session.course_id },
//           { current_module: mod._id, last_active: new Date() }
//         );

//         const cleanTitle1 = mod.title.replace(/^Module\s*\d+[:\s-]*/i, '').trim();
//         let msg = '*📖 Module ' + (nextIndex + 1) + ': ' + cleanTitle1 + '*\n\n';
//         msg += mod.description + '\n';
//         if (mod.pdf_link)   msg += '\n📄 *PDF:* ' + mod.pdf_link;
//         if (mod.video_link) msg += '\n🎥 *Video:* ' + mod.video_link;
//         msg += '\n\n_Reply *NEXT* when done, *QUIZ* for quiz._';
//         return reply(res, msg);
//       }

//       if (text.toUpperCase() === 'QUIZ') {
//         sessions[phone_str].state = 'MODULE_VIEW';
//         // Fall through to QUIZ handling below
//       } else {
//         return reply(res, 'Reply YES to continue to next module\nReply QUIZ to take quiz first\nReply MENU to go back');
//       }
//     }

//     // MODULE VIEW
//     if (session.state === 'MODULE_VIEW') {
//       if (text.toUpperCase() === 'NEXT') {
//         const nextIndex = session.module_index + 1;
//         if (nextIndex >= session.modules.length) {
//           return reply(res, 'All Modules Complete!\n\nYou have finished all modules in ' + session.course_title + '!\n\nType QUIZ to take the final quiz.\nType PROGRESS to see your progress.');
//         }

//         sessions[phone_str].state = 'MODULE_CONFIRM';
//         sessions[phone_str].next_module_index = nextIndex;
//         const currentMod = await Module.findById(session.modules[session.module_index]);
//         const cleanTitleC = currentMod.title.replace(/^Module\s*\d+[:\s-]*/i, '').trim();
//         return reply(res, '✅ *Module ' + (session.module_index + 1) + ': ' + cleanTitleC + '* marked as read!\n\nReady for the next module?\n\nReply YES to continue to Module ' + (nextIndex + 1) + '\nReply QUIZ to take quiz first\nReply MENU to go back');
//       }

//       if (text.toUpperCase() === 'QUIZ') {
//         const questions = await QuizQuestion.find({ course_id: session.course_id });
//         if (questions.length === 0) {
//           return reply(res, 'No quiz questions yet.\n\nType NEXT to continue or MENU for another course.');
//         }

//         sessions[phone_str].state          = 'QUIZ';
//         sessions[phone_str].quiz_questions = questions.map(q => ({
//           id: q._id.toString(), question: q.question,
//           options: q.options, correct: q.correct_answer,
//         }));
//         sessions[phone_str].quiz_index   = 0;
//         sessions[phone_str].quiz_answers = [];

//         const q   = sessions[phone_str].quiz_questions[0];
//         let msg   = 'Quiz: ' + session.course_title + '\n';
//         msg += 'Question 1 of ' + questions.length + '\n\n';
//         msg += q.question + '\n\n';
//         msg += 'A. ' + q.options.A + '\nB. ' + q.options.B + '\nC. ' + q.options.C + '\nD. ' + q.options.D + '\n\n';
//         msg += 'Reply with A, B, C, or D';
//         return reply(res, msg);
//       }

//       return reply(res, 'You are studying ' + session.course_title + '.\n\nNEXT - Next module\nQUIZ - Take quiz\nPROGRESS - Your progress\nMENU - Course list');
//     }

//     // QUIZ
//     if (session.state === 'QUIZ') {
//       const answer = text.toUpperCase();
//       if (!['A','B','C','D'].includes(answer)) {
//         return reply(res, 'Please reply with A, B, C, or D.');
//       }

//       const qIndex    = session.quiz_index;
//       const questions = session.quiz_questions;
//       const current   = questions[qIndex];
//       const isCorrect = answer === current.correct;

//       session.quiz_answers.push({ question_id: current.id, answer, is_correct: isCorrect });

//       const nextIndex = qIndex + 1;

//       if (nextIndex >= questions.length) {
//         const correct = session.quiz_answers.filter(a => a.is_correct).length;
//         const total   = questions.length;
//         const score   = Math.round((correct / total) * 100);

//         await QuizResult.create({
//           phone_number: phone_str, course_id: session.course_id,
//           score, total_questions: total, correct_answers: correct,
//           answers_given: session.quiz_answers,
//         });

//         const moduleId = session.modules[session.module_index];
//         await LearnerProgress.findOneAndUpdate(
//           { phone_number: phone_str, course_id: session.course_id },
//           { $addToSet: { modules_completed: moduleId }, last_active: new Date() }
//         );

//         sessions[phone_str].state       = 'MODULE_VIEW';
//         sessions[phone_str].quiz_index  = 0;
//         sessions[phone_str].quiz_answers = [];

//         const feedbackFinal = isCorrect ? 'Correct!\n\n' : 'Last answer was ' + current.correct + '.\n\n';
//         const now  = new Date();
//         const date = now.getDate() + '/' + (now.getMonth()+1) + '/' + now.getFullYear();

//         let msg = feedbackFinal;
//         msg += 'Quiz Complete!\n\n';
//         msg += 'Your Score: ' + score + '%\n';
//         msg += 'Correct: ' + correct + '/' + total + '\n';
//         msg += (score >= 80 ? 'Outstanding!' : score >= 60 ? 'Good work!' : 'Keep going!') + '\n\n';

//         if (score >= 60) {
//           msg += 'CERTIFICATE OF COMPLETION\n';
//           msg += '------------------------\n';
//           msg += 'Name: ' + (sessions[phone_str]?.reg_name || 'Learner') + '\n';
//           msg += 'Course: ' + session.course_title + '\n';
//           msg += 'Score: ' + score + '%\n';
//           msg += 'Date: ' + date + '\n';
//           msg += 'Issued by Andragogy Learning Platform\n\n';
//         }

//         msg += 'What next?\nNEXT - Continue\nMENU - Courses\nPROGRESS - Your progress';
//         return reply(res, msg);
//       }

//       sessions[phone_str].quiz_index = nextIndex;
//       const nextQ        = questions[nextIndex];
//       const feedbackNext = isCorrect ? 'Correct!\n\n' : 'Incorrect. Answer was ' + current.correct + '.\n\n';

//       let msgNext = feedbackNext;
//       msgNext += 'Question ' + (nextIndex + 1) + ' of ' + questions.length + ':\n\n';
//       msgNext += nextQ.question + '\n\n';
//       msgNext += 'A. ' + nextQ.options.A + '\nB. ' + nextQ.options.B + '\nC. ' + nextQ.options.C + '\nD. ' + nextQ.options.D + '\n\n';
//       msgNext += 'Reply with A, B, C, or D';
//       return reply(res, msgNext);
//     }

//     // DEFAULT — check if there's an active poll the learner hasn't answered
//     const nlpAnswer = processNLPQuery(text);
//     if (nlpAnswer) {
//       return reply(res, nlpAnswer + '\n\nType START to begin a course.');
//     }

//     return reply(res, 'Andragogy Learning Bot\n\nType START to begin learning\nType HELP to see all commands');

//   } catch (err) {
//     console.error('WhatsApp route error:', err);
//     res.status(500).json({ success: false, message: err.message });
//   }
// });

// router.post('/webhook', async (req, res) => {
//   try {
//     const body    = req.body;
//     const phone   = body.from || body.source || body.phone;
//     const message = body.text?.body || body.message || body.msg;
//     if (phone && message) {
//       const fakeReq = { body: { phone, message } };
//       const fakeRes = { json: () => {}, set: () => {}, send: () => {} };
//       await router.handle(fakeReq, fakeRes, () => {});
//     }
//     res.json({ success: true });
//   } catch (err) {
//     console.error('Webhook error:', err);
//     res.status(500).json({ success: false });
//   }
// });

// router.get('/test', async (req, res) => {
//   const result = await whatsappService.testConnection();
//   res.json(result);
// });

// router.get('/sessions', (req, res) => {
//   res.json({ success: true, active_sessions: Object.keys(sessions).length });
// });

// module.exports = router;






















const express  = require('express');
const { Course, Module, QuizQuestion, QuizResult, LearnerProgress } = require('../models/models');
const User     = require('../models/User');
const { processNLPQuery, isQuestion } = require('../services/nlpService');
const whatsappService = require('../services/whatsappService');

const router   = express.Router();
const sessions = {};

function reply(res, message) {
  res.set('Content-Type', 'text/xml');
  const safe = message
    .replace(/&/g,'&amp;')
    .replace(/</g,'&lt;')
    .replace(/>/g,'&gt;');
  return res.send(`<?xml version="1.0" encoding="UTF-8"?><Response><Message>${safe}</Message></Response>`);
}

async function ensureLearner(phone) {
  let user = await User.findOne({ phone_number: phone, role: 'learner' });
  if (!user) {
    user = await User.create({ name: `Learner_${phone.slice(-4)}`, phone_number: phone, role: 'learner' });
  }
  return user;
}

router.post('/message', async (req, res) => {
  try {
    const phone   = req.body.From || req.body.phone || '';
    const message = req.body.Body || req.body.message || '';

    if (!phone || !message) {
      return res.status(400).json({ success: false, message: 'phone and message required' });
    }

    const text      = message.trim();
    const phone_str = String(phone).replace(/whatsapp:\+/i, '').replace(/\D/g, '');
    await ensureLearner(phone_str);

    if (!sessions[phone_str]) {
      sessions[phone_str] = { state: 'IDLE', course_id: null, module_index: 0 };
    }
    const session = sessions[phone_str];

    // NLP
    if (isQuestion(text) && !['A','B','C','D'].includes(text.toUpperCase()) && session.state !== 'QUIZ') {
      const nlpAnswer = processNLPQuery(text);
      if (nlpAnswer) {
        return reply(res, nlpAnswer + '\n\n_Reply MENU to return to courses._');
      }
    }

    // POLL RESPONSE — check active poll even if state is IDLE
    const cleanText = text.toUpperCase().trim();
    const isPollAnswer = ['A','B','C','D','E','F'].includes(cleanText) && cleanText.length === 1;

    // If looks like multiple poll answers e.g. "B,C" or "B.C" or "BC"
    if (!isPollAnswer && /^[A-Fa-f][,.\s][A-Fa-f]$/.test(text.trim())) {
      return reply(res, '⚠️ Please reply with only *one* letter at a time.\n\nType *A*, *B* or *C* to vote.');
    }

    if (isPollAnswer && !session.state?.includes('QUIZ')) {
      // Check if there's an active poll in memory
      try {
        const pollsResp = await fetch(`http://localhost:${process.env.PORT || 5000}/api/polls`);
        const pollsData = await pollsResp.json();
        const activePoll = pollsData.data?.find(p => p.status === 'active');
        console.log('Active poll:', activePoll?.id, activePoll?.question);

        if (activePoll) {
          const answer = text.toUpperCase();
          const idx    = answer.charCodeAt(0) - 65;

          if (idx < activePoll.options.length) {
            const selected = activePoll.options[idx];

            // Record response
            await fetch(`http://localhost:${process.env.PORT || 5000}/api/polls/${activePoll.id}/respond`, {
              method: 'POST',
              headers: { 'Content-Type': 'application/json' },
              body: JSON.stringify({ phone_number: phone_str, name: sessions[phone_str]?.reg_name || 'Learner', selected })
            });

            // Fetch updated results
            const updatedResp = await fetch(`http://localhost:${process.env.PORT || 5000}/api/polls/${activePoll.id}`);
            const updatedData = await updatedResp.json();
            const p      = updatedData.data;
            const total  = p.response_count || 0;
            const counts = p.counts || {};
            const maxVotes = Math.max(...Object.values(counts).map(v => Number(v)));

            let msg = `📊 *Live Results — ${p.question}*\n`;
            msg += `━━━━━━━━━━━━━━━━━━━━\n`;
            p.options.forEach((opt, i) => {
              const letter   = String.fromCharCode(65 + i);
              const count    = Number(counts[opt]) || 0;
              const pct      = total > 0 ? Math.round((count / total) * 100) : 0;
              const bars     = Math.round(pct / 10);
              const bar      = '█'.repeat(bars) + '░'.repeat(10 - bars);
              const isWinner = count === maxVotes && count > 0;
              msg += `${isWinner ? '🏆' : '  '} *${letter}.* ${opt}\n`;
              msg += `   ${bar} ${pct}%  (${count})\n\n`;
            });
            msg += `━━━━━━━━━━━━━━━━━━━━\n`;
            msg += `👥 *Total: ${total} vote${total !== 1 ? 's' : ''}*`;

            return reply(res, msg);
          }
        }
      } catch(e) {
        console.error('Poll response error:', e.message);
      }
    }

    // HELP
    if (text.toUpperCase() === 'HELP') {
      return reply(res, 'HELP MENU\n\nSTART - Show courses\nMENU - Return to courses\nQUIZ - Take quiz\nNEXT - Next module\nPROGRESS - Your progress\nA/B/C/D - Answer quiz');
    }

    // PROGRESS
    if (text.toUpperCase() === 'PROGRESS') {
      const results  = await QuizResult.find({ phone_number: phone_str }).populate('course_id', 'title');
      const progress = await LearnerProgress.find({ phone_number: phone_str });

      if (results.length === 0 && progress.length === 0) {
        return reply(res, 'No progress yet.\n\nType START to begin learning!');
      }

      let msg = 'YOUR LEARNING JOURNEY\n\n';
      msg += `Courses Enrolled: ${progress.length}\n`;
      msg += `Quizzes Taken: ${results.length}\n`;

      if (results.length > 0) {
        const avg = Math.round(results.reduce((s, r) => s + r.score, 0) / results.length);
        msg += `Average Score: ${avg}%\n\nCourse Results:\n`;
        results.forEach(r => {
          msg += `${r.course_id?.title || 'Course'}: ${r.score}%\n`;
        });
      }
      return reply(res, msg);
    }

    // START / MENU
    if (['MENU','START','HI','HELLO'].includes(text.toUpperCase())) {
      const existingUser = await User.findOne({ phone_number: phone_str, role: 'learner' });
      const isRegistered = existingUser && existingUser.name && !existingUser.name.startsWith('Learner_');

      if (!isRegistered) {
        sessions[phone_str] = { state: 'REG_NAME' };
      return reply(res, '👋 *Welcome to Andragogy Learning Platform!*\n\n🎓 Let\'s set up your profile first.\n\n*What is your full name?*\n\n_e.g. Riya Shinde_');
      }

      sessions[phone_str] = { state: 'COURSE_SELECTION', course_id: null, module_index: 0 };
      const courses = await Course.find({ is_active: true });

      if (courses.length === 0) {
        return reply(res, 'Welcome back ' + existingUser.name + '!\n\nNo courses available yet.');
      }

      let msg = '👋 *Welcome back, ' + existingUser.name + '!* 🎓\n\n';
      msg += '━━━━━━━━━━━━━━━━━━━━\n';
      msg += '📚 *Available Courses:*\n\n';
      courses.forEach((c, i) => { msg += `*${i + 1}.* ${c.title}\n`; });
      msg += '\n━━━━━━━━━━━━━━━━━━━━\n';
      msg += '_Reply with a number to begin your learning journey!_';
      sessions[phone_str].courses = courses.map(c => c._id.toString());
      return reply(res, msg);
    }

    // REGISTRATION
    if (session.state === 'REG_NAME') {
      sessions[phone_str].reg_name = text;
      sessions[phone_str].state    = 'REG_DEPARTMENT';
      return reply(res, '✅ *Nice to meet you, ' + text + '!*\n\n🏢 *What is your department?*\n\n_Choose one:_\n• IT\n• HR\n• Sales\n• Marketing\n• Finance\n• Operations\n• Development\n• Design\n• Management\n• Other\n\n_Or type your own department name_');
    }

    if (session.state === 'REG_DEPARTMENT') {
      sessions[phone_str].reg_department = text;
      sessions[phone_str].state          = 'REG_JOBROLE';
      return reply(res, '✅ *Department noted!*\n\n💼 *What is your job role?*\n\n_Choose one:_\n• Developer\n• Analyst\n• Manager\n• Designer\n• Trainer\n• Executive\n• Other\n\n_Or type your own job role_');
    }

    if (session.state === 'REG_JOBROLE') {
      const name       = sessions[phone_str].reg_name;
      const department = sessions[phone_str].reg_department;
      const jobRole    = text;

      await User.findOneAndUpdate(
        { phone_number: phone_str },
        { name, department, job_role: jobRole, role: 'learner' },
        { upsert: true, new: true }
      );

      sessions[phone_str] = { state: 'COURSE_SELECTION', course_id: null, module_index: 0 };
      const courses = await Course.find({ is_active: true });

      let msg = '🎉 *Registration Complete!*\n\n';
      msg += '━━━━━━━━━━━━━━━━━━━━\n';
      msg += '👤 *Name:* ' + name + '\n';
      msg += '🏢 *Department:* ' + department + '\n';
      msg += '💼 *Role:* ' + jobRole + '\n';
      msg += '━━━━━━━━━━━━━━━━━━━━\n\n';
      msg += '📚 *Available Courses:*\n\n';
      courses.forEach((c, i) => { msg += `*${i + 1}.* ${c.title}\n`; });
      msg += '\n_Reply with a number to begin your learning journey!_';
      sessions[phone_str].courses = courses.map(c => c._id.toString());
      return reply(res, msg);
    }

    // COURSE SELECTION
    if (session.state === 'COURSE_SELECTION') {
      const num       = parseInt(text);
      const courseIds = session.courses || [];

      if (isNaN(num) || num < 1 || num > courseIds.length) {
        return reply(res, `Please reply with a number between 1 and ${courseIds.length}.\n\nType MENU to see courses again.`);
      }

      const courseId = courseIds[num - 1];
      const course   = await Course.findById(courseId);
      const modules  = await Module.find({ course_id: courseId }).sort('order');

      if (modules.length === 0) {
        return reply(res, course.title + '\n\nNo modules available yet.\n\nType MENU to choose another course.');
      }

      await LearnerProgress.findOneAndUpdate(
        { phone_number: phone_str, course_id: courseId },
        { current_module: modules[0]._id, last_active: new Date() },
        { upsert: true, new: true }
      );

      sessions[phone_str] = {
        state: 'MODULE_VIEW',
        course_id: courseId,
        course_title: course.title,
        modules: modules.map(m => m._id.toString()),
        module_index: 0,
        courses: courseIds,
      };

      const mod = modules[0];
      const cleanTitle0 = mod.title.replace(/^Module\s*\d+[:\s-]*/i, '').trim();
      let msg = '✅ *Enrolled: ' + course.title + '*\n\n';
      msg += '*📖 Module 1: ' + cleanTitle0 + '*\n\n';
      msg += mod.description + '\n';
      if (mod.pdf_link)   msg += '\n📄 *PDF:* ' + mod.pdf_link;
      if (mod.video_link) msg += '\n🎥 *Video:* ' + mod.video_link;
      msg += '\n\n_Reply *NEXT* when done, or *QUIZ* to take the quiz._';
      return reply(res, msg);
    }

    // MODULE CONFIRM
    if (session.state === 'MODULE_CONFIRM') {
      if (text.toUpperCase() === 'YES') {
        const nextIndex = session.next_module_index;
        const mod = await Module.findById(session.modules[nextIndex]);
        sessions[phone_str].module_index = nextIndex;
        sessions[phone_str].state        = 'MODULE_VIEW';
        delete sessions[phone_str].next_module_index;

        await LearnerProgress.findOneAndUpdate(
          { phone_number: phone_str, course_id: session.course_id },
          { current_module: mod._id, last_active: new Date() }
        );

        const cleanTitle1 = mod.title.replace(/^Module\s*\d+[:\s-]*/i, '').trim();
        let msg = '*📖 Module ' + (nextIndex + 1) + ': ' + cleanTitle1 + '*\n\n';
        msg += mod.description + '\n';
        if (mod.pdf_link)   msg += '\n📄 *PDF:* ' + mod.pdf_link;
        if (mod.video_link) msg += '\n🎥 *Video:* ' + mod.video_link;
        msg += '\n\n_Reply *NEXT* when done, *QUIZ* for quiz._';
        return reply(res, msg);
      }

      if (text.toUpperCase() === 'QUIZ') {
        sessions[phone_str].state = 'MODULE_VIEW';
        // Fall through to QUIZ handling below
      } else {
        return reply(res, 'Reply YES to continue to next module\nReply QUIZ to take quiz first\nReply MENU to go back');
      }
    }

    // MODULE VIEW
    if (session.state === 'MODULE_VIEW') {
      if (text.toUpperCase() === 'NEXT') {
        const nextIndex = session.module_index + 1;
        if (nextIndex >= session.modules.length) {
          return reply(res, 'All Modules Complete!\n\nYou have finished all modules in ' + session.course_title + '!\n\nType QUIZ to take the final quiz.\nType PROGRESS to see your progress.');
        }

        sessions[phone_str].state = 'MODULE_CONFIRM';
        sessions[phone_str].next_module_index = nextIndex;
        const currentMod = await Module.findById(session.modules[session.module_index]);
        const cleanTitleC = currentMod.title.replace(/^Module\s*\d+[:\s-]*/i, '').trim();
        return reply(res, '✅ *Module ' + (session.module_index + 1) + ': ' + cleanTitleC + '* marked as read!\n\nReady for the next module?\n\nReply YES to continue to Module ' + (nextIndex + 1) + '\nReply QUIZ to take quiz first\nReply MENU to go back');
      }

      if (text.toUpperCase() === 'QUIZ') {
        const questions = await QuizQuestion.find({ course_id: session.course_id });
        if (questions.length === 0) {
          return reply(res, 'No quiz questions yet.\n\nType NEXT to continue or MENU for another course.');
        }

        sessions[phone_str].state          = 'QUIZ';
        sessions[phone_str].quiz_questions = questions.map(q => ({
          id: q._id.toString(), question: q.question,
          options: q.options, correct: q.correct_answer,
        }));
        sessions[phone_str].quiz_index   = 0;
        sessions[phone_str].quiz_answers = [];

        const q   = sessions[phone_str].quiz_questions[0];
        let msg   = 'Quiz: ' + session.course_title + '\n';
        msg += 'Question 1 of ' + questions.length + '\n\n';
        msg += q.question + '\n\n';
        msg += 'A. ' + q.options.A + '\nB. ' + q.options.B + '\nC. ' + q.options.C + '\nD. ' + q.options.D + '\n\n';
        msg += 'Reply with A, B, C, or D';
        return reply(res, msg);
      }

      return reply(res, 'You are studying ' + session.course_title + '.\n\nNEXT - Next module\nQUIZ - Take quiz\nPROGRESS - Your progress\nMENU - Course list');
    }

    // QUIZ
    if (session.state === 'QUIZ') {
      const answer = text.toUpperCase();
      if (!['A','B','C','D'].includes(answer)) {
        return reply(res, 'Please reply with A, B, C, or D.');
      }

      const qIndex    = session.quiz_index;
      const questions = session.quiz_questions;
      const current   = questions[qIndex];
      const isCorrect = answer === current.correct;

      session.quiz_answers.push({ question_id: current.id, answer, is_correct: isCorrect });

      const nextIndex = qIndex + 1;

      if (nextIndex >= questions.length) {
        const correct = session.quiz_answers.filter(a => a.is_correct).length;
        const total   = questions.length;
        const score   = Math.round((correct / total) * 100);

        await QuizResult.create({
          phone_number: phone_str, course_id: session.course_id,
          score, total_questions: total, correct_answers: correct,
          answers_given: session.quiz_answers,
        });

        const moduleId = session.modules[session.module_index];
        await LearnerProgress.findOneAndUpdate(
          { phone_number: phone_str, course_id: session.course_id },
          { $addToSet: { modules_completed: moduleId }, last_active: new Date() }
        );

        sessions[phone_str].state       = 'MODULE_VIEW';
        sessions[phone_str].quiz_index  = 0;
        sessions[phone_str].quiz_answers = [];

        const feedbackFinal = isCorrect ? 'Correct!\n\n' : 'Last answer was ' + current.correct + '.\n\n';
        const now  = new Date();
        const date = now.getDate() + '/' + (now.getMonth()+1) + '/' + now.getFullYear();

        let msg = feedbackFinal;
        msg += 'Quiz Complete!\n\n';
        msg += 'Your Score: ' + score + '%\n';
        msg += 'Correct: ' + correct + '/' + total + '\n';
        msg += (score >= 80 ? 'Outstanding!' : score >= 60 ? 'Good work!' : 'Keep going!') + '\n\n';

        if (score >= 60) {
          msg += 'CERTIFICATE OF COMPLETION\n';
          msg += '------------------------\n';
          msg += 'Name: ' + (sessions[phone_str]?.reg_name || 'Learner') + '\n';
          msg += 'Course: ' + session.course_title + '\n';
          msg += 'Score: ' + score + '%\n';
          msg += 'Date: ' + date + '\n';
          msg += 'Issued by Andragogy Learning Platform\n\n';
        }

        msg += 'What next?\nNEXT - Continue\nMENU - Courses\nPROGRESS - Your progress';
        return reply(res, msg);
      }

      sessions[phone_str].quiz_index = nextIndex;
      const nextQ        = questions[nextIndex];
      const feedbackNext = isCorrect ? 'Correct!\n\n' : 'Incorrect. Answer was ' + current.correct + '.\n\n';

      let msgNext = feedbackNext;
      msgNext += 'Question ' + (nextIndex + 1) + ' of ' + questions.length + ':\n\n';
      msgNext += nextQ.question + '\n\n';
      msgNext += 'A. ' + nextQ.options.A + '\nB. ' + nextQ.options.B + '\nC. ' + nextQ.options.C + '\nD. ' + nextQ.options.D + '\n\n';
      msgNext += 'Reply with A, B, C, or D';
      return reply(res, msgNext);
    }

    // DEFAULT — check if there's an active poll the learner hasn't answered
    const nlpAnswer = processNLPQuery(text);
    if (nlpAnswer) {
      return reply(res, nlpAnswer + '\n\nType START to begin a course.');
    }

    return reply(res, 'Andragogy Learning Bot\n\nType START to begin learning\nType HELP to see all commands');

  } catch (err) {
    console.error('WhatsApp route error:', err);
    res.status(500).json({ success: false, message: err.message });
  }
});

router.post('/webhook', async (req, res) => {
  try {
    const body    = req.body;
    const phone   = body.from || body.source || body.phone;
    const message = body.text?.body || body.message || body.msg;
    if (phone && message) {
      const fakeReq = { body: { phone, message } };
      const fakeRes = { json: () => {}, set: () => {}, send: () => {} };
      await router.handle(fakeReq, fakeRes, () => {});
    }
    res.json({ success: true });
  } catch (err) {
    console.error('Webhook error:', err);
    res.status(500).json({ success: false });
  }
});

router.get('/test', async (req, res) => {
  const result = await whatsappService.testConnection();
  res.json(result);
});

router.get('/sessions', (req, res) => {
  res.json({ success: true, active_sessions: Object.keys(sessions).length });
});

module.exports = router;