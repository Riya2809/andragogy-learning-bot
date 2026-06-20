// import 'package:flutter/material.dart';
// import '../services/app_theme.dart';

// // ─── Poll data model ──────────────────────────────────────────────────────────
// class PollOption {
//   final String label;
//   int votes;
//   PollOption({required this.label, required this.votes});
// }

// class Poll {
//   final String question;
//   final List<PollOption> options;
//   int? votedIndex; // null = not voted yet

//   Poll({required this.question, required this.options, this.votedIndex});

//   int get totalVotes => options.fold(0, (s, o) => s + o.votes);

//   double percent(int index) {
//     final total = totalVotes;
//     if (total == 0) return 0;
//     return options[index].votes / total;
//   }
// }

// // ─── Screen ───────────────────────────────────────────────────────────────────
// class PollsScreen extends StatefulWidget {
//   const PollsScreen({super.key});

//   @override
//   State<PollsScreen> createState() => _PollsScreenState();
// }

// class _PollsScreenState extends State<PollsScreen> {
//   // Sample polls — replace with API data as needed
//   final List<Poll> _polls = [
//     Poll(
//       question: 'What time works best for live sessions?',
//       options: [
//         PollOption(label: 'Morning (9–11 AM)', votes: 12),
//         PollOption(label: 'Afternoon (2–4 PM)', votes: 28),
//         PollOption(label: 'Evening (7–9 PM)', votes: 35),
//       ],
//     ),
//     Poll(
//       question: 'Which learning format do you prefer?',
//       options: [
//         PollOption(label: 'Video lessons', votes: 40),
//         PollOption(label: 'Text + exercises', votes: 18),
//         PollOption(label: 'Live workshops', votes: 22),
//       ],
//     ),
//     Poll(
//       question: 'How often should we send course updates?',
//       options: [
//         PollOption(label: 'Daily', votes: 10),
//         PollOption(label: 'Every 2–3 days', votes: 33),
//         PollOption(label: 'Weekly', votes: 20),
//       ],
//     ),
//   ];

//   void _vote(Poll poll, int optionIndex) {
//     if (poll.votedIndex != null) return; // already voted
//     setState(() {
//       poll.options[optionIndex].votes++;
//       poll.votedIndex = optionIndex;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text('Polls',
//             style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w900,
//                 color: AppColors.primaryDark,
//                 letterSpacing: -0.8)),
//         bottom: const PreferredSize(
//             preferredSize: Size.fromHeight(1),
//             child: Divider(height: 1, color: AppColors.border)),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Section header
//           const Text('Active Polls',
//               style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w800,
//                   color: AppColors.textPrimary,
//                   letterSpacing: -0.3)),
//           const SizedBox(height: 12),

//           // Poll cards
//           ..._polls.map((poll) => _PollCard(
//                 poll: poll,
//                 onVote: (i) => _vote(poll, i),
//               )),
//         ],
//       ),
//     );
//   }
// }

// // ─── Poll card widget ─────────────────────────────────────────────────────────
// class _PollCard extends StatelessWidget {
//   final Poll poll;
//   final void Function(int) onVote;

//   const _PollCard({required this.poll, required this.onVote});

//   @override
//   Widget build(BuildContext context) {
//     final hasVoted = poll.votedIndex != null;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.border),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Question
//           Text(poll.question,
//               style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textPrimary,
//                   letterSpacing: -0.2)),

//           const SizedBox(height: 14),

//           // Options
//           ...List.generate(poll.options.length, (i) {
//             final option = poll.options[i];
//             final pct = poll.percent(i);
//             final pctInt = (pct * 100).round();
//             final isVoted = poll.votedIndex == i;
//             final isWinner = hasVoted &&
//                 poll.options[i].votes ==
//                     poll.options
//                         .map((o) => o.votes)
//                         .reduce((a, b) => a > b ? a : b);

//             return GestureDetector(
//               onTap: hasVoted ? null : () => onVote(i),
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 14),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Label + percentage
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(option.label,
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: isVoted
//                                       ? FontWeight.w700
//                                       : FontWeight.w500,
//                                   color: isVoted
//                                       ? AppColors.primary
//                                       : AppColors.textPrimary)),
//                         ),
//                         if (hasVoted)
//                           Text('$pctInt%',
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w700,
//                                   color: isWinner
//                                       ? AppColors.primary
//                                       : AppColors.textSecondary)),
//                       ],
//                     ),

//                     const SizedBox(height: 6),

//                     // Progress bar
//                     hasVoted
//                         ? _AnimatedBar(value: pct, isVoted: isVoted)
//                         : _TapBar(isVoted: false),
//                   ],
//                 ),
//               ),
//             );
//           }),

//           // Footer
//           Text(
//             hasVoted
//                 ? 'Total votes: ${poll.totalVotes}'
//                 : 'Total votes: ${poll.totalVotes} · Tap to vote',
//             style: const TextStyle(
//                 fontSize: 11,
//                 color: AppColors.textSecondary,
//                 fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Animated result bar ──────────────────────────────────────────────────────
// class _AnimatedBar extends StatefulWidget {
//   final double value;
//   final bool isVoted;
//   const _AnimatedBar({required this.value, required this.isVoted});

//   @override
//   State<_AnimatedBar> createState() => _AnimatedBarState();
// }

// class _AnimatedBarState extends State<_AnimatedBar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _anim;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 700));
//     _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
//     _ctrl.forward();
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _anim,
//       builder: (_, __) => ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: LinearProgressIndicator(
//           value: widget.value * _anim.value,
//           minHeight: 8,
//           backgroundColor: const Color(0xFFEEF1FB),
//           valueColor: AlwaysStoppedAnimation<Color>(
//             widget.isVoted
//                 ? AppColors.primary
//                 : const Color(0xFF6B7AE8),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─── Pre-vote empty bar ───────────────────────────────────────────────────────
// class _TapBar extends StatelessWidget {
//   final bool isVoted;
//   const _TapBar({required this.isVoted});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(6),
//       child: LinearProgressIndicator(
//         value: 0,
//         minHeight: 8,
//         backgroundColor: const Color(0xFFEEF1FB),
//         valueColor:
//             const AlwaysStoppedAnimation<Color>(AppColors.primary),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import '../services/app_theme.dart';
// import 'polls_provider.dart';

// class PollsScreen extends StatefulWidget {
//   const PollsScreen({super.key});

//   @override
//   State<PollsScreen> createState() => _PollsScreenState();
// }

// class _PollsScreenState extends State<PollsScreen> {
//   final _provider = PollsProvider.instance;

//   @override
//   void initState() {
//     super.initState();
//     // Rebuild this screen whenever a vote happens anywhere
//     _provider.addListener(_onPollUpdate);
//   }

//   @override
//   void dispose() {
//     _provider.removeListener(_onPollUpdate);
//     super.dispose();
//   }

//   void _onPollUpdate() => setState(() {});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text('Polls',
//             style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w900,
//                 color: AppColors.primaryDark,
//                 letterSpacing: -0.8)),
//         bottom: const PreferredSize(
//             preferredSize: Size.fromHeight(1),
//             child: Divider(height: 1, color: AppColors.border)),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text('Active Polls',
//                   style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w800,
//                       color: AppColors.textPrimary,
//                       letterSpacing: -0.3)),
//               // Live indicator
//               Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE8F5E9),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(children: [
//                   Container(
//                       width: 6,
//                       height: 6,
//                       decoration: const BoxDecoration(
//                           color: AppColors.green, shape: BoxShape.circle)),
//                   const SizedBox(width: 5),
//                   const Text('Live',
//                       style: TextStyle(
//                           fontSize: 11,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.green)),
//                 ]),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           const Text('Votes update in real-time from WhatsApp responses',
//               style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
//           const SizedBox(height: 14),

//           ..._provider.polls.map((poll) => _PollCard(
//                 poll: poll,
//                 onVote: (i) => _provider.vote(poll, i),
//               )),
//         ],
//       ),
//     );
//   }
// }

// // ─── Poll card ────────────────────────────────────────────────────────────────
// class _PollCard extends StatelessWidget {
//   final Poll poll;
//   final void Function(int) onVote;

//   const _PollCard({required this.poll, required this.onVote});

//   @override
//   Widget build(BuildContext context) {
//     final hasVoted = poll.votedIndex != null;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.border),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header: question + voted badge
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Expanded(
//                 child: Text(poll.question,
//                     style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textPrimary,
//                         letterSpacing: -0.2)),
//               ),
//               if (hasVoted)
//                 Container(
//                   margin: const EdgeInsets.only(left: 8, top: 2),
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 8, vertical: 3),
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE8F5E9),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: const Text('Voted ✓',
//                       style: TextStyle(
//                           fontSize: 10,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.green)),
//                 ),
//             ],
//           ),

//           const SizedBox(height: 14),

//           // Options
//           ...List.generate(poll.options.length, (i) {
//             final option = poll.options[i];
//             final pct = poll.percent(i);
//             final pctInt = (pct * 100).round();
//             final isVoted = poll.votedIndex == i;
//             final isLeading = hasVoted && i == poll.leadingIndex;

//             return GestureDetector(
//               onTap: hasVoted ? null : () => onVote(i),
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 14),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(children: [
//                           // Dot indicator
//                           if (hasVoted)
//                             Container(
//                               width: 14,
//                               height: 14,
//                               margin: const EdgeInsets.only(right: 6),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: isVoted
//                                     ? AppColors.primary
//                                     : Colors.transparent,
//                                 border: Border.all(
//                                     color: isVoted
//                                         ? AppColors.primary
//                                         : AppColors.border,
//                                     width: 2),
//                               ),
//                               child: isVoted
//                                   ? const Icon(Icons.check,
//                                       size: 9, color: Colors.white)
//                                   : null,
//                             ),
//                           Text(option.label,
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: isVoted
//                                       ? FontWeight.w700
//                                       : FontWeight.w500,
//                                   color: isVoted
//                                       ? AppColors.primary
//                                       : AppColors.textPrimary)),
//                         ]),
//                         if (hasVoted)
//                           Text('$pctInt%',
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w700,
//                                   color: isLeading
//                                       ? AppColors.primary
//                                       : AppColors.textSecondary)),
//                       ],
//                     ),

//                     const SizedBox(height: 6),

//                     hasVoted
//                         ? _AnimatedBar(
//                             value: pct,
//                             isVoted: isVoted,
//                             isLeading: isLeading,
//                           )
//                         : _EmptyBar(),
//                   ],
//                 ),
//               ),
//             );
//           }),

//           // Footer
//           Text(
//             hasVoted
//                 ? 'Total votes: ${poll.totalVotes}'
//                 : 'Total votes: ${poll.totalVotes} · Tap to vote',
//             style: const TextStyle(
//                 fontSize: 11,
//                 color: AppColors.textSecondary,
//                 fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Animated bar ─────────────────────────────────────────────────────────────
// class _AnimatedBar extends StatefulWidget {
//   final double value;
//   final bool isVoted;
//   final bool isLeading;
//   const _AnimatedBar(
//       {required this.value,
//       required this.isVoted,
//       required this.isLeading});

//   @override
//   State<_AnimatedBar> createState() => _AnimatedBarState();
// }

// class _AnimatedBarState extends State<_AnimatedBar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _anim;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 700));
//     _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
//     _ctrl.forward();
//   }

//   @override
//   void didUpdateWidget(_AnimatedBar old) {
//     super.didUpdateWidget(old);
//     // Re-animate if value changed (e.g. new vote from WhatsApp)
//     if (old.value != widget.value) {
//       _ctrl.forward(from: 0);
//     }
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _anim,
//       builder: (_, __) => ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: LinearProgressIndicator(
//           value: widget.value * _anim.value,
//           minHeight: 8,
//           backgroundColor: const Color(0xFFEEF1FB),
//           valueColor: AlwaysStoppedAnimation<Color>(
//             widget.isVoted
//                 ? AppColors.primary
//                 : widget.isLeading
//                     ? const Color(0xFF6B7AE8)
//                     : AppColors.border,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _EmptyBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(6),
//       child: const LinearProgressIndicator(
//         value: 0,
//         minHeight: 8,
//         backgroundColor: Color(0xFFEEF1FB),
//         valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import '../services/app_theme.dart';
// import 'polls_provider.dart';

// class PollsScreen extends StatefulWidget {
//   const PollsScreen({super.key});

//   @override
//   State<PollsScreen> createState() => _PollsScreenState();
// }

// class _PollsScreenState extends State<PollsScreen> {
//   final _provider = PollsProvider.instance;

//   @override
//   void initState() {
//     super.initState();
//     _provider.addListener(_onPollUpdate);
//   }

//   @override
//   void dispose() {
//     _provider.removeListener(_onPollUpdate);
//     super.dispose();
//   }

//   void _onPollUpdate() => setState(() {});

//   void _showCreatePoll() {
//     final questionCtrl = TextEditingController();
//     final List<TextEditingController> optionCtrls = [
//       TextEditingController(),
//       TextEditingController(),
//     ];

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => StatefulBuilder(
//         builder: (ctx, ss) => Padding(
//           padding: EdgeInsets.only(
//             left: 20, right: 20, top: 24,
//             bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header
//                 Row(children: [
//                   const Text('Create Poll',
//                       style: TextStyle(
//                           fontSize: 20, fontWeight: FontWeight.w800)),
//                   const Spacer(),
//                   IconButton(
//                       onPressed: () => Navigator.pop(ctx),
//                       icon: const Icon(Icons.close)),
//                 ]),
//                 const SizedBox(height: 4),
//                 const Text('Ask your learners a question',
//                     style: TextStyle(
//                         fontSize: 13, color: AppColors.textSecondary)),
//                 const SizedBox(height: 20),

//                 // Question
//                 const Text('Poll Question',
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textSecondary)),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: questionCtrl,
//                   maxLines: 2,
//                   textCapitalization: TextCapitalization.sentences,
//                   decoration: const InputDecoration(
//                     hintText: 'e.g. What time works best for live sessions?',
//                     alignLabelWithHint: true,
//                   ),
//                 ),
//                 const SizedBox(height: 20),

//                 // Options
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Options',
//                         style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.textSecondary)),
//                     if (optionCtrls.length < 5)
//                       GestureDetector(
//                         onTap: () =>
//                             ss(() => optionCtrls.add(TextEditingController())),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10, vertical: 4),
//                           decoration: BoxDecoration(
//                               color: AppColors.primaryLight,
//                               borderRadius: BorderRadius.circular(20)),
//                           child: const Row(children: [
//                             Icon(Icons.add, size: 14, color: AppColors.primary),
//                             SizedBox(width: 4),
//                             Text('Add Option',
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                     color: AppColors.primary)),
//                           ]),
//                         ),
//                       ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),

//                 ...List.generate(optionCtrls.length, (i) => Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Row(children: [
//                     Container(
//                       width: 28,
//                       height: 28,
//                       decoration: BoxDecoration(
//                           color: AppColors.primaryLight,
//                           borderRadius: BorderRadius.circular(8)),
//                       child: Center(
//                           child: Text('${i + 1}',
//                               style: const TextStyle(
//                                   fontWeight: FontWeight.w800,
//                                   color: AppColors.primary,
//                                   fontSize: 12))),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: TextField(
//                         controller: optionCtrls[i],
//                         textCapitalization: TextCapitalization.sentences,
//                         decoration: InputDecoration(
//                             hintText: 'Option ${i + 1}'),
//                       ),
//                     ),
//                     if (optionCtrls.length > 2)
//                       IconButton(
//                         onPressed: () => ss(() => optionCtrls.removeAt(i)),
//                         icon: const Icon(Icons.remove_circle_outline,
//                             size: 20, color: AppColors.textSecondary),
//                         padding: EdgeInsets.zero,
//                         constraints: const BoxConstraints(),
//                       ),
//                   ]),
//                 )),

//                 const SizedBox(height: 16),

//                 // Action buttons
//                 Row(children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                       ),
//                       onPressed: () => Navigator.pop(ctx),
//                       child: const Text('Cancel'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                       ),
//                       onPressed: () {
//                         final question = questionCtrl.text.trim();
//                         final options = optionCtrls
//                             .map((c) => c.text.trim())
//                             .where((s) => s.isNotEmpty)
//                             .toList();
//                         if (question.isEmpty) {
//                           ScaffoldMessenger.of(ctx).showSnackBar(
//                               const SnackBar(
//                                   content: Text('Please enter a question')));
//                           return;
//                         }
//                         if (options.length < 2) {
//                           ScaffoldMessenger.of(ctx).showSnackBar(
//                               const SnackBar(
//                                   content:
//                                       Text('Please add at least 2 options')));
//                           return;
//                         }
//                         _provider.addPoll(question, options);
//                         Navigator.pop(ctx);
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: const Text('Poll created!'),
//                           backgroundColor: AppColors.green,
//                           behavior: SnackBarBehavior.floating,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           margin: const EdgeInsets.all(12),
//                         ));
//                       },
//                       icon: const Icon(Icons.bar_chart_rounded, size: 16),
//                       label: const Text('Create Poll'),
//                     ),
//                   ),
//                 ]),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _deletePoll(Poll poll) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Delete Poll',
//             style: TextStyle(fontWeight: FontWeight.w800)),
//         content: Text('Delete "${poll.question}"?',
//             style: const TextStyle(color: AppColors.textSecondary)),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel')),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10))),
//             onPressed: () {
//               Navigator.pop(context);
//               _provider.deletePoll(poll.id);
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: const Text('Poll deleted'),
//                 backgroundColor: Colors.red,
//                 behavior: SnackBarBehavior.floating,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 margin: const EdgeInsets.all(12),
//               ));
//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final polls = _provider.polls;
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text('Polls',
//             style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.w900,
//                 color: AppColors.primaryDark,
//                 letterSpacing: -0.8)),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//               ),
//               onPressed: _showCreatePoll,
//               icon: const Icon(Icons.add, size: 16),
//               label: const Text('New Poll',
//                   style: TextStyle(
//                       fontSize: 12, fontWeight: FontWeight.w700)),
//             ),
//           ),
//         ],
//         bottom: const PreferredSize(
//             preferredSize: Size.fromHeight(1),
//             child: Divider(height: 1, color: AppColors.border)),
//       ),
//       body: polls.isEmpty
//           ? Center(
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 const Text('📊', style: TextStyle(fontSize: 48)),
//                 const SizedBox(height: 12),
//                 const Text('No polls yet',
//                     style: TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.w700)),
//                 const SizedBox(height: 4),
//                 const Text('Tap "New Poll" to ask your learners',
//                     style: TextStyle(
//                         color: AppColors.textSecondary, fontSize: 13)),
//                 const SizedBox(height: 16),
//                 ElevatedButton.icon(
//                   onPressed: _showCreatePoll,
//                   icon: const Icon(Icons.add),
//                   label: const Text('Create First Poll'),
//                 ),
//               ]),
//             )
//           : ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('${polls.length} Active Poll${polls.length == 1 ? '' : 's'}',
//                         style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w800,
//                             color: AppColors.textPrimary,
//                             letterSpacing: -0.3)),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFE8F5E9),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Row(children: [
//                         Container(
//                             width: 6,
//                             height: 6,
//                             decoration: const BoxDecoration(
//                                 color: AppColors.green,
//                                 shape: BoxShape.circle)),
//                         const SizedBox(width: 5),
//                         const Text('Live',
//                             style: TextStyle(
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w700,
//                                 color: AppColors.green)),
//                       ]),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 const Text('Votes update in real-time from WhatsApp responses',
//                     style: TextStyle(
//                         fontSize: 11, color: AppColors.textSecondary)),
//                 const SizedBox(height: 14),
//                 ...polls.map((poll) => _PollCard(
//                       poll: poll,
//                       onVote: (i) => _provider.vote(poll, i),
//                       onDelete: () => _deletePoll(poll),
//                     )),
//               ],
//             ),
//     );
//   }
// }

// // ─── Poll card ────────────────────────────────────────────────────────────────
// class _PollCard extends StatelessWidget {
//   final Poll poll;
//   final void Function(int) onVote;
//   final VoidCallback onDelete;

//   const _PollCard({
//     required this.poll,
//     required this.onVote,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final hasVoted = poll.votedIndex != null;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.border),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 2)),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Header: question + badges + delete
//           Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Expanded(
//               child: Text(poll.question,
//                   style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.textPrimary,
//                       letterSpacing: -0.2)),
//             ),
//             const SizedBox(width: 8),
//             if (hasVoted)
//               Container(
//                 margin: const EdgeInsets.only(top: 2),
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 8, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE8F5E9),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: const Text('Voted ✓',
//                     style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.green)),
//               ),
//             const SizedBox(width: 4),
//             GestureDetector(
//               onTap: onDelete,
//               child: const Padding(
//                 padding: EdgeInsets.only(top: 2),
//                 child: Icon(Icons.delete_outline,
//                     size: 18, color: AppColors.textSecondary),
//               ),
//             ),
//           ]),

//           const SizedBox(height: 14),

//           // Options
//           ...List.generate(poll.options.length, (i) {
//             final option = poll.options[i];
//             final pct = poll.percent(i);
//             final pctInt = (pct * 100).round();
//             final isVoted = poll.votedIndex == i;
//             final isLeading = hasVoted && i == poll.leadingIndex;

//             return GestureDetector(
//               onTap: hasVoted ? null : () => onVote(i),
//               child: Padding(
//                 padding: const EdgeInsets.only(bottom: 14),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(children: [
//                           if (hasVoted)
//                             Container(
//                               width: 14,
//                               height: 14,
//                               margin: const EdgeInsets.only(right: 6),
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: isVoted
//                                     ? AppColors.primary
//                                     : Colors.transparent,
//                                 border: Border.all(
//                                     color: isVoted
//                                         ? AppColors.primary
//                                         : AppColors.border,
//                                     width: 2),
//                               ),
//                               child: isVoted
//                                   ? const Icon(Icons.check,
//                                       size: 9, color: Colors.white)
//                                   : null,
//                             ),
//                           Text(option.label,
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: isVoted
//                                       ? FontWeight.w700
//                                       : FontWeight.w500,
//                                   color: isVoted
//                                       ? AppColors.primary
//                                       : AppColors.textPrimary)),
//                         ]),
//                         if (hasVoted)
//                           Text('$pctInt%',
//                               style: TextStyle(
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w700,
//                                   color: isLeading
//                                       ? AppColors.primary
//                                       : AppColors.textSecondary)),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     hasVoted
//                         ? _AnimatedBar(
//                             value: pct,
//                             isVoted: isVoted,
//                             isLeading: isLeading,
//                           )
//                         : _EmptyBar(),
//                   ],
//                 ),
//               ),
//             );
//           }),

//           // Footer
//           Text(
//             hasVoted
//                 ? 'Total votes: ${poll.totalVotes}'
//                 : 'Total votes: ${poll.totalVotes} · Tap to vote',
//             style: const TextStyle(
//                 fontSize: 11,
//                 color: AppColors.textSecondary,
//                 fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Animated bar ─────────────────────────────────────────────────────────────
// class _AnimatedBar extends StatefulWidget {
//   final double value;
//   final bool isVoted;
//   final bool isLeading;
//   const _AnimatedBar(
//       {required this.value,
//       required this.isVoted,
//       required this.isLeading});

//   @override
//   State<_AnimatedBar> createState() => _AnimatedBarState();
// }

// class _AnimatedBarState extends State<_AnimatedBar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _ctrl;
//   late Animation<double> _anim;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 700));
//     _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
//     _ctrl.forward();
//   }

//   @override
//   void didUpdateWidget(_AnimatedBar old) {
//     super.didUpdateWidget(old);
//     if (old.value != widget.value) _ctrl.forward(from: 0);
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _anim,
//       builder: (_, __) => ClipRRect(
//         borderRadius: BorderRadius.circular(6),
//         child: LinearProgressIndicator(
//           value: widget.value * _anim.value,
//           minHeight: 8,
//           backgroundColor: const Color(0xFFEEF1FB),
//           valueColor: AlwaysStoppedAnimation<Color>(
//             widget.isVoted
//                 ? AppColors.primary
//                 : widget.isLeading
//                     ? const Color(0xFF6B7AE8)
//                     : AppColors.border,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _EmptyBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(6),
//       child: const LinearProgressIndicator(
//         value: 0,
//         minHeight: 8,
//         backgroundColor: Color(0xFFEEF1FB),
//         valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
//       ),
//     );
//   }
// }


















import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/app_theme.dart';

class PollsScreen extends StatefulWidget {
  const PollsScreen({super.key});
  @override
  State<PollsScreen> createState() => _PollsScreenState();
}

class _PollsScreenState extends State<PollsScreen> {
  List<dynamic> _polls = [];
  bool _loading = false;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await ApiService.get('/polls');
      if (mounted) setState(() => _polls = r['data'] ?? []);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _delete(String id) async {
    try {
      await ApiService.delete('/polls/$id');
      _load();
      if (mounted) _snack('Poll deleted', AppColors.orange);
    } catch (_) {}
  }

  void _snack(String msg, Color color) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(12)));

  void _showResults(Map<String, dynamic> poll) {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85, maxChildSize: 0.97, minChildSize: 0.5,
        expand: false,
        builder: (_, ctrl) => _PollResultsSheet(poll: poll, scrollController: ctrl)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        title: const Text('Polls', style: TextStyle(fontSize: 18,
          fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _load),
        ],
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border))),
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : RefreshIndicator(
            onRefresh: _load,
            child: _polls.isEmpty
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('📊', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  const Text('No polls yet', style: TextStyle(fontSize: 16,
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  const Text('Create a poll from the Home tab',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ]))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _polls.length,
                  itemBuilder: (_, i) => _PollCard(
                    poll: _polls[i],
                    onTap: () => _showResults(_polls[i]),
                    onDelete: () => _delete(_polls[i]['id'] ?? '')))));
  }
}

// ── Poll card ──────────────────────────────────────────────────
class _PollCard extends StatelessWidget {
  final Map<String, dynamic> poll;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  const _PollCard({required this.poll, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final count     = poll['response_count'] ?? 0;
    final options   = (poll['options'] as List? ?? []);
    final counts    = (poll['counts'] as Map? ?? {});
    final maxCount  = counts.values.fold(0, (int a, b) => (b as int) > a ? b : a);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: const Border(
            left: BorderSide(color: AppColors.primary, width: 4),
            right: BorderSide(color: AppColors.border),
            top: BorderSide(color: AppColors.border),
            bottom: BorderSide(color: AppColors.border)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04),
            blurRadius: 8, offset: const Offset(0, 2))]),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, children: [
            // Header
            Row(children: [
              const Text('📊', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(child: Text(poll['question'] ?? '',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary),
                maxLines: 2, overflow: TextOverflow.ellipsis)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: count > 0 ? AppColors.greenLight : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20)),
                child: Text('$count responses',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                    color: count > 0 ? AppColors.green : AppColors.primary))),
            ]),
            const SizedBox(height: 12),

            // Mini bar chart preview (top 2 options)
            ...options.take(3).map((opt) {
              final c = (counts[opt] ?? 0) as int;
              final pct = maxCount > 0 ? c / maxCount : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(children: [
                  SizedBox(width: 120,
                    child: Text(opt.toString(), style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                      maxLines: 1, overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  Expanded(child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: pct.toDouble(), minHeight: 8,
                      backgroundColor: AppColors.primaryLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary)))),
                  const SizedBox(width: 8),
                  Text('$c', style: const TextStyle(fontSize: 11,
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                ]));
            }),
            if ((options.length) > 3)
              Text('+${options.length - 3} more options',
                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),

            const SizedBox(height: 10),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: poll['multi_select'] == true
                    ? AppColors.amberLight : AppColors.bg,
                  borderRadius: BorderRadius.circular(20)),
                child: Text(
                  poll['multi_select'] == true ? 'Multi-select' : 'Single choice',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                    color: poll['multi_select'] == true
                      ? AppColors.amber : AppColors.textSecondary))),
              const Spacer(),
              GestureDetector(
                onTap: onTap,
                child: const Text('View results →',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                    color: AppColors.primary))),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete_outline,
                  size: 18, color: AppColors.textSecondary)),
            ]),
          ]))));
  }
}

// ── Poll results bottom sheet ──────────────────────────────────
class _PollResultsSheet extends StatelessWidget {
  final Map<String, dynamic> poll;
  final ScrollController scrollController;
  const _PollResultsSheet({required this.poll, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final options  = (poll['options'] as List? ?? []);
    final counts   = (poll['counts'] as Map? ?? {});
    final total    = (poll['response_count'] ?? 0) as int;
    final maxCount = counts.values.fold(0, (int a, b) => (b as int) > a ? b : a);
    final responses = (poll['responses'] as List? ?? []);

    // Sort options by count descending
    final sorted = List<String>.from(options)
      ..sort((a, b) => ((counts[b] ?? 0) as int).compareTo((counts[a] ?? 0) as int));

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      children: [
        // Handle
        Center(child: Container(width: 40, height: 4,
          decoration: BoxDecoration(color: AppColors.border,
            borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 16),

        // Question
        Row(children: [
          const Text('📊', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(child: Text(poll['question'] ?? '',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
              color: AppColors.textPrimary))),
        ]),
        const SizedBox(height: 6),
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: total > 0 ? AppColors.greenLight : AppColors.primaryLight,
              borderRadius: BorderRadius.circular(20)),
            child: Text('$total response${total == 1 ? '' : 's'}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                color: total > 0 ? AppColors.green : AppColors.primary))),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.bg,
              borderRadius: BorderRadius.circular(20),
              border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
            child: Text(
              poll['multi_select'] == true ? 'Multi-select' : 'Single choice',
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary,
                fontWeight: FontWeight.w600))),
        ]),
        const SizedBox(height: 20),

        // Results bars
        const Text('Results', style: TextStyle(fontSize: 15,
          fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        const SizedBox(height: 12),

        if (total == 0)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.bg,
              borderRadius: BorderRadius.circular(12),
              border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
            child: const Center(child: Text('No responses yet',
              style: TextStyle(color: AppColors.textSecondary))))
        else
          ...sorted.map((opt) {
            final c   = (counts[opt] ?? 0) as int;
            final pct = total > 0 ? (c / total * 100) : 0.0;
            final isTop = c == maxCount && c > 0;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isTop ? AppColors.primaryLight : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isTop ? AppColors.primary : AppColors.border,
                  width: isTop ? 1.5 : 1)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, children: [
                Row(children: [
                  if (isTop) ...[
                    const Text('🏆', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                  ],
                  Expanded(child: Text(opt,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                      color: isTop ? AppColors.primary : AppColors.textPrimary))),
                  Text('${pct.toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
                      color: isTop ? AppColors.primary : AppColors.textSecondary)),
                  const SizedBox(width: 8),
                  Text('($c)', style: const TextStyle(fontSize: 12,
                    color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: total > 0 ? c / total : 0.0,
                    minHeight: 10,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isTop ? AppColors.primary : AppColors.textSecondary))),
              ]));
          }),

        // Who responded
        if (responses.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Responses (${responses.length})',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
              color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ...responses.take(10).map((r) {
            final selected = (r['selected'] as List? ?? []).join(', ');
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
              child: Row(children: [
                CircleAvatar(backgroundColor: AppColors.primaryLight, radius: 16,
                  child: Text(
                    (r['name'] ?? 'L').toString().isNotEmpty
                      ? (r['name'] ?? 'L').toString()[0].toUpperCase() : 'L',
                    style: const TextStyle(fontSize: 11,
                      fontWeight: FontWeight.w800, color: AppColors.primary))),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(r['name'] ?? 'Learner',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
                  Text(r['phone_number'] ?? '',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20)),
                  child: Text(selected,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
              ]));
          }),
          if (responses.length > 10)
            Center(child: Text('+${responses.length - 10} more responses',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
        ],
        const SizedBox(height: 24),
      ]);
  }
}