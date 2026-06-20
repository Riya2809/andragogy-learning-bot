
// import 'package:flutter/material.dart';
// import '../services/app_theme.dart';
// import '../models/alert_store.dart';

// class AlertsScreen extends StatefulWidget {
//   final VoidCallback? onOpenWhatsApp;
//   const AlertsScreen({super.key, this.onOpenWhatsApp});

//   @override
//   State<AlertsScreen> createState() => _AlertsScreenState();
// }

// class _AlertsScreenState extends State<AlertsScreen> {
//   final _store = AlertStore.instance;

//   static const _emojis = [
//     '📢', '⏰', '🏆', '📗', '👥', '🎓', '💡', '🚨',
//     '✅', '📌', '🔔', '📝', '🌟', '⚡', '🎯', '💬',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _store.addListener(_onStoreChanged);
//   }

//   @override
//   void dispose() {
//     _store.removeListener(_onStoreChanged);
//     super.dispose();
//   }

//   void _onStoreChanged() => setState(() {});

//   // ── View Details bottom sheet ─────────────────────────────
//   void _showDetails(AppAlert alert) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => Padding(
//         padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Handle bar
//             Center(
//               child: Container(
//                 width: 40, height: 4,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 decoration: BoxDecoration(
//                     color: AppColors.border,
//                     borderRadius: BorderRadius.circular(2)),
//               ),
//             ),
//             // Emoji + title
//             Row(children: [
//               Container(
//                 width: 48, height: 48,
//                 decoration: BoxDecoration(
//                     color: AppColors.primaryLight,
//                     borderRadius: BorderRadius.circular(14)),
//                 child: Center(child: Text(alert.emoji,
//                     style: const TextStyle(fontSize: 24))),
//               ),
//               const SizedBox(width: 14),
//               Expanded(child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(alert.title,
//                       style: const TextStyle(fontSize: 16,
//                           fontWeight: FontWeight.w800,
//                           color: AppColors.textPrimary)),
//                   const SizedBox(height: 3),
//                   Text(alert.timeAgo,
//                       style: const TextStyle(fontSize: 12,
//                           color: AppColors.textSecondary)),
//                 ],
//               )),
//             ]),
//             const SizedBox(height: 16),
//             const Divider(color: AppColors.border),
//             const SizedBox(height: 12),
//             const Text('Message',
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
//                     color: AppColors.textSecondary)),
//             const SizedBox(height: 8),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                   color: AppColors.bg,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.border)),
//               child: Text(alert.message,
//                   style: const TextStyle(fontSize: 14,
//                       color: AppColors.textPrimary, height: 1.5)),
//             ),
//             const SizedBox(height: 20),
//             // Send via WhatsApp button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1A5C38),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   widget.onOpenWhatsApp?.call();
//                 },
//                 icon: const Icon(Icons.chat_rounded, size: 18),
//                 label: const Text('Send via WhatsApp',
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Close'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCreateAlert() {
//     final titleCtrl = TextEditingController();
//     final messageCtrl = TextEditingController();
//     String selectedEmoji = '📢';

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
//                 Row(children: [
//                   const Text('Create Alert',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
//                   const Spacer(),
//                   IconButton(onPressed: () => Navigator.pop(ctx),
//                       icon: const Icon(Icons.close)),
//                 ]),
//                 const SizedBox(height: 4),
//                 const Text('Send a notification to your learners',
//                     style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
//                 const SizedBox(height: 20),
//                 const Text('Choose Icon',
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
//                         color: AppColors.textSecondary)),
//                 const SizedBox(height: 10),
//                 Wrap(
//                   spacing: 8, runSpacing: 8,
//                   children: _emojis.map((e) => GestureDetector(
//                     onTap: () => ss(() => selectedEmoji = e),
//                     child: Container(
//                       width: 44, height: 44,
//                       decoration: BoxDecoration(
//                         color: selectedEmoji == e ? AppColors.primaryLight : AppColors.bg,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: selectedEmoji == e ? AppColors.primary : AppColors.border,
//                           width: selectedEmoji == e ? 2 : 1,
//                         ),
//                       ),
//                       child: Center(child: Text(e, style: const TextStyle(fontSize: 20))),
//                     ),
//                   )).toList(),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Alert Title',
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
//                         color: AppColors.textSecondary)),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: titleCtrl,
//                   textCapitalization: TextCapitalization.sentences,
//                   decoration: InputDecoration(
//                     hintText: 'e.g. Quiz Deadline Approaching',
//                     prefixIcon: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Text(selectedEmoji, style: const TextStyle(fontSize: 18)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text('Message',
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
//                         color: AppColors.textSecondary)),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: messageCtrl,
//                   maxLines: 3,
//                   textCapitalization: TextCapitalization.sentences,
//                   decoration: const InputDecoration(
//                     hintText: 'Write your alert message for learners...',
//                     alignLabelWithHint: true,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
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
//                         final title = titleCtrl.text.trim();
//                         final message = messageCtrl.text.trim();
//                         if (title.isEmpty || message.isEmpty) {
//                           ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
//                               content: Text('Please fill in title and message')));
//                           return;
//                         }
//                         _store.addAlert(AppAlert(
//                           id: DateTime.now().millisecondsSinceEpoch.toString(),
//                           emoji: selectedEmoji,
//                           title: title,
//                           message: message,
//                           createdAt: DateTime.now(),
//                         ));
//                         Navigator.pop(ctx);
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: const Text('Alert created!'),
//                           backgroundColor: AppColors.green,
//                           behavior: SnackBarBehavior.floating,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           margin: const EdgeInsets.all(12),
//                         ));
//                       },
//                       icon: const Icon(Icons.send_rounded, size: 16),
//                       label: const Text('Post Alert'),
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

//   void _deleteAlert(AppAlert alert) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Delete Alert',
//             style: TextStyle(fontWeight: FontWeight.w800)),
//         content: Text('Are you sure you want to delete "${alert.title}"?',
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
//               _store.deleteAlert(alert.id);
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: const Text('Alert deleted'),
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
//     final alerts = _store.alerts;
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text('Alerts',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900,
//                 color: AppColors.primaryDark, letterSpacing: -0.8)),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 12),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//               ),
//               onPressed: _showCreateAlert,
//               icon: const Icon(Icons.add, size: 16),
//               label: const Text('New Alert',
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
//             ),
//           ),
//         ],
//         bottom: const PreferredSize(
//             preferredSize: Size.fromHeight(1),
//             child: Divider(height: 1, color: AppColors.border)),
//       ),
//       body: alerts.isEmpty
//           ? Center(
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 const Text('🔔', style: TextStyle(fontSize: 48)),
//                 const SizedBox(height: 12),
//                 const Text('No alerts yet',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
//                 const SizedBox(height: 4),
//                 const Text('Tap "New Alert" to notify your learners',
//                     style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
//                 const SizedBox(height: 16),
//                 ElevatedButton.icon(
//                   onPressed: _showCreateAlert,
//                   icon: const Icon(Icons.add),
//                   label: const Text('Create First Alert'),
//                 ),
//               ]),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: alerts.length,
//               itemBuilder: (_, i) => _AlertCard(
//                 alert: alerts[i],
//                 onDelete: () => _deleteAlert(alerts[i]),
//                 onViewDetails: () => _showDetails(alerts[i]),
//                 onSendWhatsApp: () => widget.onOpenWhatsApp?.call(),
//               ),
//             ),
//     );
//   }
// }

// class _AlertCard extends StatelessWidget {
//   final AppAlert alert;
//   final VoidCallback onDelete;
//   final VoidCallback onViewDetails;
//   final VoidCallback onSendWhatsApp;

//   const _AlertCard({
//     required this.alert,
//     required this.onDelete,
//     required this.onViewDetails,
//     required this.onSendWhatsApp,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: AppColors.border),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.03),
//               blurRadius: 6, offset: const Offset(0, 2))
//         ],
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: IntrinsicHeight(
//         child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//           Container(width: 4, color: AppColors.primary),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text(alert.emoji, style: const TextStyle(fontSize: 16)),
//                   const SizedBox(width: 6),
//                   Expanded(child: Text(alert.title,
//                       style: const TextStyle(fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           color: AppColors.textPrimary,
//                           letterSpacing: -0.2))),
//                   const SizedBox(width: 8),
//                   Text(alert.timeAgo,
//                       style: const TextStyle(fontSize: 11,
//                           color: AppColors.textSecondary,
//                           fontWeight: FontWeight.w500)),
//                   const SizedBox(width: 4),
//                   GestureDetector(onTap: onDelete,
//                       child: const Icon(Icons.delete_outline,
//                           size: 18, color: AppColors.textSecondary)),
//                 ]),
//                 const SizedBox(height: 5),
//                 Text(alert.message,
//                     style: const TextStyle(fontSize: 12,
//                         color: AppColors.textSecondary, height: 1.4)),
//                 const SizedBox(height: 10),
//                 Row(children: [
//                   // View Details button
//                   GestureDetector(
//                     onTap: onViewDetails,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                           color: AppColors.primaryLight,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: const Text('View Details',
//                           style: TextStyle(fontSize: 11,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.primary)),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   // Send via WhatsApp button
//                   GestureDetector(
//                     onTap: onSendWhatsApp,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                           color: const Color(0xFF1A5C38).withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(20)),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.chat_rounded,
//                               size: 12, color: Color(0xFF1A5C38)),
//                           SizedBox(width: 4),
//                           Text('Send via WhatsApp',
//                               style: TextStyle(fontSize: 11,
//                                   fontWeight: FontWeight.w700,
//                                   color: Color(0xFF1A5C38))),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ]),
//               ]),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }





















// import 'package:flutter/material.dart';
// import '../services/app_theme.dart';
// import '../models/alert_store.dart';

// class AlertsScreen extends StatefulWidget {
//   final VoidCallback? onOpenWhatsApp;
//   final ScrollController? scrollController; // ← ADDED for bottom sheet use
//   const AlertsScreen({super.key, this.onOpenWhatsApp, this.scrollController});

//   @override
//   State<AlertsScreen> createState() => _AlertsScreenState();
// }

// class _AlertsScreenState extends State<AlertsScreen> {
//   final _store = AlertStore.instance;

//   static const _emojis = [
//     '📢', '⏰', '🏆', '📗', '👥', '🎓', '💡', '🚨',
//     '✅', '📌', '🔔', '📝', '🌟', '⚡', '🎯', '💬',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _store.addListener(_onStoreChanged);
//   }

//   @override
//   void dispose() {
//     _store.removeListener(_onStoreChanged);
//     super.dispose();
//   }

//   void _onStoreChanged() => setState(() {});

//   void _showDetails(AppAlert alert) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => Padding(
//         padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 40, height: 4,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 decoration: BoxDecoration(
//                     color: AppColors.border,
//                     borderRadius: BorderRadius.circular(2)),
//               ),
//             ),
//             Row(children: [
//               Container(
//                 width: 48, height: 48,
//                 decoration: BoxDecoration(
//                     color: AppColors.primaryLight,
//                     borderRadius: BorderRadius.circular(14)),
//                 child: Center(child: Text(alert.emoji,
//                     style: const TextStyle(fontSize: 24))),
//               ),
//               const SizedBox(width: 14),
//               Expanded(child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(alert.title,
//                       style: const TextStyle(fontSize: 16,
//                           fontWeight: FontWeight.w800,
//                           color: AppColors.textPrimary)),
//                   const SizedBox(height: 3),
//                   Text(alert.timeAgo,
//                       style: const TextStyle(fontSize: 12,
//                           color: AppColors.textSecondary)),
//                 ],
//               )),
//             ]),
//             const SizedBox(height: 16),
//             const Divider(color: AppColors.border),
//             const SizedBox(height: 12),
//             const Text('Message',
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
//                     color: AppColors.textSecondary)),
//             const SizedBox(height: 8),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                   color: AppColors.bg,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.border)),
//               child: Text(alert.message,
//                   style: const TextStyle(fontSize: 14,
//                       color: AppColors.textPrimary, height: 1.5)),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1A5C38),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   widget.onOpenWhatsApp?.call();
//                 },
//                 icon: const Icon(Icons.chat_rounded, size: 18),
//                 label: const Text('Send via WhatsApp',
//                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Close'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCreateAlert() {
//     final titleCtrl = TextEditingController();
//     final messageCtrl = TextEditingController();
//     String selectedEmoji = '📢';

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
//                 Row(children: [
//                   const Text('Create Alert',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
//                   const Spacer(),
//                   IconButton(onPressed: () => Navigator.pop(ctx),
//                       icon: const Icon(Icons.close)),
//                 ]),
//                 const SizedBox(height: 4),
//                 const Text('Send a notification to your learners',
//                     style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
//                 const SizedBox(height: 20),
//                 const Text('Choose Icon',
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
//                         color: AppColors.textSecondary)),
//                 const SizedBox(height: 10),
//                 Wrap(
//                   spacing: 8, runSpacing: 8,
//                   children: _emojis.map((e) => GestureDetector(
//                     onTap: () => ss(() => selectedEmoji = e),
//                     child: Container(
//                       width: 44, height: 44,
//                       decoration: BoxDecoration(
//                         color: selectedEmoji == e
//                             ? AppColors.primaryLight : AppColors.bg,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: selectedEmoji == e
//                               ? AppColors.primary : AppColors.border,
//                           width: selectedEmoji == e ? 2 : 1,
//                         ),
//                       ),
//                       child: Center(child: Text(e,
//                           style: const TextStyle(fontSize: 20))),
//                     ),
//                   )).toList(),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Alert Title',
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
//                         color: AppColors.textSecondary)),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: titleCtrl,
//                   textCapitalization: TextCapitalization.sentences,
//                   decoration: InputDecoration(
//                     hintText: 'e.g. Quiz Deadline Approaching',
//                     prefixIcon: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Text(selectedEmoji,
//                           style: const TextStyle(fontSize: 18)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text('Message',
//                     style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
//                         color: AppColors.textSecondary)),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: messageCtrl,
//                   maxLines: 3,
//                   textCapitalization: TextCapitalization.sentences,
//                   decoration: const InputDecoration(
//                     hintText: 'Write your alert message for learners...',
//                     alignLabelWithHint: true,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
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
//                         final title = titleCtrl.text.trim();
//                         final message = messageCtrl.text.trim();
//                         if (title.isEmpty || message.isEmpty) {
//                           ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
//                               content: Text('Please fill in title and message')));
//                           return;
//                         }
//                         _store.addAlert(AppAlert(
//                           id: DateTime.now().millisecondsSinceEpoch.toString(),
//                           emoji: selectedEmoji,
//                           title: title,
//                           message: message,
//                           createdAt: DateTime.now(),
//                         ));
//                         Navigator.pop(ctx);
//                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                           content: const Text('Alert created!'),
//                           backgroundColor: AppColors.green,
//                           behavior: SnackBarBehavior.floating,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           margin: const EdgeInsets.all(12),
//                         ));
//                       },
//                       icon: const Icon(Icons.send_rounded, size: 16),
//                       label: const Text('Post Alert'),
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

//   void _deleteAlert(AppAlert alert) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Delete Alert',
//             style: TextStyle(fontWeight: FontWeight.w800)),
//         content: Text('Are you sure you want to delete "${alert.title}"?',
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
//               _store.deleteAlert(alert.id);
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: const Text('Alert deleted'),
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
//     final alerts = _store.alerts;

//     // ── When used inside bottom sheet, render without Scaffold/AppBar ────────
//     if (widget.scrollController != null) {
//       if (alerts.isEmpty) {
//         return const Center(
//           child: Padding(
//             padding: EdgeInsets.all(32),
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               Text('🔔', style: TextStyle(fontSize: 40)),
//               SizedBox(height: 10),
//               Text('No alerts yet',
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
//               SizedBox(height: 4),
//               Text('Create alerts from the Home screen',
//                   style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
//             ]),
//           ),
//         );
//       }
//       return ListView.builder(
//         controller: widget.scrollController,
//         padding: const EdgeInsets.all(16),
//         itemCount: alerts.length,
//         itemBuilder: (_, i) => _AlertCard(
//           alert: alerts[i],
//           onDelete: () => _deleteAlert(alerts[i]),
//           onViewDetails: () => _showDetails(alerts[i]),
//           onSendWhatsApp: () => widget.onOpenWhatsApp?.call(),
//         ),
//       );
//     }

//     // ── Standalone screen (original behaviour) ───────────────────────────────
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text('Alerts',
//             style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900,
//                 color: AppColors.primaryDark, letterSpacing: -0.8)),
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
//               onPressed: _showCreateAlert,
//               icon: const Icon(Icons.add, size: 16),
//               label: const Text('New Alert',
//                   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
//             ),
//           ),
//         ],
//         bottom: const PreferredSize(
//             preferredSize: Size.fromHeight(1),
//             child: Divider(height: 1, color: AppColors.border)),
//       ),
//       body: alerts.isEmpty
//           ? Center(
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 const Text('🔔', style: TextStyle(fontSize: 48)),
//                 const SizedBox(height: 12),
//                 const Text('No alerts yet',
//                     style:
//                         TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
//                 const SizedBox(height: 4),
//                 const Text('Tap "New Alert" to notify your learners',
//                     style: TextStyle(
//                         color: AppColors.textSecondary, fontSize: 13)),
//                 const SizedBox(height: 16),
//                 ElevatedButton.icon(
//                   onPressed: _showCreateAlert,
//                   icon: const Icon(Icons.add),
//                   label: const Text('Create First Alert'),
//                 ),
//               ]),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: alerts.length,
//               itemBuilder: (_, i) => _AlertCard(
//                 alert: alerts[i],
//                 onDelete: () => _deleteAlert(alerts[i]),
//                 onViewDetails: () => _showDetails(alerts[i]),
//                 onSendWhatsApp: () => widget.onOpenWhatsApp?.call(),
//               ),
//             ),
//     );
//   }
// }

// class _AlertCard extends StatelessWidget {
//   final AppAlert alert;
//   final VoidCallback onDelete;
//   final VoidCallback onViewDetails;
//   final VoidCallback onSendWhatsApp;

//   const _AlertCard({
//     required this.alert,
//     required this.onDelete,
//     required this.onViewDetails,
//     required this.onSendWhatsApp,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: AppColors.border),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withValues(alpha: 0.03),
//               blurRadius: 6,
//               offset: const Offset(0, 2))
//         ],
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: IntrinsicHeight(
//         child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
//           Container(width: 4, color: AppColors.primary),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                   Text(alert.emoji, style: const TextStyle(fontSize: 16)),
//                   const SizedBox(width: 6),
//                   Expanded(
//                       child: Text(alert.title,
//                           style: const TextStyle(fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.textPrimary,
//                               letterSpacing: -0.2))),
//                   const SizedBox(width: 8),
//                   Text(alert.timeAgo,
//                       style: const TextStyle(fontSize: 11,
//                           color: AppColors.textSecondary,
//                           fontWeight: FontWeight.w500)),
//                   const SizedBox(width: 4),
//                   GestureDetector(
//                       onTap: onDelete,
//                       child: const Icon(Icons.delete_outline,
//                           size: 18, color: AppColors.textSecondary)),
//                 ]),
//                 const SizedBox(height: 5),
//                 Text(alert.message,
//                     style: const TextStyle(fontSize: 12,
//                         color: AppColors.textSecondary, height: 1.4)),
//                 const SizedBox(height: 10),
//                 Row(children: [
//                   GestureDetector(
//                     onTap: onViewDetails,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                           color: AppColors.primaryLight,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: const Text('View Details',
//                           style: TextStyle(fontSize: 11,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.primary)),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: onSendWhatsApp,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                           color: const Color(0xFF1A5C38).withValues(alpha: 0.08),
//                           borderRadius: BorderRadius.circular(20)),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.chat_rounded,
//                               size: 12, color: Color(0xFF1A5C38)),
//                           SizedBox(width: 4),
//                           Text('Send via WhatsApp',
//                               style: TextStyle(fontSize: 11,
//                                   fontWeight: FontWeight.w700,
//                                   color: Color(0xFF1A5C38))),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ]),
//               ]),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }































// import 'package:flutter/material.dart';
// import '../services/app_theme.dart';
// import '../models/alert_store.dart';

// class AlertsScreen extends StatefulWidget {
//   final VoidCallback? onOpenWhatsApp;
//   final ScrollController? scrollController;
//   // ↓ NEW: called with (emoji, title, message) when "Send via WhatsApp" tapped
//   final void Function(String emoji, String title, String message)?
//       onSendViaWhatsApp;

//   const AlertsScreen({
//     super.key,
//     this.onOpenWhatsApp,
//     this.scrollController,
//     this.onSendViaWhatsApp,
//   });

//   @override
//   State<AlertsScreen> createState() => _AlertsScreenState();
// }

// class _AlertsScreenState extends State<AlertsScreen> {
//   final _store = AlertStore.instance;

//   static const _emojis = [
//     '📢', '⏰', '🏆', '📗', '👥', '🎓', '💡', '🚨',
//     '✅', '📌', '🔔', '📝', '🌟', '⚡', '🎯', '💬',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _store.addListener(_onStoreChanged);
//   }

//   @override
//   void dispose() {
//     _store.removeListener(_onStoreChanged);
//     super.dispose();
//   }

//   void _onStoreChanged() => setState(() {});

//   // ── "Send via WhatsApp" handler ───────────────────────────────────────────
//   void _handleSendWhatsApp(AppAlert alert) {
//     if (widget.onSendViaWhatsApp != null) {
//       // Use the new callback — switches tab + pre-fills message
//       widget.onSendViaWhatsApp!(alert.emoji, alert.title, alert.message);
//     } else {
//       // Fallback: original behaviour
//       widget.onOpenWhatsApp?.call();
//     }
//   }

//   void _showDetails(AppAlert alert) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => Padding(
//         padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Container(
//                 width: 40, height: 4,
//                 margin: const EdgeInsets.only(bottom: 20),
//                 decoration: BoxDecoration(
//                     color: AppColors.border,
//                     borderRadius: BorderRadius.circular(2)),
//               ),
//             ),
//             Row(children: [
//               Container(
//                 width: 48, height: 48,
//                 decoration: BoxDecoration(
//                     color: AppColors.primaryLight,
//                     borderRadius: BorderRadius.circular(14)),
//                 child: Center(
//                     child: Text(alert.emoji,
//                         style: const TextStyle(fontSize: 24))),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(alert.title,
//                         style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w800,
//                             color: AppColors.textPrimary)),
//                     const SizedBox(height: 3),
//                     Text(alert.timeAgo,
//                         style: const TextStyle(
//                             fontSize: 12,
//                             color: AppColors.textSecondary)),
//                   ],
//                 ),
//               ),
//             ]),
//             const SizedBox(height: 16),
//             const Divider(color: AppColors.border),
//             const SizedBox(height: 12),
//             const Text('Message',
//                 style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w700,
//                     color: AppColors.textSecondary)),
//             const SizedBox(height: 8),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                   color: AppColors.bg,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.border)),
//               child: Text(alert.message,
//                   style: const TextStyle(
//                       fontSize: 14,
//                       color: AppColors.textPrimary,
//                       height: 1.5)),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1A5C38),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _handleSendWhatsApp(alert);
//                 },
//                 icon: const Icon(Icons.chat_rounded, size: 18),
//                 label: const Text('Send via WhatsApp',
//                     style: TextStyle(
//                         fontSize: 14, fontWeight: FontWeight.w700)),
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onPressed: () => Navigator.pop(context),
//                 child: const Text('Close'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCreateAlert() {
//     final titleCtrl   = TextEditingController();
//     final messageCtrl = TextEditingController();
//     String selectedEmoji = '📢';

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
//                 Row(children: [
//                   const Text('Create Alert',
//                       style: TextStyle(
//                           fontSize: 20, fontWeight: FontWeight.w800)),
//                   const Spacer(),
//                   IconButton(
//                       onPressed: () => Navigator.pop(ctx),
//                       icon: const Icon(Icons.close)),
//                 ]),
//                 const SizedBox(height: 4),
//                 const Text('Send a notification to your learners',
//                     style: TextStyle(
//                         fontSize: 13,
//                         color: AppColors.textSecondary)),
//                 const SizedBox(height: 20),
//                 const Text('Choose Icon',
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textSecondary)),
//                 const SizedBox(height: 10),
//                 Wrap(
//                   spacing: 8, runSpacing: 8,
//                   children: _emojis.map((e) => GestureDetector(
//                     onTap: () => ss(() => selectedEmoji = e),
//                     child: Container(
//                       width: 44, height: 44,
//                       decoration: BoxDecoration(
//                         color: selectedEmoji == e
//                             ? AppColors.primaryLight
//                             : AppColors.bg,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                           color: selectedEmoji == e
//                               ? AppColors.primary
//                               : AppColors.border,
//                           width: selectedEmoji == e ? 2 : 1,
//                         ),
//                       ),
//                       child: Center(
//                           child: Text(e,
//                               style:
//                                   const TextStyle(fontSize: 20))),
//                     ),
//                   )).toList(),
//                 ),
//                 const SizedBox(height: 20),
//                 const Text('Alert Title',
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textSecondary)),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: titleCtrl,
//                   textCapitalization: TextCapitalization.sentences,
//                   decoration: InputDecoration(
//                     hintText: 'e.g. Quiz Deadline Approaching',
//                     prefixIcon: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: Text(selectedEmoji,
//                           style: const TextStyle(fontSize: 18)),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text('Message',
//                     style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.textSecondary)),
//                 const SizedBox(height: 8),
//                 TextField(
//                   controller: messageCtrl,
//                   maxLines: 3,
//                   textCapitalization: TextCapitalization.sentences,
//                   decoration: const InputDecoration(
//                     hintText:
//                         'Write your alert message for learners...',
//                     alignLabelWithHint: true,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 Row(children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         padding:
//                             const EdgeInsets.symmetric(vertical: 14),
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
//                         padding:
//                             const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12)),
//                       ),
//                       onPressed: () {
//                         final title   = titleCtrl.text.trim();
//                         final message = messageCtrl.text.trim();
//                         if (title.isEmpty || message.isEmpty) {
//                           ScaffoldMessenger.of(ctx).showSnackBar(
//                               const SnackBar(
//                                   content: Text(
//                                       'Please fill in title and message')));
//                           return;
//                         }
//                         _store.addAlert(AppAlert(
//                           id:        DateTime.now()
//                               .millisecondsSinceEpoch
//                               .toString(),
//                           emoji:     selectedEmoji,
//                           title:     title,
//                           message:   message,
//                           createdAt: DateTime.now(),
//                         ));
//                         Navigator.pop(ctx);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: const Text('Alert created!'),
//                             backgroundColor: AppColors.green,
//                             behavior: SnackBarBehavior.floating,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(10)),
//                             margin: const EdgeInsets.all(12),
//                           ),
//                         );
//                       },
//                       icon: const Icon(Icons.send_rounded, size: 16),
//                       label: const Text('Post Alert'),
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

//   void _deleteAlert(AppAlert alert) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Delete Alert',
//             style: TextStyle(fontWeight: FontWeight.w800)),
//         content: Text(
//             'Are you sure you want to delete "${alert.title}"?',
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
//               _store.deleteAlert(alert.id);
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: const Text('Alert deleted'),
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
//     final alerts = _store.alerts;

//     // ── Bottom-sheet mode (no Scaffold) ─────────────────────────────────────
//     if (widget.scrollController != null) {
//       if (alerts.isEmpty) {
//         return const Center(
//           child: Padding(
//             padding: EdgeInsets.all(32),
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               Text('🔔', style: TextStyle(fontSize: 40)),
//               SizedBox(height: 10),
//               Text('No alerts yet',
//                   style: TextStyle(
//                       fontSize: 15, fontWeight: FontWeight.w700)),
//               SizedBox(height: 4),
//               Text('Create alerts from the Home screen',
//                   style: TextStyle(
//                       color: AppColors.textSecondary, fontSize: 12)),
//             ]),
//           ),
//         );
//       }
//       return ListView.builder(
//         controller: widget.scrollController,
//         padding: const EdgeInsets.all(16),
//         itemCount: alerts.length,
//         itemBuilder: (_, i) => _AlertCard(
//           alert:          alerts[i],
//           onDelete:       () => _deleteAlert(alerts[i]),
//           onViewDetails:  () => _showDetails(alerts[i]),
//           // ↓ wired to the new handler
//           onSendWhatsApp: () => _handleSendWhatsApp(alerts[i]),
//         ),
//       );
//     }

//     // ── Standalone screen ────────────────────────────────────────────────────
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text('Alerts',
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
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 8),
//               ),
//               onPressed: _showCreateAlert,
//               icon: const Icon(Icons.add, size: 16),
//               label: const Text('New Alert',
//                   style: TextStyle(
//                       fontSize: 12, fontWeight: FontWeight.w700)),
//             ),
//           ),
//         ],
//         bottom: const PreferredSize(
//             preferredSize: Size.fromHeight(1),
//             child: Divider(height: 1, color: AppColors.border)),
//       ),
//       body: alerts.isEmpty
//           ? Center(
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 const Text('🔔', style: TextStyle(fontSize: 48)),
//                 const SizedBox(height: 12),
//                 const Text('No alerts yet',
//                     style: TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.w700)),
//                 const SizedBox(height: 4),
//                 const Text('Tap "New Alert" to notify your learners',
//                     style: TextStyle(
//                         color: AppColors.textSecondary,
//                         fontSize: 13)),
//                 const SizedBox(height: 16),
//                 ElevatedButton.icon(
//                   onPressed: _showCreateAlert,
//                   icon: const Icon(Icons.add),
//                   label: const Text('Create First Alert'),
//                 ),
//               ]),
//             )
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: alerts.length,
//               itemBuilder: (_, i) => _AlertCard(
//                 alert:          alerts[i],
//                 onDelete:       () => _deleteAlert(alerts[i]),
//                 onViewDetails:  () => _showDetails(alerts[i]),
//                 onSendWhatsApp: () => _handleSendWhatsApp(alerts[i]),
//               ),
//             ),
//     );
//   }
// }

// // ── Alert card widget ─────────────────────────────────────────────────────────
// class _AlertCard extends StatelessWidget {
//   final AppAlert   alert;
//   final VoidCallback onDelete;
//   final VoidCallback onViewDetails;
//   final VoidCallback onSendWhatsApp;

//   const _AlertCard({
//     required this.alert,
//     required this.onDelete,
//     required this.onViewDetails,
//     required this.onSendWhatsApp,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: AppColors.border),
//         boxShadow: [
//           BoxShadow(
//               color: Colors.black.withValues(alpha: 0.03),
//               blurRadius: 6,
//               offset: const Offset(0, 2))
//         ],
//       ),
//       clipBehavior: Clip.antiAlias,
//       child: IntrinsicHeight(
//         child: Row(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//           Container(width: 4, color: AppColors.primary),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 // Title row
//                 Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                   Text(alert.emoji,
//                       style: const TextStyle(fontSize: 16)),
//                   const SizedBox(width: 6),
//                   Expanded(
//                       child: Text(alert.title,
//                           style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.textPrimary,
//                               letterSpacing: -0.2))),
//                   const SizedBox(width: 8),
//                   Text(alert.timeAgo,
//                       style: const TextStyle(
//                           fontSize: 11,
//                           color: AppColors.textSecondary,
//                           fontWeight: FontWeight.w500)),
//                   const SizedBox(width: 4),
//                   GestureDetector(
//                       onTap: onDelete,
//                       child: const Icon(Icons.delete_outline,
//                           size: 18,
//                           color: AppColors.textSecondary)),
//                 ]),
//                 const SizedBox(height: 5),
//                 Text(alert.message,
//                     style: const TextStyle(
//                         fontSize: 12,
//                         color: AppColors.textSecondary,
//                         height: 1.4)),
//                 const SizedBox(height: 10),

//                 // Action buttons
//                 Row(children: [
//                   // View Details
//                   GestureDetector(
//                     onTap: onViewDetails,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                           color: AppColors.primaryLight,
//                           borderRadius: BorderRadius.circular(20)),
//                       child: const Text('View Details',
//                           style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w700,
//                               color: AppColors.primary)),
//                     ),
//                   ),
//                   const SizedBox(width: 10),

//                   // Send via WhatsApp ← now truly wired
//                   GestureDetector(
//                     onTap: onSendWhatsApp,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       decoration: BoxDecoration(
//                           color: const Color(0xFF1A5C38)
//                               .withValues(alpha: 0.08),
//                           borderRadius: BorderRadius.circular(20)),
//                       child: const Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(Icons.chat_rounded,
//                               size: 12, color: Color(0xFF1A5C38)),
//                           SizedBox(width: 4),
//                           Text('Send via WhatsApp',
//                               style: TextStyle(
//                                   fontSize: 11,
//                                   fontWeight: FontWeight.w700,
//                                   color: Color(0xFF1A5C38))),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ]),
//               ]),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }


















// import 'package:flutter/material.dart';
// import '../services/app_theme.dart';
// import '../models/alert_store.dart';

// // ── Bell icon for AppBar ──────────────────────────────────────
// class AlertBell extends StatefulWidget {
//   const AlertBell({super.key});
//   @override
//   State<AlertBell> createState() => _AlertBellState();
// }

// class _AlertBellState extends State<AlertBell> {
//   final _store = AlertStore.instance;

//   @override
//   void initState() {
//     super.initState();
//     _store.addListener(_rebuild);
//   }

//   @override
//   void dispose() {
//     _store.removeListener(_rebuild);
//     super.dispose();
//   }

//   void _rebuild() => setState(() {});

//   @override
//   Widget build(BuildContext context) {
//     final unread = _store.alerts.length;
//     return GestureDetector(
//       onTap: () => showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         backgroundColor: Colors.white,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//         builder: (_) => DraggableScrollableSheet(
//           initialChildSize: 0.75,
//           maxChildSize: 0.95,
//           minChildSize: 0.4,
//           expand: false,
//           builder: (_, ctrl) => AlertsScreen(scrollController: ctrl))),
//       child: Stack(children: [
//         const Padding(
//           padding: EdgeInsets.all(8),
//           child: Icon(Icons.notifications_outlined,
//             color: AppColors.textPrimary, size: 24)),
//         if (unread > 0)
//           Positioned(top: 4, right: 4,
//             child: Container(
//               width: 16, height: 16,
//               decoration: const BoxDecoration(
//                 color: Colors.red, shape: BoxShape.circle),
//               child: Center(child: Text(
//                 unread > 9 ? '9+' : '$unread',
//                 style: const TextStyle(color: Colors.white,
//                   fontSize: 9, fontWeight: FontWeight.w800))))),
//       ]));
//   }
// }

// // ── Main alerts screen ────────────────────────────────────────
// class AlertsScreen extends StatefulWidget {
//   final VoidCallback? onOpenWhatsApp;
//   final ScrollController? scrollController;
//   final void Function(String emoji, String title, String message)?
//       onSendViaWhatsApp;

//   const AlertsScreen({
//     super.key,
//     this.onOpenWhatsApp,
//     this.scrollController,
//     this.onSendViaWhatsApp,
//   });

//   @override
//   State<AlertsScreen> createState() => _AlertsScreenState();
// }

// class _AlertsScreenState extends State<AlertsScreen> {
//   final _store = AlertStore.instance;

//   static const _emojis = [
//     '📢', '⏰', '🏆', '📗', '👥', '🎓', '💡', '🚨',
//     '✅', '📌', '🔔', '📝', '🌟', '⚡', '🎯', '💬',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _store.addListener(_onStoreChanged);
//   }

//   @override
//   void dispose() {
//     _store.removeListener(_onStoreChanged);
//     super.dispose();
//   }

//   void _onStoreChanged() => setState(() {});

//   void _handleSendWhatsApp(AppAlert alert) {
//     if (widget.onSendViaWhatsApp != null) {
//       widget.onSendViaWhatsApp!(alert.emoji, alert.title, alert.message);
//     } else {
//       widget.onOpenWhatsApp?.call();
//     }
//   }

//   void _showDetails(AppAlert alert) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => Padding(
//         padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
//         child: Column(mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Center(child: Container(width: 40, height: 4,
//             margin: const EdgeInsets.only(bottom: 20),
//             decoration: BoxDecoration(color: AppColors.border,
//               borderRadius: BorderRadius.circular(2)))),
//           Row(children: [
//             Container(width: 48, height: 48,
//               decoration: BoxDecoration(color: AppColors.primaryLight,
//                 borderRadius: BorderRadius.circular(14)),
//               child: Center(child: Text(alert.emoji,
//                 style: const TextStyle(fontSize: 24)))),
//             const SizedBox(width: 14),
//             Expanded(child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(alert.title, style: const TextStyle(fontSize: 16,
//                 fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
//               const SizedBox(height: 3),
//               Text(alert.timeAgo, style: const TextStyle(
//                 fontSize: 12, color: AppColors.textSecondary)),
//             ])),
//           ]),
//           const SizedBox(height: 16),
//           const Divider(color: AppColors.border),
//           const SizedBox(height: 12),
//           const Text('Message', style: TextStyle(fontSize: 12,
//             fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
//           const SizedBox(height: 8),
//           Container(width: double.infinity,
//             padding: const EdgeInsets.all(14),
//             decoration: BoxDecoration(color: AppColors.bg,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: AppColors.border)),
//             child: Text(alert.message, style: const TextStyle(
//               fontSize: 14, color: AppColors.textPrimary, height: 1.5))),
//           const SizedBox(height: 20),
//           SizedBox(width: double.infinity,
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF1A5C38),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12))),
//               onPressed: () {
//                 Navigator.pop(context);
//                 _handleSendWhatsApp(alert);
//               },
//               icon: const Icon(Icons.chat_rounded, size: 18),
//               label: const Text('Send via WhatsApp',
//                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)))),
//           const SizedBox(height: 10),
//           SizedBox(width: double.infinity,
//             child: OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12))),
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Close'))),
//         ])));
//   }

//   void _showCreateAlert() {
//     final titleCtrl   = TextEditingController();
//     final messageCtrl = TextEditingController();
//     String selectedEmoji = '📢';

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => StatefulBuilder(
//         builder: (ctx, ss) => Padding(
//           padding: EdgeInsets.only(
//             left: 20, right: 20, top: 24,
//             bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
//           child: SingleChildScrollView(child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Row(children: [
//               const Text('Create Alert', style: TextStyle(
//                 fontSize: 20, fontWeight: FontWeight.w800)),
//               const Spacer(),
//               IconButton(onPressed: () => Navigator.pop(ctx),
//                 icon: const Icon(Icons.close)),
//             ]),
//             const SizedBox(height: 4),
//             const Text('Send a notification to your learners',
//               style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
//             const SizedBox(height: 20),
//             const Text('Choose Icon', style: TextStyle(fontSize: 13,
//               fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
//             const SizedBox(height: 10),
//             Wrap(spacing: 8, runSpacing: 8,
//               children: _emojis.map((e) => GestureDetector(
//                 onTap: () => ss(() => selectedEmoji = e),
//                 child: Container(width: 44, height: 44,
//                   decoration: BoxDecoration(
//                     color: selectedEmoji == e
//                       ? AppColors.primaryLight : AppColors.bg,
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: selectedEmoji == e
//                         ? AppColors.primary : AppColors.border,
//                       width: selectedEmoji == e ? 2 : 1)),
//                   child: Center(child: Text(e,
//                     style: const TextStyle(fontSize: 20)))))).toList()),
//             const SizedBox(height: 20),
//             const Text('Alert Title', style: TextStyle(fontSize: 13,
//               fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
//             const SizedBox(height: 8),
//             TextField(controller: titleCtrl,
//               textCapitalization: TextCapitalization.sentences,
//               decoration: InputDecoration(
//                 hintText: 'e.g. Quiz Deadline Approaching',
//                 prefixIcon: Padding(padding: const EdgeInsets.all(12),
//                   child: Text(selectedEmoji,
//                     style: const TextStyle(fontSize: 18))))),
//             const SizedBox(height: 16),
//             const Text('Message', style: TextStyle(fontSize: 13,
//               fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
//             const SizedBox(height: 8),
//             TextField(controller: messageCtrl, maxLines: 3,
//               textCapitalization: TextCapitalization.sentences,
//               decoration: const InputDecoration(
//                 hintText: 'Write your alert message for learners...',
//                 alignLabelWithHint: true)),
//             const SizedBox(height: 24),
//             Row(children: [
//               Expanded(child: OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12))),
//                 onPressed: () => Navigator.pop(ctx),
//                 child: const Text('Cancel'))),
//               const SizedBox(width: 12),
//               Expanded(child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12))),
//                 onPressed: () {
//                   final t = titleCtrl.text.trim();
//                   final m = messageCtrl.text.trim();
//                   if (t.isEmpty || m.isEmpty) {
//                     ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
//                       content: Text('Please fill in title and message')));
//                     return;
//                   }
//                   _store.addAlert(AppAlert(
//                     id: DateTime.now().millisecondsSinceEpoch.toString(),
//                     emoji: selectedEmoji,
//                     title: t, message: m,
//                     createdAt: DateTime.now()));
//                   Navigator.pop(ctx);
//                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                     content: const Text('Alert created!'),
//                     backgroundColor: AppColors.green,
//                     behavior: SnackBarBehavior.floating,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                     margin: const EdgeInsets.all(12)));
//                 },
//                 icon: const Icon(Icons.send_rounded, size: 16),
//                 label: const Text('Post Alert'))),
//             ]),
//           ])))));
//   }

//   void _deleteAlert(AppAlert alert) {
//     showDialog(context: context,
//       builder: (_) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text('Delete Alert',
//           style: TextStyle(fontWeight: FontWeight.w800)),
//         content: Text('Are you sure you want to delete "${alert.title}"?',
//           style: const TextStyle(color: AppColors.textSecondary)),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel')),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10))),
//             onPressed: () {
//               Navigator.pop(context);
//               _store.deleteAlert(alert.id);
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                 content: const Text('Alert deleted'),
//                 backgroundColor: Colors.red,
//                 behavior: SnackBarBehavior.floating,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//                 margin: const EdgeInsets.all(12)));
//             },
//             child: const Text('Delete')),
//         ]));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final alerts = _store.alerts;

//     if (widget.scrollController != null) {
//       if (alerts.isEmpty) {
//         return const Center(child: Padding(
//           padding: EdgeInsets.all(32),
//           child: Column(mainAxisSize: MainAxisSize.min, children: [
//             Text('🔔', style: TextStyle(fontSize: 40)),
//             SizedBox(height: 10),
//             Text('No alerts yet',
//               style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
//             SizedBox(height: 4),
//             Text('Create alerts from the Home screen',
//               style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
//           ])));
//       }
//       return ListView.builder(
//         controller: widget.scrollController,
//         padding: const EdgeInsets.all(16),
//         itemCount: alerts.length,
//         itemBuilder: (_, i) => _AlertCard(
//           alert:         alerts[i],
//           onDelete:      () => _deleteAlert(alerts[i]),
//           onViewDetails: () => _showDetails(alerts[i]),
//           onSendWhatsApp:() => _handleSendWhatsApp(alerts[i])));
//     }

//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white, elevation: 0,
//         title: const Text('Alerts', style: TextStyle(fontSize: 22,
//           fontWeight: FontWeight.w900, color: AppColors.primaryDark,
//           letterSpacing: -0.8)),
//         actions: [
//           Padding(padding: const EdgeInsets.only(right: 12),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 14, vertical: 8)),
//               onPressed: _showCreateAlert,
//               icon: const Icon(Icons.add, size: 16),
//               label: const Text('New Alert',
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)))),
//         ],
//         bottom: const PreferredSize(preferredSize: Size.fromHeight(1),
//           child: Divider(height: 1, color: AppColors.border))),
//       body: alerts.isEmpty
//         ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
//             const Text('🔔', style: TextStyle(fontSize: 48)),
//             const SizedBox(height: 12),
//             const Text('No alerts yet',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
//             const SizedBox(height: 4),
//             const Text('Tap "New Alert" to notify your learners',
//               style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: _showCreateAlert,
//               icon: const Icon(Icons.add),
//               label: const Text('Create First Alert')),
//           ]))
//         : ListView.builder(
//             padding: const EdgeInsets.all(16),
//             itemCount: alerts.length,
//             itemBuilder: (_, i) => _AlertCard(
//               alert:         alerts[i],
//               onDelete:      () => _deleteAlert(alerts[i]),
//               onViewDetails: () => _showDetails(alerts[i]),
//               onSendWhatsApp:() => _handleSendWhatsApp(alerts[i]))));
//   }
// }

// class _AlertCard extends StatelessWidget {
//   final AppAlert alert;
//   final VoidCallback onDelete;
//   final VoidCallback onViewDetails;
//   final VoidCallback onSendWhatsApp;

//   const _AlertCard({
//     required this.alert,
//     required this.onDelete,
//     required this.onViewDetails,
//     required this.onSendWhatsApp,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: AppColors.border),
//         boxShadow: [BoxShadow(
//           color: Colors.black.withOpacity(0.03),
//           blurRadius: 6, offset: const Offset(0, 2))]),
//       clipBehavior: Clip.antiAlias,
//       child: IntrinsicHeight(child: Row(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Container(width: 4, color: AppColors.primary),
//           Expanded(child: Padding(
//             padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Text(alert.emoji, style: const TextStyle(fontSize: 16)),
//                 const SizedBox(width: 6),
//                 Expanded(child: Text(alert.title, style: const TextStyle(
//                   fontSize: 14, fontWeight: FontWeight.w700,
//                   color: AppColors.textPrimary, letterSpacing: -0.2))),
//                 const SizedBox(width: 8),
//                 Text(alert.timeAgo, style: const TextStyle(
//                   fontSize: 11, color: AppColors.textSecondary,
//                   fontWeight: FontWeight.w500)),
//                 const SizedBox(width: 4),
//                 GestureDetector(onTap: onDelete,
//                   child: const Icon(Icons.delete_outline,
//                     size: 18, color: AppColors.textSecondary)),
//               ]),
//               const SizedBox(height: 5),
//               Text(alert.message, style: const TextStyle(
//                 fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
//               const SizedBox(height: 10),
//               Row(children: [
//                 GestureDetector(onTap: onViewDetails,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(color: AppColors.primaryLight,
//                       borderRadius: BorderRadius.circular(20)),
//                     child: const Text('View Details', style: TextStyle(
//                       fontSize: 11, fontWeight: FontWeight.w700,
//                       color: AppColors.primary)))),
//                 const SizedBox(width: 10),
//                 GestureDetector(onTap: onSendWhatsApp,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF1A5C38).withOpacity(0.08),
//                       borderRadius: BorderRadius.circular(20)),
//                     child: const Row(mainAxisSize: MainAxisSize.min, children: [
//                       Icon(Icons.chat_rounded,
//                         size: 12, color: Color(0xFF1A5C38)),
//                       SizedBox(width: 4),
//                       Text('Send via WhatsApp', style: TextStyle(
//                         fontSize: 11, fontWeight: FontWeight.w700,
//                         color: Color(0xFF1A5C38))),
//                     ]))),
//               ]),
//             ])))
//         ])));
//   }
// }



















import 'package:flutter/material.dart';
import '../services/app_theme.dart';
import '../models/alert_store.dart';

// ── Bell icon for AppBar ──────────────────────────────────────
class AlertBell extends StatefulWidget {
  const AlertBell({super.key});
  @override
  State<AlertBell> createState() => _AlertBellState();
}

class _AlertBellState extends State<AlertBell> {
  final _store = AlertStore.instance;

  @override
  void initState() {
    super.initState();
    _store.addListener(_rebuild);
  }

  @override
  void dispose() {
    _store.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final unread = _store.alerts.length;
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (_) => DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          expand: false,
          builder: (_, ctrl) => AlertsScreen(scrollController: ctrl))),
      child: Stack(children: [
        const Padding(
          padding: EdgeInsets.all(8),
          child: Icon(Icons.notifications_outlined,
            color: AppColors.textPrimary, size: 24)),
        if (unread > 0)
          Positioned(top: 4, right: 4,
            child: Container(
              width: 16, height: 16,
              decoration: const BoxDecoration(
                color: Colors.red, shape: BoxShape.circle),
              child: Center(child: Text(
                unread > 9 ? '9+' : '$unread',
                style: const TextStyle(color: Colors.white,
                  fontSize: 9, fontWeight: FontWeight.w800))))),
      ]));
  }
}

// ── Main alerts screen ────────────────────────────────────────
class AlertsScreen extends StatefulWidget {
  final VoidCallback? onOpenWhatsApp;
  final ScrollController? scrollController;
  final void Function(String emoji, String title, String message)?
      onSendViaWhatsApp;

  const AlertsScreen({
    super.key,
    this.onOpenWhatsApp,
    this.scrollController,
    this.onSendViaWhatsApp,
  });

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final _store = AlertStore.instance;

  static const _emojis = [
    '📢', '⏰', '🏆', '📗', '👥', '🎓', '💡', '🚨',
    '✅', '📌', '🔔', '📝', '🌟', '⚡', '🎯', '💬',
  ];

  @override
  void initState() {
    super.initState();
    _store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() => setState(() {});

  void _handleSendWhatsApp(AppAlert alert) {
    if (widget.onSendViaWhatsApp != null) {
      widget.onSendViaWhatsApp!(alert.emoji, alert.title, alert.message);
    } else {
      widget.onOpenWhatsApp?.call();
    }
  }

  void _showDetails(AppAlert alert) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: AppColors.border,
              borderRadius: BorderRadius.circular(2)))),
          Row(children: [
            Container(width: 48, height: 48,
              decoration: BoxDecoration(color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14)),
              child: Center(child: Text(alert.emoji,
                style: const TextStyle(fontSize: 24)))),
            const SizedBox(width: 14),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(alert.title, style: const TextStyle(fontSize: 16,
                fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 3),
              Text(alert.timeAgo, style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
            ])),
          ]),
          const SizedBox(height: 16),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),
          const Text('Message', style: TextStyle(fontSize: 12,
            fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Container(width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border)),
            child: Text(alert.message, style: const TextStyle(
              fontSize: 14, color: AppColors.textPrimary, height: 1.5))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A5C38),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                Navigator.pop(context);
                _handleSendWhatsApp(alert);
              },
              icon: const Icon(Icons.chat_rounded, size: 18),
              label: const Text('Send via WhatsApp',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)))),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'))),
        ])));
  }

  void _showCreateAlert() {
    final titleCtrl   = TextEditingController();
    final messageCtrl = TextEditingController();
    String selectedEmoji = '📢';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, ss) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Text('Create Alert', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800)),
              const Spacer(),
              IconButton(onPressed: () => Navigator.pop(ctx),
                icon: const Icon(Icons.close)),
            ]),
            const SizedBox(height: 4),
            const Text('Send a notification to your learners',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            const Text('Choose Icon', style: TextStyle(fontSize: 13,
              fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8,
              children: _emojis.map((e) => GestureDetector(
                onTap: () => ss(() => selectedEmoji = e),
                child: Container(width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: selectedEmoji == e
                      ? AppColors.primaryLight : AppColors.bg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selectedEmoji == e
                        ? AppColors.primary : AppColors.border,
                      width: selectedEmoji == e ? 2 : 1)),
                  child: Center(child: Text(e,
                    style: const TextStyle(fontSize: 20)))))).toList()),
            const SizedBox(height: 20),
            const Text('Alert Title', style: TextStyle(fontSize: 13,
              fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            TextField(controller: titleCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'e.g. Quiz Deadline Approaching',
                prefixIcon: Padding(padding: const EdgeInsets.all(12),
                  child: Text(selectedEmoji,
                    style: const TextStyle(fontSize: 18))))),
            const SizedBox(height: 16),
            const Text('Message', style: TextStyle(fontSize: 13,
              fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            TextField(controller: messageCtrl, maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Write your alert message for learners...',
                alignLabelWithHint: true)),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  final t = titleCtrl.text.trim();
                  final m = messageCtrl.text.trim();
                  if (t.isEmpty || m.isEmpty) {
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                      content: Text('Please fill in title and message')));
                    return;
                  }
                  _store.addAlert(AppAlert(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    emoji: selectedEmoji,
                    title: t, message: m,
                    createdAt: DateTime.now()));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Alert created!'),
                    backgroundColor: AppColors.green,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.all(12)));
                },
                icon: const Icon(Icons.send_rounded, size: 16),
                label: const Text('Post Alert'))),
            ]),
          ])))));
  }

  void _deleteAlert(AppAlert alert) {
    showDialog(context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Alert',
          style: TextStyle(fontWeight: FontWeight.w800)),
        content: Text('Are you sure you want to delete "${alert.title}"?',
          style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.pop(context);
              _store.deleteAlert(alert.id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Alert deleted'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.all(12)));
            },
            child: const Text('Delete')),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final alerts = _store.alerts;

    if (widget.scrollController != null) {
      if (alerts.isEmpty) {
        return Center(child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('🔔', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            const Text('No alerts yet',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Tap the + button above to create one',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showCreateAlert,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Create Alert')),
          ])));
      }
      return Column(children: [
        // ── Sheet header with Create button ──────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
          child: Row(children: [
            const Text('🔔', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text('Alerts (${alerts.length})',
              style: const TextStyle(fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
                elevation: 0),
              onPressed: _showCreateAlert,
              icon: const Icon(Icons.add, size: 14, color: Colors.white),
              label: const Text('Create Alert',
                style: TextStyle(fontSize: 12,
                  fontWeight: FontWeight.w700, color: Colors.white))),
          ])),
        const Divider(height: 1, color: AppColors.border),
        Expanded(child: ListView.builder(
          controller: widget.scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: alerts.length,
          itemBuilder: (_, i) => _AlertCard(
            alert:          alerts[i],
            onDelete:       () => _deleteAlert(alerts[i]),
            onViewDetails:  () => _showDetails(alerts[i]),
            onSendWhatsApp: () => _handleSendWhatsApp(alerts[i])))),
      ]);
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        title: const Text('Alerts', style: TextStyle(fontSize: 22,
          fontWeight: FontWeight.w900, color: AppColors.primaryDark,
          letterSpacing: -0.8)),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8)),
              onPressed: _showCreateAlert,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('New Alert',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)))),
        ],
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border))),
      body: alerts.isEmpty
        ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('🔔', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text('No alerts yet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Tap "New Alert" to notify your learners',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _showCreateAlert,
              icon: const Icon(Icons.add),
              label: const Text('Create First Alert')),
          ]))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            itemBuilder: (_, i) => _AlertCard(
              alert:         alerts[i],
              onDelete:      () => _deleteAlert(alerts[i]),
              onViewDetails: () => _showDetails(alerts[i]),
              onSendWhatsApp:() => _handleSendWhatsApp(alerts[i]))));
  }
}

class _AlertCard extends StatelessWidget {
  final AppAlert alert;
  final VoidCallback onDelete;
  final VoidCallback onViewDetails;
  final VoidCallback onSendWhatsApp;

  const _AlertCard({
    required this.alert,
    required this.onDelete,
    required this.onViewDetails,
    required this.onSendWhatsApp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6, offset: const Offset(0, 2))]),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 4, color: AppColors.primary),
          Expanded(child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(alert.emoji, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 6),
                Expanded(child: Text(alert.title, style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary, letterSpacing: -0.2))),
                const SizedBox(width: 8),
                Text(alert.timeAgo, style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500)),
                const SizedBox(width: 4),
                GestureDetector(onTap: onDelete,
                  child: const Icon(Icons.delete_outline,
                    size: 18, color: AppColors.textSecondary)),
              ]),
              const SizedBox(height: 5),
              Text(alert.message, style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
              const SizedBox(height: 10),
              Row(children: [
                GestureDetector(onTap: onViewDetails,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20)),
                    child: const Text('View Details', style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700,
                      color: AppColors.primary)))),
                const SizedBox(width: 10),
                GestureDetector(onTap: onSendWhatsApp,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A5C38).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.chat_rounded,
                        size: 12, color: Color(0xFF1A5C38)),
                      SizedBox(width: 4),
                      Text('Send via WhatsApp', style: TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w700,
                        color: Color(0xFF1A5C38))),
                    ]))),
              ]),
            ])))
        ])));
  }
}


















