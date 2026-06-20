// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../services/app_theme.dart';
// import 'certificate_service.dart';

// // ─── Entry point for learners at localhost/#/learner ─────────────────────────
// class LearnerScreen extends StatefulWidget {
//   const LearnerScreen({super.key});

//   @override
//   State<LearnerScreen> createState() => _LearnerScreenState();
// }

// class _LearnerScreenState extends State<LearnerScreen> {
//   final _nameCtrl = TextEditingController();
//   final _phoneCtrl = TextEditingController();
//   bool _entered = false;

//   void _startChat() {
//     final name = _nameCtrl.text.trim();
//     final phone = _phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), '');
//     if (name.isEmpty || phone.length < 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter your name and a valid phone number'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }
//     setState(() => _entered = true);
//   }

//   // ── Sign out → back to entry form ─────────────────────────
//   void _signOut() {
//     setState(() {
//       _entered = false;
//       _nameCtrl.clear();
//       _phoneCtrl.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _entered
//         ? _LearnerChatScreen(
//             name: _nameCtrl.text.trim(),
//             phone: _phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), ''),
//             onSignOut: _signOut,
//           )
//         : _LearnerEntryScreen(
//             nameCtrl: _nameCtrl,
//             phoneCtrl: _phoneCtrl,
//             onStart: _startChat,
//           );
//   }
// }

// // ─── Entry form ───────────────────────────────────────────────────────────────
// class _LearnerEntryScreen extends StatelessWidget {
//   final TextEditingController nameCtrl;
//   final TextEditingController phoneCtrl;
//   final VoidCallback onStart;

//   const _LearnerEntryScreen({
//     required this.nameCtrl,
//     required this.phoneCtrl,
//     required this.onStart,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF075E54),
//       body: SafeArea(
//         child: Column(children: [
//           // ── Branding ─────────────────────────────────────────────────
//           Expanded(
//             flex: 2,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 90, height: 90,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.2),
//                           blurRadius: 20,
//                           offset: const Offset(0, 8)),
//                     ],
//                   ),
//                   child: const Center(
//                       child: Text('🎓', style: TextStyle(fontSize: 44))),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Andragogy',
//                     style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                         letterSpacing: -1)),
//                 const SizedBox(height: 6),
//                 const Text('Your mobile learning companion',
//                     style: TextStyle(fontSize: 14, color: Colors.white70)),
//               ],
//             ),
//           ),

//           // ── Form card ─────────────────────────────────────────────────
//           Expanded(
//             flex: 3,
//             child: Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius:
//                     BorderRadius.vertical(top: Radius.circular(32)),
//               ),
//               padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Get Started',
//                       style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w900,
//                           color: Color(0xFF075E54))),
//                   const SizedBox(height: 6),
//                   const Text('Enter your details to start learning',
//                       style: TextStyle(
//                           fontSize: 13, color: AppColors.textSecondary)),
//                   const SizedBox(height: 28),

//                   // Name
//                   TextField(
//                     controller: nameCtrl,
//                     textCapitalization: TextCapitalization.words,
//                     decoration: InputDecoration(
//                       labelText: 'Full Name',
//                       hintText: 'e.g. John Smith',
//                       prefixIcon: const Icon(Icons.person_rounded,
//                           color: Color(0xFF075E54)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14),
//                           borderSide: const BorderSide(
//                               color: Color(0xFF075E54), width: 2)),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Phone
//                   TextField(
//                     controller: phoneCtrl,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       labelText: 'Phone Number',
//                       hintText: 'e.g. 9876543210',
//                       prefixIcon: const Icon(Icons.phone_rounded,
//                           color: Color(0xFF075E54)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14),
//                           borderSide: const BorderSide(
//                               color: Color(0xFF075E54), width: 2)),
//                     ),
//                   ),
//                   const SizedBox(height: 28),

//                   // Info note
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE8F5E9),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: const Color(0xFF25D366).withValues(alpha: 0.4)),
//                     ),
//                     child: const Row(children: [
//                       Icon(Icons.info_outline_rounded,
//                           color: Color(0xFF075E54), size: 16),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           'The bot will collect your Employee ID, Department & Job Role during registration.',
//                           style: TextStyle(fontSize: 11, color: Color(0xFF075E54), height: 1.4),
//                         ),
//                       ),
//                     ]),
//                   ),

//                   const SizedBox(height: 16),

//                   // Start button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: onStart,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF25D366),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14)),
//                         elevation: 0,
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.chat_rounded, size: 20),
//                           SizedBox(width: 10),
//                           Text('Start Learning',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w800)),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const Spacer(),
//                   Center(
//                     child: Text(
//                       'Powered by WhatsApp Bot Technology',
//                       style: TextStyle(
//                           fontSize: 11, color: Colors.grey.shade400),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ─── Chat screen ──────────────────────────────────────────────────────────────
// class _LearnerChatScreen extends StatefulWidget {
//   final String name;
//   final String phone;
//   final VoidCallback onSignOut;

//   const _LearnerChatScreen({
//     required this.name,
//     required this.phone,
//     required this.onSignOut,
//   });

//   @override
//   State<_LearnerChatScreen> createState() => _LearnerChatScreenState();
// }

// class _LearnerChatScreenState extends State<_LearnerChatScreen> {
//   final _msgCtrl = TextEditingController();
//   final _scrollCtrl = ScrollController();
//   final List<_Msg> _messages = [];
//   bool _sending = false;

//   // Track last completed course for certificate
//   String _lastCourseTitle = '';
//   int _lastScore = 0;

//   final List<String> _chips = [
//     'START', 'MENU', 'YES', 'NO', 'QUIZ', 'PROGRESS', 'HELP',
//     'A', 'B', 'C', 'D',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _send('START'));
//   }

//   @override
//   void dispose() {
//     _msgCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   // ── Detect quiz score from bot response ───────────────────
//   // Bot sends: "✅ Score: *92%* (11/12 correct)"
//   int? _extractScore(String text) {
//     final re = RegExp(r'Score:\s*\*?(\d+)%\*?');
//     final match = re.firstMatch(text);
//     if (match != null) return int.tryParse(match.group(1)!);
//     return null;
//   }

//   // ── Detect course title from bot response ─────────────────
//   // Bot sends: "📝 *Quiz: Digital Marketing*"
//   String _extractCourse(String text) {
//     final re = RegExp(r'Quiz:\s*(.+?)\n');
//     final match = re.firstMatch(text);
//     return match?.group(1)?.replaceAll('*', '').trim() ?? _lastCourseTitle;
//   }

//   Future<void> _send(String text) async {
//     final trimmed = text.trim();
//     if (trimmed.isEmpty || _sending) return;

//     setState(() {
//       if (trimmed != 'START' || _messages.isEmpty)
//         _messages.add(_Msg(text: trimmed, isBot: false));
//       _sending = true;
//     });
//     _msgCtrl.clear();
//     _scrollToBottom();

//     final response =
//         await ApiService.sendWhatsAppMessage(widget.phone, trimmed);

//     if (mounted) {
//       // Extract score and course from quiz complete message
//       final score = _extractScore(response);
//       final course = _extractCourse(response);
//       if (course.isNotEmpty) _lastCourseTitle = course;
//       if (score != null) _lastScore = score;

//       setState(() {
//         _messages.add(_Msg(
//           text: response,
//           isBot: true,
//           // Attach certificate if score >= 90
//           showCertificate: score != null && score >= 90,
//           quizScore: score,
//           courseTitle: course.isNotEmpty ? course : _lastCourseTitle,
//         ));
//         _sending = false;
//       });
//       _scrollToBottom();
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(
//           _scrollCtrl.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   // ── Sign out confirmation ──────────────────────────────────
//   void _confirmSignOut() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Sign Out',
//             style: TextStyle(fontWeight: FontWeight.w800)),
//         content:
//             const Text('Are you sure you want to sign out?\nYour progress is saved.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel',
//                 style: TextStyle(color: Colors.grey)),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               widget.onSignOut();
//             },
//             child: const Text('Sign Out',
//                 style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF075E54),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: Row(children: [
//           CircleAvatar(
//             radius: 18,
//             backgroundColor: const Color(0xFF25D366),
//             child: Text(
//               widget.name.isNotEmpty
//                   ? widget.name[0].toUpperCase()
//                   : '?',
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 14),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.name,
//                       style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white)),
//                   const Text('Andragogy Learning Bot',
//                       style:
//                           TextStyle(fontSize: 11, color: Colors.white70)),
//                 ]),
//           ),
//         ]),
//         // ── Sign out button ──────────────────────────────────
//         actions: [
//           IconButton(
//             onPressed: _confirmSignOut,
//             icon: const Icon(Icons.logout_rounded, color: Colors.white),
//             tooltip: 'Sign Out',
//           ),
//         ],
//       ),

//       body: Column(children: [
//         // ── Quick chips ──────────────────────────────────────────────
//         Container(
//           color: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: SizedBox(
//             height: 36,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               itemCount: _chips.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 6),
//               itemBuilder: (_, i) {
//                 final chip = _chips[i];
//                 final isAnswer =
//                     ['A', 'B', 'C', 'D'].contains(chip);
//                 return GestureDetector(
//                   onTap: () => _send(chip),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 14, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: chip == 'YES'
//                           ? const Color(0xFFE8F5E9)
//                           : chip == 'NO'
//                               ? const Color(0xFFFFEBEE)
//                               : isAnswer
//                                   ? const Color(0xFFE8EEFF)
//                                   : const Color(0xFFF5F5F5),
//                       border: Border.all(
//                           color: chip == 'YES'
//                               ? const Color(0xFF25D366)
//                               : chip == 'NO'
//                                   ? Colors.red
//                                   : isAnswer
//                                       ? AppColors.primary
//                                       : const Color(0xFF075E54)),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(chip,
//                         style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w700,
//                             color: chip == 'YES'
//                                 ? const Color(0xFF075E54)
//                                 : chip == 'NO'
//                                     ? Colors.red
//                                     : isAnswer
//                                         ? AppColors.primary
//                                         : const Color(0xFF075E54))),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         const Divider(height: 1, color: AppColors.border),

//         // ── Messages ─────────────────────────────────────────────────
//         Expanded(
//           child: Container(
//             color: const Color(0xFFE5DDD5),
//             child: ListView.builder(
//               controller: _scrollCtrl,
//               padding: const EdgeInsets.all(12),
//               itemCount: _messages.length + (_sending ? 1 : 0),
//               itemBuilder: (_, i) {
//                 if (i == _messages.length) return _buildTyping();
//                 return _buildBubble(_messages[i]);
//               },
//             ),
//           ),
//         ),

//         // ── Input bar ────────────────────────────────────────────────
//         Container(
//           padding:
//               const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           color: const Color(0xFFF0F0F0),
//           child: Row(children: [
//             Expanded(
//               child: TextField(
//                 controller: _msgCtrl,
//                 textInputAction: TextInputAction.send,
//                 onSubmitted: _send,
//                 decoration: InputDecoration(
//                   hintText: 'Type a message...',
//                   fillColor: Colors.white,
//                   filled: true,
//                   contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16, vertical: 10),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(24),
//                       borderSide: BorderSide.none),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(24),
//                       borderSide: BorderSide.none),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             GestureDetector(
//               onTap: () => _send(_msgCtrl.text),
//               child: Container(
//                 width: 44, height: 44,
//                 decoration: const BoxDecoration(
//                     color: Color(0xFF25D366), shape: BoxShape.circle),
//                 child: const Icon(Icons.send,
//                     color: Colors.white, size: 20),
//               ),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }

//   // ── Bubble builder ────────────────────────────────────────────────────────
//   Widget _buildBubble(_Msg m) {
//     final ytUrls =
//         m.isBot ? _findYtUrls(m.text) : <String>[];
//     final cleanText =
//         ytUrls.isNotEmpty ? _stripYtUrls(m.text) : m.text;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Align(
//         alignment:
//             m.isBot ? Alignment.centerLeft : Alignment.centerRight,
//         child: Column(
//           crossAxisAlignment: m.isBot
//               ? CrossAxisAlignment.start
//               : CrossAxisAlignment.end,
//           children: [
//             // Text bubble
//             if (cleanText.isNotEmpty)
//               Container(
//                 constraints: BoxConstraints(
//                     maxWidth:
//                         MediaQuery.of(context).size.width * 0.78),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: m.isBot
//                       ? Colors.white
//                       : const Color(0xFFD9FDD3),
//                   borderRadius: BorderRadius.only(
//                     topLeft: const Radius.circular(12),
//                     topRight: const Radius.circular(12),
//                     bottomLeft: m.isBot
//                         ? Radius.zero
//                         : const Radius.circular(12),
//                     bottomRight: m.isBot
//                         ? const Radius.circular(12)
//                         : Radius.zero,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black.withValues(alpha: 0.06),
//                         blurRadius: 4,
//                         offset: const Offset(0, 1)),
//                   ],
//                 ),
//                 child: Text(cleanText,
//                     style: const TextStyle(
//                         fontSize: 13,
//                         height: 1.5,
//                         color: AppColors.textPrimary)),
//               ),

//             // YouTube cards
//             ...ytUrls.map((url) => _buildYouTubeCard(url)),

//             // ── Certificate card (score >= 90) ────────────────────
//             if (m.showCertificate)
//               _buildCertificateCard(
//                   m.courseTitle, m.quizScore ?? 0),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Certificate card ──────────────────────────────────────────────────────
//   Widget _buildCertificateCard(String courseTitle, int score) {
//     return Container(
//       margin: const EdgeInsets.only(top: 8),
//       constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.85),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF1348D4), Color(0xFF4B3FD8)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//               color: const Color(0xFF1348D4).withValues(alpha: 0.4),
//               blurRadius: 12,
//               offset: const Offset(0, 4)),
//         ],
//       ),
//       child: Stack(children: [
//         // Background decoration circles
//         Positioned(
//           top: -20, right: -20,
//           child: Container(
//             width: 100, height: 100,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white.withValues(alpha: 0.08),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: -30, left: -10,
//           child: Container(
//             width: 120, height: 120,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.white.withValues(alpha: 0.05),
//             ),
//           ),
//         ),

//         // Content
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Header
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withValues(alpha: 0.2),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Row(children: [
//                       Icon(Icons.verified_rounded,
//                           color: Colors.white, size: 14),
//                       SizedBox(width: 4),
//                       Text('CERTIFICATE OF COMPLETION',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 9,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: 1)),
//                     ]),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               // Trophy
//               const Text('🏆',
//                   style: TextStyle(fontSize: 48)),

//               const SizedBox(height: 8),

//               // Congratulations
//               const Text('Congratulations!',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w900,
//                       letterSpacing: -0.5)),

//               const SizedBox(height: 4),

//               // Learner name
//               Text(
//                 widget.name,
//                 style: const TextStyle(
//                     color: Colors.white70,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600),
//               ),

//               const SizedBox(height: 16),

//               // Divider
//               Container(
//                 height: 1,
//                 color: Colors.white.withValues(alpha: 0.2),
//               ),

//               const SizedBox(height: 16),

//               // Course name
//               const Text('has successfully completed',
//                   style: TextStyle(
//                       color: Colors.white70, fontSize: 11)),
//               const SizedBox(height: 4),
//               Text(
//                 courseTitle.isNotEmpty
//                     ? courseTitle
//                     : 'the course',
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w800,
//                     letterSpacing: -0.3),
//               ),

//               const SizedBox(height: 16),

//               // Score + date row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Column(children: [
//                     Text(
//                       '$score%',
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.w900),
//                     ),
//                     const Text('Final Score',
//                         style: TextStyle(
//                             color: Colors.white70, fontSize: 10)),
//                   ]),
//                   Container(
//                       width: 1, height: 40,
//                       color: Colors.white.withValues(alpha: 0.2)),
//                   Column(children: [
//                     Text(
//                       _formatDate(),
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700),
//                     ),
//                     const Text('Date Issued',
//                         style: TextStyle(
//                             color: Colors.white70, fontSize: 10)),
//                   ]),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               // Footer badge
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF25D366),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.star_rounded,
//                           color: Colors.white, size: 14),
//                       SizedBox(width: 4),
//                       Text('Excellence Award',
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 11,
//                               fontWeight: FontWeight.w800)),
//                     ]),
//               ),

//               const SizedBox(height: 8),
//               const Text('Issued by Andragogy Learning Platform',
//                   style: TextStyle(color: Colors.white54, fontSize: 9)),

//               const SizedBox(height: 16),

//               // Download PDF button
//               GestureDetector(
//                 onTap: () => CertificateService.downloadCertificate(
//                   learnerName: widget.name,
//                   courseTitle: courseTitle.isNotEmpty ? courseTitle : 'the course',
//                   score: score,
//                   date: _formatDate(),
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(color: Colors.black.withValues(alpha: 0.15),
//                           blurRadius: 8, offset: const Offset(0, 3)),
//                     ],
//                   ),
//                   child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                     Icon(Icons.download_rounded,
//                         color: Color(0xFF1348D4), size: 18),
//                     SizedBox(width: 8),
//                     Text('Download Certificate (PDF)',
//                         style: TextStyle(
//                             color: Color(0xFF1348D4),
//                             fontSize: 13,
//                             fontWeight: FontWeight.w800)),
//                   ]),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ]),
//     );
//   }

//   String _formatDate() {
//     final now = DateTime.now();
//     const months = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
//     ];
//     return '${months[now.month - 1]} ${now.day}, ${now.year}';
//   }

//   // ── YouTube helpers ───────────────────────────────────────────────────────
//   List<String> _findYtUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return re.allMatches(text).map((m) => m.group(0)!).toList();
//   }

//   String _stripYtUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return text
//         .replaceAll(re, '')
//         .replaceAll(RegExp(r'\n{3,}'), '\n\n')
//         .trim();
//   }

//   String? _ytVideoId(String url) {
//     final patterns = [
//       RegExp(r'youtu\.be/([^?&\s]+)'),
//       RegExp(r'youtube\.com/watch\?v=([^&\s]+)'),
//       RegExp(r'youtube\.com/shorts/([^?&\s]+)'),
//     ];
//     for (final p in patterns) {
//       final m = p.firstMatch(url);
//       if (m != null) return m.group(1);
//     }
//     return null;
//   }

//   Widget _buildYouTubeCard(String url) {
//     final videoId = _ytVideoId(url);
//     return Container(
//       margin: const EdgeInsets.only(top: 6),
//       constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.78),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withValues(alpha: 0.08),
//               blurRadius: 6,
//               offset: const Offset(0, 2)),
//         ],
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: Column(children: [
//         Stack(children: [
//           videoId != null
//               ? Image.network(
//                   'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
//                   width: double.infinity,
//                   height: 130,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => _ytPlaceholder(),
//                 )
//               : _ytPlaceholder(),
//           Positioned.fill(
//             child: Center(
//               child: Container(
//                 width: 48, height: 48,
//                 decoration: const BoxDecoration(
//                     color: Colors.red, shape: BoxShape.circle),
//                 child: const Icon(Icons.play_arrow_rounded,
//                     color: Colors.white, size: 28),
//               ),
//             ),
//           ),
//         ]),
//         Padding(
//           padding:
//               const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           child: Row(children: [
//             const Icon(Icons.play_circle_outline_rounded,
//                 color: Colors.red, size: 16),
//             const SizedBox(width: 6),
//             const Expanded(
//                 child: Text('Tap to watch video',
//                     style: TextStyle(
//                         fontSize: 12, fontWeight: FontWeight.w600))),
//             Container(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 8, vertical: 3),
//               decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(20)),
//               child: const Text('Watch',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 10,
//                       fontWeight: FontWeight.w700)),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }

//   Widget _ytPlaceholder() {
//     return Container(
//       width: double.infinity, height: 130,
//       color: const Color(0xFF1A1A1A),
//       child: const Column(
//           mainAxisAlignment: MainAxisAlignment.center, children: [
//         Icon(Icons.play_circle_filled_rounded,
//             color: Colors.red, size: 40),
//         SizedBox(height: 4),
//         Text('YouTube Video',
//             style: TextStyle(color: Colors.white70, fontSize: 11)),
//       ]),
//     );
//   }

//   Widget _buildTyping() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.symmetric(
//             horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12)),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           _dot(), _dot(), _dot(),
//         ]),
//       ),
//     );
//   }

//   Widget _dot() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 2),
//       width: 7, height: 7,
//       decoration: BoxDecoration(
//         color: AppColors.textSecondary.withValues(alpha: 0.5),
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }

// // ─── Message model ────────────────────────────────────────────────────────────
// class _Msg {
//   final String text;
//   final bool isBot;
//   final bool showCertificate;
//   final int? quizScore;
//   final String courseTitle;

//   _Msg({
//     required this.text,
//     required this.isBot,
//     this.showCertificate = false,
//     this.quizScore,
//     this.courseTitle = '',
//   });
// }










// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../services/api_service.dart';
// import '../services/app_theme.dart';
// import 'certificate_service.dart';

// // ─── Entry point for learners at localhost/#/learner ─────────────────────────
// class LearnerScreen extends StatefulWidget {
//   const LearnerScreen({super.key});

//   @override
//   State<LearnerScreen> createState() => _LearnerScreenState();
// }

// class _LearnerScreenState extends State<LearnerScreen> {
//   final _nameCtrl = TextEditingController();
//   final _phoneCtrl = TextEditingController();
//   bool _entered = false;

//   void _startChat() {
//     final name = _nameCtrl.text.trim();
//     final phone = _phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), '');
//     if (name.isEmpty || phone.length < 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter your name and a valid phone number'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }
//     setState(() => _entered = true);
//   }

//   void _signOut() {
//     setState(() {
//       _entered = false;
//       _nameCtrl.clear();
//       _phoneCtrl.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _entered
//         ? _LearnerChatScreen(
//             name: _nameCtrl.text.trim(),
//             phone: _phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), ''),
//             onSignOut: _signOut,
//           )
//         : _LearnerEntryScreen(
//             nameCtrl: _nameCtrl,
//             phoneCtrl: _phoneCtrl,
//             onStart: _startChat,
//           );
//   }
// }

// // ─── Entry form ───────────────────────────────────────────────────────────────
// class _LearnerEntryScreen extends StatelessWidget {
//   final TextEditingController nameCtrl;
//   final TextEditingController phoneCtrl;
//   final VoidCallback onStart;

//   const _LearnerEntryScreen({
//     required this.nameCtrl,
//     required this.phoneCtrl,
//     required this.onStart,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF075E54),
//       body: SafeArea(
//         child: Column(children: [
//           Expanded(
//             flex: 2,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 90, height: 90,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.2),
//                           blurRadius: 20,
//                           offset: const Offset(0, 8)),
//                     ],
//                   ),
//                   child: const Center(
//                       child: Text('🎓', style: TextStyle(fontSize: 44))),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Andragogy',
//                     style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                         letterSpacing: -1)),
//                 const SizedBox(height: 6),
//                 const Text('Your mobile learning companion',
//                     style: TextStyle(fontSize: 14, color: Colors.white70)),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//               ),
//               padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Get Started',
//                       style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w900,
//                           color: Color(0xFF075E54))),
//                   const SizedBox(height: 6),
//                   const Text('Enter your details to start learning',
//                       style: TextStyle(
//                           fontSize: 13, color: AppColors.textSecondary)),
//                   const SizedBox(height: 28),
//                   TextField(
//                     controller: nameCtrl,
//                     textCapitalization: TextCapitalization.words,
//                     decoration: InputDecoration(
//                       labelText: 'Full Name',
//                       hintText: 'e.g. John Smith',
//                       prefixIcon: const Icon(Icons.person_rounded,
//                           color: Color(0xFF075E54)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14),
//                           borderSide: const BorderSide(
//                               color: Color(0xFF075E54), width: 2)),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: phoneCtrl,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       labelText: 'Phone Number',
//                       hintText: 'e.g. 9876543210',
//                       prefixIcon: const Icon(Icons.phone_rounded,
//                           color: Color(0xFF075E54)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14),
//                           borderSide: const BorderSide(
//                               color: Color(0xFF075E54), width: 2)),
//                     ),
//                   ),
//                   const SizedBox(height: 28),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE8F5E9),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: const Color(0xFF25D366).withValues(alpha: 0.4)),
//                     ),
//                     child: const Row(children: [
//                       Icon(Icons.info_outline_rounded,
//                           color: Color(0xFF075E54), size: 16),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           'The bot will collect your Employee ID, Department & Job Role during registration.',
//                           style: TextStyle(
//                               fontSize: 11, color: Color(0xFF075E54), height: 1.4),
//                         ),
//                       ),
//                     ]),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: onStart,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF25D366),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14)),
//                         elevation: 0,
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.chat_rounded, size: 20),
//                           SizedBox(width: 10),
//                           Text('Start Learning',
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.w800)),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                   Center(
//                     child: Text(
//                       'Powered by WhatsApp Bot Technology',
//                       style: TextStyle(
//                           fontSize: 11, color: Colors.grey.shade400),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ─── Chat screen ──────────────────────────────────────────────────────────────
// class _LearnerChatScreen extends StatefulWidget {
//   final String name;
//   final String phone;
//   final VoidCallback onSignOut;

//   const _LearnerChatScreen({
//     required this.name,
//     required this.phone,
//     required this.onSignOut,
//   });

//   @override
//   State<_LearnerChatScreen> createState() => _LearnerChatScreenState();
// }

// class _LearnerChatScreenState extends State<_LearnerChatScreen> {
//   final _msgCtrl = TextEditingController();
//   final _scrollCtrl = ScrollController();
//   final List<_Msg> _messages = [];
//   bool _sending = false;

//   String _lastCourseTitle = '';
//   int _lastScore = 0;

//   final List<String> _chips = [
//     'START', 'MENU', 'YES', 'NO', 'QUIZ', 'PROGRESS', 'HELP',
//     'A', 'B', 'C', 'D',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) => _send('START'));
//   }

//   @override
//   void dispose() {
//     _msgCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   int? _extractScore(String text) {
//     final re = RegExp(r'Score:\s*\*?(\d+)%\*?');
//     final match = re.firstMatch(text);
//     if (match != null) return int.tryParse(match.group(1)!);
//     return null;
//   }

//   String _extractCourse(String text) {
//     final re = RegExp(r'Quiz:\s*(.+?)\n');
//     final match = re.firstMatch(text);
//     return match?.group(1)?.replaceAll('*', '').trim() ?? _lastCourseTitle;
//   }

//   Future<void> _send(String text) async {
//     final trimmed = text.trim();
//     if (trimmed.isEmpty || _sending) return;

//     setState(() {
//       if (trimmed != 'START' || _messages.isEmpty)
//         _messages.add(_Msg(text: trimmed, isBot: false));
//       _sending = true;
//     });
//     _msgCtrl.clear();
//     _scrollToBottom();

//     final response =
//         await ApiService.sendWhatsAppMessage(widget.phone, trimmed);

//     if (mounted) {
//       final score = _extractScore(response);
//       final course = _extractCourse(response);
//       if (course.isNotEmpty) _lastCourseTitle = course;
//       if (score != null) _lastScore = score;

//       setState(() {
//         _messages.add(_Msg(
//           text: response,
//           isBot: true,
//           showCertificate: score != null && score >= 90,
//           quizScore: score,
//           courseTitle: course.isNotEmpty ? course : _lastCourseTitle,
//         ));
//         _sending = false;
//       });
//       _scrollToBottom();
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(
//           _scrollCtrl.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   void _confirmSignOut() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Sign Out',
//             style: TextStyle(fontWeight: FontWeight.w800)),
//         content: const Text(
//             'Are you sure you want to sign out?\nYour progress is saved.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               widget.onSignOut();
//             },
//             child: const Text('Sign Out',
//                 style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF075E54),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: Row(children: [
//           CircleAvatar(
//             radius: 18,
//             backgroundColor: const Color(0xFF25D366),
//             child: Text(
//               widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?',
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 14),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.name,
//                       style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white)),
//                   const Text('Andragogy Learning Bot',
//                       style: TextStyle(fontSize: 11, color: Colors.white70)),
//                 ]),
//           ),
//         ]),
//         actions: [
//           IconButton(
//             onPressed: _confirmSignOut,
//             icon: const Icon(Icons.logout_rounded, color: Colors.white),
//             tooltip: 'Sign Out',
//           ),
//         ],
//       ),
//       body: Column(children: [
//         // ── Quick chips ──────────────────────────────────────────────
//         Container(
//           color: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 8),
//           child: SizedBox(
//             height: 36,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               itemCount: _chips.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 6),
//               itemBuilder: (_, i) {
//                 final chip = _chips[i];
//                 final isAnswer = ['A', 'B', 'C', 'D'].contains(chip);
//                 return GestureDetector(
//                   onTap: () => _send(chip),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 14, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: chip == 'YES'
//                           ? const Color(0xFFE8F5E9)
//                           : chip == 'NO'
//                               ? const Color(0xFFFFEBEE)
//                               : isAnswer
//                                   ? const Color(0xFFE8EEFF)
//                                   : const Color(0xFFF5F5F5),
//                       border: Border.all(
//                           color: chip == 'YES'
//                               ? const Color(0xFF25D366)
//                               : chip == 'NO'
//                                   ? Colors.red
//                                   : isAnswer
//                                       ? AppColors.primary
//                                       : const Color(0xFF075E54)),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(chip,
//                         style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w700,
//                             color: chip == 'YES'
//                                 ? const Color(0xFF075E54)
//                                 : chip == 'NO'
//                                     ? Colors.red
//                                     : isAnswer
//                                         ? AppColors.primary
//                                         : const Color(0xFF075E54))),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),
//         const Divider(height: 1, color: AppColors.border),

//         // ── Messages ─────────────────────────────────────────────────
//         Expanded(
//           child: Container(
//             color: const Color(0xFFE5DDD5),
//             child: ListView.builder(
//               controller: _scrollCtrl,
//               padding: const EdgeInsets.all(12),
//               itemCount: _messages.length + (_sending ? 1 : 0),
//               itemBuilder: (_, i) {
//                 if (i == _messages.length) return _buildTyping();
//                 return _buildBubble(_messages[i]);
//               },
//             ),
//           ),
//         ),

//         // ── Input bar ────────────────────────────────────────────────
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//           color: const Color(0xFFF0F0F0),
//           child: Row(children: [
//             Expanded(
//               child: TextField(
//                 controller: _msgCtrl,
//                 textInputAction: TextInputAction.send,
//                 onSubmitted: _send,
//                 decoration: InputDecoration(
//                   hintText: 'Type a message...',
//                   fillColor: Colors.white,
//                   filled: true,
//                   contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16, vertical: 10),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(24),
//                       borderSide: BorderSide.none),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(24),
//                       borderSide: BorderSide.none),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 8),
//             GestureDetector(
//               onTap: () => _send(_msgCtrl.text),
//               child: Container(
//                 width: 44, height: 44,
//                 decoration: const BoxDecoration(
//                     color: Color(0xFF25D366), shape: BoxShape.circle),
//                 child: const Icon(Icons.send, color: Colors.white, size: 20),
//               ),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }

//   // ── Bubble builder ────────────────────────────────────────────────────────
//   Widget _buildBubble(_Msg m) {
//     final ytUrls  = m.isBot ? _findYtUrls(m.text) : <String>[];
//     final pdfUrls = m.isBot ? _findPdfUrls(m.text) : <String>[];
//     String cleanText = m.text;
//     if (ytUrls.isNotEmpty)  cleanText = _stripYtUrls(cleanText);
//     if (pdfUrls.isNotEmpty) cleanText = _stripPdfUrls(cleanText);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Align(
//         alignment: m.isBot ? Alignment.centerLeft : Alignment.centerRight,
//         child: Column(
//           crossAxisAlignment: m.isBot
//               ? CrossAxisAlignment.start
//               : CrossAxisAlignment.end,
//           children: [
//             if (cleanText.isNotEmpty)
//               Container(
//                 constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.78),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: m.isBot ? Colors.white : const Color(0xFFD9FDD3),
//                   borderRadius: BorderRadius.only(
//                     topLeft: const Radius.circular(12),
//                     topRight: const Radius.circular(12),
//                     bottomLeft:
//                         m.isBot ? Radius.zero : const Radius.circular(12),
//                     bottomRight:
//                         m.isBot ? const Radius.circular(12) : Radius.zero,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black.withValues(alpha: 0.06),
//                         blurRadius: 4,
//                         offset: const Offset(0, 1)),
//                   ],
//                 ),
//                 child: Text(cleanText,
//                     style: const TextStyle(
//                         fontSize: 13,
//                         height: 1.5,
//                         color: AppColors.textPrimary)),
//               ),

//             ...ytUrls.map((url) => _buildYouTubeCard(url)),
//             ...pdfUrls.map((url) => _buildPdfCard(url)),

//             if (m.showCertificate)
//               _buildCertificateCard(m.courseTitle, m.quizScore ?? 0),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Certificate card ──────────────────────────────────────────────────────
//   Widget _buildCertificateCard(String courseTitle, int score) {
//     return Container(
//       margin: const EdgeInsets.only(top: 8),
//       constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.85),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF1348D4), Color(0xFF4B3FD8)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//               color: const Color(0xFF1348D4).withValues(alpha: 0.4),
//               blurRadius: 12,
//               offset: const Offset(0, 4)),
//         ],
//       ),
//       child: Stack(children: [
//         Positioned(top: -20, right: -20,
//           child: Container(width: 100, height: 100,
//             decoration: BoxDecoration(shape: BoxShape.circle,
//               color: Colors.white.withValues(alpha: 0.08)))),
//         Positioned(bottom: -30, left: -10,
//           child: Container(width: 120, height: 120,
//             decoration: BoxDecoration(shape: BoxShape.circle,
//               color: Colors.white.withValues(alpha: 0.05)))),
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.2),
//                   borderRadius: BorderRadius.circular(20)),
//                 child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                   Icon(Icons.verified_rounded, color: Colors.white, size: 14),
//                   SizedBox(width: 4),
//                   Text('CERTIFICATE OF COMPLETION',
//                       style: TextStyle(color: Colors.white, fontSize: 9,
//                           fontWeight: FontWeight.w800, letterSpacing: 1)),
//                 ])),
//               const SizedBox(height: 16),
//               const Text('🏆', style: TextStyle(fontSize: 48)),
//               const SizedBox(height: 8),
//               const Text('Congratulations!',
//                   style: TextStyle(color: Colors.white, fontSize: 18,
//                       fontWeight: FontWeight.w900, letterSpacing: -0.5)),
//               const SizedBox(height: 4),
//               Text(widget.name,
//                   style: const TextStyle(color: Colors.white70,
//                       fontSize: 14, fontWeight: FontWeight.w600)),
//               const SizedBox(height: 16),
//               Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
//               const SizedBox(height: 16),
//               const Text('has successfully completed',
//                   style: TextStyle(color: Colors.white70, fontSize: 11)),
//               const SizedBox(height: 4),
//               Text(courseTitle.isNotEmpty ? courseTitle : 'the course',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(color: Colors.white, fontSize: 16,
//                       fontWeight: FontWeight.w800, letterSpacing: -0.3)),
//               const SizedBox(height: 16),
//               Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//                 Column(children: [
//                   Text('$score%',
//                       style: const TextStyle(color: Colors.white,
//                           fontSize: 24, fontWeight: FontWeight.w900)),
//                   const Text('Final Score',
//                       style: TextStyle(color: Colors.white70, fontSize: 10)),
//                 ]),
//                 Container(width: 1, height: 40,
//                     color: Colors.white.withValues(alpha: 0.2)),
//                 Column(children: [
//                   Text(_formatDate(),
//                       style: const TextStyle(color: Colors.white,
//                           fontSize: 14, fontWeight: FontWeight.w700)),
//                   const Text('Date Issued',
//                       style: TextStyle(color: Colors.white70, fontSize: 10)),
//                 ]),
//               ]),
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                     color: const Color(0xFF25D366),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                   Icon(Icons.star_rounded, color: Colors.white, size: 14),
//                   SizedBox(width: 4),
//                   Text('Excellence Award',
//                       style: TextStyle(color: Colors.white, fontSize: 11,
//                           fontWeight: FontWeight.w800)),
//                 ])),
//               const SizedBox(height: 8),
//               const Text('Issued by Andragogy Learning Platform',
//                   style: TextStyle(color: Colors.white54, fontSize: 9)),
//               const SizedBox(height: 16),
//               GestureDetector(
//                 onTap: () => CertificateService.downloadCertificate(
//                   learnerName: widget.name,
//                   courseTitle: courseTitle.isNotEmpty ? courseTitle : 'the course',
//                   score: score,
//                   date: _formatDate(),
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 24, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.15),
//                           blurRadius: 8,
//                           offset: const Offset(0, 3)),
//                     ],
//                   ),
//                   child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                     Icon(Icons.download_rounded,
//                         color: Color(0xFF1348D4), size: 18),
//                     SizedBox(width: 8),
//                     Text('Download Certificate (PDF)',
//                         style: TextStyle(color: Color(0xFF1348D4),
//                             fontSize: 13, fontWeight: FontWeight.w800)),
//                   ]),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ]),
//     );
//   }

//   String _formatDate() {
//     final now = DateTime.now();
//     const months = ['Jan','Feb','Mar','Apr','May','Jun',
//                     'Jul','Aug','Sep','Oct','Nov','Dec'];
//     return '${months[now.month - 1]} ${now.day}, ${now.year}';
//   }

//   // ── YouTube helpers ───────────────────────────────────────────────────────
//   List<String> _findYtUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return re.allMatches(text).map((m) => m.group(0)!).toList();
//   }

//   String _stripYtUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return text
//         .replaceAll(re, '')
//         .replaceAll(RegExp(r'\n{3,}'), '\n\n')
//         .trim();
//   }

//   // ── PDF helpers ──────────────────────────────────────────────────────────
//   List<String> _findPdfUrls(String text) {
//     final labelRe = RegExp(
//         '(?:\u{1F4C4}|Read:|PDF:)\\s*(https?://[^\\s]+)',
//         caseSensitive: false,
//         unicode: true);
//     return labelRe.allMatches(text).map((m) => m.group(1)!).toList();
//   }

//   String _stripPdfUrls(String text) {
//     final labelRe = RegExp(
//         '\u{1F4C4} \\*?Read:\\*? https?://[^\\s]+',
//         caseSensitive: false,
//         unicode: true);
//     return text
//         .replaceAll(labelRe, '')
//         .replaceAll(RegExp(r'\n{3,}'), '\n\n')
//         .trim();
//   }

//   // ── PDF card ──────────────────────────────────────────────────────────────
//   Widget _buildPdfCard(String url) {
//     String filename = url.split('/').last.split('?').first;
//     if (filename.isEmpty || !filename.contains('.')) filename = 'Document.pdf';
//     try { filename = Uri.decodeComponent(filename); } catch (_) {}

//     return GestureDetector(
//       onTap: () async {
//         final uri = Uri.parse(url);
//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri, mode: LaunchMode.externalApplication);
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.only(top: 6),
//         constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.78),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.red.shade100),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.06),
//                 blurRadius: 6,
//                 offset: const Offset(0, 2)),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(14),
//           child: Row(children: [
//             Container(
//               width: 44, height: 44,
//               decoration: BoxDecoration(
//                 color: Colors.red.shade50,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Center(
//                   child: Text('📄', style: TextStyle(fontSize: 22))),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     filename.length > 30
//                         ? '${filename.substring(0, 30)}...'
//                         : filename,
//                     style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textPrimary),
//                   ),
//                   const SizedBox(height: 2),
//                   const Text('Tap to open PDF document',
//                       style: TextStyle(
//                           fontSize: 11, color: AppColors.textSecondary)),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                   color: Colors.red.shade600,
//                   borderRadius: BorderRadius.circular(20)),
//               child: const Text('Open',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700)),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }

//   // ── YouTube card ─────────────────────────────────────────────────────────
//   String? _ytVideoId(String url) {
//     final patterns = [
//       RegExp(r'youtu\.be/([^?&\s]+)'),
//       RegExp(r'youtube\.com/watch\?v=([^&\s]+)'),
//       RegExp(r'youtube\.com/shorts/([^?&\s]+)'),
//     ];
//     for (final p in patterns) {
//       final m = p.firstMatch(url);
//       if (m != null) return m.group(1);
//     }
//     return null;
//   }

//   Widget _buildYouTubeCard(String url) {
//     final videoId = _ytVideoId(url);
//     return GestureDetector(
//       onTap: () async {
//         final watchUrl = videoId != null
//             ? 'https://www.youtube.com/watch?v=$videoId'
//             : url;
//         final uri = Uri.parse(watchUrl);
//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri, mode: LaunchMode.externalApplication);
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.only(top: 6),
//         constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.78),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.08),
//                 blurRadius: 6,
//                 offset: const Offset(0, 2)),
//           ],
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Column(children: [
//           Stack(children: [
//             videoId != null
//                 ? Image.network(
//                     'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
//                     width: double.infinity,
//                     height: 130,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => _ytPlaceholder(),
//                   )
//                 : _ytPlaceholder(),
//             Positioned.fill(
//               child: Center(
//                 child: Container(
//                   width: 48, height: 48,
//                   decoration: const BoxDecoration(
//                       color: Colors.red, shape: BoxShape.circle),
//                   child: const Icon(Icons.play_arrow_rounded,
//                       color: Colors.white, size: 28),
//                 ),
//               ),
//             ),
//           ]),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(children: [
//               const Icon(Icons.play_circle_outline_rounded,
//                   color: Colors.red, size: 16),
//               const SizedBox(width: 6),
//               const Expanded(
//                   child: Text('Tap to watch video',
//                       style: TextStyle(
//                           fontSize: 12, fontWeight: FontWeight.w600))),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 8, vertical: 3),
//                 decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: const Text('Watch',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w700)),
//               ),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }

//   Widget _ytPlaceholder() {
//     return Container(
//       width: double.infinity, height: 130,
//       color: const Color(0xFF1A1A1A),
//       child: const Column(
//           mainAxisAlignment: MainAxisAlignment.center, children: [
//         Icon(Icons.play_circle_filled_rounded, color: Colors.red, size: 40),
//         SizedBox(height: 4),
//         Text('YouTube Video',
//             style: TextStyle(color: Colors.white70, fontSize: 11)),
//       ]),
//     );
//   }

//   Widget _buildTyping() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12)),
//         child: Row(mainAxisSize: MainAxisSize.min, children: [
//           _dot(), _dot(), _dot(),
//         ]),
//       ),
//     );
//   }

//   Widget _dot() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 2),
//       width: 7, height: 7,
//       decoration: BoxDecoration(
//         color: AppColors.textSecondary.withValues(alpha: 0.5),
//         shape: BoxShape.circle,
//       ),
//     );
//   }
// }

// // ─── Message model ────────────────────────────────────────────────────────────
// class _Msg {
//   final String text;
//   final bool isBot;
//   final bool showCertificate;
//   final int? quizScore;
//   final String courseTitle;

//   _Msg({
//     required this.text,
//     required this.isBot,
//     this.showCertificate = false,
//     this.quizScore,
//     this.courseTitle = '',
//   });
// }











// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html show AnchorElement, Blob, Url;
// import 'package:url_launcher/url_launcher.dart';
// import '../services/api_service.dart';
// import '../services/app_theme.dart';
// import '../models/models.dart';
// import 'certificate_service.dart';

// // ─── Entry point for learners at localhost/#/learner ─────────────────────────
// class LearnerScreen extends StatefulWidget {
//   const LearnerScreen({super.key});

//   @override
//   State<LearnerScreen> createState() => _LearnerScreenState();
// }

// class _LearnerScreenState extends State<LearnerScreen> {
//   final _nameCtrl  = TextEditingController();
//   final _phoneCtrl = TextEditingController();
//   bool _entered = false;

//   void _startChat() {
//     final name  = _nameCtrl.text.trim();
//     final phone = _phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), '');
//     if (name.isEmpty || phone.length < 10) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter your name and a valid phone number'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }
//     setState(() => _entered = true);
//   }

//   void _signOut() {
//     setState(() {
//       _entered = false;
//       _nameCtrl.clear();
//       _phoneCtrl.clear();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _entered
//         ? _LearnerChatScreen(
//             name:      _nameCtrl.text.trim(),
//             phone:     _phoneCtrl.text.trim().replaceAll(RegExp(r'\D'), ''),
//             onSignOut: _signOut,
//           )
//         : _LearnerEntryScreen(
//             nameCtrl:  _nameCtrl,
//             phoneCtrl: _phoneCtrl,
//             onStart:   _startChat,
//           );
//   }
// }

// // ─── Entry form ───────────────────────────────────────────────────────────────
// class _LearnerEntryScreen extends StatelessWidget {
//   final TextEditingController nameCtrl;
//   final TextEditingController phoneCtrl;
//   final VoidCallback onStart;

//   const _LearnerEntryScreen({
//     required this.nameCtrl,
//     required this.phoneCtrl,
//     required this.onStart,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF075E54),
//       body: SafeArea(
//         child: Column(children: [
//           Expanded(
//             flex: 2,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 90, height: 90,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.2),
//                           blurRadius: 20,
//                           offset: const Offset(0, 8)),
//                     ],
//                   ),
//                   child: const Center(
//                       child: Text('🎓', style: TextStyle(fontSize: 44))),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Andragogy',
//                     style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.w900,
//                         color: Colors.white,
//                         letterSpacing: -1)),
//                 const SizedBox(height: 6),
//                 const Text('Your mobile learning companion',
//                     style: TextStyle(fontSize: 14, color: Colors.white70)),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//               ),
//               padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Get Started',
//                       style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w900,
//                           color: Color(0xFF075E54))),
//                   const SizedBox(height: 6),
//                   const Text('Enter your details to start learning',
//                       style: TextStyle(
//                           fontSize: 13, color: AppColors.textSecondary)),
//                   const SizedBox(height: 28),
//                   TextField(
//                     controller: nameCtrl,
//                     textCapitalization: TextCapitalization.words,
//                     decoration: InputDecoration(
//                       labelText: 'Full Name',
//                       hintText: 'e.g. John Smith',
//                       prefixIcon: const Icon(Icons.person_rounded,
//                           color: Color(0xFF075E54)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14),
//                           borderSide: const BorderSide(
//                               color: Color(0xFF075E54), width: 2)),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextField(
//                     controller: phoneCtrl,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       labelText: 'Phone Number',
//                       hintText: 'e.g. 9876543210',
//                       prefixIcon: const Icon(Icons.phone_rounded,
//                           color: Color(0xFF075E54)),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(14),
//                           borderSide: const BorderSide(
//                               color: Color(0xFF075E54), width: 2)),
//                     ),
//                   ),
//                   const SizedBox(height: 28),
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE8F5E9),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: const Color(0xFF25D366).withValues(alpha: 0.4)),
//                     ),
//                     child: const Row(children: [
//                       Icon(Icons.info_outline_rounded,
//                           color: Color(0xFF075E54), size: 16),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           'The bot will collect your Employee ID, Department & Job Role during registration.',
//                           style: TextStyle(
//                               fontSize: 11,
//                               color: Color(0xFF075E54),
//                               height: 1.4),
//                         ),
//                       ),
//                     ]),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: onStart,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF25D366),
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14)),
//                         elevation: 0,
//                       ),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.chat_rounded, size: 20),
//                           SizedBox(width: 10),
//                           Text('Start Learning',
//                               style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w800)),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const Spacer(),
//                   Center(
//                     child: Text(
//                       'Powered by WhatsApp Bot Technology',
//                       style: TextStyle(
//                           fontSize: 11, color: Colors.grey.shade400),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ─── Chat screen ──────────────────────────────────────────────────────────────
// class _LearnerChatScreen extends StatefulWidget {
//   final String name;
//   final String phone;
//   final VoidCallback onSignOut;

//   const _LearnerChatScreen({
//     required this.name,
//     required this.phone,
//     required this.onSignOut,
//   });

//   @override
//   State<_LearnerChatScreen> createState() => _LearnerChatScreenState();
// }

// class _LearnerChatScreenState extends State<_LearnerChatScreen>
//     with SingleTickerProviderStateMixin {
//   // ── Chat state ──────────────────────────────────────────────────────────
//   final _msgCtrl    = TextEditingController();
//   final _scrollCtrl = ScrollController();
//   final List<_Msg> _messages = [];
//   bool _sending = false;

//   String _lastCourseTitle = '';
//   int    _lastScore       = 0;

//   final List<String> _chips = [
//     'START', 'MENU', 'YES', 'NO', 'QUIZ', 'PROGRESS', 'HELP',
//     'A', 'B', 'C', 'D',
//   ];

//   // ── Progress panel state ────────────────────────────────────────────────
//   bool _showProgress = false;
//   bool _progressLoading = false;
//   LearnerProgress? _myProgress;          // single-learner progress object
//   String _progressSortBy = 'name';
//   late AnimationController _animCtrl;
//   late Animation<double> _anim;

//   @override
//   void initState() {
//     super.initState();
//     _animCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 900));
//     _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
//     WidgetsBinding.instance.addPostFrameCallback((_) => _send('START'));
//   }

//   @override
//   void dispose() {
//     _msgCtrl.dispose();
//     _scrollCtrl.dispose();
//     _animCtrl.dispose();
//     super.dispose();
//   }

//   // ── Progress loader ─────────────────────────────────────────────────────
//   Future<void> _loadMyProgress() async {
//     setState(() => _progressLoading = true);
//     final all = await ApiService.getAllProgress();
//     // Find this learner's record by phone number
//     final match = all.firstWhere(
//       (l) => l.phoneNumber.replaceAll(RegExp(r'\D'), '') == widget.phone,
//       orElse: () => LearnerProgress(
//         name: widget.name,
//         phoneNumber: widget.phone,
//         averageScore: 0,
//         coursesTaken: 0,
//         quizzesTaken: 0,
//         modulesCompleted: 0,
//       ),
//     );
//     setState(() {
//       _myProgress      = match;
//       _progressLoading = false;
//     });
//     _animCtrl.forward(from: 0);
//   }

//   void _toggleProgress() {
//     setState(() => _showProgress = !_showProgress);
//     if (_showProgress && _myProgress == null) _loadMyProgress();
//   }

//   // ── Chat helpers ────────────────────────────────────────────────────────
//   int? _extractScore(String text) {
//     final re    = RegExp(r'Score:\s*\*?(\d+)%\*?');
//     final match = re.firstMatch(text);
//     if (match != null) return int.tryParse(match.group(1)!);
//     return null;
//   }

//   String _extractCourse(String text) {
//     final re    = RegExp(r'Quiz:\s*(.+?)\n');
//     final match = re.firstMatch(text);
//     return match?.group(1)?.replaceAll('*', '').trim() ?? _lastCourseTitle;
//   }

//   Future<void> _send(String text) async {
//     final trimmed = text.trim();
//     if (trimmed.isEmpty || _sending) return;

//     setState(() {
//       if (trimmed != 'START' || _messages.isEmpty)
//         _messages.add(_Msg(text: trimmed, isBot: false));
//       _sending = true;
//     });
//     _msgCtrl.clear();
//     _scrollToBottom();

//     final response =
//         await ApiService.sendWhatsAppMessage(widget.phone, trimmed);

//     if (mounted) {
//       final score  = _extractScore(response);
//       final course = _extractCourse(response);
//       if (course.isNotEmpty) _lastCourseTitle = course;
//       if (score != null) {
//         _lastScore = score;
//         // Refresh progress silently whenever a quiz is completed
//         _loadMyProgress();
//       }

//       setState(() {
//         _messages.add(_Msg(
//           text:            response,
//           isBot:           true,
//           showCertificate: score != null && score >= 90,
//           quizScore:       score,
//           courseTitle:     course.isNotEmpty ? course : _lastCourseTitle,
//         ));
//         _sending = false;
//       });
//       _scrollToBottom();
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 300), () {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(
//           _scrollCtrl.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   void _confirmSignOut() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Sign Out',
//             style: TextStyle(fontWeight: FontWeight.w800)),
//         content: const Text(
//             'Are you sure you want to sign out?\nYour progress is saved.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child:
//                 const Text('Cancel', style: TextStyle(color: Colors.grey)),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               elevation: 0,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               widget.onSignOut();
//             },
//             child: const Text('Sign Out',
//                 style: TextStyle(color: Colors.white)),
//           ),
//         ],
//       ),
//     );
//   }

//   // ────────────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF075E54),
//         foregroundColor: Colors.white,
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         title: Row(children: [
//           CircleAvatar(
//             radius: 18,
//             backgroundColor: const Color(0xFF25D366),
//             child: Text(
//               widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?',
//               style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 14),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.name,
//                       style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.white)),
//                   const Text('Andragogy Learning Bot',
//                       style:
//                           TextStyle(fontSize: 11, color: Colors.white70)),
//                 ]),
//           ),
//         ]),
//         actions: [
//           // ── Progress toggle button ──────────────────────────────────
//           IconButton(
//             onPressed: _toggleProgress,
//             icon: Icon(
//               _showProgress
//                   ? Icons.chat_rounded
//                   : Icons.bar_chart_rounded,
//               color: Colors.white,
//             ),
//             tooltip: _showProgress ? 'Back to chat' : 'My progress',
//           ),
//           IconButton(
//             onPressed: _confirmSignOut,
//             icon: const Icon(Icons.logout_rounded, color: Colors.white),
//             tooltip: 'Sign Out',
//           ),
//         ],
//       ),

//       // ── Body switches between chat and progress panel ───────────────
//       body: _showProgress ? _buildProgressPanel() : _buildChatBody(),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // CHAT BODY (original)
//   // ══════════════════════════════════════════════════════════════════════════
//   Widget _buildChatBody() {
//     return Column(children: [
//       // Quick chips
//       Container(
//         color: Colors.white,
//         padding: const EdgeInsets.symmetric(vertical: 8),
//         child: SizedBox(
//           height: 36,
//           child: ListView.separated(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             itemCount: _chips.length,
//             separatorBuilder: (_, __) => const SizedBox(width: 6),
//             itemBuilder: (_, i) {
//               final chip     = _chips[i];
//               final isAnswer = ['A', 'B', 'C', 'D'].contains(chip);
//               return GestureDetector(
//                 onTap: () => _send(chip),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 14, vertical: 6),
//                   decoration: BoxDecoration(
//                     color: chip == 'YES'
//                         ? const Color(0xFFE8F5E9)
//                         : chip == 'NO'
//                             ? const Color(0xFFFFEBEE)
//                             : isAnswer
//                                 ? const Color(0xFFE8EEFF)
//                                 : const Color(0xFFF5F5F5),
//                     border: Border.all(
//                         color: chip == 'YES'
//                             ? const Color(0xFF25D366)
//                             : chip == 'NO'
//                                 ? Colors.red
//                                 : isAnswer
//                                     ? AppColors.primary
//                                     : const Color(0xFF075E54)),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(chip,
//                       style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w700,
//                           color: chip == 'YES'
//                               ? const Color(0xFF075E54)
//                               : chip == 'NO'
//                                   ? Colors.red
//                                   : isAnswer
//                                       ? AppColors.primary
//                                       : const Color(0xFF075E54))),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//       const Divider(height: 1, color: AppColors.border),

//       // Messages
//       Expanded(
//         child: Container(
//           color: const Color(0xFFE5DDD5),
//           child: ListView.builder(
//             controller: _scrollCtrl,
//             padding: const EdgeInsets.all(12),
//             itemCount: _messages.length + (_sending ? 1 : 0),
//             itemBuilder: (_, i) {
//               if (i == _messages.length) return _buildTyping();
//               return _buildBubble(_messages[i]);
//             },
//           ),
//         ),
//       ),

//       // Input bar
//       Container(
//         padding:
//             const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         color: const Color(0xFFF0F0F0),
//         child: Row(children: [
//           Expanded(
//             child: TextField(
//               controller: _msgCtrl,
//               textInputAction: TextInputAction.send,
//               onSubmitted: _send,
//               decoration: InputDecoration(
//                 hintText: 'Type a message...',
//                 fillColor: Colors.white,
//                 filled: true,
//                 contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16, vertical: 10),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide.none),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(24),
//                     borderSide: BorderSide.none),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           GestureDetector(
//             onTap: () => _send(_msgCtrl.text),
//             child: Container(
//               width: 44, height: 44,
//               decoration: const BoxDecoration(
//                   color: Color(0xFF25D366), shape: BoxShape.circle),
//               child: const Icon(Icons.send,
//                   color: Colors.white, size: 20),
//             ),
//           ),
//         ]),
//       ),
//     ]);
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // PROGRESS PANEL — shows this learner's own stats
//   // ══════════════════════════════════════════════════════════════════════════
//   Widget _buildProgressPanel() {
//     if (_progressLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (_myProgress == null) {
//       return Center(
//         child: Column(mainAxisSize: MainAxisSize.min, children: [
//           const Text('👤', style: TextStyle(fontSize: 48)),
//           const SizedBox(height: 12),
//           const Text('No progress found yet',
//               style: TextStyle(
//                   fontSize: 16, fontWeight: FontWeight.w700)),
//           const SizedBox(height: 6),
//           const Text('Complete a quiz to see your stats here',
//               style: TextStyle(color: AppColors.textSecondary)),
//           const SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: _loadMyProgress,
//             icon: const Icon(Icons.refresh),
//             label: const Text('Refresh'),
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white),
//           ),
//         ]),
//       );
//     }

//     final p = _myProgress!;
//     return AnimatedBuilder(
//       animation: _anim,
//       builder: (_, __) => RefreshIndicator(
//         onRefresh: _loadMyProgress,
//         child: ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             // ── Personal header card ──────────────────────────────────
//             _buildPersonalHeader(p),
//             const SizedBox(height: 20),

//             // ── Summary stat chips ────────────────────────────────────
//             _buildMyStatRow(p),
//             const SizedBox(height: 20),

//             // ── Score ring ────────────────────────────────────────────
//             _sectionTitle('Overall Score'),
//             const SizedBox(height: 12),
//             _buildMyRing(p),
//             const SizedBox(height: 20),

//             // ── Activity bar breakdown ────────────────────────────────
//             _sectionTitle('Activity Breakdown'),
//             const SizedBox(height: 12),
//             _buildMyActivityBars(p),
//             const SizedBox(height: 20),

//             // ── Score grade badge ─────────────────────────────────────
//             _buildScoreGrade(p),
//             const SizedBox(height: 16),

//             // ── Refresh button ────────────────────────────────────────
//             OutlinedButton.icon(
//               onPressed: _loadMyProgress,
//               icon: const Icon(Icons.refresh, size: 16),
//               label: const Text('Refresh progress'),
//               style: OutlinedButton.styleFrom(
//                   foregroundColor: AppColors.primary),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPersonalHeader(LearnerProgress p) {
//     final scoreColor = _scoreColor(p.averageScore);
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border:
//             const Border.fromBorderSide(BorderSide(color: AppColors.border)),
//       ),
//       child: Row(children: [
//         CircleAvatar(
//           radius: 28,
//           backgroundColor: AppColors.primaryLight,
//           child: Text(
//             p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
//             style: const TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w900,
//                 color: AppColors.primary),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//             Text(p.name,
//                 style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w800,
//                     color: AppColors.textPrimary)),
//             const SizedBox(height: 2),
//             Row(children: [
//               const Icon(Icons.phone,
//                   size: 12, color: AppColors.textSecondary),
//               const SizedBox(width: 4),
//               Text(p.phoneNumber,
//                   style: const TextStyle(
//                       fontSize: 12, color: AppColors.textSecondary)),
//             ]),
//             if (p.department != null || p.jobRole != null) ...[
//               const SizedBox(height: 2),
//               Text(
//                 [p.jobRole, p.department]
//                     .where((s) => s != null && s!.isNotEmpty)
//                     .join(' · '),
//                 style: const TextStyle(
//                     fontSize: 11, color: AppColors.textSecondary),
//               ),
//             ],
//           ]),
//         ),
//         Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//           Text('${p.averageScore}%',
//               style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.w900,
//                   color: scoreColor)),
//           Container(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//             decoration: BoxDecoration(
//                 color: scoreColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10)),
//             child: Text(_scoreLabel(p.averageScore),
//                 style: TextStyle(
//                     fontSize: 10,
//                     fontWeight: FontWeight.w700,
//                     color: scoreColor)),
//           ),
//         ]),
//       ]),
//     );
//   }

//   Widget _buildMyStatRow(LearnerProgress p) {
//     return Row(children: [
//       Expanded(
//           child: _MiniStat(
//               value: '${p.coursesTaken}',
//               label: 'Courses\nTaken',
//               color: AppColors.primary,
//               icon: Icons.menu_book)),
//       const SizedBox(width: 8),
//       Expanded(
//           child: _MiniStat(
//               value: '${p.quizzesTaken}',
//               label: 'Quizzes\nTaken',
//               color: AppColors.amber,
//               icon: Icons.quiz)),
//       const SizedBox(width: 8),
//       Expanded(
//           child: _MiniStat(
//               value: '${p.modulesCompleted}',
//               label: 'Modules\nDone',
//               color: AppColors.green,
//               icon: Icons.check_circle)),
//     ]);
//   }

//   Widget _buildMyRing(LearnerProgress p) {
//     final color = _scoreColor(p.averageScore);
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: const Border.fromBorderSide(
//               BorderSide(color: AppColors.border))),
//       child: Row(children: [
//         SizedBox(
//           width: 120, height: 120,
//           child: CustomPaint(
//             painter: _RingPainter(
//               value:    p.averageScore / 100.0,
//               progress: _anim.value,
//               color:    color,
//               bgColor:  AppColors.border,
//             ),
//             child: Center(
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 Text('${p.averageScore}%',
//                     style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w900,
//                         color: color)),
//                 const Text('avg',
//                     style: TextStyle(
//                         fontSize: 11,
//                         color: AppColors.textSecondary)),
//               ]),
//             ),
//           ),
//         ),
//         const SizedBox(width: 24),
//         Expanded(
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//             _legendDot(AppColors.green,   'Excellent  (80–100%)'),
//             const SizedBox(height: 8),
//             _legendDot(AppColors.primary, 'Good       (60–79%)'),
//             const SizedBox(height: 8),
//             _legendDot(AppColors.amber,   'Average    (40–59%)'),
//             const SizedBox(height: 8),
//             _legendDot(AppColors.orange,  'Needs work (<40%)'),
//             const SizedBox(height: 14),
//             Text(
//               p.averageScore >= 80
//                   ? '🎉 Outstanding performance!'
//                   : p.averageScore >= 60
//                       ? '👍 On track — keep going!'
//                       : '📚 More practice needed',
//               style: const TextStyle(
//                   fontSize: 12,
//                   color: AppColors.textSecondary,
//                   fontStyle: FontStyle.italic),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }

//   Widget _buildMyActivityBars(LearnerProgress p) {
//     final items = [
//       _ActivityBar('Courses',  p.coursesTaken,      AppColors.primary,  Icons.menu_book),
//       _ActivityBar('Quizzes',  p.quizzesTaken,      AppColors.amber,    Icons.quiz),
//       _ActivityBar('Modules',  p.modulesCompleted,  AppColors.green,    Icons.check_circle),
//     ];
//     final maxVal = items.map((i) => i.value).reduce((a, b) => a > b ? a : b);

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: const Border.fromBorderSide(
//               BorderSide(color: AppColors.border))),
//       child: Column(
//         children: items.map((item) {
//           final frac =
//               maxVal > 0 ? (item.value / maxVal) * _anim.value : 0.0;
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 14),
//             child: Row(children: [
//               Icon(item.icon, size: 18, color: item.color),
//               const SizedBox(width: 10),
//               SizedBox(
//                 width: 62,
//                 child: Text(item.label,
//                     style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary)),
//               ),
//               Expanded(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(4),
//                   child: LinearProgressIndicator(
//                     value:           frac,
//                     minHeight:       10,
//                     backgroundColor: AppColors.primaryLight,
//                     valueColor:
//                         AlwaysStoppedAnimation<Color>(item.color),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               SizedBox(
//                 width: 24,
//                 child: Text('${item.value}',
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: item.color)),
//               ),
//             ]),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   Widget _buildScoreGrade(LearnerProgress p) {
//     final color = _scoreColor(p.averageScore);
//     final label = _scoreLabel(p.averageScore);
//     final emoji = p.averageScore >= 80
//         ? '🏆'
//         : p.averageScore >= 60
//             ? '⭐'
//             : p.averageScore >= 40
//                 ? '📘'
//                 : '💪';
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Text(emoji, style: const TextStyle(fontSize: 32)),
//         const SizedBox(width: 16),
//         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text(label,
//               style: TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w900,
//                   color: color)),
//           Text('Current grade based on avg score',
//               style: const TextStyle(
//                   fontSize: 11, color: AppColors.textSecondary)),
//         ]),
//       ]),
//     );
//   }

//   // ── Shared section helpers ──────────────────────────────────────────────
//   Color _scoreColor(int score) => score >= 80
//       ? AppColors.green
//       : score >= 60
//           ? AppColors.primary
//           : AppColors.orange;

//   String _scoreLabel(int score) => score >= 80
//       ? 'Excellent'
//       : score >= 60
//           ? 'Good'
//           : score >= 40
//               ? 'Average'
//               : 'Needs work';

//   Widget _sectionTitle(String t) => Text(t,
//       style: const TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w800,
//           color: AppColors.textPrimary,
//           letterSpacing: -0.3));

//   Widget _legendDot(Color color, String label) => Row(children: [
//         Container(
//             width: 10,
//             height: 10,
//             decoration:
//                 BoxDecoration(color: color, shape: BoxShape.circle)),
//         const SizedBox(width: 8),
//         Text(label,
//             style: const TextStyle(
//                 fontSize: 12, color: AppColors.textSecondary)),
//       ]);

//   // ══════════════════════════════════════════════════════════════════════════
//   // BUBBLE BUILDER  (original, unchanged)
//   // ══════════════════════════════════════════════════════════════════════════
//   Widget _buildBubble(_Msg m) {
//     final ytUrls  = m.isBot ? _findYtUrls(m.text) : <String>[];
//     final pdfUrls = m.isBot ? _findPdfUrls(m.text) : <String>[];
//     String cleanText = m.text;
//     if (ytUrls.isNotEmpty)  cleanText = _stripYtUrls(cleanText);
//     if (pdfUrls.isNotEmpty) cleanText = _stripPdfUrls(cleanText);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Align(
//         alignment: m.isBot ? Alignment.centerLeft : Alignment.centerRight,
//         child: Column(
//           crossAxisAlignment: m.isBot
//               ? CrossAxisAlignment.start
//               : CrossAxisAlignment.end,
//           children: [
//             if (cleanText.isNotEmpty)
//               Container(
//                 constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.78),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: m.isBot
//                       ? Colors.white
//                       : const Color(0xFFD9FDD3),
//                   borderRadius: BorderRadius.only(
//                     topLeft:     const Radius.circular(12),
//                     topRight:    const Radius.circular(12),
//                     bottomLeft:
//                         m.isBot ? Radius.zero : const Radius.circular(12),
//                     bottomRight:
//                         m.isBot ? const Radius.circular(12) : Radius.zero,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                         color: Colors.black.withValues(alpha: 0.06),
//                         blurRadius: 4,
//                         offset: const Offset(0, 1)),
//                   ],
//                 ),
//                 child: Text(cleanText,
//                     style: const TextStyle(
//                         fontSize: 13,
//                         height: 1.5,
//                         color: AppColors.textPrimary)),
//               ),
//             ...ytUrls.map((url)  => _buildYouTubeCard(url)),
//             ...pdfUrls.map((url) => _buildPdfCard(url)),
//             if (m.showCertificate)
//               _buildCertificateCard(m.courseTitle, m.quizScore ?? 0),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Certificate card (original) ─────────────────────────────────────────
//   Widget _buildCertificateCard(String courseTitle, int score) {
//     return Container(
//       margin: const EdgeInsets.only(top: 8),
//       constraints: BoxConstraints(
//           maxWidth: MediaQuery.of(context).size.width * 0.85),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFF1348D4), Color(0xFF4B3FD8)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//               color: const Color(0xFF1348D4).withValues(alpha: 0.4),
//               blurRadius: 12,
//               offset: const Offset(0, 4)),
//         ],
//       ),
//       child: Stack(children: [
//         Positioned(top: -20, right: -20,
//           child: Container(width: 100, height: 100,
//               decoration: BoxDecoration(shape: BoxShape.circle,
//                   color: Colors.white.withValues(alpha: 0.08)))),
//         Positioned(bottom: -30, left: -10,
//           child: Container(width: 120, height: 120,
//               decoration: BoxDecoration(shape: BoxShape.circle,
//                   color: Colors.white.withValues(alpha: 0.05)))),
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 12, vertical: 4),
//                 decoration: BoxDecoration(
//                     color: Colors.white.withValues(alpha: 0.2),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                   Icon(Icons.verified_rounded,
//                       color: Colors.white, size: 14),
//                   SizedBox(width: 4),
//                   Text('CERTIFICATE OF COMPLETION',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 9,
//                           fontWeight: FontWeight.w800,
//                           letterSpacing: 1)),
//                 ])),
//               const SizedBox(height: 16),
//               const Text('🏆', style: TextStyle(fontSize: 48)),
//               const SizedBox(height: 8),
//               const Text('Congratulations!',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.w900,
//                       letterSpacing: -0.5)),
//               const SizedBox(height: 4),
//               Text(widget.name,
//                   style: const TextStyle(
//                       color: Colors.white70,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600)),
//               const SizedBox(height: 16),
//               Container(
//                   height: 1,
//                   color: Colors.white.withValues(alpha: 0.2)),
//               const SizedBox(height: 16),
//               const Text('has successfully completed',
//                   style:
//                       TextStyle(color: Colors.white70, fontSize: 11)),
//               const SizedBox(height: 4),
//               Text(
//                   courseTitle.isNotEmpty ? courseTitle : 'the course',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w800,
//                       letterSpacing: -0.3)),
//               const SizedBox(height: 16),
//               Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                 Column(children: [
//                   Text('$score%',
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 24,
//                           fontWeight: FontWeight.w900)),
//                   const Text('Final Score',
//                       style: TextStyle(
//                           color: Colors.white70, fontSize: 10)),
//                 ]),
//                 Container(
//                     width: 1,
//                     height: 40,
//                     color: Colors.white.withValues(alpha: 0.2)),
//                 Column(children: [
//                   Text(_formatDate(),
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700)),
//                   const Text('Date Issued',
//                       style: TextStyle(
//                           color: Colors.white70, fontSize: 10)),
//                 ]),
//               ]),
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                     color: const Color(0xFF25D366),
//                     borderRadius: BorderRadius.circular(20)),
//                 child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                   Icon(Icons.star_rounded,
//                       color: Colors.white, size: 14),
//                   SizedBox(width: 4),
//                   Text('Excellence Award',
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 11,
//                           fontWeight: FontWeight.w800)),
//                 ])),
//               const SizedBox(height: 8),
//               const Text('Issued by Andragogy Learning Platform',
//                   style:
//                       TextStyle(color: Colors.white54, fontSize: 9)),
//               const SizedBox(height: 16),
//               GestureDetector(
//                 onTap: () => CertificateService.downloadCertificate(
//                   learnerName: widget.name,
//                   courseTitle: courseTitle.isNotEmpty
//                       ? courseTitle
//                       : 'the course',
//                   score: score,
//                   date:  _formatDate(),
//                 ),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 24, vertical: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.15),
//                           blurRadius: 8,
//                           offset: const Offset(0, 3)),
//                     ],
//                   ),
//                   child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                     Icon(Icons.download_rounded,
//                         color: Color(0xFF1348D4), size: 18),
//                     SizedBox(width: 8),
//                     Text('Download Certificate (PDF)',
//                         style: TextStyle(
//                             color: Color(0xFF1348D4),
//                             fontSize: 13,
//                             fontWeight: FontWeight.w800)),
//                   ]),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ]),
//     );
//   }

//   String _formatDate() {
//     final now = DateTime.now();
//     const months = [
//       'Jan','Feb','Mar','Apr','May','Jun',
//       'Jul','Aug','Sep','Oct','Nov','Dec'
//     ];
//     return '${months[now.month - 1]} ${now.day}, ${now.year}';
//   }

//   // ── URL helpers (original) ───────────────────────────────────────────────
//   List<String> _findYtUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return re.allMatches(text).map((m) => m.group(0)!).toList();
//   }

//   String _stripYtUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return text
//         .replaceAll(re, '')
//         .replaceAll(RegExp(r'\n{3,}'), '\n\n')
//         .trim();
//   }

//   List<String> _findPdfUrls(String text) {
//     final labelRe = RegExp(
//         '(?:\u{1F4C4}|Read:|PDF:)\\s*(https?://[^\\s]+)',
//         caseSensitive: false,
//         unicode: true);
//     return labelRe.allMatches(text).map((m) => m.group(1)!).toList();
//   }

//   String _stripPdfUrls(String text) {
//     final labelRe = RegExp(
//         '\u{1F4C4} \\*?Read:\\*? https?://[^\\s]+',
//         caseSensitive: false,
//         unicode: true);
//     return text
//         .replaceAll(labelRe, '')
//         .replaceAll(RegExp(r'\n{3,}'), '\n\n')
//         .trim();
//   }

//   // ── PDF card (original) ──────────────────────────────────────────────────
//   Widget _buildPdfCard(String url) {
//     String filename =
//         url.split('/').last.split('?').first;
//     if (filename.isEmpty || !filename.contains('.'))
//       filename = 'Document.pdf';
//     try {
//       filename = Uri.decodeComponent(filename);
//     } catch (_) {}

//     return GestureDetector(
//       onTap: () async {
//         final uri = Uri.parse(url);
//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri, mode: LaunchMode.externalApplication);
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.only(top: 6),
//         constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.78),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.red.shade100),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.06),
//                 blurRadius: 6,
//                 offset: const Offset(0, 2)),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(14),
//           child: Row(children: [
//             Container(
//               width: 44, height: 44,
//               decoration: BoxDecoration(
//                   color: Colors.red.shade50,
//                   borderRadius: BorderRadius.circular(10)),
//               child: const Center(
//                   child: Text('📄', style: TextStyle(fontSize: 22))),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Text(
//                   filename.length > 30
//                       ? '${filename.substring(0, 30)}...'
//                       : filename,
//                   style: const TextStyle(
//                       fontSize: 13,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.textPrimary),
//                 ),
//                 const SizedBox(height: 2),
//                 const Text('Tap to open PDF document',
//                     style: TextStyle(
//                         fontSize: 11,
//                         color: AppColors.textSecondary)),
//               ]),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                   color: Colors.red.shade600,
//                   borderRadius: BorderRadius.circular(20)),
//               child: const Text('Open',
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 11,
//                       fontWeight: FontWeight.w700)),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }

//   // ── YouTube card (original) ──────────────────────────────────────────────
//   String? _ytVideoId(String url) {
//     final patterns = [
//       RegExp(r'youtu\.be/([^?&\s]+)'),
//       RegExp(r'youtube\.com/watch\?v=([^&\s]+)'),
//       RegExp(r'youtube\.com/shorts/([^?&\s]+)'),
//     ];
//     for (final p in patterns) {
//       final m = p.firstMatch(url);
//       if (m != null) return m.group(1);
//     }
//     return null;
//   }

//   Widget _buildYouTubeCard(String url) {
//     final videoId = _ytVideoId(url);
//     return GestureDetector(
//       onTap: () async {
//         final watchUrl = videoId != null
//             ? 'https://www.youtube.com/watch?v=$videoId'
//             : url;
//         final uri = Uri.parse(watchUrl);
//         if (await canLaunchUrl(uri)) {
//           await launchUrl(uri, mode: LaunchMode.externalApplication);
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.only(top: 6),
//         constraints: BoxConstraints(
//             maxWidth: MediaQuery.of(context).size.width * 0.78),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withValues(alpha: 0.08),
//                 blurRadius: 6,
//                 offset: const Offset(0, 2)),
//           ],
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Column(children: [
//           Stack(children: [
//             videoId != null
//                 ? Image.network(
//                     'https://img.youtube.com/vi/$videoId/hqdefault.jpg',
//                     width: double.infinity,
//                     height: 130,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => _ytPlaceholder(),
//                   )
//                 : _ytPlaceholder(),
//             Positioned.fill(
//               child: Center(
//                 child: Container(
//                   width: 48, height: 48,
//                   decoration: const BoxDecoration(
//                       color: Colors.red, shape: BoxShape.circle),
//                   child: const Icon(Icons.play_arrow_rounded,
//                       color: Colors.white, size: 28),
//                 ),
//               ),
//             ),
//           ]),
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Row(children: [
//               const Icon(Icons.play_circle_outline_rounded,
//                   color: Colors.red, size: 16),
//               const SizedBox(width: 6),
//               const Expanded(
//                   child: Text('Tap to watch video',
//                       style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.w600))),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 8, vertical: 3),
//                 decoration: BoxDecoration(
//                     color: Colors.red,
//                     borderRadius: BorderRadius.circular(20)),
//                 child: const Text('Watch',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 10,
//                         fontWeight: FontWeight.w700)),
//               ),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }

//   Widget _ytPlaceholder() => Container(
//         width: double.infinity, height: 130,
//         color: const Color(0xFF1A1A1A),
//         child: const Column(
//             mainAxisAlignment: MainAxisAlignment.center, children: [
//           Icon(Icons.play_circle_filled_rounded,
//               color: Colors.red, size: 40),
//           SizedBox(height: 4),
//           Text('YouTube Video',
//               style: TextStyle(color: Colors.white70, fontSize: 11)),
//         ]),
//       );

//   Widget _buildTyping() => Align(
//         alignment: Alignment.centerLeft,
//         child: Container(
//           margin: const EdgeInsets.only(bottom: 8),
//           padding: const EdgeInsets.symmetric(
//               horizontal: 14, vertical: 12),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12)),
//           child: Row(mainAxisSize: MainAxisSize.min, children: [
//             _dot(), _dot(), _dot(),
//           ]),
//         ),
//       );

//   Widget _dot() => Container(
//         margin: const EdgeInsets.symmetric(horizontal: 2),
//         width: 7, height: 7,
//         decoration: BoxDecoration(
//           color: AppColors.textSecondary.withValues(alpha: 0.5),
//           shape: BoxShape.circle,
//         ),
//       );
// }

// // ─── Message model ────────────────────────────────────────────────────────────
// class _Msg {
//   final String text;
//   final bool   isBot;
//   final bool   showCertificate;
//   final int?   quizScore;
//   final String courseTitle;

//   _Msg({
//     required this.text,
//     required this.isBot,
//     this.showCertificate = false,
//     this.quizScore,
//     this.courseTitle = '',
//   });
// }

// // ─── Activity bar model ───────────────────────────────────────────────────────
// class _ActivityBar {
//   final String  label;
//   final int     value;
//   final Color   color;
//   final IconData icon;
//   const _ActivityBar(this.label, this.value, this.color, this.icon);
// }

// // ─── Shared widgets (used by progress panel) ──────────────────────────────────
// class _MiniStat extends StatelessWidget {
//   final String   value, label;
//   final Color    color;
//   final IconData icon;

//   const _MiniStat({
//     required this.value,
//     required this.label,
//     required this.color,
//     required this.icon,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: const Border.fromBorderSide(
//               BorderSide(color: AppColors.border))),
//       child: Column(children: [
//         Icon(icon, color: color, size: 20),
//         const SizedBox(height: 6),
//         Text(value,
//             style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w800,
//                 color: color)),
//         const SizedBox(height: 2),
//         Text(label,
//             style: const TextStyle(
//                 fontSize: 9,
//                 color: AppColors.textSecondary,
//                 fontWeight: FontWeight.w600),
//             textAlign: TextAlign.center),
//       ]),
//     );
//   }
// }

// // ─── Ring painter ─────────────────────────────────────────────────────────────
// class _RingPainter extends CustomPainter {
//   final double value, progress;
//   final Color  color, bgColor;

//   const _RingPainter({
//     required this.value,
//     required this.progress,
//     required this.color,
//     required this.bgColor,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx     = size.width / 2;
//     final cy     = size.height / 2;
//     final r      = min(cx, cy) - 10;
//     const stroke = 12.0;

//     canvas.drawCircle(
//         Offset(cx, cy),
//         r,
//         Paint()
//           ..style       = PaintingStyle.stroke
//           ..strokeWidth = stroke
//           ..color       = bgColor.withOpacity(0.3));

//     final sweep = 2 * pi * value * progress;
//     canvas.drawArc(
//         Rect.fromCircle(center: Offset(cx, cy), radius: r),
//         -pi / 2, sweep, false,
//         Paint()
//           ..style       = PaintingStyle.stroke
//           ..strokeWidth = stroke
//           ..strokeCap   = StrokeCap.round
//           ..color       = color);
//   }

//   @override
//   bool shouldRepaint(_RingPainter old) =>
//       old.value != value || old.progress != progress;
// }



































import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show AnchorElement, Blob, Url;
import '../services/api_service.dart';
import '../services/app_theme.dart';
import '../models/models.dart';

const _blue   = AppColors.primary;
const _green  = AppColors.green;
const _orange = AppColors.orange;
const _amber  = AppColors.amber;
const _bg     = AppColors.bg;
const _border = AppColors.border;
const _text   = AppColors.textPrimary;
const _sub    = AppColors.textSecondary;
const _pLight = AppColors.primaryLight;

// ═══════════════════════════════════════════════════════════════
// MAIN SCREEN
// ═══════════════════════════════════════════════════════════════
class LearnersScreen extends StatefulWidget {
  final List<LearnerProgress> learners;
  final VoidCallback? onRefresh;
  const LearnersScreen({super.key, this.learners = const [], this.onRefresh});
  @override
  State<LearnersScreen> createState() => _LearnersScreenState();
}

class _LearnersScreenState extends State<LearnersScreen>
    with TickerProviderStateMixin {
  List<LearnerProgress> _learners = [];
  List<Course> _courses = [];
  bool _loading = false;
  late TabController _tabs;
  String _search = '';
  String _sortBy = 'name';
  late AnimationController _animCtrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(() => setState(() {}));
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _learners = List.from(widget.learners);
    _load();
  }

  @override
  void dispose() { _tabs.dispose(); _animCtrl.dispose(); super.dispose(); }

  @override
  void didUpdateWidget(LearnersScreen old) {
    super.didUpdateWidget(old);
    if (widget.learners != old.learners) {
      setState(() => _learners = List.from(widget.learners));
      _animCtrl.forward(from: 0);
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final results = await Future.wait([
        ApiService.getAllProgress(),
        ApiService.getCourses(),
      ]);
      setState(() {
        _learners = results[0] as List<LearnerProgress>;
        _courses  = results[1] as List<Course>;
      });
    } catch (_) {}
    setState(() => _loading = false);
    _animCtrl.forward(from: 0);
  }

  // ── Computed stats ─────────────────────────────────────────
  int get _avgScore => _learners.isEmpty ? 0
      : _learners.fold(0, (int s, l) => s + l.averageScore) ~/ _learners.length;
  int get _totalQuizzes  => _learners.fold(0, (int s, l) => s + l.quizzesTaken);
  int get _totalModules  => _learners.fold(0, (int s, l) => s + l.modulesCompleted);

  List<LearnerProgress> get _filtered {
    var list = List<LearnerProgress>.from(_learners);
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((l) =>
        l.name.toLowerCase().contains(q) ||
        l.phoneNumber.contains(q) ||
        (l.department ?? '').toLowerCase().contains(q) ||
        (l.jobRole ?? '').toLowerCase().contains(q)).toList();
    }
    switch (_sortBy) {
      case 'score':   list.sort((a, b) => b.averageScore.compareTo(a.averageScore)); break;
      case 'courses': list.sort((a, b) => b.coursesTaken.compareTo(a.coursesTaken)); break;
      default:        list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  void _exportCSV() {
    final rows = ['Name,Phone,Department,Job Role,Courses,Quizzes,Modules,Avg Score (%)'];
    for (final l in _filtered) {
      rows.add(['"${l.name}"','"${l.phoneNumber}"',
        '"${l.department ?? '-'}"','"${l.jobRole ?? '-'}"',
        '${l.coursesTaken}','${l.quizzesTaken}',
        '${l.modulesCompleted}','${l.averageScore}'].join(','));
    }
    if (kIsWeb) {
      final blob = html.Blob([rows.join('\n')], 'text/csv');
      final url  = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', 'learner_report.csv')..click();
      html.Url.revokeObjectUrl(url);
      if (mounted) _snack('✅ CSV downloaded!', _green);
    }
  }

  void _snack(String msg, Color c) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: c,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(12)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        title: const Text('Learners',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text)),
        actions: [
          if (_tabs.index == 1)
            IconButton(icon: const Icon(Icons.download_rounded, color: _blue), onPressed: _exportCSV),
          IconButton(icon: const Icon(Icons.refresh, color: _blue), onPressed: _load),
        ],
        bottom: TabBar(
          controller: _tabs,
          labelColor: _blue,
          unselectedLabelColor: _sub,
          indicatorColor: _blue,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          tabs: [
            Tab(text: '📊 Progress (${_learners.length})'),
            const Tab(text: '📋 Report'),
            const Tab(text: '📣 Broadcast'),
          ])),
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: _blue))
        : TabBarView(controller: _tabs, children: [
            _buildProgressTab(),
            _buildReportTab(),
            _BroadcastTab(learners: _learners, courses: _courses),
          ]));
  }

  // ═══════════════════════════════════════════════════════════
  // TAB 1 — PROGRESS + CHARTS
  // ═══════════════════════════════════════════════════════════
  Widget _buildProgressTab() {
    return RefreshIndicator(onRefresh: _load,
      child: AnimatedBuilder(animation: _anim,
        builder: (_, __) => ListView(padding: const EdgeInsets.all(16), children: [
          // Summary
          Row(children: [
            Expanded(child: _MiniStatCard('${_learners.length}', 'Learners',  _blue,  Icons.people)),
            const SizedBox(width: 8),
            Expanded(child: _MiniStatCard('$_avgScore%',         'Avg Score', _green, Icons.star)),
            const SizedBox(width: 8),
            Expanded(child: _MiniStatCard('$_totalQuizzes',      'Quizzes',   _amber, Icons.quiz)),
            const SizedBox(width: 8),
            Expanded(child: _MiniStatCard('$_totalModules',      'Modules',   _orange,Icons.check_circle)),
          ]),
          const SizedBox(height: 20),

          if (_learners.isNotEmpty) ...[
            _secTitle('Score Distribution'),
            const SizedBox(height: 12),
            _buildRingChart(),
            const SizedBox(height: 20),
            _secTitle('Quizzes per Learner'),
            const SizedBox(height: 12),
            _buildQuizBars(),
            const SizedBox(height: 20),
          ],

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _secTitle('All Learners'),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: _pLight, borderRadius: BorderRadius.circular(20)),
              child: Text('${_learners.length} total',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _blue))),
          ]),
          const SizedBox(height: 12),

          if (_learners.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(40),
              child: Column(children: [
                Text('👥', style: TextStyle(fontSize: 48)),
                SizedBox(height: 12),
                Text('No learners yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text('Learners join by sending START via WhatsApp',
                  textAlign: TextAlign.center, style: TextStyle(color: _sub)),
              ])))
          else
            ..._learners.map((l) => GestureDetector(
              onTap: () => _showProfile(l),
              child: _LearnerCard(l))),
        ])));
  }

  // ═══════════════════════════════════════════════════════════
  // TAB 2 — REPORT TABLE
  // ═══════════════════════════════════════════════════════════
  Widget _buildReportTab() {
    final fl  = _filtered;
    final avg = fl.isEmpty ? 0.0
      : fl.fold(0, (int s, l) => s + l.averageScore) / fl.length;

    return Column(children: [
      // Banner
      Container(color: _blue, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          _BannerStat('Learners', '${fl.length}',                                      Icons.people_rounded),
          _BannerStat('Avg',      '${avg.toStringAsFixed(1)}%',                        Icons.bar_chart_rounded),
          _BannerStat('Quizzes',  '${fl.fold(0,(int s,l) => s + l.quizzesTaken)}',     Icons.quiz_rounded),
          _BannerStat('Modules',  '${fl.fold(0,(int s,l) => s + l.modulesCompleted)}', Icons.check_circle_rounded),
        ])),

      // Search + sort
      Container(color: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          Expanded(child: TextField(
            decoration: InputDecoration(
              hintText: 'Search name, phone, dept...',
              hintStyle: const TextStyle(fontSize: 12),
              prefixIcon: const Icon(Icons.search, size: 18), isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _border))),
            onChanged: (v) => setState(() => _search = v))),
          const SizedBox(width: 10),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sortBy, isDense: true,
              style: const TextStyle(fontSize: 12, color: _text),
              items: const [
                DropdownMenuItem(value: 'name',   child: Text('Name ↑')),
                DropdownMenuItem(value: 'score',  child: Text('Score ↓')),
                DropdownMenuItem(value: 'courses',child: Text('Courses ↓')),
              ],
              onChanged: (v) => setState(() => _sortBy = v ?? 'name'))),
        ])),
      const Divider(height: 1, color: _border),

      // Table header
      Container(color: const Color(0xFFF8F9FA),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const Row(children: [
          Expanded(flex: 3, child: Text('Learner',   style: _tH)),
          Expanded(flex: 2, child: Text('Dept/Role', style: _tH)),
          SizedBox(width: 44, child: Text('Crs', textAlign: TextAlign.center, style: _tH)),
          SizedBox(width: 44, child: Text('Qz',  textAlign: TextAlign.center, style: _tH)),
          SizedBox(width: 58, child: Text('Score', textAlign: TextAlign.right, style: _tH)),
        ])),
      const Divider(height: 1, color: _border),

      Expanded(child: fl.isEmpty
        ? Center(child: Text(_search.isNotEmpty ? 'No results for "$_search"' : 'No data yet',
            style: const TextStyle(color: _sub)))
        : ListView.separated(
            itemCount: fl.length,
            separatorBuilder: (_, __) => const Divider(height: 1, color: _border),
            itemBuilder: (_, i) {
              final l = fl[i];
              final sc = l.averageScore >= 80 ? _green
                : l.averageScore >= 60 ? _blue
                : l.averageScore >= 40 ? _orange : Colors.red;
              return InkWell(
                onTap: () => _showProfile(l),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  child: Row(children: [
                    Expanded(flex: 3, child: Row(children: [
                      CircleAvatar(backgroundColor: _pLight, radius: 16,
                        child: Text(l.name.isNotEmpty ? l.name[0].toUpperCase() : '?',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _blue))),
                      const SizedBox(width: 10),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(l.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _text)),
                        Text(l.phoneNumber, style: const TextStyle(fontSize: 10, color: _sub)),
                      ])),
                    ])),
                    Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l.department ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11, color: _text)),
                      Text(l.jobRole ?? '-', maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10, color: _sub)),
                    ])),
                    SizedBox(width: 44, child: Text('${l.coursesTaken}', textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _text))),
                    SizedBox(width: 44, child: Text('${l.quizzesTaken}', textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _text))),
                    SizedBox(width: 58, child: Text('${l.averageScore}%', textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: sc))),
                  ])));
            })),

      // Export footer
      Container(color: Colors.white, padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: SizedBox(width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: _green, foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            icon: const Icon(Icons.download_rounded),
            label: Text('Export ${fl.length} learners as CSV',
              style: const TextStyle(fontWeight: FontWeight.w700)),
            onPressed: fl.isEmpty ? null : _exportCSV))),
    ]);
  }

  // ── Profile bottom sheet ───────────────────────────────────
  void _showProfile(LearnerProgress l) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.88, maxChildSize: 0.97, minChildSize: 0.5,
        expand: false,
        builder: (_, ctrl) => _ProfileSheet(learner: l, ctrl: ctrl)));
  }

  // ── Chart helpers ──────────────────────────────────────────
  Widget _secTitle(String t) => Text(t,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _text));

  Widget _buildRingChart() {
    final s = _avgScore;
    final c = s >= 80 ? _green : s >= 60 ? _blue : _orange;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: const Border.fromBorderSide(BorderSide(color: _border))),
      child: Row(children: [
        SizedBox(width: 120, height: 120,
          child: CustomPaint(
            painter: _RingPainter(value: s/100, progress: _anim.value, color: c, bg: _border),
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('$s%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: c)),
              const Text('avg', style: TextStyle(fontSize: 11, color: _sub)),
            ])))),
        const SizedBox(width: 20),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _dot(_green,  '80%+  Excellent (${_learners.where((l) => l.averageScore >= 80).length})'),
          const SizedBox(height: 8),
          _dot(_blue,   '60–79% Good (${_learners.where((l) => l.averageScore >= 60 && l.averageScore < 80).length})'),
          const SizedBox(height: 8),
          _dot(_amber,  '40–59% Average (${_learners.where((l) => l.averageScore >= 40 && l.averageScore < 60).length})'),
          const SizedBox(height: 8),
          _dot(_orange, 'Below 40% (${_learners.where((l) => l.averageScore < 40).length})'),
          const SizedBox(height: 12),
          Text(s >= 80 ? '🎉 Great cohort!' : s >= 60 ? '👍 On track' : '📚 Needs attention',
            style: const TextStyle(fontSize: 12, color: _sub, fontStyle: FontStyle.italic)),
        ])),
      ]));
  }

  Widget _dot(Color c, String label) => Row(children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
    const SizedBox(width: 8),
    Expanded(child: Text(label, style: const TextStyle(fontSize: 11, color: _sub))),
  ]);

  Widget _buildQuizBars() {
    if (_learners.isEmpty) return const SizedBox.shrink();
    final maxQ = _learners.map((l) => l.quizzesTaken).reduce((a, b) => a > b ? a : b);
    if (maxQ == 0) return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: const Border.fromBorderSide(BorderSide(color: _border))),
      child: const Center(child: Text('No quizzes taken yet', style: TextStyle(color: _sub))));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: const Border.fromBorderSide(BorderSide(color: _border))),
      child: Column(children: _learners.take(8).map((l) {
        final frac = maxQ > 0 ? (l.quizzesTaken / maxQ) * _anim.value : 0.0;
        return Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
          CircleAvatar(backgroundColor: _pLight, radius: 14,
            child: Text(l.name.isNotEmpty ? l.name[0].toUpperCase() : 'L',
              style: const TextStyle(color: _blue, fontWeight: FontWeight.w800, fontSize: 11))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(l.name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _text)),
              Text('${l.quizzesTaken}', style: const TextStyle(fontSize: 10, color: _sub)),
            ]),
            const SizedBox(height: 4),
            ClipRRect(borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: frac, minHeight: 6,
                backgroundColor: _pLight,
                valueColor: const AlwaysStoppedAnimation<Color>(_blue))),
          ])),
        ]));
      }).toList()));
  }
}

// ═══════════════════════════════════════════════════════════════
// LEARNER PROFILE SHEET
// ═══════════════════════════════════════════════════════════════
class _ProfileSheet extends StatelessWidget {
  final LearnerProgress learner;
  final ScrollController ctrl;
  const _ProfileSheet({required this.learner, required this.ctrl});

  Color get _sc => learner.averageScore >= 80 ? _green
    : learner.averageScore >= 60 ? _blue : _orange;

  @override
  Widget build(BuildContext context) {
    return ListView(controller: ctrl, padding: const EdgeInsets.all(20), children: [
      Center(child: Container(width: 40, height: 4,
        decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2)))),
      const SizedBox(height: 16),

      // Header
      Row(children: [
        CircleAvatar(radius: 30, backgroundColor: _pLight,
          child: Text(learner.name.isNotEmpty ? learner.name[0].toUpperCase() : '?',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _blue))),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(learner.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text)),
          Text(learner.phoneNumber, style: const TextStyle(fontSize: 13, color: _sub)),
          if ((learner.jobRole ?? '').isNotEmpty)
            Text('${learner.jobRole} · ${learner.department ?? ''}',
              style: const TextStyle(fontSize: 12, color: _sub)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text('${learner.averageScore}%',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: _sc)),
          const Text('avg score', style: TextStyle(fontSize: 10, color: _sub)),
        ]),
      ]),
      const SizedBox(height: 10),
      ClipRRect(borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(value: learner.averageScore / 100, minHeight: 8,
          backgroundColor: _border, valueColor: AlwaysStoppedAnimation<Color>(_sc))),
      const SizedBox(height: 20),

      // 4 stat boxes
      Row(children: [
        _PStat('Courses',  '${learner.coursesTaken}',    Icons.menu_book,    _blue),
        const SizedBox(width: 8),
        _PStat('Quizzes',  '${learner.quizzesTaken}',    Icons.quiz,         _amber),
        const SizedBox(width: 8),
        _PStat('Modules',  '${learner.modulesCompleted}',Icons.check_circle, _green),
        const SizedBox(width: 8),
        _PStat('Score',    '${learner.averageScore}%',   Icons.star,         _orange),
      ]),
      const SizedBox(height: 20),

      // Profile info
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFF4F6FB),
          borderRadius: BorderRadius.circular(14)),
        child: Column(children: [
          _IR('Employee ID', learner.employeeId ?? '—'),
          _IR('Department',  learner.department ?? '—'),
          _IR('Job Role',    learner.jobRole ?? '—'),
          _IR('Phone',       learner.phoneNumber),
        ])),
      const SizedBox(height: 20),

      // Performance card
      Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: learner.averageScore >= 80
              ? [const Color(0xFF00875A), const Color(0xFF00A36C)]
              : learner.averageScore >= 60
                ? [const Color(0xFF1348D4), const Color(0xFF4B3FD8)]
                : [const Color(0xFFFF5630), const Color(0xFFFF7A50)],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Text(learner.averageScore >= 80 ? '🏆' : learner.averageScore >= 60 ? '👍' : '📚',
            style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(learner.averageScore >= 80 ? 'Outstanding Performance!'
              : learner.averageScore >= 60 ? 'Good Progress'
              : 'Needs Attention',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(learner.averageScore >= 80
              ? 'This learner is excelling across all assessments.'
              : learner.averageScore >= 60
                ? 'Performing well. Encourage to push for excellence.'
                : 'Consider reaching out and providing extra support.',
              style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.4)),
          ])),
        ])),
      const SizedBox(height: 24),
    ]);
  }

  Widget _IR(String label, String val) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(children: [
      SizedBox(width: 110, child: Text(label, style: const TextStyle(fontSize: 12, color: _sub))),
      Expanded(child: Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _text))),
    ]));

  Widget _PStat(String label, String val, IconData icon, Color color) =>
    Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: const Border.fromBorderSide(BorderSide(color: _border))),
      child: Column(children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(val, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        Text(label, style: const TextStyle(fontSize: 9, color: _sub), textAlign: TextAlign.center),
      ])));
}

// ═══════════════════════════════════════════════════════════════
// BROADCAST TAB
// ═══════════════════════════════════════════════════════════════
class _BroadcastTab extends StatefulWidget {
  final List<LearnerProgress> learners;
  final List<Course> courses;
  const _BroadcastTab({required this.learners, required this.courses});
  @override
  State<_BroadcastTab> createState() => _BroadcastTabState();
}

class _BroadcastTabState extends State<_BroadcastTab> {
  final _msgCtrl = TextEditingController();
  String _filter  = 'all';
  String? _courseId;
  bool _sending   = false;
  List<dynamic> _logs = [];

  final _filterOptions = const [
    {'v':'all',       'l':'👥 All Learners',      'd':'Send to everyone'},
    {'v':'enrolled',  'l':'📚 Course Enrolled',    'd':'Only enrolled in a specific course'},
    {'v':'inactive',  'l':'😴 Inactive (7+ days)', 'd':'No activity in 7+ days'},
    {'v':'low_score', 'l':'📉 Low Score (<60%)',   'd':'Needs extra support'},
  ];

  final _templates = const {
    '📢 Quiz reminder':    '📢 *Reminder:* Your quiz deadline is approaching!\n\nType *QUIZ* to complete your assessment now.\n\n_Andragogy Learning Platform_',
    '🎉 New module':       '🎉 *New Content Available!*\n\nA new module has been added to your course.\n\nType *NEXT* to access it now.\n\n_Andragogy Learning Platform_',
    '⏰ Course ending':    '⏰ *Course Ending Soon!*\n\nYour course ends in 3 days. Complete all modules.\n\nType *PROGRESS* to check your status.\n\n_Andragogy Learning Platform_',
    '📊 Check progress':   '📊 *Check Your Progress!*\n\nType *PROGRESS* to view your scores and completed modules.\n\n_Andragogy Learning Platform_',
  };

  @override
  void initState() { super.initState(); _loadLogs(); }
  @override
  void dispose() { _msgCtrl.dispose(); super.dispose(); }

  Future<void> _loadLogs() async {
    try {
      final r = await ApiService.get('/broadcast/logs');
      if (mounted) setState(() => _logs = r['data'] ?? []);
    } catch (_) {}
  }

  int get _recipientCount {
    if (_filter == 'all') return widget.learners.length;
    if (_filter == 'low_score') return widget.learners.where((l) => l.averageScore < 60).length;
    return widget.learners.length;
  }

  Future<void> _send() async {
    if (_msgCtrl.text.trim().isEmpty) { _snack('Type a message first', _orange); return; }
    if (_filter == 'enrolled' && (_courseId == null || _courseId!.isEmpty)) {
      _snack('Please select a course', _orange); return;
    }
    setState(() => _sending = true);
    try {
      final r = await ApiService.post('/broadcast', {
        'message': _msgCtrl.text.trim(), 'filter': _filter, 'course_id': _courseId ?? '',
      });
      if (mounted) {
        _snack('✅ Broadcast sent to ${r['recipients']} learner(s)!', _green);
        _msgCtrl.clear();
        _loadLogs();
      }
    } catch (e) {
      if (mounted) _snack('Error: $e', _orange);
    }
    if (mounted) setState(() => _sending = false);
  }

  void _snack(String msg, Color c) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: c,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(12)));

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      // ── Compose ────────────────────────────────────────────
      Container(padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
          border: const Border.fromBorderSide(BorderSide(color: _border))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Row(children: [
            Icon(Icons.campaign_rounded, color: _blue, size: 22),
            SizedBox(width: 8),
            Text('Broadcast Message',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _text)),
          ]),
          const SizedBox(height: 4),
          const Text('Send one message to all or filtered learners instantly.',
            style: TextStyle(fontSize: 12, color: _sub)),
          const SizedBox(height: 16),

          // Filter chips
          const Text('Send to:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _text)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8,
            children: _filterOptions.map((f) {
              final sel = _filter == f['v'];
              return GestureDetector(
                onTap: () => setState(() { _filter = f['v']!; _courseId = null; }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFFE8EEFF) : const Color(0xFFF4F6FB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sel ? _blue : _border)),
                  child: Text(f['l']!,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                      color: sel ? _blue : _text))));
            }).toList()),
          const SizedBox(height: 12),

          // Course selector (only for enrolled)
          if (_filter == 'enrolled') ...[
            DropdownButtonFormField<String>(
              value: _courseId,
              hint: const Text('Select a course'),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _border)),
                isDense: true, contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                filled: true, fillColor: Colors.white),
              items: widget.courses.map((c) =>
                DropdownMenuItem(value: c.id, child: Text(c.title, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (v) => setState(() => _courseId = v)),
            const SizedBox(height: 12),
          ],

          // Recipient badge
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFE8EEFF), borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.people_outline, color: _blue, size: 18),
              const SizedBox(width: 8),
              Text('$_recipientCount learner(s) will receive this message',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _blue)),
            ])),
          const SizedBox(height: 14),

          // Message box
          TextField(controller: _msgCtrl, maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Type your broadcast message...\n\ne.g. "📢 Quiz deadline is tomorrow! Type QUIZ now."',
              hintStyle: const TextStyle(fontSize: 12, color: _sub),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _border)),
              filled: true, fillColor: const Color(0xFFF4F6FB),
              contentPadding: const EdgeInsets.all(14))),
          const SizedBox(height: 12),

          // Templates
          const Text('Quick Templates:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _sub)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 6,
            children: _templates.entries.map((e) => GestureDetector(
              onTap: () => setState(() => _msgCtrl.text = e.value),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFF4F6FB),
                  borderRadius: BorderRadius.circular(20),
                  border: const Border.fromBorderSide(BorderSide(color: _border))),
                child: Text(e.key, style: const TextStyle(fontSize: 11, color: _text))))).toList()),
          const SizedBox(height: 16),

          // Send button
          SizedBox(width: double.infinity, height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: _blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: _sending ? null : _send,
              icon: _sending
                ? const SizedBox(width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.send_rounded, color: Colors.white),
              label: Text(_sending ? 'Sending...' : 'Send Broadcast to $_recipientCount Learners',
                style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)))),
        ])),

      // ── Broadcast logs ─────────────────────────────────────
      if (_logs.isNotEmpty) ...[
        const SizedBox(height: 20),
        const Text('Recent Broadcasts',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _text)),
        const SizedBox(height: 10),
        ..._logs.take(5).map((log) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
            border: const Border.fromBorderSide(BorderSide(color: _border))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 8, height: 8,
                decoration: const BoxDecoration(color: _green, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text('Sent to ${log['recipients']} learners',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _text)),
              const Spacer(),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFE8EEFF), borderRadius: BorderRadius.circular(10)),
                child: Text(log['filter'] ?? 'all',
                  style: const TextStyle(fontSize: 10, color: _blue, fontWeight: FontWeight.w700))),
            ]),
            const SizedBox(height: 6),
            Text(log['message'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, color: _sub)),
          ]))),
      ],
    ]);
  }
}

// ── Shared small widgets ───────────────────────────────────────
class _LearnerCard extends StatelessWidget {
  final LearnerProgress l;
  const _LearnerCard(this.l);
  Color get _sc => l.averageScore >= 80 ? _green : l.averageScore >= 60 ? _amber : _orange;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: const Border.fromBorderSide(BorderSide(color: _border))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(backgroundColor: _pLight, radius: 22,
            child: Text(l.name.isNotEmpty ? l.name[0].toUpperCase() : 'L',
              style: const TextStyle(color: _blue, fontWeight: FontWeight.w800, fontSize: 16))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _text)),
            Text(l.phoneNumber, style: const TextStyle(fontSize: 11, color: _sub)),
            if ((l.jobRole ?? '').isNotEmpty || (l.department ?? '').isNotEmpty)
              Text('${l.jobRole ?? ''} · ${l.department ?? ''}',
                style: const TextStyle(fontSize: 10, color: _sub)),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${l.averageScore}%',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _sc)),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: _sc.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Text(l.averageScore >= 80 ? 'Excellent' : l.averageScore >= 60 ? 'Good' : 'Needs work',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _sc))),
          ]),
        ]),
        const SizedBox(height: 10),
        ClipRRect(borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: l.averageScore / 100, minHeight: 5,
            backgroundColor: _pLight, valueColor: AlwaysStoppedAnimation<Color>(_sc))),
        const SizedBox(height: 8),
        Row(children: [
          _Chip(Icons.menu_book,    '${l.coursesTaken} courses',  _blue),
          const SizedBox(width: 6),
          _Chip(Icons.quiz,         '${l.quizzesTaken} quizzes',  _amber),
          const SizedBox(width: 6),
          _Chip(Icons.check_circle, '${l.modulesCompleted} mods', _green),
          const Spacer(),
          const Text('Tap for profile', style: TextStyle(fontSize: 10, color: _sub)),
          const Icon(Icons.chevron_right, size: 14, color: _sub),
        ]),
      ]));
  }
}

Widget _Chip(IconData icon, String label, Color color) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
  decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
  child: Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 11, color: color), const SizedBox(width: 3),
    Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w700)),
  ]));

Widget _MiniStatCard(String value, String label, Color color, IconData icon) =>
  Container(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
      border: const Border.fromBorderSide(BorderSide(color: _border))),
    child: Column(children: [
      Icon(icon, color: color, size: 18), const SizedBox(height: 4),
      Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
      Text(label, textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 9, color: _sub, fontWeight: FontWeight.w600)),
    ]));

Widget _BannerStat(String label, String value, IconData icon) =>
  Expanded(child: Row(children: [
    Icon(icon, color: Colors.white60, size: 15), const SizedBox(width: 5),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800)),
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 9)),
    ]),
  ]));

const _tH = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _sub);

// ── Ring painter ───────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double value, progress; final Color color, bg;
  const _RingPainter({required this.value, required this.progress, required this.color, required this.bg});
  @override
  void paint(Canvas canvas, Size size) {
    final cx=size.width/2, cy=size.height/2, r=min(cx,cy)-10;
    canvas.drawCircle(Offset(cx,cy), r,
      Paint()..style=PaintingStyle.stroke..strokeWidth=12..color=bg.withOpacity(0.3));
    canvas.drawArc(Rect.fromCircle(center:Offset(cx,cy),radius:r),
      -pi/2, 2*pi*value*progress, false,
      Paint()..style=PaintingStyle.stroke..strokeWidth=12..strokeCap=StrokeCap.round..color=color);
  }
  @override bool shouldRepaint(_RingPainter o) => o.value!=value||o.progress!=progress;
}