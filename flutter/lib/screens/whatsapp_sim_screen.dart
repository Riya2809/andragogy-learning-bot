
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../services/api_service.dart';
// import '../services/app_theme.dart';
// import 'polls_provider.dart';
// import 'certificate_service.dart';

// // ─── Message model ────────────────────────────────────────────────────────────
// class _Msg {
//   final String text;
//   final bool isBot;
//   final bool isSystem;
//   final bool isError;
//   final Poll? poll;
//   final bool showCertificate;
//   final int? quizScore;
//   final String courseTitle;

//   _Msg({
//     required this.text,
//     required this.isBot,
//     this.isSystem = false,
//     this.isError = false,
//     this.poll,
//     this.showCertificate = false,
//     this.quizScore,
//     this.courseTitle = '',
//   });
// }

// // ─── YouTube URL helper ───────────────────────────────────────────────────────
// class _YT {
//   /// Extract video ID from any YouTube URL format
//   static String? videoId(String url) {
//     final patterns = [
//       RegExp(r'youtu\.be/([^?&\s]+)'),
//       RegExp(r'youtube\.com/watch\?v=([^&\s]+)'),
//       RegExp(r'youtube\.com/embed/([^?&\s]+)'),
//       RegExp(r'youtube\.com/shorts/([^?&\s]+)'),
//     ];
//     for (final p in patterns) {
//       final m = p.firstMatch(url);
//       if (m != null) return m.group(1);
//     }
//     return null;
//   }

//   static String thumbnail(String videoId) =>
//       'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

//   static String watchUrl(String videoId) =>
//       'https://www.youtube.com/watch?v=$videoId';

//   /// Find ALL youtube URLs in a block of text
//   static List<String> findUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return re.allMatches(text).map((m) => m.group(0)!).toList();
//   }

//   /// Remove youtube URLs from text so we don't duplicate them
//   static String stripUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return text.replaceAll(re, '').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
//   }
// }

// // ─── Screen ───────────────────────────────────────────────────────────────────
// class WhatsAppSimScreen extends StatefulWidget {
//   const WhatsAppSimScreen({super.key});

//   @override
//   State<WhatsAppSimScreen> createState() => _WhatsAppSimScreenState();
// }

// class _WhatsAppSimScreenState extends State<WhatsAppSimScreen> {
//   final _phoneCtrl = TextEditingController(text: '9876543210');
//   final _msgCtrl = TextEditingController();
//   final _scrollCtrl = ScrollController();
//   final List<_Msg> _messages = [];
//   bool _sending = false;
//   int _pollIndex = 0;

//   final _provider = PollsProvider.instance;

//   final List<String> _chips = [
//     'START', 'MENU', 'HELP', 'QUIZ', 'NEXT', 'PROGRESS',
//     'POLL', 'A', 'B', 'C', 'D',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _provider.addListener(_onProviderUpdate);
//     _messages.add(_Msg(
//       text: '📱 WhatsApp Simulation Terminal\n\n'
//           'Test your chatbot here. Enter a phone number and send a message.\n\n'
//           'Try sending: START\n'
//           'YouTube links in modules will show as playable cards! 🎥',
//       isBot: true,
//       isSystem: true,
//     ));
//   }

//   @override
//   void dispose() {
//     _provider.removeListener(_onProviderUpdate);
//     _phoneCtrl.dispose();
//     _msgCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   void _onProviderUpdate() => setState(() {});

//   void _sendPoll() {
//     final polls = _provider.polls;
//     final poll = polls[_pollIndex % polls.length];
//     _pollIndex++;
//     setState(() {
//       _messages.add(_Msg(text: 'POLL', isBot: false));
//       _messages.add(_Msg(text: '', isBot: true, poll: poll));
//     });
//     _scrollToBottom();
//   }

//   void _vote(Poll poll, int index) {
//     if (poll.votedIndex != null) return;
//     _provider.vote(poll, index);
//     setState(() {
//       _messages.add(_Msg(
//           text: '✅ Voted: ${poll.options[index].label}', isBot: false));
//       _messages.add(_Msg(
//           text: 'Thanks for voting! 🎉 Your response has been recorded.',
//           isBot: true));
//     });
//     _scrollToBottom();
//   }

//   Future<void> _send(String text) async {
//     final trimmed = text.trim();
//     if (trimmed.isEmpty || _sending) return;

//     if (trimmed.toUpperCase() == 'POLL') {
//       _msgCtrl.clear();
//       _sendPoll();
//       return;
//     }

//     final phone = _phoneCtrl.text.trim();
//     if (phone.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Enter a phone number first')));
//       return;
//     }

//     setState(() {
//       _messages.add(_Msg(text: trimmed, isBot: false));
//       _sending = true;
//     });
//     _msgCtrl.clear();
//     _scrollToBottom();

//     final response = await ApiService.sendWhatsAppMessage(phone, trimmed);

//     if (mounted) {
//       // Detect quiz score for certificate
//       final scoreMatch = RegExp(r'Score:\s*\*?(\d+)%\*?').firstMatch(response);
//       final score = scoreMatch != null ? int.tryParse(scoreMatch.group(1)!) : null;
//       final courseMatch = RegExp(r'Quiz:\s*(.+?)\n').firstMatch(response);
//       final course = courseMatch?.group(1)?.replaceAll('*', '').trim() ?? '';

//       setState(() {
//         _messages.add(_Msg(
//             text: response,
//             isBot: true,
//             isError: response.startsWith('❌'),
//             showCertificate: score != null && score >= 90,
//             quizScore: score,
//             courseTitle: course));
//         _sending = false;
//       });
//       _scrollToBottom();
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: AppColors.whatsappDark,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         title: Row(children: [
//           Container(
//             width: 36, height: 36,
//             decoration: BoxDecoration(
//                 color: AppColors.whatsapp,
//                 borderRadius: BorderRadius.circular(18)),
//             child: const Center(
//                 child: Text('AI',
//                     style: TextStyle(color: Colors.white,
//                         fontWeight: FontWeight.w800, fontSize: 13))),
//           ),
//           const SizedBox(width: 10),
//           const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text('WhatsApp Bot Simulator',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
//                     color: Colors.white)),
//             Text('⚡ NLP Engine Active',
//                 style: TextStyle(fontSize: 10, color: Colors.white70)),
//           ]),
//         ]),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete_outline, color: Colors.white),
//             onPressed: () => setState(() {
//               _messages.clear();
//               _pollIndex = 0;
//             }),
//             tooltip: 'Clear chat',
//           ),
//         ],
//       ),
//       body: Column(children: [
//         // ── Phone input ──────────────────────────────────────────────────
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           color: Colors.white,
//           child: Row(children: [
//             const Icon(Icons.phone, size: 18, color: AppColors.textSecondary),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextField(
//                 controller: _phoneCtrl,
//                 keyboardType: TextInputType.phone,
//                 style: const TextStyle(fontSize: 13),
//                 decoration: const InputDecoration(
//                   hintText: 'Learner phone number (digits only)',
//                   hintStyle: TextStyle(fontSize: 12),
//                   isDense: true,
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8))),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8)),
//                       borderSide: BorderSide(color: AppColors.border)),
//                 ),
//               ),
//             ),
//           ]),
//         ),
//         const Divider(height: 1, color: AppColors.border),

//         // ── Quick chips ──────────────────────────────────────────────────
//         Padding(
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
//                 final isPoll = chip == 'POLL';
//                 return GestureDetector(
//                   onTap: () => _send(chip),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: isPoll
//                           ? const Color(0xFFE8F5E9)
//                           : isAnswer
//                               ? AppColors.primaryLight
//                               : Colors.white,
//                       border: Border.all(
//                           color: isPoll
//                               ? AppColors.green
//                               : isAnswer
//                                   ? AppColors.primary
//                                   : AppColors.border),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Text(chip,
//                         style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w700,
//                             color: isPoll
//                                 ? AppColors.green
//                                 : isAnswer
//                                     ? AppColors.primary
//                                     : AppColors.textPrimary)),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),

//         // ── Messages ─────────────────────────────────────────────────────
//         Expanded(
//           child: Container(
//             color: const Color(0xFFE5DDD5),
//             child: ListView.builder(
//               controller: _scrollCtrl,
//               padding: const EdgeInsets.all(12),
//               itemCount: _messages.length + (_sending ? 1 : 0),
//               itemBuilder: (_, i) {
//                 if (i == _messages.length) return _buildTyping();
//                 final msg = _messages[i];
//                 if (msg.poll != null) return _buildPollBubble(msg.poll!);
//                 return _buildBubble(msg);
//               },
//             ),
//           ),
//         ),

//         // ── Input bar ────────────────────────────────────────────────────
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
//                     color: AppColors.whatsapp, shape: BoxShape.circle),
//                 child: const Icon(Icons.send, color: Colors.white, size: 20),
//               ),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }

//   // ── Main bubble builder — detects YouTube links ───────────────────────────
//   Widget _buildBubble(_Msg m) {
//     // Only parse bot messages for YouTube links
//     final ytUrls = m.isBot && !m.isSystem && !m.isError
//         ? _YT.findUrls(m.text)
//         : <String>[];

//     final cleanText = ytUrls.isNotEmpty ? _YT.stripUrls(m.text) : m.text;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Align(
//         alignment: m.isBot ? Alignment.centerLeft : Alignment.centerRight,
//         child: Column(
//           crossAxisAlignment:
//               m.isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//           children: [
//             // Text bubble
//             if (cleanText.isNotEmpty)
//               Container(
//                 constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.78),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: m.isError
//                       ? AppColors.orangeLight
//                       : m.isSystem
//                           ? AppColors.primaryLight
//                           : m.isBot
//                               ? Colors.white
//                               : const Color(0xFFD9FDD3),
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
//                         offset: const Offset(0, 1))
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(cleanText,
//                         style: TextStyle(
//                             fontSize: 13,
//                             height: 1.5,
//                             color: m.isError
//                                 ? AppColors.orange
//                                 : AppColors.textPrimary)),
//                     const SizedBox(height: 2),
//                     Text(m.isBot ? '⚡ Bot' : '👤 Learner',
//                         style: const TextStyle(
//                             fontSize: 9,
//                             color: AppColors.textSecondary,
//                             fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//               ),

//             // ── YouTube video cards ──────────────────────────────────
//             ...ytUrls.map((url) => _buildYouTubeCard(url)),

//             // ── Certificate card (score >= 90) ───────────────────────
//             if (m.showCertificate)
//               _buildCertificateCard(m.courseTitle, m.quizScore ?? 0),
//           ],
//         ),
//       ),
//     );
//   }

//   // ── Certificate card ──────────────────────────────────────────────────────
//   Widget _buildCertificateCard(String courseTitle, int score) {
//     // Get learner name from phone field
//     final phone = _phoneCtrl.text.trim();
//     final learnerName = 'Learner ($phone)';

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
//         // Background circles
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
//               // Header badge
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
//               Text(learnerName,
//                   style: const TextStyle(color: Colors.white70, fontSize: 13,
//                       fontWeight: FontWeight.w600)),

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

//               // Score + date
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

//               // Footer
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                     color: AppColors.green,
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

//               // Download PDF button
//               GestureDetector(
//                 onTap: () => CertificateService.downloadCertificate(
//                   learnerName: learnerName,
//                   courseTitle: courseTitle.isNotEmpty ? courseTitle : 'the course',
//                    companyName: 'Acme',  
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
//                     Icon(Icons.download_rounded, color: Color(0xFF1348D4), size: 18),
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

//   // ── YouTube card widget ───────────────────────────────────────────────────
//   Widget _buildYouTubeCard(String url) {
//     final videoId = _YT.videoId(url);

//     return GestureDetector(
//       onTap: () async {
//         final uri = Uri.parse(videoId != null ? _YT.watchUrl(videoId) : url);
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
//                 offset: const Offset(0, 2))
//           ],
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           // Thumbnail
//           Stack(children: [
//             // Thumbnail image
//             videoId != null
//                 ? Image.network(
//                     _YT.thumbnail(videoId),
//                     width: double.infinity,
//                     height: 140,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => _ytPlaceholder(),
//                   )
//                 : _ytPlaceholder(),

//             // Play button overlay
//             Positioned.fill(
//               child: Center(
//                 child: Container(
//                   width: 52, height: 52,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.3),
//                           blurRadius: 8)
//                     ],
//                   ),
//                   child: const Icon(Icons.play_arrow_rounded,
//                       color: Colors.white, size: 32),
//                 ),
//               ),
//             ),

//             // YouTube badge
//             Positioned(
//               bottom: 8, right: 8,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 6, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: const Row(children: [
//                   Icon(Icons.play_circle_filled,
//                       color: Colors.white, size: 12),
//                   SizedBox(width: 4),
//                   Text('YouTube',
//                       style: TextStyle(color: Colors.white,
//                           fontSize: 10, fontWeight: FontWeight.w700)),
//                 ]),
//               ),
//             ),
//           ]),

//           // Bottom bar
//           Container(
//             padding: const EdgeInsets.symmetric(
//                 horizontal: 12, vertical: 10),
//             child: Row(children: [
//               const Icon(Icons.play_circle_outline_rounded,
//                   color: Colors.red, size: 18),
//               const SizedBox(width: 8),
//               const Expanded(
//                 child: Text('Tap to watch video',
//                     style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary)),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text('Watch',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 11,
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
//       width: double.infinity, height: 140,
//       color: const Color(0xFF1A1A1A),
//       child: const Column(
//           mainAxisAlignment: MainAxisAlignment.center, children: [
//         Icon(Icons.play_circle_filled_rounded,
//             color: Colors.red, size: 48),
//         SizedBox(height: 6),
//         Text('YouTube Video',
//             style: TextStyle(color: Colors.white70,
//                 fontSize: 12, fontWeight: FontWeight.w600)),
//       ]),
//     );
//   }

//   // ── Poll bubble ───────────────────────────────────────────────────────────
//   Widget _buildPollBubble(Poll poll) {
//     final hasVoted = poll.votedIndex != null;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Container(
//           constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.85),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(12),
//               topRight: Radius.circular(12),
//               bottomRight: Radius.circular(12),
//             ),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.06),
//                   blurRadius: 4,
//                   offset: const Offset(0, 1))
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 8),
//                 color: const Color(0xFF075E54),
//                 child: Row(children: [
//                   const Icon(Icons.bar_chart_rounded,
//                       color: Colors.white, size: 16),
//                   const SizedBox(width: 6),
//                   const Text('POLL',
//                       style: TextStyle(color: Colors.white,
//                           fontSize: 11, fontWeight: FontWeight.w800,
//                           letterSpacing: 1)),
//                   const Spacer(),
//                   if (hasVoted)
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8, vertical: 2),
//                       decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.2),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: const Text('Voted ✓',
//                           style: TextStyle(color: Colors.white,
//                               fontSize: 9, fontWeight: FontWeight.w700)),
//                     ),
//                 ]),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
//                 child: Text(poll.question,
//                     style: const TextStyle(fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textPrimary, height: 1.3)),
//               ),
//               const SizedBox(height: 8),
//               ...List.generate(poll.options.length, (i) {
//                 final pct = poll.percent(i);
//                 final pctInt = (pct * 100).round();
//                 final isVoted = poll.votedIndex == i;
//                 final isLeading = hasVoted && i == poll.leadingIndex;
//                 return GestureDetector(
//                   onTap: hasVoted ? null : () => _vote(poll, i),
//                   child: Container(
//                     margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
//                     decoration: BoxDecoration(
//                       color: isVoted
//                           ? const Color(0xFFE8F5E9)
//                           : hasVoted
//                               ? const Color(0xFFF5F5F5)
//                               : const Color(0xFFEEF1FB),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: isVoted
//                               ? AppColors.green
//                               : hasVoted
//                                   ? AppColors.border
//                                   : AppColors.primary.withValues(alpha: 0.3)),
//                     ),
//                     child: Stack(children: [
//                       if (hasVoted)
//                         FractionallySizedBox(
//                           widthFactor: pct,
//                           child: Container(
//                             height: 44,
//                             decoration: BoxDecoration(
//                               color: isVoted
//                                   ? AppColors.green.withValues(alpha: 0.15)
//                                   : Colors.grey.withValues(alpha: 0.08),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 12),
//                         child: Row(children: [
//                           Container(
//                             width: 18, height: 18,
//                             margin: const EdgeInsets.only(right: 8),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: isVoted
//                                   ? AppColors.green
//                                   : Colors.transparent,
//                               border: Border.all(
//                                   color: isVoted
//                                       ? AppColors.green
//                                       : AppColors.primary.withValues(alpha: 0.5),
//                                   width: 2),
//                             ),
//                             child: isVoted
//                                 ? const Icon(Icons.check,
//                                     size: 11, color: Colors.white)
//                                 : null,
//                           ),
//                           Expanded(
//                             child: Text(poll.options[i].label,
//                                 style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: isVoted
//                                         ? FontWeight.w700
//                                         : FontWeight.w500,
//                                     color: isVoted
//                                         ? AppColors.green
//                                         : AppColors.textPrimary)),
//                           ),
//                           if (hasVoted)
//                             Text('$pctInt%',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                     color: isLeading
//                                         ? AppColors.primary
//                                         : AppColors.textSecondary))
//                           else
//                             const Icon(Icons.chevron_right,
//                                 size: 16,
//                                 color: AppColors.textSecondary),
//                         ]),
//                       ),
//                     ]),
//                   ),
//                 );
//               }),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       hasVoted
//                           ? 'Total votes: ${poll.totalVotes}'
//                           : 'Total votes: ${poll.totalVotes} · Tap to vote',
//                       style: const TextStyle(fontSize: 11,
//                           color: AppColors.textSecondary,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     const Text('⚡ Bot',
//                         style: TextStyle(fontSize: 9,
//                             color: AppColors.textSecondary,
//                             fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTyping() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(12)),
//         child: const Text('⚡ Typing...',
//             style: TextStyle(
//                 fontSize: 11, color: AppColors.textSecondary)),
//       ),
//     );
//   }
// }












// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../services/api_service.dart';
// import '../services/app_theme.dart';
// import 'polls_provider.dart';
// import 'certificate_service.dart';

// // ─── Message model ────────────────────────────────────────────────────────────
// class _Msg {
//   final String text;
//   final bool isBot;
//   final bool isSystem;
//   final bool isError;
//   final Poll? poll;
//   final bool showCertificate;
//   final int? quizScore;
//   final String courseTitle;

//   _Msg({
//     required this.text,
//     required this.isBot,
//     this.isSystem = false,
//     this.isError = false,
//     this.poll,
//     this.showCertificate = false,
//     this.quizScore,
//     this.courseTitle = '',
//   });
// }

// // ─── YouTube URL helper ───────────────────────────────────────────────────────
// class _YT {
//   static String? videoId(String url) {
//     final patterns = [
//       RegExp(r'youtu\.be/([^?&\s]+)'),
//       RegExp(r'youtube\.com/watch\?v=([^&\s]+)'),
//       RegExp(r'youtube\.com/embed/([^?&\s]+)'),
//       RegExp(r'youtube\.com/shorts/([^?&\s]+)'),
//     ];
//     for (final p in patterns) {
//       final m = p.firstMatch(url);
//       if (m != null) return m.group(1);
//     }
//     return null;
//   }

//   static String thumbnail(String videoId) =>
//       'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

//   static String watchUrl(String videoId) =>
//       'https://www.youtube.com/watch?v=$videoId';

//   static List<String> findUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return re.allMatches(text).map((m) => m.group(0)!).toList();
//   }

//   static String stripUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return text.replaceAll(re, '').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
//   }
// }

// // ─── PDF URL helper ──────────────────────────────────────────────────────────
// class _PDF {
//   /// Find PDF URLs in bot message text (after the 📄 Read: label)
//   static List<String> findUrls(String text) {
//     final re = RegExp(
//         '(?:\u{1F4C4} \\*?Read:\\*? )(https?://[^\\s]+)',
//         caseSensitive: false,
//         unicode: true);
//     return re.allMatches(text).map((m) => m.group(1)!).toList();
//   }

//   /// Remove PDF label + URL from text
//   static String stripUrls(String text) {
//     final re = RegExp(
//         '\u{1F4C4} \\*?Read:\\*? https?://[^\\s]+',
//         caseSensitive: false,
//         unicode: true);
//     return text
//         .replaceAll(re, '')
//         .replaceAll(RegExp(r'\n{3,}'), '\n\n')
//         .trim();
//   }
// }

// // ─── Screen ───────────────────────────────────────────────────────────────────
// class WhatsAppSimScreen extends StatefulWidget {
//   const WhatsAppSimScreen({super.key});

//   @override
//   State<WhatsAppSimScreen> createState() => _WhatsAppSimScreenState();
// }

// class _WhatsAppSimScreenState extends State<WhatsAppSimScreen> {
//   final _phoneCtrl = TextEditingController(text: '9876543210');
//   final _msgCtrl = TextEditingController();
//   final _scrollCtrl = ScrollController();
//   final List<_Msg> _messages = [];
//   bool _sending = false;
//   int _pollIndex = 0;

//   final _provider = PollsProvider.instance;

//   final List<String> _chips = [
//     'START', 'MENU', 'HELP', 'QUIZ', 'NEXT', 'PROGRESS',
//     'POLL', 'A', 'B', 'C', 'D',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _provider.addListener(_onProviderUpdate);
//     _messages.add(_Msg(
//       text: '📱 WhatsApp Simulation Terminal\n\n'
//           'Test your chatbot here. Enter a phone number and send a message.\n\n'
//           'Try sending: START\n'
//           'YouTube links in modules will show as playable cards! 🎥',
//       isBot: true,
//       isSystem: true,
//     ));
//   }

//   @override
//   void dispose() {
//     _provider.removeListener(_onProviderUpdate);
//     _phoneCtrl.dispose();
//     _msgCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   void _onProviderUpdate() => setState(() {});

//   void _sendPoll() {
//     final polls = _provider.polls;
//     final poll = polls[_pollIndex % polls.length];
//     _pollIndex++;
//     setState(() {
//       _messages.add(_Msg(text: 'POLL', isBot: false));
//       _messages.add(_Msg(text: '', isBot: true, poll: poll));
//     });
//     _scrollToBottom();
//   }

//   void _vote(Poll poll, int index) {
//     if (poll.votedIndex != null) return;
//     _provider.vote(poll, index);
//     setState(() {
//       _messages.add(_Msg(
//           text: '✅ Voted: ${poll.options[index].label}', isBot: false));
//       _messages.add(_Msg(
//           text: 'Thanks for voting! 🎉 Your response has been recorded.',
//           isBot: true));
//     });
//     _scrollToBottom();
//   }

//   Future<void> _send(String text) async {
//     final trimmed = text.trim();
//     if (trimmed.isEmpty || _sending) return;

//     if (trimmed.toUpperCase() == 'POLL') {
//       _msgCtrl.clear();
//       _sendPoll();
//       return;
//     }

//     final phone = _phoneCtrl.text.trim();
//     if (phone.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Enter a phone number first')));
//       return;
//     }

//     setState(() {
//       _messages.add(_Msg(text: trimmed, isBot: false));
//       _sending = true;
//     });
//     _msgCtrl.clear();
//     _scrollToBottom();

//     final response = await ApiService.sendWhatsAppMessage(phone, trimmed);

//     if (mounted) {
//       final scoreMatch = RegExp(r'Score:\s*\*?(\d+)%\*?').firstMatch(response);
//       final score = scoreMatch != null ? int.tryParse(scoreMatch.group(1)!) : null;
//       final courseMatch = RegExp(r'Quiz:\s*(.+?)\n').firstMatch(response);
//       final course = courseMatch?.group(1)?.replaceAll('*', '').trim() ?? '';

//       setState(() {
//         _messages.add(_Msg(
//             text: response,
//             isBot: true,
//             isError: response.startsWith('❌'),
//             showCertificate: score != null && score >= 90,
//             quizScore: score,
//             courseTitle: course));
//         _sending = false;
//       });
//       _scrollToBottom();
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: AppColors.whatsappDark,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         title: Row(children: [
//           Container(
//             width: 36, height: 36,
//             decoration: BoxDecoration(
//                 color: AppColors.whatsapp,
//                 borderRadius: BorderRadius.circular(18)),
//             child: const Center(
//                 child: Text('AI',
//                     style: TextStyle(color: Colors.white,
//                         fontWeight: FontWeight.w800, fontSize: 13))),
//           ),
//           const SizedBox(width: 10),
//           const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text('WhatsApp Bot Simulator',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
//                     color: Colors.white)),
//             Text('⚡ NLP Engine Active',
//                 style: TextStyle(fontSize: 10, color: Colors.white70)),
//           ]),
//         ]),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete_outline, color: Colors.white),
//             onPressed: () => setState(() {
//               _messages.clear();
//               _pollIndex = 0;
//             }),
//             tooltip: 'Clear chat',
//           ),
//         ],
//       ),
//       body: Column(children: [
//         // ── Phone input ──────────────────────────────────────────────────
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           color: Colors.white,
//           child: Row(children: [
//             const Icon(Icons.phone, size: 18, color: AppColors.textSecondary),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextField(
//                 controller: _phoneCtrl,
//                 keyboardType: TextInputType.phone,
//                 style: const TextStyle(fontSize: 13),
//                 decoration: const InputDecoration(
//                   hintText: 'Learner phone number (digits only)',
//                   hintStyle: TextStyle(fontSize: 12),
//                   isDense: true,
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8))),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8)),
//                       borderSide: BorderSide(color: AppColors.border)),
//                 ),
//               ),
//             ),
//           ]),
//         ),
//         const Divider(height: 1, color: AppColors.border),

//         // ── Quick chips ──────────────────────────────────────────────────
//         Padding(
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
//                 final isPoll = chip == 'POLL';
//                 return GestureDetector(
//                   onTap: () => _send(chip),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: isPoll
//                           ? const Color(0xFFE8F5E9)
//                           : isAnswer
//                               ? AppColors.primaryLight
//                               : Colors.white,
//                       border: Border.all(
//                           color: isPoll
//                               ? AppColors.green
//                               : isAnswer
//                                   ? AppColors.primary
//                                   : AppColors.border),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Text(chip,
//                         style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w700,
//                             color: isPoll
//                                 ? AppColors.green
//                                 : isAnswer
//                                     ? AppColors.primary
//                                     : AppColors.textPrimary)),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),

//         // ── Messages ─────────────────────────────────────────────────────
//         Expanded(
//           child: Container(
//             color: const Color(0xFFE5DDD5),
//             child: ListView.builder(
//               controller: _scrollCtrl,
//               padding: const EdgeInsets.all(12),
//               itemCount: _messages.length + (_sending ? 1 : 0),
//               itemBuilder: (_, i) {
//                 if (i == _messages.length) return _buildTyping();
//                 final msg = _messages[i];
//                 if (msg.poll != null) return _buildPollBubble(msg.poll!);
//                 return _buildBubble(msg);
//               },
//             ),
//           ),
//         ),

//         // ── Input bar ────────────────────────────────────────────────────
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
//                     color: AppColors.whatsapp, shape: BoxShape.circle),
//                 child: const Icon(Icons.send, color: Colors.white, size: 20),
//               ),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }

//   // ── Main bubble builder ───────────────────────────────────────────────────
//   Widget _buildBubble(_Msg m) {
//     final ytUrls  = m.isBot && !m.isSystem && !m.isError
//         ? _YT.findUrls(m.text) : <String>[];
//     final pdfUrls = m.isBot && !m.isSystem && !m.isError
//         ? _PDF.findUrls(m.text) : <String>[];

//     String cleanText = m.text;
//     if (ytUrls.isNotEmpty)  cleanText = _YT.stripUrls(cleanText);
//     if (pdfUrls.isNotEmpty) cleanText = _PDF.stripUrls(cleanText);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Align(
//         alignment: m.isBot ? Alignment.centerLeft : Alignment.centerRight,
//         child: Column(
//           crossAxisAlignment:
//               m.isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//           children: [
//             if (cleanText.isNotEmpty)
//               Container(
//                 constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.78),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: m.isError
//                       ? AppColors.orangeLight
//                       : m.isSystem
//                           ? AppColors.primaryLight
//                           : m.isBot
//                               ? Colors.white
//                               : const Color(0xFFD9FDD3),
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
//                         offset: const Offset(0, 1))
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(cleanText,
//                         style: TextStyle(
//                             fontSize: 13,
//                             height: 1.5,
//                             color: m.isError
//                                 ? AppColors.orange
//                                 : AppColors.textPrimary)),
//                     const SizedBox(height: 2),
//                     Text(m.isBot ? '⚡ Bot' : '👤 Learner',
//                         style: const TextStyle(
//                             fontSize: 9,
//                             color: AppColors.textSecondary,
//                             fontWeight: FontWeight.w600)),
//                   ],
//                 ),
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
//     final phone = _phoneCtrl.text.trim();
//     final learnerName = 'Learner ($phone)';

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
//               Text(learnerName,
//                   style: const TextStyle(color: Colors.white70, fontSize: 13,
//                       fontWeight: FontWeight.w600)),
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
//                     color: AppColors.green,
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
//                   learnerName: learnerName,
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
//                     Icon(Icons.download_rounded, color: Color(0xFF1348D4), size: 18),
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

//   // ── YouTube card ─────────────────────────────────────────────────────────
//   Widget _buildYouTubeCard(String url) {
//     final videoId = _YT.videoId(url);

//     return GestureDetector(
//       onTap: () async {
//         final uri = Uri.parse(videoId != null ? _YT.watchUrl(videoId) : url);
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
//                 offset: const Offset(0, 2))
//           ],
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Stack(children: [
//             videoId != null
//                 ? Image.network(
//                     _YT.thumbnail(videoId),
//                     width: double.infinity,
//                     height: 140,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => _ytPlaceholder(),
//                   )
//                 : _ytPlaceholder(),
//             Positioned.fill(
//               child: Center(
//                 child: Container(
//                   width: 52, height: 52,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.3),
//                           blurRadius: 8)
//                     ],
//                   ),
//                   child: const Icon(Icons.play_arrow_rounded,
//                       color: Colors.white, size: 32),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 8, right: 8,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: const Row(children: [
//                   Icon(Icons.play_circle_filled, color: Colors.white, size: 12),
//                   SizedBox(width: 4),
//                   Text('YouTube',
//                       style: TextStyle(color: Colors.white,
//                           fontSize: 10, fontWeight: FontWeight.w700)),
//                 ]),
//               ),
//             ),
//           ]),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             child: Row(children: [
//               const Icon(Icons.play_circle_outline_rounded,
//                   color: Colors.red, size: 18),
//               const SizedBox(width: 8),
//               const Expanded(
//                 child: Text('Tap to watch video',
//                     style: TextStyle(fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary)),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text('Watch',
//                     style: TextStyle(color: Colors.white,
//                         fontSize: 11, fontWeight: FontWeight.w700)),
//               ),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }

//   Widget _ytPlaceholder() {
//     return Container(
//       width: double.infinity, height: 140,
//       color: const Color(0xFF1A1A1A),
//       child: const Column(
//           mainAxisAlignment: MainAxisAlignment.center, children: [
//         Icon(Icons.play_circle_filled_rounded, color: Colors.red, size: 48),
//         SizedBox(height: 6),
//         Text('YouTube Video',
//             style: TextStyle(color: Colors.white70,
//                 fontSize: 12, fontWeight: FontWeight.w600)),
//       ]),
//     );
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
//               child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     filename.length > 30
//                         ? '${filename.substring(0, 30)}...' : filename,
//                     style: const TextStyle(fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textPrimary),
//                   ),
//                   const SizedBox(height: 2),
//                   const Text('Tap to open PDF document',
//                       style: TextStyle(fontSize: 11,
//                           color: AppColors.textSecondary)),
//                 ]),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                   color: Colors.red.shade600,
//                   borderRadius: BorderRadius.circular(20)),
//               child: const Text('Open',
//                   style: TextStyle(color: Colors.white,
//                       fontSize: 11, fontWeight: FontWeight.w700)),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }

//   // ── Poll bubble ───────────────────────────────────────────────────────────
//   Widget _buildPollBubble(Poll poll) {
//     final hasVoted = poll.votedIndex != null;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Container(
//           constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.85),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(12),
//               topRight: Radius.circular(12),
//               bottomRight: Radius.circular(12),
//             ),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.06),
//                   blurRadius: 4,
//                   offset: const Offset(0, 1))
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 color: const Color(0xFF075E54),
//                 child: Row(children: [
//                   const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 16),
//                   const SizedBox(width: 6),
//                   const Text('POLL',
//                       style: TextStyle(color: Colors.white,
//                           fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
//                   const Spacer(),
//                   if (hasVoted)
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                       decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.2),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: const Text('Voted ✓',
//                           style: TextStyle(color: Colors.white,
//                               fontSize: 9, fontWeight: FontWeight.w700)),
//                     ),
//                 ]),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
//                 child: Text(poll.question,
//                     style: const TextStyle(fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textPrimary, height: 1.3)),
//               ),
//               const SizedBox(height: 8),
//               ...List.generate(poll.options.length, (i) {
//                 final pct = poll.percent(i);
//                 final pctInt = (pct * 100).round();
//                 final isVoted = poll.votedIndex == i;
//                 final isLeading = hasVoted && i == poll.leadingIndex;
//                 return GestureDetector(
//                   onTap: hasVoted ? null : () => _vote(poll, i),
//                   child: Container(
//                     margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
//                     decoration: BoxDecoration(
//                       color: isVoted
//                           ? const Color(0xFFE8F5E9)
//                           : hasVoted
//                               ? const Color(0xFFF5F5F5)
//                               : const Color(0xFFEEF1FB),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: isVoted
//                               ? AppColors.green
//                               : hasVoted
//                                   ? AppColors.border
//                                   : AppColors.primary.withValues(alpha: 0.3)),
//                     ),
//                     child: Stack(children: [
//                       if (hasVoted)
//                         FractionallySizedBox(
//                           widthFactor: pct,
//                           child: Container(
//                             height: 44,
//                             decoration: BoxDecoration(
//                               color: isVoted
//                                   ? AppColors.green.withValues(alpha: 0.15)
//                                   : Colors.grey.withValues(alpha: 0.08),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 12),
//                         child: Row(children: [
//                           Container(
//                             width: 18, height: 18,
//                             margin: const EdgeInsets.only(right: 8),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: isVoted ? AppColors.green : Colors.transparent,
//                               border: Border.all(
//                                   color: isVoted
//                                       ? AppColors.green
//                                       : AppColors.primary.withValues(alpha: 0.5),
//                                   width: 2),
//                             ),
//                             child: isVoted
//                                 ? const Icon(Icons.check, size: 11, color: Colors.white)
//                                 : null,
//                           ),
//                           Expanded(
//                             child: Text(poll.options[i].label,
//                                 style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: isVoted ? FontWeight.w700 : FontWeight.w500,
//                                     color: isVoted ? AppColors.green : AppColors.textPrimary)),
//                           ),
//                           if (hasVoted)
//                             Text('$pctInt%',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                     color: isLeading
//                                         ? AppColors.primary
//                                         : AppColors.textSecondary))
//                           else
//                             const Icon(Icons.chevron_right,
//                                 size: 16, color: AppColors.textSecondary),
//                         ]),
//                       ),
//                     ]),
//                   ),
//                 );
//               }),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       hasVoted
//                           ? 'Total votes: ${poll.totalVotes}'
//                           : 'Total votes: ${poll.totalVotes} · Tap to vote',
//                       style: const TextStyle(fontSize: 11,
//                           color: AppColors.textSecondary,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     const Text('⚡ Bot',
//                         style: TextStyle(fontSize: 9,
//                             color: AppColors.textSecondary,
//                             fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTyping() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(12)),
//         child: const Text('⚡ Typing...',
//             style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
//       ),
//     );
//   }
// }














// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../services/api_service.dart';
// import '../services/app_theme.dart';
// import 'polls_provider.dart';
// import 'certificate_service.dart';

// // ─── Message model ────────────────────────────────────────────────────────────
// class _Msg {
//   final String text;
//   final bool isBot;
//   final bool isSystem;
//   final bool isError;
//   final Poll? poll;
//   final bool showCertificate;
//   final int? quizScore;
//   final String courseTitle;

//   _Msg({
//     required this.text,
//     required this.isBot,
//     this.isSystem = false,
//     this.isError = false,
//     this.poll,
//     this.showCertificate = false,
//     this.quizScore,
//     this.courseTitle = '',
//   });
// }

// // ─── YouTube URL helper ───────────────────────────────────────────────────────
// class _YT {
//   static String? videoId(String url) {
//     final patterns = [
//       RegExp(r'youtu\.be/([^?&\s]+)'),
//       RegExp(r'youtube\.com/watch\?v=([^&\s]+)'),
//       RegExp(r'youtube\.com/embed/([^?&\s]+)'),
//       RegExp(r'youtube\.com/shorts/([^?&\s]+)'),
//     ];
//     for (final p in patterns) {
//       final m = p.firstMatch(url);
//       if (m != null) return m.group(1);
//     }
//     return null;
//   }

//   static String thumbnail(String videoId) =>
//       'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

//   static String watchUrl(String videoId) =>
//       'https://www.youtube.com/watch?v=$videoId';

//   static List<String> findUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return re.allMatches(text).map((m) => m.group(0)!).toList();
//   }

//   static String stripUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return text.replaceAll(re, '').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
//   }
// }

// // ─── PDF URL helper ──────────────────────────────────────────────────────────
// class _PDF {
//   /// Find PDF URLs in bot message text (after the 📄 Read: label)
//   static List<String> findUrls(String text) {
//     final re = RegExp(
//         '(?:\u{1F4C4} \\*?Read:\\*? )(https?://[^\\s]+)',
//         caseSensitive: false,
//         unicode: true);
//     return re.allMatches(text).map((m) => m.group(1)!).toList();
//   }

//   /// Remove PDF label + URL from text
//   static String stripUrls(String text) {
//     final re = RegExp(
//         '\u{1F4C4} \\*?Read:\\*? https?://[^\\s]+',
//         caseSensitive: false,
//         unicode: true);
//     return text
//         .replaceAll(re, '')
//         .replaceAll(RegExp(r'\n{3,}'), '\n\n')
//         .trim();
//   }
// }

// // ─── Screen ───────────────────────────────────────────────────────────────────
// class WhatsAppSimScreen extends StatefulWidget {
//   const WhatsAppSimScreen({super.key});

//   @override
//   State<WhatsAppSimScreen> createState() => _WhatsAppSimScreenState();
// }

// class _WhatsAppSimScreenState extends State<WhatsAppSimScreen> {
//   final _phoneCtrl = TextEditingController(text: '9876543210');
//   final _msgCtrl = TextEditingController();
//   final _scrollCtrl = ScrollController();
//   final List<_Msg> _messages = [];
//   bool _sending = false;
//   int _pollIndex = 0;

//   final _provider = PollsProvider.instance;

//   final List<String> _chips = [
//     'START', 'MENU', 'HELP', 'QUIZ', 'NEXT', 'PROGRESS',
//     'POLL', 'A', 'B', 'C', 'D',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _provider.addListener(_onProviderUpdate);
//     _messages.add(_Msg(
//       text: '📱 WhatsApp Simulation Terminal\n\n'
//           'Test your chatbot here. Enter a phone number and send a message.\n\n'
//           'Try sending: START\n'
//           'YouTube links in modules will show as playable cards! 🎥',
//       isBot: true,
//       isSystem: true,
//     ));
//   }

//   @override
//   void dispose() {
//     _provider.removeListener(_onProviderUpdate);
//     _phoneCtrl.dispose();
//     _msgCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   void _onProviderUpdate() => setState(() {});

//   void _sendPoll() {
//     final polls = _provider.polls;
//     final poll = polls[_pollIndex % polls.length];
//     _pollIndex++;
//     setState(() {
//       _messages.add(_Msg(text: 'POLL', isBot: false));
//       _messages.add(_Msg(text: '', isBot: true, poll: poll));
//     });
//     _scrollToBottom();
//   }

//   void _vote(Poll poll, int index) {
//     if (poll.votedIndex != null) return;
//     _provider.vote(poll, index);
//     setState(() {
//       _messages.add(_Msg(
//           text: '✅ Voted: ${poll.options[index].label}', isBot: false));
//       _messages.add(_Msg(
//           text: 'Thanks for voting! 🎉 Your response has been recorded.',
//           isBot: true));
//     });
//     _scrollToBottom();
//   }

//   Future<void> _send(String text) async {
//     final trimmed = text.trim();
//     if (trimmed.isEmpty || _sending) return;

//     if (trimmed.toUpperCase() == 'POLL') {
//       _msgCtrl.clear();
//       _sendPoll();
//       return;
//     }

//     final phone = _phoneCtrl.text.trim();
//     if (phone.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Enter a phone number first')));
//       return;
//     }

//     setState(() {
//       _messages.add(_Msg(text: trimmed, isBot: false));
//       _sending = true;
//     });
//     _msgCtrl.clear();
//     _scrollToBottom();

//     final response = await ApiService.sendWhatsAppMessage(phone, trimmed);

//     if (mounted) {
//       final scoreMatch = RegExp(r'Score:\s*\*?(\d+)%\*?').firstMatch(response);
//       final score = scoreMatch != null ? int.tryParse(scoreMatch.group(1)!) : null;
//       final courseMatch = RegExp(r'Quiz:\s*(.+?)\n').firstMatch(response);
//       final course = courseMatch?.group(1)?.replaceAll('*', '').trim() ?? '';

//       setState(() {
//         _messages.add(_Msg(
//             text: response,
//             isBot: true,
//             isError: response.startsWith('❌'),
//             showCertificate: score != null && score >= 90,
//             quizScore: score,
//             courseTitle: course));
//         _sending = false;
//       });
//       _scrollToBottom();
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: AppColors.whatsappDark,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         title: Row(children: [
//           Container(
//             width: 36, height: 36,
//             decoration: BoxDecoration(
//                 color: AppColors.whatsapp,
//                 borderRadius: BorderRadius.circular(18)),
//             child: const Center(
//                 child: Text('AI',
//                     style: TextStyle(color: Colors.white,
//                         fontWeight: FontWeight.w800, fontSize: 13))),
//           ),
//           const SizedBox(width: 10),
//           const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text('WhatsApp Bot Simulator',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
//                     color: Colors.white)),
//             Text('⚡ NLP Engine Active',
//                 style: TextStyle(fontSize: 10, color: Colors.white70)),
//           ]),
//         ]),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete_outline, color: Colors.white),
//             onPressed: () => setState(() {
//               _messages.clear();
//               _pollIndex = 0;
//             }),
//             tooltip: 'Clear chat',
//           ),
//         ],
//       ),
//       body: Column(children: [
//         // ── Phone input ──────────────────────────────────────────────────
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           color: Colors.white,
//           child: Row(children: [
//             const Icon(Icons.phone, size: 18, color: AppColors.textSecondary),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextField(
//                 controller: _phoneCtrl,
//                 keyboardType: TextInputType.phone,
//                 style: const TextStyle(fontSize: 13),
//                 decoration: const InputDecoration(
//                   hintText: 'Learner phone number (digits only)',
//                   hintStyle: TextStyle(fontSize: 12),
//                   isDense: true,
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8))),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8)),
//                       borderSide: BorderSide(color: AppColors.border)),
//                 ),
//               ),
//             ),
//           ]),
//         ),
//         const Divider(height: 1, color: AppColors.border),

//         // ── Quick chips ──────────────────────────────────────────────────
//         Padding(
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
//                 final isPoll = chip == 'POLL';
//                 return GestureDetector(
//                   onTap: () => _send(chip),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: isPoll
//                           ? const Color(0xFFE8F5E9)
//                           : isAnswer
//                               ? AppColors.primaryLight
//                               : Colors.white,
//                       border: Border.all(
//                           color: isPoll
//                               ? AppColors.green
//                               : isAnswer
//                                   ? AppColors.primary
//                                   : AppColors.border),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Text(chip,
//                         style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w700,
//                             color: isPoll
//                                 ? AppColors.green
//                                 : isAnswer
//                                     ? AppColors.primary
//                                     : AppColors.textPrimary)),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),

//         // ── Messages ─────────────────────────────────────────────────────
//         Expanded(
//           child: Container(
//             color: const Color(0xFFE5DDD5),
//             child: ListView.builder(
//               controller: _scrollCtrl,
//               padding: const EdgeInsets.all(12),
//               itemCount: _messages.length + (_sending ? 1 : 0),
//               itemBuilder: (_, i) {
//                 if (i == _messages.length) return _buildTyping();
//                 final msg = _messages[i];
//                 if (msg.poll != null) return _buildPollBubble(msg.poll!);
//                 return _buildBubble(msg);
//               },
//             ),
//           ),
//         ),

//         // ── Input bar ────────────────────────────────────────────────────
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
//                     color: AppColors.whatsapp, shape: BoxShape.circle),
//                 child: const Icon(Icons.send, color: Colors.white, size: 20),
//               ),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }

//   // ── Main bubble builder ───────────────────────────────────────────────────
//   Widget _buildBubble(_Msg m) {
//     final ytUrls  = m.isBot && !m.isSystem && !m.isError
//         ? _YT.findUrls(m.text) : <String>[];
//     final pdfUrls = m.isBot && !m.isSystem && !m.isError
//         ? _PDF.findUrls(m.text) : <String>[];

//     String cleanText = m.text;
//     if (ytUrls.isNotEmpty)  cleanText = _YT.stripUrls(cleanText);
//     if (pdfUrls.isNotEmpty) cleanText = _PDF.stripUrls(cleanText);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Align(
//         alignment: m.isBot ? Alignment.centerLeft : Alignment.centerRight,
//         child: Column(
//           crossAxisAlignment:
//               m.isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//           children: [
//             if (cleanText.isNotEmpty)
//               Container(
//                 constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.78),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: m.isError
//                       ? AppColors.orangeLight
//                       : m.isSystem
//                           ? AppColors.primaryLight
//                           : m.isBot
//                               ? Colors.white
//                               : const Color(0xFFD9FDD3),
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
//                         offset: const Offset(0, 1))
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(cleanText,
//                         style: TextStyle(
//                             fontSize: 13,
//                             height: 1.5,
//                             color: m.isError
//                                 ? AppColors.orange
//                                 : AppColors.textPrimary)),
//                     const SizedBox(height: 2),
//                     Text(m.isBot ? '⚡ Bot' : '👤 Learner',
//                         style: const TextStyle(
//                             fontSize: 9,
//                             color: AppColors.textSecondary,
//                             fontWeight: FontWeight.w600)),
//                   ],
//                 ),
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
//     final phone = _phoneCtrl.text.trim();
//     final learnerName = 'Learner ($phone)';

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
//               Text(learnerName,
//                   style: const TextStyle(color: Colors.white70, fontSize: 13,
//                       fontWeight: FontWeight.w600)),
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
//                     color: AppColors.green,
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
//                   learnerName: learnerName,
//                   courseTitle: courseTitle.isNotEmpty ? courseTitle : 'the course',
//                   score: score,
//                   date: _formatDate(),
//                   companyName: 'Andragogy Learning Platform', // ← FIXED: added required parameter
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
//                     Icon(Icons.download_rounded, color: Color(0xFF1348D4), size: 18),
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

//   // ── YouTube card ─────────────────────────────────────────────────────────
//   Widget _buildYouTubeCard(String url) {
//     final videoId = _YT.videoId(url);

//     return GestureDetector(
//       onTap: () async {
//         final uri = Uri.parse(videoId != null ? _YT.watchUrl(videoId) : url);
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
//                 offset: const Offset(0, 2))
//           ],
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Stack(children: [
//             videoId != null
//                 ? Image.network(
//                     _YT.thumbnail(videoId),
//                     width: double.infinity,
//                     height: 140,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => _ytPlaceholder(),
//                   )
//                 : _ytPlaceholder(),
//             Positioned.fill(
//               child: Center(
//                 child: Container(
//                   width: 52, height: 52,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.3),
//                           blurRadius: 8)
//                     ],
//                   ),
//                   child: const Icon(Icons.play_arrow_rounded,
//                       color: Colors.white, size: 32),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 8, right: 8,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: const Row(children: [
//                   Icon(Icons.play_circle_filled, color: Colors.white, size: 12),
//                   SizedBox(width: 4),
//                   Text('YouTube',
//                       style: TextStyle(color: Colors.white,
//                           fontSize: 10, fontWeight: FontWeight.w700)),
//                 ]),
//               ),
//             ),
//           ]),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             child: Row(children: [
//               const Icon(Icons.play_circle_outline_rounded,
//                   color: Colors.red, size: 18),
//               const SizedBox(width: 8),
//               const Expanded(
//                 child: Text('Tap to watch video',
//                     style: TextStyle(fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary)),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text('Watch',
//                     style: TextStyle(color: Colors.white,
//                         fontSize: 11, fontWeight: FontWeight.w700)),
//               ),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }

//   Widget _ytPlaceholder() {
//     return Container(
//       width: double.infinity, height: 140,
//       color: const Color(0xFF1A1A1A),
//       child: const Column(
//           mainAxisAlignment: MainAxisAlignment.center, children: [
//         Icon(Icons.play_circle_filled_rounded, color: Colors.red, size: 48),
//         SizedBox(height: 6),
//         Text('YouTube Video',
//             style: TextStyle(color: Colors.white70,
//                 fontSize: 12, fontWeight: FontWeight.w600)),
//       ]),
//     );
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
//               child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     filename.length > 30
//                         ? '${filename.substring(0, 30)}...' : filename,
//                     style: const TextStyle(fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textPrimary),
//                   ),
//                   const SizedBox(height: 2),
//                   const Text('Tap to open PDF document',
//                       style: TextStyle(fontSize: 11,
//                           color: AppColors.textSecondary)),
//                 ]),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                   color: Colors.red.shade600,
//                   borderRadius: BorderRadius.circular(20)),
//               child: const Text('Open',
//                   style: TextStyle(color: Colors.white,
//                       fontSize: 11, fontWeight: FontWeight.w700)),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }

//   // ── Poll bubble ───────────────────────────────────────────────────────────
//   Widget _buildPollBubble(Poll poll) {
//     final hasVoted = poll.votedIndex != null;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Container(
//           constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.85),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(12),
//               topRight: Radius.circular(12),
//               bottomRight: Radius.circular(12),
//             ),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.06),
//                   blurRadius: 4,
//                   offset: const Offset(0, 1))
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 color: const Color(0xFF075E54),
//                 child: Row(children: [
//                   const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 16),
//                   const SizedBox(width: 6),
//                   const Text('POLL',
//                       style: TextStyle(color: Colors.white,
//                           fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
//                   const Spacer(),
//                   if (hasVoted)
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                       decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.2),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: const Text('Voted ✓',
//                           style: TextStyle(color: Colors.white,
//                               fontSize: 9, fontWeight: FontWeight.w700)),
//                     ),
//                 ]),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
//                 child: Text(poll.question,
//                     style: const TextStyle(fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textPrimary, height: 1.3)),
//               ),
//               const SizedBox(height: 8),
//               ...List.generate(poll.options.length, (i) {
//                 final pct = poll.percent(i);
//                 final pctInt = (pct * 100).round();
//                 final isVoted = poll.votedIndex == i;
//                 final isLeading = hasVoted && i == poll.leadingIndex;
//                 return GestureDetector(
//                   onTap: hasVoted ? null : () => _vote(poll, i),
//                   child: Container(
//                     margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
//                     decoration: BoxDecoration(
//                       color: isVoted
//                           ? const Color(0xFFE8F5E9)
//                           : hasVoted
//                               ? const Color(0xFFF5F5F5)
//                               : const Color(0xFFEEF1FB),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: isVoted
//                               ? AppColors.green
//                               : hasVoted
//                                   ? AppColors.border
//                                   : AppColors.primary.withValues(alpha: 0.3)),
//                     ),
//                     child: Stack(children: [
//                       if (hasVoted)
//                         FractionallySizedBox(
//                           widthFactor: pct,
//                           child: Container(
//                             height: 44,
//                             decoration: BoxDecoration(
//                               color: isVoted
//                                   ? AppColors.green.withValues(alpha: 0.15)
//                                   : Colors.grey.withValues(alpha: 0.08),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 12),
//                         child: Row(children: [
//                           Container(
//                             width: 18, height: 18,
//                             margin: const EdgeInsets.only(right: 8),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: isVoted ? AppColors.green : Colors.transparent,
//                               border: Border.all(
//                                   color: isVoted
//                                       ? AppColors.green
//                                       : AppColors.primary.withValues(alpha: 0.5),
//                                   width: 2),
//                             ),
//                             child: isVoted
//                                 ? const Icon(Icons.check, size: 11, color: Colors.white)
//                                 : null,
//                           ),
//                           Expanded(
//                             child: Text(poll.options[i].label,
//                                 style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: isVoted ? FontWeight.w700 : FontWeight.w500,
//                                     color: isVoted ? AppColors.green : AppColors.textPrimary)),
//                           ),
//                           if (hasVoted)
//                             Text('$pctInt%',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                     color: isLeading
//                                         ? AppColors.primary
//                                         : AppColors.textSecondary))
//                           else
//                             const Icon(Icons.chevron_right,
//                                 size: 16, color: AppColors.textSecondary),
//                         ]),
//                       ),
//                     ]),
//                   ),
//                 );
//               }),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       hasVoted
//                           ? 'Total votes: ${poll.totalVotes}'
//                           : 'Total votes: ${poll.totalVotes} · Tap to vote',
//                       style: const TextStyle(fontSize: 11,
//                           color: AppColors.textSecondary,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     const Text('⚡ Bot',
//                         style: TextStyle(fontSize: 9,
//                             color: AppColors.textSecondary,
//                             fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTyping() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(12)),
//         child: const Text('⚡ Typing...',
//             style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
//       ),
//     );
//   }
// }












// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../services/api_service.dart';
// import '../services/app_theme.dart';
// import 'polls_provider.dart';
// import 'certificate_service.dart';

// // ─── Message model ────────────────────────────────────────────────────────────
// class _Msg {
//   final String text;
//   final bool isBot;
//   final bool isSystem;
//   final bool isError;
//   final Poll? poll;
//   final bool showCertificate;
//   final int? quizScore;
//   final String courseTitle;
//   final DateTime timestamp;

//   _Msg({
//     required this.text,
//     required this.isBot,
//     this.isSystem = false,
//     this.isError = false,
//     this.poll,
//     this.showCertificate = false,
//     this.quizScore,
//     this.courseTitle = '',
//   }) : timestamp = DateTime.now();
// }

// // ─── YouTube URL helper ───────────────────────────────────────────────────────
// class _YT {
//   static String? videoId(String url) {
//     final patterns = [
//       RegExp(r'youtu\.be/([^?&\s]+)'),
//       RegExp(r'youtube\.com/watch\?v=([^&\s]+)'),
//       RegExp(r'youtube\.com/embed/([^?&\s]+)'),
//       RegExp(r'youtube\.com/shorts/([^?&\s]+)'),
//     ];
//     for (final p in patterns) {
//       final m = p.firstMatch(url);
//       if (m != null) return m.group(1);
//     }
//     return null;
//   }

//   static String thumbnail(String videoId) =>
//       'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

//   static String watchUrl(String videoId) =>
//       'https://www.youtube.com/watch?v=$videoId';

//   static List<String> findUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return re.allMatches(text).map((m) => m.group(0)!).toList();
//   }

//   static String stripUrls(String text) {
//     final re = RegExp(
//         r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
//         caseSensitive: false);
//     return text.replaceAll(re, '').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
//   }
// }

// // ─── PDF URL helper ──────────────────────────────────────────────────────────
// class _PDF {
//   /// Find PDF URLs in bot message text (after the 📄 Read: label)
//   static List<String> findUrls(String text) {
//     final re = RegExp(
//         '(?:\u{1F4C4} \\*?Read:\\*? )(https?://[^\\s]+)',
//         caseSensitive: false,
//         unicode: true);
//     return re.allMatches(text).map((m) => m.group(1)!).toList();
//   }

//   /// Remove PDF label + URL from text
//   static String stripUrls(String text) {
//     final re = RegExp(
//         '\u{1F4C4} \\*?Read:\\*? https?://[^\\s]+',
//         caseSensitive: false,
//         unicode: true);
//     return text
//         .replaceAll(re, '')
//         .replaceAll(RegExp(r'\n{3,}'), '\n\n')
//         .trim();
//   }
// }

// // ─── Screen ───────────────────────────────────────────────────────────────────
// class WhatsAppSimScreen extends StatefulWidget {
//   const WhatsAppSimScreen({super.key});

//   @override
//   State<WhatsAppSimScreen> createState() => _WhatsAppSimScreenState();
// }

// class _WhatsAppSimScreenState extends State<WhatsAppSimScreen> {
//   final _phoneCtrl = TextEditingController(text: '9876543210');
//   final _msgCtrl = TextEditingController();
//   final _scrollCtrl = ScrollController();
//   final List<_Msg> _messages = [];
//   bool _sending = false;
//   int _pollIndex = 0;

//   final _provider = PollsProvider.instance;

//   final List<String> _chips = [
//     'START', 'MENU', 'HELP', 'QUIZ', 'NEXT', 'PROGRESS',
//     'POLL', 'A', 'B', 'C', 'D',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _provider.addListener(_onProviderUpdate);
//     _messages.add(_Msg(
//       text: '📱 WhatsApp Simulation Terminal\n\n'
//           'Test your chatbot here. Enter a phone number and send a message.\n\n'
//           'Try sending: START\n'
//           'YouTube links in modules will show as playable cards! 🎥',
//       isBot: true,
//       isSystem: true,
//     ));
//   }

//   @override
//   void dispose() {
//     _provider.removeListener(_onProviderUpdate);
//     _phoneCtrl.dispose();
//     _msgCtrl.dispose();
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   void _onProviderUpdate() => setState(() {});

//   void _sendPoll() {
//     final polls = _provider.polls;
//     final poll = polls[_pollIndex % polls.length];
//     _pollIndex++;
//     setState(() {
//       _messages.add(_Msg(text: 'POLL', isBot: false));
//       _messages.add(_Msg(text: '', isBot: true, poll: poll));
//     });
//     _scrollToBottom();
//   }

//   void _vote(Poll poll, int index) {
//     if (poll.votedIndex != null) return;
//     _provider.vote(poll, index);
//     setState(() {
//       _messages.add(_Msg(
//           text: '✅ Voted: ${poll.options[index].label}', isBot: false));
//       _messages.add(_Msg(
//           text: 'Thanks for voting! 🎉 Your response has been recorded.',
//           isBot: true));
//     });
//     _scrollToBottom();
//   }

//   Future<void> _send(String text) async {
//     final trimmed = text.trim();
//     if (trimmed.isEmpty || _sending) return;

//     if (trimmed.toUpperCase() == 'POLL') {
//       _msgCtrl.clear();
//       _sendPoll();
//       return;
//     }

//     final phone = _phoneCtrl.text.trim();
//     if (phone.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Enter a phone number first')));
//       return;
//     }

//     setState(() {
//       _messages.add(_Msg(text: trimmed, isBot: false));
//       _sending = true;
//     });
//     _msgCtrl.clear();
//     _scrollToBottom();

//     final response = await ApiService.sendWhatsAppMessage(phone, trimmed);

//     if (mounted) {
//       final scoreMatch = RegExp(r'Score:\s*\*?(\d+)%\*?').firstMatch(response);
//       final score = scoreMatch != null ? int.tryParse(scoreMatch.group(1)!) : null;
//       final courseMatch = RegExp(r'Quiz:\s*(.+?)\n').firstMatch(response);
//       final course = courseMatch?.group(1)?.replaceAll('*', '').trim() ?? '';

//       setState(() {
//         _messages.add(_Msg(
//             text: response,
//             isBot: true,
//             isError: response.startsWith('❌'),
//             showCertificate: score != null && score >= 90,
//             quizScore: score,
//             courseTitle: course));
//         _sending = false;
//       });
//       _scrollToBottom();
//     }
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (_scrollCtrl.hasClients) {
//         _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: AppColors.whatsappDark,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         title: Row(children: [
//           Container(
//             width: 36, height: 36,
//             decoration: BoxDecoration(
//                 color: AppColors.whatsapp,
//                 borderRadius: BorderRadius.circular(18)),
//             child: const Center(
//                 child: Text('AI',
//                     style: TextStyle(color: Colors.white,
//                         fontWeight: FontWeight.w800, fontSize: 13))),
//           ),
//           const SizedBox(width: 10),
//           const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text('Andragogy Bot',
//                 style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
//                     color: Colors.white)),
//             Text('online',
//                 style: TextStyle(fontSize: 10, color: Colors.white70)),
//           ]),
//         ]),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete_outline, color: Colors.white),
//             onPressed: () => setState(() {
//               _messages.clear();
//               _pollIndex = 0;
//             }),
//             tooltip: 'Clear chat',
//           ),
//         ],
//       ),
//       body: Column(children: [
//         // ── Phone input ──────────────────────────────────────────────────
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//           color: Colors.white,
//           child: Row(children: [
//             const Icon(Icons.phone, size: 18, color: AppColors.textSecondary),
//             const SizedBox(width: 8),
//             Expanded(
//               child: TextField(
//                 controller: _phoneCtrl,
//                 keyboardType: TextInputType.phone,
//                 style: const TextStyle(fontSize: 13),
//                 decoration: const InputDecoration(
//                   hintText: 'Learner phone number (digits only)',
//                   hintStyle: TextStyle(fontSize: 12),
//                   isDense: true,
//                   contentPadding:
//                       EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8))),
//                   enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(8)),
//                       borderSide: BorderSide(color: AppColors.border)),
//                 ),
//               ),
//             ),
//           ]),
//         ),
//         const Divider(height: 1, color: AppColors.border),

//         // ── Quick chips ──────────────────────────────────────────────────
//         Padding(
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
//                 final isPoll = chip == 'POLL';
//                 return GestureDetector(
//                   onTap: () => _send(chip),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: isPoll
//                           ? const Color(0xFFE8F5E9)
//                           : isAnswer
//                               ? AppColors.primaryLight
//                               : Colors.white,
//                       border: Border.all(
//                           color: isPoll
//                               ? AppColors.green
//                               : isAnswer
//                                   ? AppColors.primary
//                                   : AppColors.border),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Text(chip,
//                         style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w700,
//                             color: isPoll
//                                 ? AppColors.green
//                                 : isAnswer
//                                     ? AppColors.primary
//                                     : AppColors.textPrimary)),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ),

//         // ── Messages ─────────────────────────────────────────────────────
//         Expanded(
//           child: Container(
//             color: const Color(0xFFE5DDD5),
//             child: ListView.builder(
//               controller: _scrollCtrl,
//               padding: const EdgeInsets.all(12),
//               itemCount: _messages.length + (_sending ? 1 : 0),
//               itemBuilder: (_, i) {
//                 if (i == _messages.length) return _buildTyping();
//                 final msg = _messages[i];
//                 if (msg.poll != null) return _buildPollBubble(msg.poll!);
//                 return _buildBubble(msg);
//               },
//             ),
//           ),
//         ),

//         // ── Input bar ────────────────────────────────────────────────────
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
//                     color: AppColors.whatsapp, shape: BoxShape.circle),
//                 child: const Icon(Icons.send, color: Colors.white, size: 20),
//               ),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }

//   // ── Main bubble builder ───────────────────────────────────────────────────
//   Widget _buildBubble(_Msg m) {
//     final ytUrls  = m.isBot && !m.isSystem && !m.isError
//         ? _YT.findUrls(m.text) : <String>[];
//     final pdfUrls = m.isBot && !m.isSystem && !m.isError
//         ? _PDF.findUrls(m.text) : <String>[];

//     String cleanText = m.text;
//     if (ytUrls.isNotEmpty)  cleanText = _YT.stripUrls(cleanText);
//     if (pdfUrls.isNotEmpty) cleanText = _PDF.stripUrls(cleanText);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Align(
//         alignment: m.isBot ? Alignment.centerLeft : Alignment.centerRight,
//         child: Column(
//           crossAxisAlignment:
//               m.isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
//           children: [
//             if (cleanText.isNotEmpty)
//               Container(
//                 constraints: BoxConstraints(
//                     maxWidth: MediaQuery.of(context).size.width * 0.78),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 10),
//                 decoration: BoxDecoration(
//                   color: m.isError
//                       ? AppColors.orangeLight
//                       : m.isSystem
//                           ? AppColors.primaryLight
//                           : m.isBot
//                               ? Colors.white
//                               : const Color(0xFFD9FDD3),
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
//                         offset: const Offset(0, 1))
//                   ],
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(cleanText,
//                         style: TextStyle(
//                             fontSize: 13,
//                             height: 1.5,
//                             color: m.isError
//                                 ? AppColors.orange
//                                 : AppColors.textPrimary)),
//                     const SizedBox(height: 2),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           _formatTime(m.timestamp),
//                           style: const TextStyle(
//                               fontSize: 9,
//                               color: AppColors.textSecondary),
//                         ),
//                         if (!m.isBot) ...[
//                           const SizedBox(width: 3),
//                           const Text(
//                             '✓✓',
//                             style: TextStyle(
//                                 fontSize: 9,
//                                 color: Color(0xFF4FC3F7),
//                                 fontWeight: FontWeight.w700),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ],
//                 ),
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
//     final phone = _phoneCtrl.text.trim();
//     final learnerName = 'Learner ($phone)';

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
//               Text(learnerName,
//                   style: const TextStyle(color: Colors.white70, fontSize: 13,
//                       fontWeight: FontWeight.w600)),
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
//                     color: AppColors.green,
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
//                   learnerName: learnerName,
//                   courseTitle: courseTitle.isNotEmpty ? courseTitle : 'the course',
//                   score: score,
//                   date: _formatDate(),
//                   companyName: 'Andragogy Learning Platform', // ← FIXED: added required parameter
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
//                     Icon(Icons.download_rounded, color: Color(0xFF1348D4), size: 18),
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

//   String _formatTime(DateTime dt) {
//     final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
//     final m = dt.minute.toString().padLeft(2, '0');
//     final period = dt.hour < 12 ? 'AM' : 'PM';
//     return '$h:$m $period';
//   }

//   // ── YouTube card ─────────────────────────────────────────────────────────
//   Widget _buildYouTubeCard(String url) {
//     final videoId = _YT.videoId(url);

//     return GestureDetector(
//       onTap: () async {
//         final uri = Uri.parse(videoId != null ? _YT.watchUrl(videoId) : url);
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
//                 offset: const Offset(0, 2))
//           ],
//         ),
//         clipBehavior: Clip.antiAlias,
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Stack(children: [
//             videoId != null
//                 ? Image.network(
//                     _YT.thumbnail(videoId),
//                     width: double.infinity,
//                     height: 140,
//                     fit: BoxFit.cover,
//                     errorBuilder: (_, __, ___) => _ytPlaceholder(),
//                   )
//                 : _ytPlaceholder(),
//             Positioned.fill(
//               child: Center(
//                 child: Container(
//                   width: 52, height: 52,
//                   decoration: BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.black.withValues(alpha: 0.3),
//                           blurRadius: 8)
//                     ],
//                   ),
//                   child: const Icon(Icons.play_arrow_rounded,
//                       color: Colors.white, size: 32),
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: 8, right: 8,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: const Row(children: [
//                   Icon(Icons.play_circle_filled, color: Colors.white, size: 12),
//                   SizedBox(width: 4),
//                   Text('YouTube',
//                       style: TextStyle(color: Colors.white,
//                           fontSize: 10, fontWeight: FontWeight.w700)),
//                 ]),
//               ),
//             ),
//           ]),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             child: Row(children: [
//               const Icon(Icons.play_circle_outline_rounded,
//                   color: Colors.red, size: 18),
//               const SizedBox(width: 8),
//               const Expanded(
//                 child: Text('Tap to watch video',
//                     style: TextStyle(fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary)),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.red,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text('Watch',
//                     style: TextStyle(color: Colors.white,
//                         fontSize: 11, fontWeight: FontWeight.w700)),
//               ),
//             ]),
//           ),
//         ]),
//       ),
//     );
//   }

//   Widget _ytPlaceholder() {
//     return Container(
//       width: double.infinity, height: 140,
//       color: const Color(0xFF1A1A1A),
//       child: const Column(
//           mainAxisAlignment: MainAxisAlignment.center, children: [
//         Icon(Icons.play_circle_filled_rounded, color: Colors.red, size: 48),
//         SizedBox(height: 6),
//         Text('YouTube Video',
//             style: TextStyle(color: Colors.white70,
//                 fontSize: 12, fontWeight: FontWeight.w600)),
//       ]),
//     );
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
//               child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     filename.length > 30
//                         ? '${filename.substring(0, 30)}...' : filename,
//                     style: const TextStyle(fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textPrimary),
//                   ),
//                   const SizedBox(height: 2),
//                   const Text('Tap to open PDF document',
//                       style: TextStyle(fontSize: 11,
//                           color: AppColors.textSecondary)),
//                 ]),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                   color: Colors.red.shade600,
//                   borderRadius: BorderRadius.circular(20)),
//               child: const Text('Open',
//                   style: TextStyle(color: Colors.white,
//                       fontSize: 11, fontWeight: FontWeight.w700)),
//             ),
//           ]),
//         ),
//       ),
//     );
//   }

//   // ── Poll bubble ───────────────────────────────────────────────────────────
//   Widget _buildPollBubble(Poll poll) {
//     final hasVoted = poll.votedIndex != null;

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Container(
//           constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.85),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(12),
//               topRight: Radius.circular(12),
//               bottomRight: Radius.circular(12),
//             ),
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.06),
//                   blurRadius: 4,
//                   offset: const Offset(0, 1))
//             ],
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 color: const Color(0xFF075E54),
//                 child: Row(children: [
//                   const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 16),
//                   const SizedBox(width: 6),
//                   const Text('POLL',
//                       style: TextStyle(color: Colors.white,
//                           fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
//                   const Spacer(),
//                   if (hasVoted)
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                       decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.2),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: const Text('Voted ✓',
//                           style: TextStyle(color: Colors.white,
//                               fontSize: 9, fontWeight: FontWeight.w700)),
//                     ),
//                 ]),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
//                 child: Text(poll.question,
//                     style: const TextStyle(fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textPrimary, height: 1.3)),
//               ),
//               const SizedBox(height: 8),
//               ...List.generate(poll.options.length, (i) {
//                 final pct = poll.percent(i);
//                 final pctInt = (pct * 100).round();
//                 final isVoted = poll.votedIndex == i;
//                 final isLeading = hasVoted && i == poll.leadingIndex;
//                 return GestureDetector(
//                   onTap: hasVoted ? null : () => _vote(poll, i),
//                   child: Container(
//                     margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
//                     decoration: BoxDecoration(
//                       color: isVoted
//                           ? const Color(0xFFE8F5E9)
//                           : hasVoted
//                               ? const Color(0xFFF5F5F5)
//                               : const Color(0xFFEEF1FB),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: isVoted
//                               ? AppColors.green
//                               : hasVoted
//                                   ? AppColors.border
//                                   : AppColors.primary.withValues(alpha: 0.3)),
//                     ),
//                     child: Stack(children: [
//                       if (hasVoted)
//                         FractionallySizedBox(
//                           widthFactor: pct,
//                           child: Container(
//                             height: 44,
//                             decoration: BoxDecoration(
//                               color: isVoted
//                                   ? AppColors.green.withValues(alpha: 0.15)
//                                   : Colors.grey.withValues(alpha: 0.08),
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 12),
//                         child: Row(children: [
//                           Container(
//                             width: 18, height: 18,
//                             margin: const EdgeInsets.only(right: 8),
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: isVoted ? AppColors.green : Colors.transparent,
//                               border: Border.all(
//                                   color: isVoted
//                                       ? AppColors.green
//                                       : AppColors.primary.withValues(alpha: 0.5),
//                                   width: 2),
//                             ),
//                             child: isVoted
//                                 ? const Icon(Icons.check, size: 11, color: Colors.white)
//                                 : null,
//                           ),
//                           Expanded(
//                             child: Text(poll.options[i].label,
//                                 style: TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: isVoted ? FontWeight.w700 : FontWeight.w500,
//                                     color: isVoted ? AppColors.green : AppColors.textPrimary)),
//                           ),
//                           if (hasVoted)
//                             Text('$pctInt%',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                     color: isLeading
//                                         ? AppColors.primary
//                                         : AppColors.textSecondary))
//                           else
//                             const Icon(Icons.chevron_right,
//                                 size: 16, color: AppColors.textSecondary),
//                         ]),
//                       ),
//                     ]),
//                   ),
//                 );
//               }),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       hasVoted
//                           ? 'Total votes: ${poll.totalVotes}'
//                           : 'Total votes: ${poll.totalVotes} · Tap to vote',
//                       style: const TextStyle(fontSize: 11,
//                           color: AppColors.textSecondary,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     const Text('⚡ Bot',
//                         style: TextStyle(fontSize: 9,
//                             color: AppColors.textSecondary,
//                             fontWeight: FontWeight.w600)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTyping() {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         decoration: BoxDecoration(
//             color: Colors.white, borderRadius: BorderRadius.circular(12)),
//         child: const Text('⚡ Typing...',
//             style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
//       ),
//     );
//   }
// }
































import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../services/app_theme.dart';
import 'polls_provider.dart';
import 'certificate_service.dart';

// ─── Message model ────────────────────────────────────────────────────────────
class _Msg {
  final String text;
  final bool isBot;
  final bool isSystem;
  final bool isError;
  final Poll? poll;
  final bool showCertificate;
  final int? quizScore;
  final String courseTitle;
  final DateTime timestamp;

  _Msg({
    required this.text,
    required this.isBot,
    this.isSystem = false,
    this.isError = false,
    this.poll,
    this.showCertificate = false,
    this.quizScore,
    this.courseTitle = '',
  }) : timestamp = DateTime.now();
}

// ─── YouTube URL helper ───────────────────────────────────────────────────────
class _YT {
  static String? videoId(String url) {
    final patterns = [
      RegExp(r'youtu\.be/([^?&\s]+)'),
      RegExp(r'youtube\.com/watch\?v=([^&\s]+)'),
      RegExp(r'youtube\.com/embed/([^?&\s]+)'),
      RegExp(r'youtube\.com/shorts/([^?&\s]+)'),
    ];
    for (final p in patterns) {
      final m = p.firstMatch(url);
      if (m != null) return m.group(1);
    }
    return null;
  }

  static String thumbnail(String videoId) =>
      'https://img.youtube.com/vi/$videoId/hqdefault.jpg';

  static String watchUrl(String videoId) =>
      'https://www.youtube.com/watch?v=$videoId';

  static List<String> findUrls(String text) {
    final re = RegExp(
        r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
        caseSensitive: false);
    return re.allMatches(text).map((m) => m.group(0)!).toList();
  }

  static String stripUrls(String text) {
    final re = RegExp(
        r'https?://(www\.)?(youtube\.com|youtu\.be)/[^\s]+',
        caseSensitive: false);
    return text.replaceAll(re, '').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
  }
}

// ─── PDF URL helper ──────────────────────────────────────────────────────────
class _PDF {
  static List<String> findUrls(String text) {
    final re = RegExp(
        '(?:\u{1F4C4} \\*?Read:\\*? )(https?://[^\\s]+)',
        caseSensitive: false,
        unicode: true);
    return re.allMatches(text).map((m) => m.group(1)!).toList();
  }

  static String stripUrls(String text) {
    final re = RegExp(
        '\u{1F4C4} \\*?Read:\\*? https?://[^\\s]+',
        caseSensitive: false,
        unicode: true);
    return text
        .replaceAll(re, '')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────
class WhatsAppSimScreen extends StatefulWidget {
  final String? initialMessage; // ← NEW: auto-sent on open
  final String? initialPhone;   // ← NEW: pre-fills phone field

  const WhatsAppSimScreen({
    super.key,
    this.initialMessage,
    this.initialPhone,
  });

  @override
  State<WhatsAppSimScreen> createState() => _WhatsAppSimScreenState();
}

class _WhatsAppSimScreenState extends State<WhatsAppSimScreen> {
  final _phoneCtrl = TextEditingController(text: '9876543210');
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<_Msg> _messages = [];
  bool _sending = false;
  int _pollIndex = 0;

  final _provider = PollsProvider.instance;

  final List<String> _chips = [
    'START', 'MENU', 'HELP', 'QUIZ', 'NEXT', 'PROGRESS',
    'POLL', 'A', 'B', 'C', 'D',
  ];

  @override
  void initState() {
    super.initState();
    _provider.addListener(_onProviderUpdate);

    // ← NEW: pre-fill phone if passed from dashboard
    if (widget.initialPhone != null && widget.initialPhone!.isNotEmpty) {
      _phoneCtrl.text = widget.initialPhone!;
    }

    _messages.add(_Msg(
      text: '📱 WhatsApp Simulation Terminal\n\n'
          'Test your chatbot here. Enter a phone number and send a message.\n\n'
          'Try sending: START\n'
          'YouTube links in modules will show as playable cards! 🎥',
      isBot: true,
      isSystem: true,
    ));

    // ← NEW: auto-send initial message if passed from dashboard
    if (widget.initialMessage != null && widget.initialMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _send(widget.initialMessage!);
      });
    }
  }

  @override
  void dispose() {
    _provider.removeListener(_onProviderUpdate);
    _phoneCtrl.dispose();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onProviderUpdate() => setState(() {});

  void _sendPoll() {
    final polls = _provider.polls;
    final poll = polls[_pollIndex % polls.length];
    _pollIndex++;
    setState(() {
      _messages.add(_Msg(text: 'POLL', isBot: false));
      _messages.add(_Msg(text: '', isBot: true, poll: poll));
    });
    _scrollToBottom();
  }

  void _vote(Poll poll, int index) {
    if (poll.votedIndex != null) return;
    _provider.vote(poll, index);
    setState(() {
      _messages.add(_Msg(
          text: '✅ Voted: ${poll.options[index].label}', isBot: false));
      _messages.add(_Msg(
          text: 'Thanks for voting! 🎉 Your response has been recorded.',
          isBot: true));
    });
    _scrollToBottom();
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _sending) return;

    if (trimmed.toUpperCase() == 'POLL') {
      _msgCtrl.clear();
      _sendPoll();
      return;
    }

    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enter a phone number first')));
      return;
    }

    setState(() {
      _messages.add(_Msg(text: trimmed, isBot: false));
      _sending = true;
    });
    _msgCtrl.clear();
    _scrollToBottom();

    final response = await ApiService.sendWhatsAppMessage(phone, trimmed);

    if (mounted) {
      final scoreMatch = RegExp(r'Score:\s*\*?(\d+)%\*?').firstMatch(response);
      final score = scoreMatch != null ? int.tryParse(scoreMatch.group(1)!) : null;
      final courseMatch = RegExp(r'Quiz:\s*(.+?)\n').firstMatch(response);
      final course = courseMatch?.group(1)?.replaceAll('*', '').trim() ?? '';

      setState(() {
        _messages.add(_Msg(
            text: response,
            isBot: true,
            isError: response.startsWith('❌'),
            showCertificate: score != null && score >= 90,
            quizScore: score,
            courseTitle: course));
        _sending = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.whatsappDark,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: AppColors.whatsapp,
                borderRadius: BorderRadius.circular(18)),
            child: const Center(
                child: Text('AI',
                    style: TextStyle(color: Colors.white,
                        fontWeight: FontWeight.w800, fontSize: 13))),
          ),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Andragogy Bot',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: Colors.white)),
            Text('online',
                style: TextStyle(fontSize: 10, color: Colors.white70)),
          ]),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () => setState(() {
              _messages.clear();
              _pollIndex = 0;
            }),
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Column(children: [
        // ── Phone input ──────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: Colors.white,
          child: Row(children: [
            const Icon(Icons.phone, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Learner phone number (digits only)',
                  hintStyle: TextStyle(fontSize: 12),
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide(color: AppColors.border)),
                ),
              ),
            ),
          ]),
        ),
        const Divider(height: 1, color: AppColors.border),

        // ── Quick chips ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _chips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (_, i) {
                final chip = _chips[i];
                final isAnswer = ['A', 'B', 'C', 'D'].contains(chip);
                final isPoll = chip == 'POLL';
                return GestureDetector(
                  onTap: () => _send(chip),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isPoll
                          ? const Color(0xFFE8F5E9)
                          : isAnswer
                              ? AppColors.primaryLight
                              : Colors.white,
                      border: Border.all(
                          color: isPoll
                              ? AppColors.green
                              : isAnswer
                                  ? AppColors.primary
                                  : AppColors.border),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(chip,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isPoll
                                ? AppColors.green
                                : isAnswer
                                    ? AppColors.primary
                                    : AppColors.textPrimary)),
                  ),
                );
              },
            ),
          ),
        ),

        // ── Messages ─────────────────────────────────────────────────────
        Expanded(
          child: Container(
            color: const Color(0xFFE5DDD5),
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_sending ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _messages.length) return _buildTyping();
                final msg = _messages[i];
                if (msg.poll != null) return _buildPollBubble(msg.poll!);
                return _buildBubble(msg);
              },
            ),
          ),
        ),

        // ── Input bar ────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: const Color(0xFFF0F0F0),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller: _msgCtrl,
                textInputAction: TextInputAction.send,
                onSubmitted: _send,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _send(_msgCtrl.text),
              child: Container(
                width: 44, height: 44,
                decoration: const BoxDecoration(
                    color: AppColors.whatsapp, shape: BoxShape.circle),
                child: const Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  // ── Main bubble builder ───────────────────────────────────────────────────
  Widget _buildBubble(_Msg m) {
    final ytUrls  = m.isBot && !m.isSystem && !m.isError
        ? _YT.findUrls(m.text) : <String>[];
    final pdfUrls = m.isBot && !m.isSystem && !m.isError
        ? _PDF.findUrls(m.text) : <String>[];

    String cleanText = m.text;
    if (ytUrls.isNotEmpty)  cleanText = _YT.stripUrls(cleanText);
    if (pdfUrls.isNotEmpty) cleanText = _PDF.stripUrls(cleanText);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: m.isBot ? Alignment.centerLeft : Alignment.centerRight,
        child: Column(
          crossAxisAlignment:
              m.isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            if (cleanText.isNotEmpty)
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.78),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: m.isError
                      ? AppColors.orangeLight
                      : m.isSystem
                          ? AppColors.primaryLight
                          : m.isBot
                              ? Colors.white
                              : const Color(0xFFD9FDD3),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                    bottomLeft:
                        m.isBot ? Radius.zero : const Radius.circular(12),
                    bottomRight:
                        m.isBot ? const Radius.circular(12) : Radius.zero,
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 1))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cleanText,
                        style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: m.isError
                                ? AppColors.orange
                                : AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(m.timestamp),
                          style: const TextStyle(
                              fontSize: 9,
                              color: AppColors.textSecondary),
                        ),
                        if (!m.isBot) ...[
                          const SizedBox(width: 3),
                          const Text(
                            '✓✓',
                            style: TextStyle(
                                fontSize: 9,
                                color: Color(0xFF4FC3F7),
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

            ...ytUrls.map((url) => _buildYouTubeCard(url)),
            ...pdfUrls.map((url) => _buildPdfCard(url)),

            if (m.showCertificate)
              _buildCertificateCard(m.courseTitle, m.quizScore ?? 0),
          ],
        ),
      ),
    );
  }

  // ── Certificate card ──────────────────────────────────────────────────────
  Widget _buildCertificateCard(String courseTitle, int score) {
    final phone = _phoneCtrl.text.trim();
    final learnerName = 'Learner ($phone)';

    return Container(
      margin: const EdgeInsets.only(top: 8),
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1348D4), Color(0xFF4B3FD8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF1348D4).withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(children: [
        Positioned(top: -20, right: -20,
          child: Container(width: 100, height: 100,
            decoration: BoxDecoration(shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08)))),
        Positioned(bottom: -30, left: -10,
          child: Container(width: 120, height: 120,
            decoration: BoxDecoration(shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05)))),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.verified_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('CERTIFICATE OF COMPLETION',
                      style: TextStyle(color: Colors.white, fontSize: 9,
                          fontWeight: FontWeight.w800, letterSpacing: 1)),
                ])),
              const SizedBox(height: 16),
              const Text('🏆', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 8),
              const Text('Congratulations!',
                  style: TextStyle(color: Colors.white, fontSize: 18,
                      fontWeight: FontWeight.w900, letterSpacing: -0.5)),
              const SizedBox(height: 4),
              Text(learnerName,
                  style: const TextStyle(color: Colors.white70, fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.2)),
              const SizedBox(height: 16),
              const Text('has successfully completed',
                  style: TextStyle(color: Colors.white70, fontSize: 11)),
              const SizedBox(height: 4),
              Text(courseTitle.isNotEmpty ? courseTitle : 'the course',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 16,
                      fontWeight: FontWeight.w800, letterSpacing: -0.3)),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Column(children: [
                  Text('$score%',
                      style: const TextStyle(color: Colors.white,
                          fontSize: 24, fontWeight: FontWeight.w900)),
                  const Text('Final Score',
                      style: TextStyle(color: Colors.white70, fontSize: 10)),
                ]),
                Container(width: 1, height: 40,
                    color: Colors.white.withValues(alpha: 0.2)),
                Column(children: [
                  Text(_formatDate(),
                      style: const TextStyle(color: Colors.white,
                          fontSize: 14, fontWeight: FontWeight.w700)),
                  const Text('Date Issued',
                      style: TextStyle(color: Colors.white70, fontSize: 10)),
                ]),
              ]),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.star_rounded, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text('Excellence Award',
                      style: TextStyle(color: Colors.white, fontSize: 11,
                          fontWeight: FontWeight.w800)),
                ])),
              const SizedBox(height: 8),
              const Text('Issued by Andragogy Learning Platform',
                  style: TextStyle(color: Colors.white54, fontSize: 9)),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => CertificateService.downloadCertificate(
                  learnerName: learnerName,
                  courseTitle: courseTitle.isNotEmpty ? courseTitle : 'the course',
                  score: score,
                  date: _formatDate(),
                  companyName: 'Andragogy Learning Platform',
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.download_rounded, color: Color(0xFF1348D4), size: 18),
                    SizedBox(width: 8),
                    Text('Download Certificate (PDF)',
                        style: TextStyle(color: Color(0xFF1348D4),
                            fontSize: 13, fontWeight: FontWeight.w800)),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  String _formatDate() {
    final now = DateTime.now();
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  // ── YouTube card ─────────────────────────────────────────────────────────
  Widget _buildYouTubeCard(String url) {
    final videoId = _YT.videoId(url);

    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(videoId != null ? _YT.watchUrl(videoId) : url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            videoId != null
                ? Image.network(
                    _YT.thumbnail(videoId),
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _ytPlaceholder(),
                  )
                : _ytPlaceholder(),
            Positioned.fill(
              child: Center(
                child: Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8)
                    ],
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 32),
                ),
              ),
            ),
            Positioned(
              bottom: 8, right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Row(children: [
                  Icon(Icons.play_circle_filled, color: Colors.white, size: 12),
                  SizedBox(width: 4),
                  Text('YouTube',
                      style: TextStyle(color: Colors.white,
                          fontSize: 10, fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(children: [
              const Icon(Icons.play_circle_outline_rounded,
                  color: Colors.red, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Tap to watch video',
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Watch',
                    style: TextStyle(color: Colors.white,
                        fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _ytPlaceholder() {
    return Container(
      width: double.infinity, height: 140,
      color: const Color(0xFF1A1A1A),
      child: const Column(
          mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.play_circle_filled_rounded, color: Colors.red, size: 48),
        SizedBox(height: 6),
        Text('YouTube Video',
            style: TextStyle(color: Colors.white70,
                fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  // ── PDF card ──────────────────────────────────────────────────────────────
  Widget _buildPdfCard(String url) {
    String filename = url.split('/').last.split('?').first;
    if (filename.isEmpty || !filename.contains('.')) filename = 'Document.pdf';
    try { filename = Uri.decodeComponent(filename); } catch (_) {}

    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade100),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                  child: Text('📄', style: TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filename.length > 30
                        ? '${filename.substring(0, 30)}...' : filename,
                    style: const TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 2),
                  const Text('Tap to open PDF document',
                      style: TextStyle(fontSize: 11,
                          color: AppColors.textSecondary)),
                ]),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(20)),
              child: const Text('Open',
                  style: TextStyle(color: Colors.white,
                      fontSize: 11, fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
      ),
    );
  }

  // ── Poll bubble ───────────────────────────────────────────────────────────
  Widget _buildPollBubble(Poll poll) {
    final hasVoted = poll.votedIndex != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 1))
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                color: const Color(0xFF075E54),
                child: Row(children: [
                  const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  const Text('POLL',
                      style: TextStyle(color: Colors.white,
                          fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)),
                  const Spacer(),
                  if (hasVoted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text('Voted ✓',
                          style: TextStyle(color: Colors.white,
                              fontSize: 9, fontWeight: FontWeight.w700)),
                    ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
                child: Text(poll.question,
                    style: const TextStyle(fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary, height: 1.3)),
              ),
              const SizedBox(height: 8),
              ...List.generate(poll.options.length, (i) {
                final pct = poll.percent(i);
                final pctInt = (pct * 100).round();
                final isVoted = poll.votedIndex == i;
                final isLeading = hasVoted && i == poll.leadingIndex;
                return GestureDetector(
                  onTap: hasVoted ? null : () => _vote(poll, i),
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                    decoration: BoxDecoration(
                      color: isVoted
                          ? const Color(0xFFE8F5E9)
                          : hasVoted
                              ? const Color(0xFFF5F5F5)
                              : const Color(0xFFEEF1FB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: isVoted
                              ? AppColors.green
                              : hasVoted
                                  ? AppColors.border
                                  : AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Stack(children: [
                      if (hasVoted)
                        FractionallySizedBox(
                          widthFactor: pct,
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: isVoted
                                  ? AppColors.green.withValues(alpha: 0.15)
                                  : Colors.grey.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 12),
                        child: Row(children: [
                          Container(
                            width: 18, height: 18,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isVoted ? AppColors.green : Colors.transparent,
                              border: Border.all(
                                  color: isVoted
                                      ? AppColors.green
                                      : AppColors.primary.withValues(alpha: 0.5),
                                  width: 2),
                            ),
                            child: isVoted
                                ? const Icon(Icons.check, size: 11, color: Colors.white)
                                : null,
                          ),
                          Expanded(
                            child: Text(poll.options[i].label,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isVoted ? FontWeight.w700 : FontWeight.w500,
                                    color: isVoted ? AppColors.green : AppColors.textPrimary)),
                          ),
                          if (hasVoted)
                            Text('$pctInt%',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isLeading
                                        ? AppColors.primary
                                        : AppColors.textSecondary))
                          else
                            const Icon(Icons.chevron_right,
                                size: 16, color: AppColors.textSecondary),
                        ]),
                      ),
                    ]),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hasVoted
                          ? 'Total votes: ${poll.totalVotes}'
                          : 'Total votes: ${poll.totalVotes} · Tap to vote',
                      style: const TextStyle(fontSize: 11,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500),
                    ),
                    const Text('⚡ Bot',
                        style: TextStyle(fontSize: 9,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTyping() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: const Text('⚡ Typing...',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ),
    );
  }
}