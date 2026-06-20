

// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../services/app_theme.dart';
// import '../models/models.dart';

// class SendScreen extends StatefulWidget {
//   final List<Course> courses;
//   final List<LearnerProgress> learners;
//   const SendScreen({super.key, required this.courses, required this.learners});
//   @override
//   State<SendScreen> createState() => _SendScreenState();
// }

// class _SendScreenState extends State<SendScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tab;
//   @override
//   void initState() {
//     super.initState();
//     _tab = TabController(length: 4, vsync: this);
//   }
//   @override
//   void dispose() { _tab.dispose(); super.dispose(); }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white, elevation: 0,
//         title: const Text('Send & Notify', style: TextStyle(
//           fontSize: 20, fontWeight: FontWeight.w900,
//           color: AppColors.primaryDark, letterSpacing: -0.5)),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48),
//           child: Container(
//             color: Colors.white,
//             child: TabBar(
//               controller: _tab,
//               isScrollable: false,
//               labelStyle: const TextStyle(
//                 fontSize: 13, fontWeight: FontWeight.w700),
//               unselectedLabelStyle: const TextStyle(fontSize: 13),
//               labelColor: AppColors.primary,
//               unselectedLabelColor: AppColors.textSecondary,
//               indicatorColor: AppColors.primary,
//               indicatorWeight: 2.5,
//               tabs: const [
//                 Tab(text: '📤  Module'),
//                 Tab(text: '📊  Poll'),
//                 Tab(text: '🔔  Alert'),
//                 Tab(text: '📋  Log'),
//               ]))),
//         bottomOpacity: 1),
//       body: TabBarView(controller: _tab, children: [
//         _SendModuleTab(courses: widget.courses, learners: widget.learners),
//         _SendPollTab(learners: widget.learners),
//         _SendAlertTab(learners: widget.learners),
//         const _DeliveryLogTab(),
//       ]));
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // TAB 1 — Send Module
// // ══════════════════════════════════════════════════════════════
// class _SendModuleTab extends StatefulWidget {
//   final List<Course> courses;
//   final List<LearnerProgress> learners;
//   const _SendModuleTab({required this.courses, required this.learners});
//   @override
//   State<_SendModuleTab> createState() => _SendModuleTabState();
// }

// class _SendModuleTabState extends State<_SendModuleTab> {
//   String? _selectedCourseId;
//   String _audience = 'all';
//   bool _sending = false;
//   List<CourseModule> _modules = [];
//   String? _selectedModuleId;

//   Future<void> _loadModules(String courseId) async {
//     try {
//       final mods = await ApiService.getModules(courseId);
//       if (mounted) setState(() => _modules = mods);
//     } catch (_) {}
//   }

//   Future<void> _send() async {
//     if (_selectedCourseId == null || _selectedModuleId == null) return;
//     setState(() => _sending = true);
//     try {
//       // Find selected course and module details
//       final course = widget.courses.firstWhere((c) => c.id == _selectedCourseId);
//       final moduleIndex = _modules.indexWhere((m) => m.id == _selectedModuleId);
//       final module = _modules[moduleIndex];
//       final moduleNo = moduleIndex + 1;
//       // Clean module title - remove "Module X:" prefix if already there
//       final cleanTitle = module.title.replaceAll(RegExp(r'^Module\s*\d+[:\s-]*', caseSensitive: false), '').trim();

//       final message = '📚 *New Module Available!*\n\n'
//           '━━━━━━━━━━━━━━━━━━━━\n'
//           '📖 *Course:* ${course.title}\n'
//           '🔢 *Module $moduleNo:* $cleanTitle\n'
//           '━━━━━━━━━━━━━━━━━━━━\n\n'
//           'Send *NEXT* on WhatsApp to continue your learning journey! 🎓';

//       await ApiService.post('/broadcast', {
//         'message': message,
//         'filter': _audience,
//         'course_id': _selectedCourseId,
//         'module_id': _selectedModuleId,
//         'type': 'module',
//       });
//       if (mounted) _snack('✅ Module sent to learners!', AppColors.green);
//     } catch (e) {
//       if (mounted) _snack('Error: ${e.toString()}', AppColors.orange);
//       print('Send error: $e');
//     }
//     if (mounted) setState(() => _sending = false);
//   }

//   void _snack(String msg, Color color) =>
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg), backgroundColor: color,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.all(12)));

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _sectionCard('Select Course', Icons.menu_book_outlined, children: [
//           if (widget.courses.isEmpty)
//             const Text('No courses yet. Create one first.',
//               style: TextStyle(color: AppColors.textSecondary, fontSize: 13))
//           else
//             ...widget.courses.map((c) => _courseOption(c)),
//         ]),
//         const SizedBox(height: 14),

//         if (_selectedCourseId != null) ...[
//           _sectionCard('Select Module', Icons.view_list_outlined, children: [
//             if (_modules.isEmpty)
//               const Text('No modules in this course.',
//                 style: TextStyle(color: AppColors.textSecondary, fontSize: 13))
//             else
//               ..._modules.map((m) => _moduleOption(m)),
//           ]),
//           const SizedBox(height: 14),
//         ],

//         _sectionCard('Send To', Icons.people_outline, children: [
//           _audienceOption('all', '👥 All Learners',
//             '${widget.learners.length} learners'),
//           _audienceOption('enrolled', '📚 Enrolled Only',
//             'Learners in selected course'),
//           _audienceOption('not_started', '⚡ Not Started',
//             'Push inactive learners'),
//         ]),
//         const SizedBox(height: 24),

//         SizedBox(width: double.infinity, height: 52,
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _selectedModuleId != null
//                 ? AppColors.primary : AppColors.border,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14)),
//               elevation: 0),
//             onPressed: (_selectedModuleId != null && !_sending) ? _send : null,
//             icon: _sending
//               ? const SizedBox(width: 18, height: 18,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2, color: Colors.white))
//               : const Icon(Icons.send_rounded, color: Colors.white),
//             label: Text(_sending ? 'Sending...' : 'Send Module via WhatsApp',
//               style: const TextStyle(color: Colors.white,
//                 fontSize: 15, fontWeight: FontWeight.w700)))),
//       ]));
//   }

//   Widget _courseOption(Course c) {
//     final selected = _selectedCourseId == c.id;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedCourseId = c.id;
//           _selectedModuleId = null;
//           _modules = [];
//         });
//         _loadModules(c.id);
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: selected ? AppColors.primaryLight : AppColors.bg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selected ? AppColors.primary : AppColors.border,
//             width: selected ? 1.5 : 1)),
//         child: Row(children: [
//           Text(_courseEmoji(c.title), style: const TextStyle(fontSize: 18)),
//           const SizedBox(width: 10),
//           Expanded(child: Text(c.title,
//             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
//               color: selected ? AppColors.primary : AppColors.textPrimary))),
//           if (selected)
//             const Icon(Icons.check_circle_rounded,
//               color: AppColors.primary, size: 18),
//         ])));
//   }

//   Widget _moduleOption(CourseModule m) {
//     final selected = _selectedModuleId == m.id;
//     return GestureDetector(
//       onTap: () => setState(() => _selectedModuleId = m.id),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: selected ? AppColors.primaryLight : AppColors.bg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selected ? AppColors.primary : AppColors.border,
//             width: selected ? 1.5 : 1)),
//         child: Row(children: [
//           Container(width: 24, height: 24,
//             decoration: BoxDecoration(
//               color: selected ? AppColors.primary : AppColors.textSecondary,
//               shape: BoxShape.circle),
//             child: Center(child: Text('${m.order}',
//               style: const TextStyle(color: Colors.white,
//                 fontSize: 11, fontWeight: FontWeight.w800)))),
//           const SizedBox(width: 10),
//           Expanded(child: Text(m.title,
//             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
//               color: selected ? AppColors.primary : AppColors.textPrimary))),
//           if (selected)
//             const Icon(Icons.check_circle_rounded,
//               color: AppColors.primary, size: 18),
//         ])));
//   }

//   Widget _audienceOption(String val, String label, String sub) {
//     final selected = _audience == val;
//     return GestureDetector(
//       onTap: () => setState(() => _audience = val),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: selected ? AppColors.primaryLight : AppColors.bg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selected ? AppColors.primary : AppColors.border,
//             width: selected ? 1.5 : 1)),
//         child: Row(children: [
//           Expanded(child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min, children: [
//             Text(label, style: TextStyle(fontSize: 13,
//               fontWeight: FontWeight.w700,
//               color: selected ? AppColors.primary : AppColors.textPrimary)),
//             Text(sub, style: const TextStyle(fontSize: 11,
//               color: AppColors.textSecondary)),
//           ])),
//           if (selected)
//             const Icon(Icons.check_circle_rounded,
//               color: AppColors.primary, size: 18),
//         ])));
//   }

//   String _courseEmoji(String title) {
//     const emojis = ['📊','🎯','📚','🧠','💡','🚀','🎓','🌐'];
//     return title.isNotEmpty ? emojis[title.length % emojis.length] : '📚';
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // TAB 2 — Send Poll
// // ══════════════════════════════════════════════════════════════
// class _SendPollTab extends StatefulWidget {
//   final List<LearnerProgress> learners;
//   const _SendPollTab({required this.learners});
//   @override
//   State<_SendPollTab> createState() => _SendPollTabState();
// }

// class _SendPollTabState extends State<_SendPollTab> {
//   final _questionCtrl = TextEditingController();
//   final List<TextEditingController> _optionCtrls = [
//     TextEditingController(), TextEditingController()];
//   bool _multiSelect = false;
//   bool _sending = false;

//   void _snack(String msg, Color color) =>
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg), backgroundColor: color,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.all(12)));

//   bool get _canSend =>
//     _questionCtrl.text.trim().isNotEmpty &&
//     _optionCtrls.every((c) => c.text.trim().isNotEmpty);

//   Future<void> _send() async {
//     setState(() => _sending = true);
//     try {
//       await ApiService.post('/polls', {
//         'question': _questionCtrl.text.trim(),
//         'options': _optionCtrls.map((c) => c.text.trim())
//           .where((t) => t.isNotEmpty).toList(),
//         'multi_select': _multiSelect,
//       });
//       _questionCtrl.clear();
//       for (final c in _optionCtrls) c.clear();
//       setState(() { _multiSelect = false; _sending = false; });
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: const Text('✅ Poll sent to all learners via WhatsApp!'),
//         backgroundColor: AppColors.green, behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(12)));
//     } catch (e) {
//       if (mounted) {
//         setState(() => _sending = false);
//         _snack('Error: ${e.toString()}', AppColors.orange);
//       }
//       print('Poll send error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _sectionCard('Poll Question', Icons.help_outline_rounded, children: [
//           TextField(controller: _questionCtrl, maxLines: 2,
//             textCapitalization: TextCapitalization.sentences,
//             onChanged: (_) => setState(() {}),
//             decoration: InputDecoration(
//               hintText: 'e.g. Which topic should we cover next?',
//               hintStyle: const TextStyle(
//                 fontSize: 13, color: AppColors.textSecondary),
//               filled: true, fillColor: AppColors.bg,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: AppColors.border)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: AppColors.border)),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(
//                   color: AppColors.primary, width: 1.5)),
//               contentPadding: const EdgeInsets.all(14))),
//         ]),
//         const SizedBox(height: 14),

//         _sectionCard('Options', Icons.list_alt_outlined, trailing:
//           _optionCtrls.length < 6 ? GestureDetector(
//             onTap: () => setState(() =>
//               _optionCtrls.add(TextEditingController())),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//               decoration: BoxDecoration(color: AppColors.primaryLight,
//                 borderRadius: BorderRadius.circular(20)),
//               child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                 Icon(Icons.add_rounded, size: 14, color: AppColors.primary),
//                 SizedBox(width: 4),
//                 Text('Add', style: TextStyle(fontSize: 11,
//                   fontWeight: FontWeight.w700, color: AppColors.primary)),
//               ]))) : null,
//           children: [
//           ..._optionCtrls.asMap().entries.map((e) => Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: Row(children: [
//               Container(width: 30, height: 30,
//                 decoration: BoxDecoration(color: AppColors.primaryLight,
//                   borderRadius: BorderRadius.circular(8)),
//                 child: Center(child: Text(
//                   String.fromCharCode(65 + e.key),
//                   style: const TextStyle(fontSize: 13,
//                     fontWeight: FontWeight.w800, color: AppColors.primary)))),
//               const SizedBox(width: 10),
//               Expanded(child: TextField(controller: e.value,
//                 textCapitalization: TextCapitalization.sentences,
//                 onChanged: (_) => setState(() {}),
//                 decoration: InputDecoration(
//                   hintText: 'Option ${String.fromCharCode(65 + e.key)}',
//                   filled: true, fillColor: Colors.white, isDense: true,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(color: AppColors.border)),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(color: AppColors.border)),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 12)))),
//               if (_optionCtrls.length > 2) ...[
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: () => setState(() => _optionCtrls.removeAt(e.key)),
//                   child: const Icon(Icons.remove_circle_outline,
//                     color: AppColors.textSecondary, size: 20)),
//               ],
//             ]))),
//         ]),
//         const SizedBox(height: 14),

//         Container(padding: const EdgeInsets.symmetric(
//           horizontal: 14, vertical: 12),
//           decoration: BoxDecoration(color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: const Border.fromBorderSide(
//               BorderSide(color: AppColors.border))),
//           child: Row(children: [
//             const Icon(Icons.check_box_outlined,
//               size: 18, color: AppColors.primary),
//             const SizedBox(width: 10),
//             const Expanded(child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text('Allow multiple selections', style: TextStyle(
//                 fontSize: 13, fontWeight: FontWeight.w700,
//                 color: AppColors.textPrimary)),
//               Text('Learners can pick more than one option',
//                 style: TextStyle(fontSize: 11,
//                   color: AppColors.textSecondary)),
//             ])),
//             Switch.adaptive(value: _multiSelect,
//               activeColor: AppColors.primary,
//               onChanged: (v) => setState(() => _multiSelect = v)),
//           ])),
//         const SizedBox(height: 24),

//         SizedBox(width: double.infinity, height: 52,
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _canSend ? AppColors.primary : AppColors.border,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14)),
//               elevation: 0),
//             onPressed: (_canSend && !_sending) ? _send : null,
//             icon: _sending
//               ? const SizedBox(width: 18, height: 18,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2, color: Colors.white))
//               : const Icon(Icons.send_rounded, color: Colors.white),
//             label: Text(_sending ? 'Sending...' : 'Send Poll to All Learners',
//               style: const TextStyle(color: Colors.white,
//                 fontSize: 15, fontWeight: FontWeight.w700)))),
//       ]));
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // TAB 3 — Send Alert
// // ══════════════════════════════════════════════════════════════
// class _SendAlertTab extends StatefulWidget {
//   final List<LearnerProgress> learners;
//   const _SendAlertTab({required this.learners});
//   @override
//   State<_SendAlertTab> createState() => _SendAlertTabState();
// }

// class _SendAlertTabState extends State<_SendAlertTab> {
//   final _titleCtrl   = TextEditingController();
//   final _messageCtrl = TextEditingController();
//   String _audience   = 'all';
//   bool _sending = false;

//   void _snack(String msg, Color color) =>
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg), backgroundColor: color,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.all(12)));

//   static const _templates = [
//     {'icon': '⏰', 'title': 'Quiz Deadline Reminder',
//      'msg': 'Your quiz deadline is approaching! Log in and complete your assessment.'},
//     {'icon': '📚', 'title': 'New Content Available',
//      'msg': 'New learning materials have been added to your course. Send NEXT to access them.'},
//     {'icon': '🏆', 'title': 'Congratulations!',
//      'msg': 'You have completed the course. Your certificate is ready for download.'},
//     {'icon': '💡', 'title': 'Study Tip',
//      'msg': 'Consistent practice leads to mastery. Spend 15 minutes today reviewing your modules.'},
//     {'icon': '📋', 'title': 'Action Required',
//      'msg': 'Please complete your pending quiz to continue your learning journey.'},
//   ];

//   Future<void> _send() async {
//     final title   = _titleCtrl.text.trim();
//     final message = _messageCtrl.text.trim();
//     if (title.isEmpty || message.isEmpty) return;
//     setState(() => _sending = true);
//     try {
//       await ApiService.post('/broadcast', {
//         'message': '🔔 $title\n\n$message',
//         'filter': _audience,
//         'type': 'alert',
//       });
//       _titleCtrl.clear();
//       _messageCtrl.clear();
//       if (mounted) {
//         setState(() => _sending = false);
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: const Text('✅ Alert sent to learners!'),
//           backgroundColor: AppColors.green,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10)),
//           margin: const EdgeInsets.all(12)));
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _sending = false);
//         _snack('Error: ${e.toString()}', AppColors.orange);
//       }
//       print('Poll send error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         // Quick templates
//         _sectionCard('Quick Templates', Icons.flash_on_outlined, children: [
//           Wrap(spacing: 8, runSpacing: 8,
//             children: _templates.map((t) => GestureDetector(
//               onTap: () => setState(() {
//                 _titleCtrl.text = t['title']!;
//                 _messageCtrl.text = t['msg']!;
//               }),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(color: AppColors.primaryLight,
//                   borderRadius: BorderRadius.circular(20),
//                   border: const Border.fromBorderSide(
//                     BorderSide(color: AppColors.primary))),
//                 child: Text('${t['icon']} ${t['title']}',
//                   style: const TextStyle(fontSize: 11,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.primary))))).toList()),
//         ]),
//         const SizedBox(height: 14),

//         _sectionCard('Alert Content', Icons.edit_outlined, children: [
//           TextField(controller: _titleCtrl,
//             textCapitalization: TextCapitalization.sentences,
//             onChanged: (_) => setState(() {}),
//             decoration: InputDecoration(
//               labelText: 'Title',
//               filled: true, fillColor: AppColors.bg,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: AppColors.border)),
//               contentPadding: const EdgeInsets.all(14))),
//           const SizedBox(height: 10),
//           TextField(controller: _messageCtrl, maxLines: 3,
//             textCapitalization: TextCapitalization.sentences,
//             onChanged: (_) => setState(() {}),
//             decoration: InputDecoration(
//               labelText: 'Message',
//               filled: true, fillColor: AppColors.bg,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: AppColors.border)),
//               contentPadding: const EdgeInsets.all(14))),
//         ]),
//         const SizedBox(height: 14),

//         _sectionCard('Send To', Icons.people_outline, children: [
//           _audienceChip('all', '👥 All (${widget.learners.length})'),
//           _audienceChip('active', '✅ Active learners only'),
//           _audienceChip('inactive', '⚡ Inactive learners only'),
//         ]),
//         const SizedBox(height: 24),

//         SizedBox(width: double.infinity, height: 52,
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: (_titleCtrl.text.isNotEmpty &&
//                 _messageCtrl.text.isNotEmpty)
//                 ? const Color(0xFF1A5C38) : AppColors.border,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14)),
//               elevation: 0),
//             onPressed: (_titleCtrl.text.isNotEmpty &&
//               _messageCtrl.text.isNotEmpty && !_sending) ? _send : null,
//             icon: _sending
//               ? const SizedBox(width: 18, height: 18,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2, color: Colors.white))
//               : const Icon(Icons.notifications_active_rounded,
//                   color: Colors.white),
//             label: Text(_sending ? 'Sending...' : 'Send Alert via WhatsApp',
//               style: const TextStyle(color: Colors.white,
//                 fontSize: 15, fontWeight: FontWeight.w700)))),
//       ]));
//   }

//   Widget _audienceChip(String val, String label) {
//     final selected = _audience == val;
//     return GestureDetector(
//       onTap: () => setState(() => _audience = val),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: selected ? AppColors.primaryLight : AppColors.bg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selected ? AppColors.primary : AppColors.border,
//             width: selected ? 1.5 : 1)),
//         child: Row(children: [
//           Expanded(child: Text(label, style: TextStyle(fontSize: 13,
//             fontWeight: FontWeight.w700,
//             color: selected ? AppColors.primary : AppColors.textPrimary))),
//           if (selected)
//             const Icon(Icons.check_circle_rounded,
//               color: AppColors.primary, size: 18),
//         ])));
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // TAB 4 — Delivery Log
// // ══════════════════════════════════════════════════════════════
// class _DeliveryLogTab extends StatefulWidget {
//   const _DeliveryLogTab();
//   @override
//   State<_DeliveryLogTab> createState() => _DeliveryLogTabState();
// }

// class _DeliveryLogTabState extends State<_DeliveryLogTab> {
//   List<dynamic> _logs = [];
//   bool _loading = true;

//   @override
//   void initState() { super.initState(); _load(); }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     try {
//       final r = await ApiService.getBroadcastLogs();
//       if (mounted) setState(() => _logs = r);
//     } catch (_) {}
//     if (mounted) setState(() => _loading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) return const Center(
//       child: CircularProgressIndicator(color: AppColors.primary));

//     if (_logs.isEmpty) return Center(
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         const Text('📋', style: TextStyle(fontSize: 48)),
//         const SizedBox(height: 12),
//         const Text('No messages sent yet', style: TextStyle(
//           fontSize: 16, fontWeight: FontWeight.w700,
//           color: AppColors.textPrimary)),
//         const SizedBox(height: 6),
//         const Text('Send a module, poll or alert to see logs here',
//           style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
//         const SizedBox(height: 16),
//         TextButton.icon(onPressed: _load,
//           icon: const Icon(Icons.refresh, size: 16),
//           label: const Text('Refresh')),
//       ]));

//     return RefreshIndicator(
//       onRefresh: _load,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: _logs.length,
//         itemBuilder: (_, i) {
//           final log = _logs[i] as Map<String, dynamic>;
//           final type = log['type'] ?? 'broadcast';
//           final color = type == 'alert' ? AppColors.amber
//             : type == 'poll' ? AppColors.primary
//             : AppColors.green;
//           final icon = type == 'alert' ? '🔔'
//             : type == 'poll' ? '📊' : '📤';
//           return Container(
//             margin: const EdgeInsets.only(bottom: 10),
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: AppColors.border)),
//             child: Row(children: [
//               Container(width: 40, height: 40,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   shape: BoxShape.circle),
//                 child: Center(child: Text(icon,
//                   style: const TextStyle(fontSize: 18)))),
//               const SizedBox(width: 12),
//               Expanded(child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min, children: [
//                 Text(log['message'] ?? 'Message sent',
//                   style: const TextStyle(fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.textPrimary),
//                   maxLines: 2, overflow: TextOverflow.ellipsis),
//                 const SizedBox(height: 3),
//                 Text('Sent to ${log['recipient_count'] ?? 'all'} learners',
//                   style: const TextStyle(fontSize: 11,
//                     color: AppColors.textSecondary)),
//               ])),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20)),
//                 child: Text(type, style: TextStyle(fontSize: 10,
//                   fontWeight: FontWeight.w700, color: color))),
//             ]));
//         }));
//   }
// }

// // ── Shared helper widgets ─────────────────────────────────────
// Widget _sectionCard(String title, IconData icon,
//     {required List<Widget> children, Widget? trailing}) {
//   return Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(14),
//       border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min, children: [
//       Row(children: [
//         Icon(icon, size: 16, color: AppColors.primary),
//         const SizedBox(width: 8),
//         Expanded(child: Text(title, style: const TextStyle(
//           fontSize: 14, fontWeight: FontWeight.w800,
//           color: AppColors.textPrimary))),
//         if (trailing != null) trailing,
//       ]),
//       const SizedBox(height: 12),
//       const Divider(height: 1, color: AppColors.border),
//       const SizedBox(height: 12),
//       ...children,
//     ]));
// }















// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../services/app_theme.dart';
// import '../models/models.dart';

// class SendScreen extends StatefulWidget {
//   final List<Course> courses;
//   final List<LearnerProgress> learners;
//   const SendScreen({super.key, required this.courses, required this.learners});
//   @override
//   State<SendScreen> createState() => _SendScreenState();
// }

// class _SendScreenState extends State<SendScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tab;
//   @override
//   void initState() {
//     super.initState();
//     _tab = TabController(length: 4, vsync: this);
//   }
//   @override
//   void dispose() { _tab.dispose(); super.dispose(); }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white, elevation: 0,
//         title: const Text('Send & Notify', style: TextStyle(
//           fontSize: 20, fontWeight: FontWeight.w900,
//           color: AppColors.primaryDark, letterSpacing: -0.5)),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48),
//           child: Container(
//             color: Colors.white,
//             child: TabBar(
//               controller: _tab,
//               isScrollable: false,
//               labelStyle: const TextStyle(
//                 fontSize: 13, fontWeight: FontWeight.w700),
//               unselectedLabelStyle: const TextStyle(fontSize: 13),
//               labelColor: AppColors.primary,
//               unselectedLabelColor: AppColors.textSecondary,
//               indicatorColor: AppColors.primary,
//               indicatorWeight: 2.5,
//               tabs: const [
//                 Tab(text: '📤  Module'),
//                 Tab(text: '📊  Poll'),
//                 Tab(text: '🔔  Alert'),
//                 Tab(text: '📋  Log'),
//               ]))),
//         bottomOpacity: 1),
//       body: TabBarView(controller: _tab, children: [
//         _SendModuleTab(courses: widget.courses, learners: widget.learners),
//         _SendPollTab(learners: widget.learners),
//         _SendAlertTab(learners: widget.learners),
//         const _DeliveryLogTab(),
//       ]));
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // TAB 1 — Send Module
// // ══════════════════════════════════════════════════════════════
// class _SendModuleTab extends StatefulWidget {
//   final List<Course> courses;
//   final List<LearnerProgress> learners;
//   const _SendModuleTab({required this.courses, required this.learners});
//   @override
//   State<_SendModuleTab> createState() => _SendModuleTabState();
// }

// class _SendModuleTabState extends State<_SendModuleTab> {
//   String? _selectedCourseId;
//   String _audience = 'all';
//   bool _sending = false;
//   List<CourseModule> _modules = [];
//   String? _selectedModuleId;

//   Future<void> _loadModules(String courseId) async {
//     try {
//       final mods = await ApiService.getModules(courseId);
//       if (mounted) setState(() => _modules = mods);
//     } catch (_) {}
//   }

//   Future<void> _send() async {
//     if (_selectedCourseId == null || _selectedModuleId == null) return;
//     setState(() => _sending = true);
//     try {
//       // Find selected course and module details
//       final course = widget.courses.firstWhere((c) => c.id == _selectedCourseId);
//       final moduleIndex = _modules.indexWhere((m) => m.id == _selectedModuleId);
//       final module = _modules[moduleIndex];
//       final moduleNo = moduleIndex + 1;
//       // Clean module title - remove "Module X:" prefix if already there
//       final cleanTitle = module.title.replaceAll(RegExp(r'^Module\s*\d+[:\s-]*', caseSensitive: false), '').trim();

//       final message = '📚 *New Module Available!*\n\n'
//           '━━━━━━━━━━━━━━━━━━━━\n'
//           '📖 *Course:* ${course.title}\n'
//           '🔢 *Module $moduleNo:* $cleanTitle\n'
//           '━━━━━━━━━━━━━━━━━━━━\n\n'
//           'Send *NEXT* on WhatsApp to continue your learning journey! 🎓';

//       await ApiService.post('/broadcast', {
//         'message': message,
//         'filter': _audience,
//         'course_id': _selectedCourseId,
//         'module_id': _selectedModuleId,
//         'type': 'module',
//       });
//       if (mounted) _snack('✅ Module sent to learners!', AppColors.green);
//     } catch (e) {
//       if (mounted) _snack('Error: ${e.toString()}', AppColors.orange);
//       print('Send error: $e');
//     }
//     if (mounted) setState(() => _sending = false);
//   }

//   void _snack(String msg, Color color) =>
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg), backgroundColor: color,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.all(12)));

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _sectionCard('Select Course', Icons.menu_book_outlined, children: [
//           if (widget.courses.isEmpty)
//             const Text('No courses yet. Create one first.',
//               style: TextStyle(color: AppColors.textSecondary, fontSize: 13))
//           else
//             ...widget.courses.map((c) => _courseOption(c)),
//         ]),
//         const SizedBox(height: 14),

//         if (_selectedCourseId != null) ...[
//           _sectionCard('Select Module', Icons.view_list_outlined, children: [
//             if (_modules.isEmpty)
//               const Text('No modules in this course.',
//                 style: TextStyle(color: AppColors.textSecondary, fontSize: 13))
//             else
//               ..._modules.map((m) => _moduleOption(m)),
//           ]),
//           const SizedBox(height: 14),
//         ],

//         _sectionCard('Send To', Icons.people_outline, children: [
//           _audienceOption('all', '👥 All Learners',
//             '${widget.learners.length} learners'),
//           _audienceOption('enrolled', '📚 Enrolled Only',
//             'Learners in selected course'),
//           _audienceOption('not_started', '⚡ Not Started',
//             'Push inactive learners'),
//         ]),
//         const SizedBox(height: 24),

//         SizedBox(width: double.infinity, height: 52,
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _selectedModuleId != null
//                 ? AppColors.primary : AppColors.border,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14)),
//               elevation: 0),
//             onPressed: (_selectedModuleId != null && !_sending) ? _send : null,
//             icon: _sending
//               ? const SizedBox(width: 18, height: 18,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2, color: Colors.white))
//               : const Icon(Icons.send_rounded, color: Colors.white),
//             label: Text(_sending ? 'Sending...' : 'Send Module via WhatsApp',
//               style: const TextStyle(color: Colors.white,
//                 fontSize: 15, fontWeight: FontWeight.w700)))),
//       ]));
//   }

//   Widget _courseOption(Course c) {
//     final selected = _selectedCourseId == c.id;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           _selectedCourseId = c.id;
//           _selectedModuleId = null;
//           _modules = [];
//         });
//         _loadModules(c.id);
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: selected ? AppColors.primaryLight : AppColors.bg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selected ? AppColors.primary : AppColors.border,
//             width: selected ? 1.5 : 1)),
//         child: Row(children: [
//           Text(_courseEmoji(c.title), style: const TextStyle(fontSize: 18)),
//           const SizedBox(width: 10),
//           Expanded(child: Text(c.title,
//             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
//               color: selected ? AppColors.primary : AppColors.textPrimary))),
//           if (selected)
//             const Icon(Icons.check_circle_rounded,
//               color: AppColors.primary, size: 18),
//         ])));
//   }

//   Widget _moduleOption(CourseModule m) {
//     final selected = _selectedModuleId == m.id;
//     return GestureDetector(
//       onTap: () => setState(() => _selectedModuleId = m.id),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: selected ? AppColors.primaryLight : AppColors.bg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selected ? AppColors.primary : AppColors.border,
//             width: selected ? 1.5 : 1)),
//         child: Row(children: [
//           Container(width: 24, height: 24,
//             decoration: BoxDecoration(
//               color: selected ? AppColors.primary : AppColors.textSecondary,
//               shape: BoxShape.circle),
//             child: Center(child: Text('${m.order}',
//               style: const TextStyle(color: Colors.white,
//                 fontSize: 11, fontWeight: FontWeight.w800)))),
//           const SizedBox(width: 10),
//           Expanded(child: Text(m.title,
//             style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
//               color: selected ? AppColors.primary : AppColors.textPrimary))),
//           if (selected)
//             const Icon(Icons.check_circle_rounded,
//               color: AppColors.primary, size: 18),
//         ])));
//   }

//   Widget _audienceOption(String val, String label, String sub) {
//     final selected = _audience == val;
//     return GestureDetector(
//       onTap: () => setState(() => _audience = val),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: selected ? AppColors.primaryLight : AppColors.bg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selected ? AppColors.primary : AppColors.border,
//             width: selected ? 1.5 : 1)),
//         child: Row(children: [
//           Expanded(child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min, children: [
//             Text(label, style: TextStyle(fontSize: 13,
//               fontWeight: FontWeight.w700,
//               color: selected ? AppColors.primary : AppColors.textPrimary)),
//             Text(sub, style: const TextStyle(fontSize: 11,
//               color: AppColors.textSecondary)),
//           ])),
//           if (selected)
//             const Icon(Icons.check_circle_rounded,
//               color: AppColors.primary, size: 18),
//         ])));
//   }

//   String _courseEmoji(String title) {
//     const emojis = ['📊','🎯','📚','🧠','💡','🚀','🎓','🌐'];
//     return title.isNotEmpty ? emojis[title.length % emojis.length] : '📚';
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // TAB 2 — Send Poll
// // ══════════════════════════════════════════════════════════════
// class _SendPollTab extends StatefulWidget {
//   final List<LearnerProgress> learners;
//   const _SendPollTab({required this.learners});
//   @override
//   State<_SendPollTab> createState() => _SendPollTabState();
// }

// class _SendPollTabState extends State<_SendPollTab> {
//   final _questionCtrl = TextEditingController();
//   final List<TextEditingController> _optionCtrls = [
//     TextEditingController(), TextEditingController()];
//   bool _multiSelect = false;
//   bool _sending = false;

//   void _snack(String msg, Color color) =>
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg), backgroundColor: color,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.all(12)));

//   bool get _canSend =>
//     _questionCtrl.text.trim().isNotEmpty &&
//     _optionCtrls.every((c) => c.text.trim().isNotEmpty);

//   Future<void> _send() async {
//     setState(() => _sending = true);
//     try {
//       await ApiService.post('/polls', {
//         'question': _questionCtrl.text.trim(),
//         'options': _optionCtrls.map((c) => c.text.trim())
//           .where((t) => t.isNotEmpty).toList(),
//         'multi_select': _multiSelect,
//       });
//       if (mounted) {
//         _questionCtrl.clear();
//         for (final c in _optionCtrls) c.clear();
//         setState(() { _multiSelect = false; _sending = false; });
//         _snack('✅ Poll sent to all learners!', AppColors.green);
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _sending = false);
//         _snack('Error: ${e.toString()}', AppColors.orange);
//       }
//       print('Poll send error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _sectionCard('Poll Question', Icons.help_outline_rounded, children: [
//           TextField(controller: _questionCtrl, maxLines: 2,
//             textCapitalization: TextCapitalization.sentences,
//             onChanged: (_) => setState(() {}),
//             decoration: InputDecoration(
//               hintText: 'e.g. Which topic should we cover next?',
//               hintStyle: const TextStyle(
//                 fontSize: 13, color: AppColors.textSecondary),
//               filled: true, fillColor: AppColors.bg,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: AppColors.border)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: AppColors.border)),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(
//                   color: AppColors.primary, width: 1.5)),
//               contentPadding: const EdgeInsets.all(14))),
//         ]),
//         const SizedBox(height: 14),

//         _sectionCard('Options', Icons.list_alt_outlined, trailing:
//           _optionCtrls.length < 6 ? GestureDetector(
//             onTap: () => setState(() =>
//               _optionCtrls.add(TextEditingController())),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
//               decoration: BoxDecoration(color: AppColors.primaryLight,
//                 borderRadius: BorderRadius.circular(20)),
//               child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                 Icon(Icons.add_rounded, size: 14, color: AppColors.primary),
//                 SizedBox(width: 4),
//                 Text('Add', style: TextStyle(fontSize: 11,
//                   fontWeight: FontWeight.w700, color: AppColors.primary)),
//               ]))) : null,
//           children: [
//           ..._optionCtrls.asMap().entries.map((e) => Padding(
//             padding: const EdgeInsets.only(bottom: 10),
//             child: Row(children: [
//               Container(width: 30, height: 30,
//                 decoration: BoxDecoration(color: AppColors.primaryLight,
//                   borderRadius: BorderRadius.circular(8)),
//                 child: Center(child: Text(
//                   String.fromCharCode(65 + e.key),
//                   style: const TextStyle(fontSize: 13,
//                     fontWeight: FontWeight.w800, color: AppColors.primary)))),
//               const SizedBox(width: 10),
//               Expanded(child: TextField(controller: e.value,
//                 textCapitalization: TextCapitalization.sentences,
//                 onChanged: (_) => setState(() {}),
//                 decoration: InputDecoration(
//                   hintText: 'Option ${String.fromCharCode(65 + e.key)}',
//                   filled: true, fillColor: Colors.white, isDense: true,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(color: AppColors.border)),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                     borderSide: const BorderSide(color: AppColors.border)),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 12)))),
//               if (_optionCtrls.length > 2) ...[
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: () => setState(() => _optionCtrls.removeAt(e.key)),
//                   child: const Icon(Icons.remove_circle_outline,
//                     color: AppColors.textSecondary, size: 20)),
//               ],
//             ]))),
//         ]),
//         const SizedBox(height: 14),

//         Container(padding: const EdgeInsets.symmetric(
//           horizontal: 14, vertical: 12),
//           decoration: BoxDecoration(color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             border: const Border.fromBorderSide(
//               BorderSide(color: AppColors.border))),
//           child: Row(children: [
//             const Icon(Icons.check_box_outlined,
//               size: 18, color: AppColors.primary),
//             const SizedBox(width: 10),
//             const Expanded(child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text('Allow multiple selections', style: TextStyle(
//                 fontSize: 13, fontWeight: FontWeight.w700,
//                 color: AppColors.textPrimary)),
//               Text('Learners can pick more than one option',
//                 style: TextStyle(fontSize: 11,
//                   color: AppColors.textSecondary)),
//             ])),
//             Switch.adaptive(value: _multiSelect,
//               activeColor: AppColors.primary,
//               onChanged: (v) => setState(() => _multiSelect = v)),
//           ])),
//         const SizedBox(height: 24),

//         SizedBox(width: double.infinity, height: 52,
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: _canSend ? AppColors.primary : AppColors.border,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14)),
//               elevation: 0),
//             onPressed: (_canSend && !_sending) ? _send : null,
//             icon: _sending
//               ? const SizedBox(width: 18, height: 18,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2, color: Colors.white))
//               : const Icon(Icons.send_rounded, color: Colors.white),
//             label: Text(_sending ? 'Sending...' : 'Send Poll to All Learners',
//               style: const TextStyle(color: Colors.white,
//                 fontSize: 15, fontWeight: FontWeight.w700)))),
//       ]));
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // TAB 3 — Send Alert
// // ══════════════════════════════════════════════════════════════
// class _SendAlertTab extends StatefulWidget {
//   final List<LearnerProgress> learners;
//   const _SendAlertTab({required this.learners});
//   @override
//   State<_SendAlertTab> createState() => _SendAlertTabState();
// }

// class _SendAlertTabState extends State<_SendAlertTab> {
//   final _titleCtrl   = TextEditingController();
//   final _messageCtrl = TextEditingController();
//   String _audience   = 'all';
//   bool _sending = false;

//   void _snack(String msg, Color color) =>
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg), backgroundColor: color,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.all(12)));

//   static const _templates = [
//     {'icon': '⏰', 'title': 'Quiz Deadline Reminder',
//      'msg': 'Your quiz deadline is approaching! Log in and complete your assessment.'},
//     {'icon': '📚', 'title': 'New Content Available',
//      'msg': 'New learning materials have been added to your course. Send NEXT to access them.'},
//     {'icon': '🏆', 'title': 'Congratulations!',
//      'msg': 'You have completed the course. Your certificate is ready for download.'},
//     {'icon': '💡', 'title': 'Study Tip',
//      'msg': 'Consistent practice leads to mastery. Spend 15 minutes today reviewing your modules.'},
//     {'icon': '📋', 'title': 'Action Required',
//      'msg': 'Please complete your pending quiz to continue your learning journey.'},
//   ];

//   Future<void> _send() async {
//     final title   = _titleCtrl.text.trim();
//     final message = _messageCtrl.text.trim();
//     if (title.isEmpty || message.isEmpty) return;
//     setState(() => _sending = true);
//     try {
//       await ApiService.post('/broadcast', {
//         'message': '🔔 $title\n\n$message',
//         'filter': _audience,
//         'type': 'alert',
//       });
//       _titleCtrl.clear();
//       _messageCtrl.clear();
//       if (mounted) {
//         setState(() => _sending = false);
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: const Text('✅ Alert sent to learners!'),
//           backgroundColor: AppColors.green,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10)),
//           margin: const EdgeInsets.all(12)));
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _sending = false);
//         _snack('Error: ${e.toString()}', AppColors.orange);
//       }
//       print('Poll send error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         // Quick templates
//         _sectionCard('Quick Templates', Icons.flash_on_outlined, children: [
//           Wrap(spacing: 8, runSpacing: 8,
//             children: _templates.map((t) => GestureDetector(
//               onTap: () => setState(() {
//                 _titleCtrl.text = t['title']!;
//                 _messageCtrl.text = t['msg']!;
//               }),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12, vertical: 8),
//                 decoration: BoxDecoration(color: AppColors.primaryLight,
//                   borderRadius: BorderRadius.circular(20),
//                   border: const Border.fromBorderSide(
//                     BorderSide(color: AppColors.primary))),
//                 child: Text('${t['icon']} ${t['title']}',
//                   style: const TextStyle(fontSize: 11,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.primary))))).toList()),
//         ]),
//         const SizedBox(height: 14),

//         _sectionCard('Alert Content', Icons.edit_outlined, children: [
//           TextField(controller: _titleCtrl,
//             textCapitalization: TextCapitalization.sentences,
//             onChanged: (_) => setState(() {}),
//             decoration: InputDecoration(
//               labelText: 'Title',
//               filled: true, fillColor: AppColors.bg,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: AppColors.border)),
//               contentPadding: const EdgeInsets.all(14))),
//           const SizedBox(height: 10),
//           TextField(controller: _messageCtrl, maxLines: 3,
//             textCapitalization: TextCapitalization.sentences,
//             onChanged: (_) => setState(() {}),
//             decoration: InputDecoration(
//               labelText: 'Message',
//               filled: true, fillColor: AppColors.bg,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10)),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: AppColors.border)),
//               contentPadding: const EdgeInsets.all(14))),
//         ]),
//         const SizedBox(height: 14),

//         _sectionCard('Send To', Icons.people_outline, children: [
//           _audienceChip('all', '👥 All (${widget.learners.length})'),
//           _audienceChip('active', '✅ Active learners only'),
//           _audienceChip('inactive', '⚡ Inactive learners only'),
//         ]),
//         const SizedBox(height: 24),

//         SizedBox(width: double.infinity, height: 52,
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: (_titleCtrl.text.isNotEmpty &&
//                 _messageCtrl.text.isNotEmpty)
//                 ? const Color(0xFF1A5C38) : AppColors.border,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14)),
//               elevation: 0),
//             onPressed: (_titleCtrl.text.isNotEmpty &&
//               _messageCtrl.text.isNotEmpty && !_sending) ? _send : null,
//             icon: _sending
//               ? const SizedBox(width: 18, height: 18,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2, color: Colors.white))
//               : const Icon(Icons.notifications_active_rounded,
//                   color: Colors.white),
//             label: Text(_sending ? 'Sending...' : 'Send Alert via WhatsApp',
//               style: const TextStyle(color: Colors.white,
//                 fontSize: 15, fontWeight: FontWeight.w700)))),
//       ]));
//   }

//   Widget _audienceChip(String val, String label) {
//     final selected = _audience == val;
//     return GestureDetector(
//       onTap: () => setState(() => _audience = val),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//         decoration: BoxDecoration(
//           color: selected ? AppColors.primaryLight : AppColors.bg,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: selected ? AppColors.primary : AppColors.border,
//             width: selected ? 1.5 : 1)),
//         child: Row(children: [
//           Expanded(child: Text(label, style: TextStyle(fontSize: 13,
//             fontWeight: FontWeight.w700,
//             color: selected ? AppColors.primary : AppColors.textPrimary))),
//           if (selected)
//             const Icon(Icons.check_circle_rounded,
//               color: AppColors.primary, size: 18),
//         ])));
//   }
// }

// // ══════════════════════════════════════════════════════════════
// // TAB 4 — Delivery Log
// // ══════════════════════════════════════════════════════════════
// class _DeliveryLogTab extends StatefulWidget {
//   const _DeliveryLogTab();
//   @override
//   State<_DeliveryLogTab> createState() => _DeliveryLogTabState();
// }

// class _DeliveryLogTabState extends State<_DeliveryLogTab> {
//   List<dynamic> _logs = [];
//   bool _loading = true;

//   @override
//   void initState() { super.initState(); _load(); }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     try {
//       final r = await ApiService.getBroadcastLogs();
//       if (mounted) setState(() => _logs = r);
//     } catch (_) {}
//     if (mounted) setState(() => _loading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) return const Center(
//       child: CircularProgressIndicator(color: AppColors.primary));

//     if (_logs.isEmpty) return Center(
//       child: Column(mainAxisSize: MainAxisSize.min, children: [
//         const Text('📋', style: TextStyle(fontSize: 48)),
//         const SizedBox(height: 12),
//         const Text('No messages sent yet', style: TextStyle(
//           fontSize: 16, fontWeight: FontWeight.w700,
//           color: AppColors.textPrimary)),
//         const SizedBox(height: 6),
//         const Text('Send a module, poll or alert to see logs here',
//           style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
//         const SizedBox(height: 16),
//         TextButton.icon(onPressed: _load,
//           icon: const Icon(Icons.refresh, size: 16),
//           label: const Text('Refresh')),
//       ]));

//     return RefreshIndicator(
//       onRefresh: _load,
//       child: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: _logs.length,
//         itemBuilder: (_, i) {
//           final log = _logs[i] as Map<String, dynamic>;
//           final type = log['type'] ?? 'broadcast';
//           final color = type == 'alert' ? AppColors.amber
//             : type == 'poll' ? AppColors.primary
//             : AppColors.green;
//           final icon = type == 'alert' ? '🔔'
//             : type == 'poll' ? '📊' : '📤';
//           return Container(
//             margin: const EdgeInsets.only(bottom: 10),
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: AppColors.border)),
//             child: Row(children: [
//               Container(width: 40, height: 40,
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   shape: BoxShape.circle),
//                 child: Center(child: Text(icon,
//                   style: const TextStyle(fontSize: 18)))),
//               const SizedBox(width: 12),
//               Expanded(child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min, children: [
//                 Text(log['message'] ?? 'Message sent',
//                   style: const TextStyle(fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.textPrimary),
//                   maxLines: 2, overflow: TextOverflow.ellipsis),
//                 const SizedBox(height: 3),
//                 Text('Sent to ${log['recipient_count'] ?? 'all'} learners',
//                   style: const TextStyle(fontSize: 11,
//                     color: AppColors.textSecondary)),
//               ])),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(20)),
//                 child: Text(type, style: TextStyle(fontSize: 10,
//                   fontWeight: FontWeight.w700, color: color))),
//             ]));
//         }));
//   }
// }

// // ── Shared helper widgets ─────────────────────────────────────
// Widget _sectionCard(String title, IconData icon,
//     {required List<Widget> children, Widget? trailing}) {
//   return Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(14),
//       border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
//     child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min, children: [
//       Row(children: [
//         Icon(icon, size: 16, color: AppColors.primary),
//         const SizedBox(width: 8),
//         Expanded(child: Text(title, style: const TextStyle(
//           fontSize: 14, fontWeight: FontWeight.w800,
//           color: AppColors.textPrimary))),
//         if (trailing != null) trailing,
//       ]),
//       const SizedBox(height: 12),
//       const Divider(height: 1, color: AppColors.border),
//       const SizedBox(height: 12),
//       ...children,
//     ]));
// }






import 'package:flutter/material.dart';
import 'dart:async';
import '../services/api_service.dart';
import '../services/app_theme.dart';
import '../models/models.dart';

class SendScreen extends StatefulWidget {
  final List<Course> courses;
  final List<LearnerProgress> learners;
  const SendScreen({super.key, required this.courses, required this.learners});
  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        title: const Text('Send & Notify', style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.w900,
          color: AppColors.primaryDark, letterSpacing: -0.5)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tab,
              isScrollable: false,
              labelStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(fontSize: 13),
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2.5,
              tabs: const [
                Tab(text: '📤  Module'),
                Tab(text: '📊  Poll'),
                Tab(text: '🔔  Alert'),
                Tab(text: '📋  Log'),
              ]))),
        bottomOpacity: 1),
      body: TabBarView(controller: _tab, children: [
        _SendModuleTab(courses: widget.courses, learners: widget.learners),
        _SendPollTab(learners: widget.learners),
        _SendAlertTab(learners: widget.learners),
        const _DeliveryLogTab(),
      ]));
  }
}

// ══════════════════════════════════════════════════════════════
// TAB 1 — Send Module
// ══════════════════════════════════════════════════════════════
class _SendModuleTab extends StatefulWidget {
  final List<Course> courses;
  final List<LearnerProgress> learners;
  const _SendModuleTab({required this.courses, required this.learners});
  @override
  State<_SendModuleTab> createState() => _SendModuleTabState();
}

class _SendModuleTabState extends State<_SendModuleTab> {
  String? _selectedCourseId;
  String _audience = 'all';
  bool _sending = false;
  List<CourseModule> _modules = [];
  String? _selectedModuleId;

  Future<void> _loadModules(String courseId) async {
    try {
      final mods = await ApiService.getModules(courseId);
      if (mounted) setState(() => _modules = mods);
    } catch (_) {}
  }

  Future<void> _send() async {
    if (_selectedCourseId == null || _selectedModuleId == null) return;
    setState(() => _sending = true);
    try {
      // Find selected course and module details
      final course = widget.courses.firstWhere((c) => c.id == _selectedCourseId);
      final moduleIndex = _modules.indexWhere((m) => m.id == _selectedModuleId);
      final module = _modules[moduleIndex];
      final moduleNo = moduleIndex + 1;
      // Clean module title - remove "Module X:" prefix if already there
      final cleanTitle = module.title.replaceAll(RegExp(r'^Module\s*\d+[:\s-]*', caseSensitive: false), '').trim();

      final message = '📚 *New Module Available!*\n\n'
          '━━━━━━━━━━━━━━━━━━━━\n'
          '📖 *Course:* ${course.title}\n'
          '🔢 *Module $moduleNo:* $cleanTitle\n'
          '━━━━━━━━━━━━━━━━━━━━\n\n'
          'Send *NEXT* on WhatsApp to continue your learning journey! 🎓';

      await ApiService.post('/broadcast', {
        'message': message,
        'filter': _audience,
        'course_id': _selectedCourseId,
        'module_id': _selectedModuleId,
        'type': 'module',
      });
      if (mounted) _snack('✅ Module sent to learners!', AppColors.green);
    } catch (e) {
      if (mounted) _snack('Error: ${e.toString()}', AppColors.orange);
      print('Send error: $e');
    }
    if (mounted) setState(() => _sending = false);
  }

  void _snack(String msg, Color color) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(12)));

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionCard('Select Course', Icons.menu_book_outlined, children: [
          if (widget.courses.isEmpty)
            const Text('No courses yet. Create one first.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13))
          else
            ...widget.courses.map((c) => _courseOption(c)),
        ]),
        const SizedBox(height: 14),

        if (_selectedCourseId != null) ...[
          _sectionCard('Select Module', Icons.view_list_outlined, children: [
            if (_modules.isEmpty)
              const Text('No modules in this course.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13))
            else
              ..._modules.map((m) => _moduleOption(m)),
          ]),
          const SizedBox(height: 14),
        ],

        _sectionCard('Send To', Icons.people_outline, children: [
          _audienceOption('all', '👥 All Learners',
            '${widget.learners.length} learners'),
          _audienceOption('enrolled', '📚 Enrolled Only',
            'Learners in selected course'),
          _audienceOption('not_started', '⚡ Not Started',
            'Push inactive learners'),
        ]),
        const SizedBox(height: 24),

        SizedBox(width: double.infinity, height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _selectedModuleId != null
                ? AppColors.primary : AppColors.border,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
              elevation: 0),
            onPressed: (_selectedModuleId != null && !_sending) ? _send : null,
            icon: _sending
              ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.send_rounded, color: Colors.white),
            label: Text(_sending ? 'Sending...' : 'Send Module via WhatsApp',
              style: const TextStyle(color: Colors.white,
                fontSize: 15, fontWeight: FontWeight.w700)))),
      ]));
  }

  Widget _courseOption(Course c) {
    final selected = _selectedCourseId == c.id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCourseId = c.id;
          _selectedModuleId = null;
          _modules = [];
        });
        _loadModules(c.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1)),
        child: Row(children: [
          Text(_courseEmoji(c.title), style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 10),
          Expanded(child: Text(c.title,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
              color: selected ? AppColors.primary : AppColors.textPrimary))),
          if (selected)
            const Icon(Icons.check_circle_rounded,
              color: AppColors.primary, size: 18),
        ])));
  }

  Widget _moduleOption(CourseModule m) {
    final selected = _selectedModuleId == m.id;
    return GestureDetector(
      onTap: () => setState(() => _selectedModuleId = m.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1)),
        child: Row(children: [
          Container(width: 24, height: 24,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.textSecondary,
              shape: BoxShape.circle),
            child: Center(child: Text('${m.order}',
              style: const TextStyle(color: Colors.white,
                fontSize: 11, fontWeight: FontWeight.w800)))),
          const SizedBox(width: 10),
          Expanded(child: Text(m.title,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
              color: selected ? AppColors.primary : AppColors.textPrimary))),
          if (selected)
            const Icon(Icons.check_circle_rounded,
              color: AppColors.primary, size: 18),
        ])));
  }

  Widget _audienceOption(String val, String label, String sub) {
    final selected = _audience == val;
    return GestureDetector(
      onTap: () => setState(() => _audience = val),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1)),
        child: Row(children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, children: [
            Text(label, style: TextStyle(fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected ? AppColors.primary : AppColors.textPrimary)),
            Text(sub, style: const TextStyle(fontSize: 11,
              color: AppColors.textSecondary)),
          ])),
          if (selected)
            const Icon(Icons.check_circle_rounded,
              color: AppColors.primary, size: 18),
        ])));
  }

  String _courseEmoji(String title) {
    const emojis = ['📊','🎯','📚','🧠','💡','🚀','🎓','🌐'];
    return title.isNotEmpty ? emojis[title.length % emojis.length] : '📚';
  }
}

// ══════════════════════════════════════════════════════════════
// TAB 2 — Send Poll
// ══════════════════════════════════════════════════════════════
class _SendPollTab extends StatefulWidget {
  final List<LearnerProgress> learners;
  const _SendPollTab({required this.learners});
  @override
  State<_SendPollTab> createState() => _SendPollTabState();
}

class _SendPollTabState extends State<_SendPollTab> {
  final _questionCtrl = TextEditingController();
  final List<TextEditingController> _optionCtrls = [
    TextEditingController(), TextEditingController()];
  bool _multiSelect = false;
  bool _sending = false;
  List<Map<String, dynamic>> _polls = [];
  bool _loadingPolls = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadPolls();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _loadPolls());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadPolls() async {
    try {
      final r = await ApiService.get('/polls');
      if (mounted) setState(() => _polls = List<Map<String, dynamic>>.from(r['data'] ?? []));
    } catch (_) {}
  }

  void _snack(String msg, Color color) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(12)));

  bool get _canSend =>
    _questionCtrl.text.trim().isNotEmpty &&
    _optionCtrls.every((c) => c.text.trim().isNotEmpty);

  Future<void> _send() async {
    setState(() => _sending = true);
    try {
      await ApiService.post('/polls', {
        'question': _questionCtrl.text.trim(),
        'options': _optionCtrls.map((c) => c.text.trim())
          .where((t) => t.isNotEmpty).toList(),
        'multi_select': _multiSelect,
      });
      if (mounted) {
        _questionCtrl.clear();
        for (final c in _optionCtrls) c.clear();
        setState(() { _multiSelect = false; _sending = false; });
        _snack('✅ Poll sent to all learners!', AppColors.green);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _sending = false);
        _snack('Error: ${e.toString()}', AppColors.orange);
      }
      print('Poll send error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionCard('Poll Question', Icons.help_outline_rounded, children: [
          TextField(controller: _questionCtrl, maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'e.g. Which topic should we cover next?',
              hintStyle: const TextStyle(
                fontSize: 13, color: AppColors.textSecondary),
              filled: true, fillColor: AppColors.bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary, width: 1.5)),
              contentPadding: const EdgeInsets.all(14))),
        ]),
        const SizedBox(height: 14),

        _sectionCard('Options', Icons.list_alt_outlined, trailing:
          _optionCtrls.length < 6 ? GestureDetector(
            onTap: () => setState(() =>
              _optionCtrls.add(TextEditingController())),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.add_rounded, size: 14, color: AppColors.primary),
                SizedBox(width: 4),
                Text('Add', style: TextStyle(fontSize: 11,
                  fontWeight: FontWeight.w700, color: AppColors.primary)),
              ]))) : null,
          children: [
          ..._optionCtrls.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(children: [
              Container(width: 30, height: 30,
                decoration: BoxDecoration(color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8)),
                child: Center(child: Text(
                  String.fromCharCode(65 + e.key),
                  style: const TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w800, color: AppColors.primary)))),
              const SizedBox(width: 10),
              Expanded(child: TextField(controller: e.value,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Option ${String.fromCharCode(65 + e.key)}',
                  filled: true, fillColor: Colors.white, isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.border)),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12)))),
              if (_optionCtrls.length > 2) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _optionCtrls.removeAt(e.key)),
                  child: const Icon(Icons.remove_circle_outline,
                    color: AppColors.textSecondary, size: 20)),
              ],
            ]))),
        ]),
        const SizedBox(height: 14),

        Container(padding: const EdgeInsets.symmetric(
          horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: const Border.fromBorderSide(
              BorderSide(color: AppColors.border))),
          child: Row(children: [
            const Icon(Icons.check_box_outlined,
              size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            const Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Allow multiple selections', style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary)),
              Text('Learners can pick more than one option',
                style: TextStyle(fontSize: 11,
                  color: AppColors.textSecondary)),
            ])),
            Switch.adaptive(value: _multiSelect,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _multiSelect = v)),
          ])),
        const SizedBox(height: 24),

        SizedBox(width: double.infinity, height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _canSend ? AppColors.primary : AppColors.border,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
              elevation: 0),
            onPressed: (_canSend && !_sending) ? _send : null,
            icon: _sending
              ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.send_rounded, color: Colors.white),
            label: Text(_sending ? 'Sending...' : 'Send Poll to All Learners',
              style: const TextStyle(color: Colors.white,
                fontSize: 15, fontWeight: FontWeight.w700)))),


      // ── Poll Results Section ──────────────────────────────
      if (_polls.isNotEmpty) ...[
        const SizedBox(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Poll Results', style: TextStyle(fontSize: 16,
            fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.greenLight,
              borderRadius: BorderRadius.circular(20)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.circle, size: 8, color: AppColors.green),
              SizedBox(width: 4),
              Text('Live', style: TextStyle(fontSize: 10,
                fontWeight: FontWeight.w700, color: AppColors.green)),
            ])),
        ]),
        const SizedBox(height: 12),
        ..._polls.map((poll) {
          final total   = poll['response_count'] as int? ?? 0;
          final counts  = Map<String, dynamic>.from(poll['counts'] as Map? ?? {});
          final options = List<String>.from(poll['options'] as List? ?? []);
          final maxVotes = counts.values.fold(0, (int a, b) => (b as int) > a ? b : a);
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(poll['question'] ?? '',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: total > 0 ? AppColors.greenLight : AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20)),
                  child: Text('$total votes',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                      color: total > 0 ? AppColors.green : AppColors.primary))),
              ]),
              const SizedBox(height: 14),
              ...options.map((opt) {
                final count    = (counts[opt] as int?) ?? 0;
                final pct      = total > 0 ? count / total : 0.0;
                final isWinner = count == maxVotes && count > 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      if (isWinner) const Text('🏆 ', style: TextStyle(fontSize: 12)),
                      Expanded(child: Text(opt, style: TextStyle(
                        fontSize: 13,
                        fontWeight: isWinner ? FontWeight.w700 : FontWeight.normal,
                        color: isWinner ? AppColors.primary : AppColors.textPrimary))),
                      Text('$count · ${(pct * 100).round()}%',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                          color: isWinner ? AppColors.primary : AppColors.textSecondary)),
                    ]),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: pct,
                        minHeight: 10,
                        backgroundColor: AppColors.primaryLight,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isWinner ? AppColors.primary : AppColors.textSecondary))),
                  ]));
              }),
              if (total == 0)
                const Center(child: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('No responses yet',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary)))),
            ]));
        }),
      ],
      ]));
  }
}

// ══════════════════════════════════════════════════════════════
// TAB 3 — Send Alert
// ══════════════════════════════════════════════════════════════
class _SendAlertTab extends StatefulWidget {
  final List<LearnerProgress> learners;
  const _SendAlertTab({required this.learners});
  @override
  State<_SendAlertTab> createState() => _SendAlertTabState();
}

class _SendAlertTabState extends State<_SendAlertTab> {
  final _titleCtrl   = TextEditingController();
  final _messageCtrl = TextEditingController();
  String _audience   = 'all';
  bool _sending = false;

  void _snack(String msg, Color color) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(12)));

  static const _templates = [
    {'icon': '⏰', 'title': 'Quiz Deadline Reminder',
     'msg': 'Your quiz deadline is approaching! Log in and complete your assessment.'},
    {'icon': '📚', 'title': 'New Content Available',
     'msg': 'New learning materials have been added to your course. Send NEXT to access them.'},
    {'icon': '🏆', 'title': 'Congratulations!',
     'msg': 'You have completed the course. Your certificate is ready for download.'},
    {'icon': '💡', 'title': 'Study Tip',
     'msg': 'Consistent practice leads to mastery. Spend 15 minutes today reviewing your modules.'},
    {'icon': '📋', 'title': 'Action Required',
     'msg': 'Please complete your pending quiz to continue your learning journey.'},
  ];

  Future<void> _send() async {
    final title   = _titleCtrl.text.trim();
    final message = _messageCtrl.text.trim();
    if (title.isEmpty || message.isEmpty) return;
    setState(() => _sending = true);
    try {
      await ApiService.post('/broadcast', {
        'message': '🔔 $title\n\n$message',
        'filter': _audience,
        'type': 'alert',
      });
      _titleCtrl.clear();
      _messageCtrl.clear();
      if (mounted) {
        setState(() => _sending = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('✅ Alert sent to learners!'),
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(12)));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _sending = false);
        _snack('Error: ${e.toString()}', AppColors.orange);
      }
      print('Poll send error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Quick templates
        _sectionCard('Quick Templates', Icons.flash_on_outlined, children: [
          Wrap(spacing: 8, runSpacing: 8,
            children: _templates.map((t) => GestureDetector(
              onTap: () => setState(() {
                _titleCtrl.text = t['title']!;
                _messageCtrl.text = t['msg']!;
              }),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20),
                  border: const Border.fromBorderSide(
                    BorderSide(color: AppColors.primary))),
                child: Text('${t['icon']} ${t['title']}',
                  style: const TextStyle(fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary))))).toList()),
        ]),
        const SizedBox(height: 14),

        _sectionCard('Alert Content', Icons.edit_outlined, children: [
          TextField(controller: _titleCtrl,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Title',
              filled: true, fillColor: AppColors.bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border)),
              contentPadding: const EdgeInsets.all(14))),
          const SizedBox(height: 10),
          TextField(controller: _messageCtrl, maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Message',
              filled: true, fillColor: AppColors.bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border)),
              contentPadding: const EdgeInsets.all(14))),
        ]),
        const SizedBox(height: 14),

        _sectionCard('Send To', Icons.people_outline, children: [
          _audienceChip('all', '👥 All (${widget.learners.length})'),
          _audienceChip('active', '✅ Active learners only'),
          _audienceChip('inactive', '⚡ Inactive learners only'),
        ]),
        const SizedBox(height: 24),

        SizedBox(width: double.infinity, height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: (_titleCtrl.text.isNotEmpty &&
                _messageCtrl.text.isNotEmpty)
                ? const Color(0xFF1A5C38) : AppColors.border,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
              elevation: 0),
            onPressed: (_titleCtrl.text.isNotEmpty &&
              _messageCtrl.text.isNotEmpty && !_sending) ? _send : null,
            icon: _sending
              ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.notifications_active_rounded,
                  color: Colors.white),
            label: Text(_sending ? 'Sending...' : 'Send Alert via WhatsApp',
              style: const TextStyle(color: Colors.white,
                fontSize: 15, fontWeight: FontWeight.w700)))),
      ]));
  }

  Widget _audienceChip(String val, String label) {
    final selected = _audience == val;
    return GestureDetector(
      onTap: () => setState(() => _audience = val),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1)),
        child: Row(children: [
          Expanded(child: Text(label, style: TextStyle(fontSize: 13,
            fontWeight: FontWeight.w700,
            color: selected ? AppColors.primary : AppColors.textPrimary))),
          if (selected)
            const Icon(Icons.check_circle_rounded,
              color: AppColors.primary, size: 18),
        ])));
  }
}

// ══════════════════════════════════════════════════════════════
// TAB 4 — Delivery Log
// ══════════════════════════════════════════════════════════════
class _DeliveryLogTab extends StatefulWidget {
  const _DeliveryLogTab();
  @override
  State<_DeliveryLogTab> createState() => _DeliveryLogTabState();
}

class _DeliveryLogTabState extends State<_DeliveryLogTab> {
  List<dynamic> _logs = [];
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await ApiService.getBroadcastLogs();
      if (mounted) setState(() => _logs = r);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(
      child: CircularProgressIndicator(color: AppColors.primary));

    if (_logs.isEmpty) return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('📋', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        const Text('No messages sent yet', style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700,
          color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('Send a module, poll or alert to see logs here',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        TextButton.icon(onPressed: _load,
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Refresh')),
      ]));

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _logs.length,
        itemBuilder: (_, i) {
          final log = _logs[i] as Map<String, dynamic>;
          final type = log['type'] ?? 'broadcast';
          final color = type == 'alert' ? AppColors.amber
            : type == 'poll' ? AppColors.primary
            : AppColors.green;
          final icon = type == 'alert' ? '🔔'
            : type == 'poll' ? '📊' : '📤';
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Container(width: 40, height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle),
                child: Center(child: Text(icon,
                  style: const TextStyle(fontSize: 18)))),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, children: [
                Text(log['message'] ?? 'Message sent',
                  style: const TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text('Sent to ${log['recipient_count'] ?? 'all'} learners',
                  style: const TextStyle(fontSize: 11,
                    color: AppColors.textSecondary)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20)),
                child: Text(type, style: TextStyle(fontSize: 10,
                  fontWeight: FontWeight.w700, color: color))),
            ]));
        }));
  }
}

// ── Shared helper widgets ─────────────────────────────────────
Widget _sectionCard(String title, IconData icon,
    {required List<Widget> children, Widget? trailing}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, children: [
      Row(children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(title, style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w800,
          color: AppColors.textPrimary))),
        if (trailing != null) trailing,
      ]),
      const SizedBox(height: 12),
      const Divider(height: 1, color: AppColors.border),
      const SizedBox(height: 12),
      ...children,
    ]));
}