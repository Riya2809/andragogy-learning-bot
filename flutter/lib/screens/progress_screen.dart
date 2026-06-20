// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../services/app_theme.dart';
// import '../models/models.dart';

// class ProgressScreen extends StatefulWidget {
//   final List<LearnerProgress> learners;
//   final VoidCallback? onRefresh;
//   const ProgressScreen({super.key, required this.learners, this.onRefresh});
//   @override
//   State<ProgressScreen> createState() => _ProgressScreenState();
// }

// class _ProgressScreenState extends State<ProgressScreen> {
//   List<LearnerProgress> _learners = [];
//   bool _loading = false;

//   @override
//   void initState() {
//     super.initState();
//     _learners = widget.learners;
//     if (_learners.isEmpty) _load();
//   }

//   @override
//   void didUpdateWidget(ProgressScreen old) {
//     super.didUpdateWidget(old);
//     if (widget.learners != old.learners) setState(() => _learners = widget.learners);
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     _learners = await ApiService.getAllProgress();
//     setState(() => _loading = false);
//   }

//   int get _avgScore => _learners.isEmpty ? 0
//       : _learners.fold(0, (s, l) => s + l.averageScore) ~/ _learners.length;

//   int get _totalQuizzes => _learners.fold(0, (s, l) => s + l.quizzesTaken);
//   int get _totalModules => _learners.fold(0, (s, l) => s + l.modulesCompleted);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white, elevation: 0,
//         title: const Text('Learner Progress'),
//         actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
//         bottom: const PreferredSize(preferredSize: Size.fromHeight(1), child: Divider(height: 1, color: AppColors.border))),
//       body: _loading
//         ? const Center(child: CircularProgressIndicator())
//         : RefreshIndicator(
//             onRefresh: _load,
//             child: ListView(
//               padding: const EdgeInsets.all(16),
//               children: [
//                 // Summary stats
//                 _buildSummaryCards(),
//                 const SizedBox(height: 20),

//                 // Score distribution chart
//                 if (_learners.isNotEmpty) ...[
//                   const Text('Score Distribution', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3)),
//                   const SizedBox(height: 12),
//                   _buildScoreChart(),
//                   const SizedBox(height: 20),
//                 ],

//                 // Learner list
//                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                   const Text('All Learners', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: -0.3)),
//                   Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//                     decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
//                     child: Text('${_learners.length} total', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary))),
//                 ]),
//                 const SizedBox(height: 12),

//                 if (_learners.isEmpty)
//                   const Center(child: Padding(padding: EdgeInsets.all(40),
//                     child: Column(children: [
//                       Text('👥', style: TextStyle(fontSize: 48)),
//                       SizedBox(height: 12),
//                       Text('No learners yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
//                       SizedBox(height: 6),
//                       Text('Learners join by sending a WhatsApp\nmessage to your bot number',
//                         textAlign: TextAlign.center, style: TextStyle(color: AppColors.textSecondary)),
//                     ])))
//                 else
//                   ..._learners.map((l) => _LearnerDetailCard(learner: l)),
//               ],
//             )));
//   }

//   Widget _buildSummaryCards() {
//     return Row(children: [
//       Expanded(child: _MiniStat(value: '${_learners.length}', label: 'Learners', color: AppColors.primary, icon: Icons.people)),
//       const SizedBox(width: 8),
//       Expanded(child: _MiniStat(value: '$_avgScore%', label: 'Avg Score', color: AppColors.green, icon: Icons.star)),
//       const SizedBox(width: 8),
//       Expanded(child: _MiniStat(value: '$_totalQuizzes', label: 'Quizzes\nTaken', color: AppColors.amber, icon: Icons.quiz)),
//     ]);
//   }

//   Widget _buildScoreChart() {
//     // Simple bar chart without fl_chart dependency
//     final ranges = [
//       {'label': '0-40%', 'count': _learners.where((l) => l.averageScore < 40).length, 'color': AppColors.orange},
//       {'label': '40-60%', 'count': _learners.where((l) => l.averageScore >= 40 && l.averageScore < 60).length, 'color': AppColors.amber},
//       {'label': '60-80%', 'count': _learners.where((l) => l.averageScore >= 60 && l.averageScore < 80).length, 'color': AppColors.primary},
//       {'label': '80-100%', 'count': _learners.where((l) => l.averageScore >= 80).length, 'color': AppColors.green},
//     ];

//     final maxCount = ranges.map((r) => r['count'] as int).reduce((a, b) => a > b ? a : b);

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//         border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
//       child: Column(children: [
//         Row(crossAxisAlignment: CrossAxisAlignment.end,
//           children: ranges.map((r) {
//             final count = r['count'] as int;
//             final color = r['color'] as Color;
//             final label = r['label'] as String;
//             final height = maxCount > 0 ? (count / maxCount * 100.0) : 0.0;
//             return Expanded(child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 4),
//               child: Column(children: [
//                 Text('$count', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color)),
//                 const SizedBox(height: 4),
//                 AnimatedContainer(
//                   duration: const Duration(milliseconds: 600),
//                   height: height + 10,
//                   decoration: BoxDecoration(color: color.withOpacity(0.85), borderRadius: BorderRadius.circular(6))),
//                 const SizedBox(height: 6),
//                 Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
//               ])));
//           }).toList()),
//         const SizedBox(height: 8),
//         Text('Average score across all learners: $_avgScore%',
//           style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
//       ]));
//   }
// }

// class _LearnerDetailCard extends StatelessWidget {
//   final LearnerProgress learner;
//   const _LearnerDetailCard({required this.learner});

//   Color get _scoreColor => learner.averageScore >= 80 ? AppColors.green
//       : learner.averageScore >= 60 ? AppColors.amber : AppColors.orange;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//         border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(children: [
//           CircleAvatar(
//             backgroundColor: AppColors.primaryLight, radius: 22,
//             child: Text(learner.name.isNotEmpty ? learner.name[0].toUpperCase() : 'L',
//               style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w800, fontSize: 16))),
//           const SizedBox(width: 12),
//           Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text(learner.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
//             Row(children: [
//               const Icon(Icons.phone, size: 12, color: AppColors.textSecondary),
//               const SizedBox(width: 4),
//               Text(learner.phoneNumber, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
//             ]),
//           ])),
//           Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//             Text('${learner.averageScore}%', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _scoreColor)),
//             const Text('avg score', style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
//           ]),
//         ]),
//         const SizedBox(height: 12),

//         // Progress bar
//         ClipRRect(
//           borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(
//             value: learner.averageScore / 100,
//             backgroundColor: AppColors.primaryLight,
//             valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
//             minHeight: 6)),
//         const SizedBox(height: 10),

//         // Stats row
//         Row(children: [
//           _StatChip(icon: Icons.menu_book, label: '${learner.coursesTaken} courses', color: AppColors.primary),
//           const SizedBox(width: 8),
//           _StatChip(icon: Icons.quiz, label: '${learner.quizzesTaken} quizzes', color: AppColors.amber),
//           const SizedBox(width: 8),
//           _StatChip(icon: Icons.check_circle, label: '${learner.modulesCompleted} modules', color: AppColors.green),
//         ]),
//       ]));
//   }
// }

// class _MiniStat extends StatelessWidget {
//   final String value, label;
//   final Color color;
//   final IconData icon;
//   const _MiniStat({required this.value, required this.label, required this.color, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
//       decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
//         border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
//       child: Column(children: [
//         Icon(icon, color: color, size: 20),
//         const SizedBox(height: 6),
//         Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color)),
//         const SizedBox(height: 2),
//         Text(label, style: const TextStyle(fontSize: 9.5, color: AppColors.textSecondary, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
//       ]));
//   }
// }

// class _StatChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   const _StatChip({required this.icon, required this.label, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(20)),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, size: 11, color: color),
//         const SizedBox(width: 4),
//         Text(label, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w700)),
//       ]));
//   }
// }











// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;
// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html show AnchorElement, Blob, Url;
// import '../services/api_service.dart';
// import '../services/app_theme.dart';
// import '../models/models.dart';

// class ProgressScreen extends StatefulWidget {
//   final List<LearnerProgress> learners;
//   final VoidCallback? onRefresh;
//   const ProgressScreen({super.key, required this.learners, this.onRefresh});
//   @override
//   State<ProgressScreen> createState() => _ProgressScreenState();
// }

// class _ProgressScreenState extends State<ProgressScreen>
//     with SingleTickerProviderStateMixin {
//   List<LearnerProgress> _learners = [];
//   bool _loading = false;
//   late AnimationController _animCtrl;
//   late Animation<double> _anim;

//   // ── Report filter/sort state ─────────────────────────────────────────────
//   String _search = '';
//   String _sortBy = 'name'; // name | score | courses | modules
//   bool _showReportView = false; // toggle between chart view and report view

//   @override
//   void initState() {
//     super.initState();
//     _animCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 900));
//     _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
//     _learners = widget.learners;
//     if (_learners.isEmpty) {
//       _load();
//     } else {
//       _animCtrl.forward();
//     }
//   }

//   @override
//   void dispose() {
//     _animCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   void didUpdateWidget(ProgressScreen old) {
//     super.didUpdateWidget(old);
//     if (widget.learners != old.learners) {
//       setState(() => _learners = widget.learners);
//       _animCtrl.forward(from: 0);
//     }
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     _learners = await ApiService.getAllProgress();
//     setState(() => _loading = false);
//     _animCtrl.forward(from: 0);
//   }

//   // ── Computed stats ───────────────────────────────────────────────────────
//   int get _avgScore => _learners.isEmpty
//       ? 0
//       : _learners.fold(0, (s, l) => s + l.averageScore) ~/ _learners.length;
//   int get _totalQuizzes =>
//       _learners.fold(0, (s, l) => s + l.quizzesTaken);
//   int get _totalModules =>
//       _learners.fold(0, (s, l) => s + l.modulesCompleted);

//   List<_BarData> get _scoreBuckets => [
//         _BarData('0–39', _learners.where((l) => l.averageScore < 40).length,
//             AppColors.orange),
//         _BarData('40–59',
//             _learners.where((l) => l.averageScore >= 40 && l.averageScore < 60).length,
//             AppColors.amber),
//         _BarData('60–79',
//             _learners.where((l) => l.averageScore >= 60 && l.averageScore < 80).length,
//             AppColors.primary),
//         _BarData('80+',
//             _learners.where((l) => l.averageScore >= 80).length,
//             AppColors.green),
//       ];

//   // ── Filtered + sorted list for report view ───────────────────────────────
//   List<LearnerProgress> get _filteredLearners {
//     var list = List<LearnerProgress>.from(_learners);
//     if (_search.isNotEmpty) {
//       final q = _search.toLowerCase();
//       list = list.where((l) =>
//           l.name.toLowerCase().contains(q) ||
//           l.phoneNumber.contains(q) ||
//           (l.department ?? '').toLowerCase().contains(q) ||
//           (l.jobRole ?? '').toLowerCase().contains(q)).toList();
//     }
//     switch (_sortBy) {
//       case 'score':
//         list.sort((a, b) => b.averageScore.compareTo(a.averageScore));
//         break;
//       case 'courses':
//         list.sort((a, b) => b.coursesTaken.compareTo(a.coursesTaken));
//         break;
//       case 'modules':
//         list.sort((a, b) => b.modulesCompleted.compareTo(a.modulesCompleted));
//         break;
//       default:
//         list.sort((a, b) => a.name.compareTo(b.name));
//     }
//     return list;
//   }

//   // ── CSV export ────────────────────────────────────────────────────────────
//   void _exportCSV() {
//     final rows = <String>[
//       'Name,Phone,Department,Job Role,Courses,Quizzes,Modules,Avg Score (%)',
//     ];
//     for (final l in _filteredLearners) {
//       rows.add([
//         '"${l.name}"',
//         '"${l.phoneNumber}"',
//         '"${l.department ?? '-'}"',
//         '"${l.jobRole ?? '-'}"',
//         '${l.coursesTaken}',
//         '${l.quizzesTaken}',
//         '${l.modulesCompleted}',
//         '${l.averageScore}',
//       ].join(','));
//     }
//     final csv = rows.join('\n');

//     if (kIsWeb) {
//       final blob   = html.Blob([csv], 'text/csv');
//       final url    = html.Url.createObjectUrlFromBlob(blob);
//       final anchor = html.AnchorElement(href: url)
//         ..setAttribute('download', 'progress_report.csv')
//         ..click();
//       html.Url.revokeObjectUrl(url);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('✅ CSV downloaded!'),
//             backgroundColor: AppColors.green),
//       );
//     }
//   }

//   // ── Detail bottom sheet ───────────────────────────────────────────────────
//   void _showDetail(LearnerProgress l) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (_) {
//         final scoreColor = l.averageScore >= 80
//             ? AppColors.green
//             : l.averageScore >= 60
//                 ? AppColors.primary
//                 : AppColors.orange;
//         return Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Row(children: [
//               CircleAvatar(
//                 backgroundColor: AppColors.primaryLight,
//                 radius: 24,
//                 child: Text(
//                   l.name.isNotEmpty ? l.name[0].toUpperCase() : '?',
//                   style: const TextStyle(fontSize: 20,
//                       fontWeight: FontWeight.w800, color: AppColors.primary),
//                 ),
//               ),
//               const SizedBox(width: 14),
//               Expanded(child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Text(l.name, style: const TextStyle(
//                     fontSize: 16, fontWeight: FontWeight.w800)),
//                 Text(l.phoneNumber, style: const TextStyle(
//                     fontSize: 12, color: AppColors.textSecondary)),
//               ])),
//               Text('${l.averageScore}%', style: TextStyle(
//                   fontSize: 26, fontWeight: FontWeight.w900,
//                   color: scoreColor)),
//             ]),
//             const SizedBox(height: 20),
//             _detailRow('Department', l.department ?? '-'),
//             _detailRow('Job Role',   l.jobRole ?? '-'),
//             _detailRow('Avg Score',  '${l.averageScore}%'),
//             _detailRow('Courses',    '${l.coursesTaken}'),
//             _detailRow('Quizzes',    '${l.quizzesTaken}'),
//             _detailRow('Modules',    '${l.modulesCompleted}'),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(6),
//                 child: LinearProgressIndicator(
//                   value: l.averageScore / 100,
//                   minHeight: 8,
//                   backgroundColor: AppColors.border,
//                   valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
//                 ),
//               ),
//             ),
//           ]),
//         );
//       },
//     );
//   }

//   Widget _detailRow(String label, String value) => Padding(
//     padding: const EdgeInsets.symmetric(vertical: 6),
//     child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//       Text(label, style: const TextStyle(
//           fontSize: 12, color: AppColors.textSecondary)),
//       Text(value, style: const TextStyle(
//           fontSize: 13, fontWeight: FontWeight.w600,
//           color: AppColors.textPrimary)),
//     ]),
//   );

//   // ─────────────────────────────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text('Learner Progress'),
//         actions: [
//           // Toggle chart / report view
//           IconButton(
//             icon: Icon(_showReportView
//                 ? Icons.bar_chart_rounded
//                 : Icons.table_rows_rounded),
//             tooltip: _showReportView ? 'Chart view' : 'Report view',
//             onPressed: () =>
//                 setState(() => _showReportView = !_showReportView),
//           ),
//           // Export CSV (only in report view)
//           if (_showReportView)
//             IconButton(
//               icon: const Icon(Icons.download_rounded),
//               tooltip: 'Export CSV',
//               onPressed: _learners.isEmpty ? null : _exportCSV,
//             ),
//           IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
//         ],
//         bottom: const PreferredSize(
//             preferredSize: Size.fromHeight(1),
//             child: Divider(height: 1, color: AppColors.border)),
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _showReportView
//               ? _buildReportView()
//               : _buildChartView(),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // CHART VIEW  (your original UI, unchanged)
//   // ══════════════════════════════════════════════════════════════════════════
//   Widget _buildChartView() {
//     return RefreshIndicator(
//       onRefresh: _load,
//       child: AnimatedBuilder(
//         animation: _anim,
//         builder: (_, __) => ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             _buildSummaryCards(),
//             const SizedBox(height: 24),
//             if (_learners.isNotEmpty) ...[
//               _sectionTitle('Overall Avg Score'),
//               const SizedBox(height: 12),
//               _buildRingChart(),
//               const SizedBox(height: 24),
//               _sectionTitle('Score Distribution'),
//               const SizedBox(height: 12),
//               _buildBarChart(),
//               const SizedBox(height: 24),
//               _sectionTitle('Quizzes Taken per Learner'),
//               const SizedBox(height: 12),
//               _buildQuizBars(),
//               const SizedBox(height: 24),
//             ],
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _sectionTitle('All Learners'),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 10, vertical: 4),
//                   decoration: BoxDecoration(
//                       color: AppColors.primaryLight,
//                       borderRadius: BorderRadius.circular(20)),
//                   child: Text('${_learners.length} total',
//                       style: const TextStyle(
//                           fontSize: 11, fontWeight: FontWeight.w700,
//                           color: AppColors.primary)),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             if (_learners.isEmpty)
//               const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(40),
//                   child: Column(children: [
//                     Text('👥', style: TextStyle(fontSize: 48)),
//                     SizedBox(height: 12),
//                     Text('No learners yet',
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w700)),
//                     SizedBox(height: 6),
//                     Text(
//                         'Learners join by sending a WhatsApp\nmessage to your bot number',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: AppColors.textSecondary)),
//                   ]),
//                 ),
//               )
//             else
//               ..._learners.map((l) => GestureDetector(
//                     onTap: () => _showDetail(l),
//                     child: _LearnerDetailCard(learner: l),
//                   )),
//           ],
//         ),
//       ),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // REPORT VIEW  (new: search + sort + table + export)
//   // ══════════════════════════════════════════════════════════════════════════
//   Widget _buildReportView() {
//     final filtered = _filteredLearners;
//     final avg = filtered.isEmpty
//         ? 0.0
//         : filtered.fold(0, (s, l) => s + l.averageScore) / filtered.length;

//     return Column(children: [
//       // ── Summary banner ───────────────────────────────────────────────────
//       Container(
//         color: AppColors.primary,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(children: [
//           _topStat('Learners', '${filtered.length}', Icons.people_rounded),
//           _topStat('Avg Score', '${avg.toStringAsFixed(1)}%',
//               Icons.bar_chart_rounded),
//           _topStat('Quizzes',
//               '${filtered.fold(0, (s, l) => s + l.quizzesTaken)}',
//               Icons.quiz_rounded),
//           _topStat('Modules',
//               '${filtered.fold(0, (s, l) => s + l.modulesCompleted)}',
//               Icons.check_circle_rounded),
//         ]),
//       ),

//       // ── Search + sort ────────────────────────────────────────────────────
//       Container(
//         color: Colors.white,
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//         child: Row(children: [
//           Expanded(
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search name, phone, dept...',
//                 hintStyle: const TextStyle(fontSize: 12),
//                 prefixIcon: const Icon(Icons.search, size: 18),
//                 isDense: true,
//                 contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 12, vertical: 10),
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8)),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide:
//                         const BorderSide(color: AppColors.border)),
//               ),
//               onChanged: (v) => setState(() => _search = v),
//             ),
//           ),
//           const SizedBox(width: 10),
//           DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: _sortBy,
//               isDense: true,
//               style: const TextStyle(
//                   fontSize: 12, color: AppColors.textPrimary),
//               items: const [
//                 DropdownMenuItem(value: 'name',    child: Text('Name ↑')),
//                 DropdownMenuItem(value: 'score',   child: Text('Score ↓')),
//                 DropdownMenuItem(value: 'courses', child: Text('Courses ↓')),
//                 DropdownMenuItem(value: 'modules', child: Text('Modules ↓')),
//               ],
//               onChanged: (v) => setState(() => _sortBy = v ?? 'name'),
//             ),
//           ),
//         ]),
//       ),
//       const Divider(height: 1, color: AppColors.border),

//       // ── Table header ─────────────────────────────────────────────────────
//       Container(
//         color: const Color(0xFFF8F9FA),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         child: Row(children: const [
//           Expanded(flex: 3,
//               child: Text('Learner', style: _headerStyle)),
//           Expanded(flex: 2,
//               child: Text('Dept / Role', style: _headerStyle)),
//           SizedBox(width: 50,
//               child: Text('Crs', textAlign: TextAlign.center,
//                   style: _headerStyle)),
//           SizedBox(width: 50,
//               child: Text('Qz', textAlign: TextAlign.center,
//                   style: _headerStyle)),
//           SizedBox(width: 64,
//               child: Text('Score', textAlign: TextAlign.right,
//                   style: _headerStyle)),
//         ]),
//       ),
//       const Divider(height: 1, color: AppColors.border),

//       // ── Rows ─────────────────────────────────────────────────────────────
//       Expanded(
//         child: filtered.isEmpty
//             ? Center(
//                 child: Text(
//                   _search.isNotEmpty
//                       ? 'No results for "$_search"'
//                       : 'No learner data yet',
//                   style: const TextStyle(color: AppColors.textSecondary),
//                 ))
//             : ListView.separated(
//                 itemCount: filtered.length,
//                 separatorBuilder: (_, __) =>
//                     const Divider(height: 1, color: AppColors.border),
//                 itemBuilder: (_, i) => _buildReportRow(filtered[i]),
//               ),
//       ),

//       // ── Export footer ─────────────────────────────────────────────────────
//       Container(
//         color: Colors.white,
//         padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
//         child: SizedBox(
//           width: double.infinity,
//           child: ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.green,
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(vertical: 13),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10)),
//             ),
//             icon: const Icon(Icons.download_rounded),
//             label: Text(
//               'Export ${filtered.length} learners as CSV',
//               style: const TextStyle(fontWeight: FontWeight.w700),
//             ),
//             onPressed: filtered.isEmpty ? null : _exportCSV,
//           ),
//         ),
//       ),
//     ]);
//   }

//   Widget _buildReportRow(LearnerProgress l) {
//     final scoreColor = l.averageScore >= 80
//         ? AppColors.green
//         : l.averageScore >= 60
//             ? AppColors.primary
//             : l.averageScore >= 40
//                 ? AppColors.orange
//                 : Colors.red;

//     return InkWell(
//       onTap: () => _showDetail(l),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
//         child: Row(children: [
//           // Avatar + name + phone
//           Expanded(
//             flex: 3,
//             child: Row(children: [
//               CircleAvatar(
//                 backgroundColor: AppColors.primaryLight,
//                 radius: 16,
//                 child: Text(
//                   l.name.isNotEmpty ? l.name[0].toUpperCase() : '?',
//                   style: const TextStyle(fontSize: 12,
//                       fontWeight: FontWeight.w800, color: AppColors.primary),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Text(l.name,
//                     style: const TextStyle(fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: AppColors.textPrimary),
//                     maxLines: 1, overflow: TextOverflow.ellipsis),
//                 Text(l.phoneNumber,
//                     style: const TextStyle(fontSize: 10,
//                         color: AppColors.textSecondary)),
//               ])),
//             ]),
//           ),
//           // Dept / role
//           Expanded(
//             flex: 2,
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//               Text(l.department ?? '-',
//                   style: const TextStyle(fontSize: 11,
//                       color: AppColors.textPrimary),
//                   maxLines: 1, overflow: TextOverflow.ellipsis),
//               Text(l.jobRole ?? '-',
//                   style: const TextStyle(fontSize: 10,
//                       color: AppColors.textSecondary),
//                   maxLines: 1, overflow: TextOverflow.ellipsis),
//             ]),
//           ),
//           // Courses
//           SizedBox(
//             width: 50,
//             child: Text('${l.coursesTaken}',
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary)),
//           ),
//           // Quizzes
//           SizedBox(
//             width: 50,
//             child: Text('${l.quizzesTaken}',
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary)),
//           ),
//           // Score
//           SizedBox(
//             width: 64,
//             child: Text('${l.averageScore}%',
//                 textAlign: TextAlign.right,
//                 style: TextStyle(fontSize: 15,
//                     fontWeight: FontWeight.w800, color: scoreColor)),
//           ),
//         ]),
//       ),
//     );
//   }

//   Widget _topStat(String label, String value, IconData icon) {
//     return Expanded(
//       child: Row(children: [
//         Icon(icon, color: Colors.white60, size: 16),
//         const SizedBox(width: 6),
//         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text(value, style: const TextStyle(color: Colors.white,
//               fontSize: 16, fontWeight: FontWeight.w800)),
//           Text(label, style: const TextStyle(
//               color: Colors.white60, fontSize: 9)),
//         ]),
//       ]),
//     );
//   }

//   // ══════════════════════════════════════════════════════════════════════════
//   // ORIGINAL chart helpers — unchanged
//   // ══════════════════════════════════════════════════════════════════════════
//   Widget _sectionTitle(String t) => Text(t,
//       style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
//           color: AppColors.textPrimary, letterSpacing: -0.3));

//   Widget _buildSummaryCards() {
//     return Row(children: [
//       Expanded(child: _MiniStat(value: '${_learners.length}',
//           label: 'Learners', color: AppColors.primary, icon: Icons.people)),
//       const SizedBox(width: 8),
//       Expanded(child: _MiniStat(value: '$_avgScore%',
//           label: 'Avg Score', color: AppColors.green, icon: Icons.star)),
//       const SizedBox(width: 8),
//       Expanded(child: _MiniStat(value: '$_totalQuizzes',
//           label: 'Quizzes\nTaken', color: AppColors.amber, icon: Icons.quiz)),
//       const SizedBox(width: 8),
//       Expanded(child: _MiniStat(value: '$_totalModules',
//           label: 'Modules\nDone', color: AppColors.orange,
//           icon: Icons.check_circle)),
//     ]);
//   }

//   Widget _buildRingChart() {
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
//               value: _avgScore / 100.0,
//               progress: _anim.value,
//               color: _avgScore >= 80
//                   ? AppColors.green
//                   : _avgScore >= 60 ? AppColors.primary : AppColors.orange,
//               bgColor: AppColors.border,
//             ),
//             child: Center(
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 Text('$_avgScore%',
//                     style: TextStyle(fontSize: 22,
//                         fontWeight: FontWeight.w900,
//                         color: _avgScore >= 80
//                             ? AppColors.green
//                             : _avgScore >= 60
//                                 ? AppColors.primary
//                                 : AppColors.orange)),
//                 const Text('avg',
//                     style: TextStyle(fontSize: 11,
//                         color: AppColors.textSecondary)),
//               ]),
//             ),
//           ),
//         ),
//         const SizedBox(width: 24),
//         Expanded(
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//             _legendDot(AppColors.green,   'Excellent (80–100%)'),
//             const SizedBox(height: 8),
//             _legendDot(AppColors.primary, 'Good (60–79%)'),
//             const SizedBox(height: 8),
//             _legendDot(AppColors.amber,   'Average (40–59%)'),
//             const SizedBox(height: 8),
//             _legendDot(AppColors.orange,  'Needs work (<40%)'),
//             const SizedBox(height: 14),
//             Text(
//               _avgScore >= 80
//                   ? '🎉 Great cohort performance!'
//                   : _avgScore >= 60
//                       ? '👍 On track — keep pushing'
//                       : '📚 More practice needed',
//               style: const TextStyle(fontSize: 12,
//                   color: AppColors.textSecondary,
//                   fontStyle: FontStyle.italic),
//             ),
//           ]),
//         ),
//       ]),
//     );
//   }

//   Widget _legendDot(Color color, String label) => Row(children: [
//         Container(width: 10, height: 10,
//             decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
//         const SizedBox(width: 8),
//         Text(label, style: const TextStyle(
//             fontSize: 12, color: AppColors.textSecondary)),
//       ]);

//   Widget _buildBarChart() {
//     final buckets  = _scoreBuckets;
//     final maxCount = buckets.map((b) => b.count).reduce((a, b) => a > b ? a : b);
//     return Container(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: const Border.fromBorderSide(
//               BorderSide(color: AppColors.border))),
//       child: Column(children: [
//         SizedBox(
//           height: 140,
//           child: CustomPaint(
//             painter: _BarChartPainter(
//                 buckets: buckets, maxCount: maxCount,
//                 progress: _anim.value),
//             size: Size.infinite,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: buckets.map((b) => Column(children: [
//                 Container(width: 10, height: 10,
//                     decoration: BoxDecoration(
//                         color: b.color, shape: BoxShape.circle)),
//                 const SizedBox(height: 4),
//                 Text(b.label, style: const TextStyle(fontSize: 10,
//                     color: AppColors.textSecondary,
//                     fontWeight: FontWeight.w600)),
//               ])).toList(),
//         ),
//         const SizedBox(height: 8),
//         Text('Total learners: ${_learners.length}',
//             style: const TextStyle(
//                 fontSize: 11, color: AppColors.textSecondary)),
//       ]),
//     );
//   }

//   Widget _buildQuizBars() {
//     if (_learners.isEmpty) return const SizedBox.shrink();
//     final maxQ = _learners
//         .map((l) => l.quizzesTaken)
//         .reduce((a, b) => a > b ? a : b);
//     if (maxQ == 0) {
//       return Container(
//         padding: const EdgeInsets.all(20),
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: const Border.fromBorderSide(
//                 BorderSide(color: AppColors.border))),
//         child: const Center(
//             child: Text('No quizzes taken yet',
//                 style: TextStyle(color: AppColors.textSecondary))),
//       );
//     }
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: const Border.fromBorderSide(
//               BorderSide(color: AppColors.border))),
//       child: Column(
//           children: _learners.map((l) {
//         final frac = maxQ > 0 ? (l.quizzesTaken / maxQ) * _anim.value : 0.0;
//         return Padding(
//           padding: const EdgeInsets.only(bottom: 12),
//           child: Row(children: [
//             SizedBox(
//               width: 32, height: 32,
//               child: CircleAvatar(
//                 backgroundColor: AppColors.primaryLight,
//                 child: Text(
//                     l.name.isNotEmpty ? l.name[0].toUpperCase() : 'L',
//                     style: const TextStyle(color: AppColors.primary,
//                         fontWeight: FontWeight.w800, fontSize: 12)),
//               ),
//             ),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                   Text(l.name, style: const TextStyle(fontSize: 12,
//                       fontWeight: FontWeight.w700,
//                       color: AppColors.textPrimary)),
//                   Text(
//                       '${l.quizzesTaken} quiz${l.quizzesTaken == 1 ? '' : 'zes'}',
//                       style: const TextStyle(
//                           fontSize: 11, color: AppColors.textSecondary)),
//                 ]),
//                 const SizedBox(height: 5),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(4),
//                   child: LinearProgressIndicator(
//                       value: frac,
//                       minHeight: 8,
//                       backgroundColor: AppColors.primaryLight,
//                       valueColor: const AlwaysStoppedAnimation<Color>(
//                           AppColors.primary)),
//                 ),
//               ]),
//             ),
//           ]),
//         );
//       }).toList()),
//     );
//   }
// }

// // ── Header style constant ────────────────────────────────────────────────────
// const _headerStyle = TextStyle(
//     fontSize: 11, fontWeight: FontWeight.w700,
//     color: AppColors.textSecondary);

// // ── Custom painters (unchanged) ──────────────────────────────────────────────
// class _BarData {
//   final String label;
//   final int count;
//   final Color color;
//   const _BarData(this.label, this.count, this.color);
// }

// class _RingPainter extends CustomPainter {
//   final double value, progress;
//   final Color color, bgColor;
//   const _RingPainter({required this.value, required this.progress,
//       required this.color, required this.bgColor});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final cx = size.width / 2;
//     final cy = size.height / 2;
//     final r  = min(cx, cy) - 10;
//     const stroke = 12.0;
//     canvas.drawCircle(Offset(cx, cy), r,
//         Paint()
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = stroke
//           ..color = bgColor.withOpacity(0.3));
//     final sweep = 2 * pi * value * progress;
//     canvas.drawArc(
//         Rect.fromCircle(center: Offset(cx, cy), radius: r),
//         -pi / 2, sweep, false,
//         Paint()
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = stroke
//           ..strokeCap = StrokeCap.round
//           ..color = color);
//   }

//   @override
//   bool shouldRepaint(_RingPainter old) =>
//       old.value != value || old.progress != progress;
// }

// class _BarChartPainter extends CustomPainter {
//   final List<_BarData> buckets;
//   final int maxCount;
//   final double progress;
//   const _BarChartPainter({required this.buckets, required this.maxCount,
//       required this.progress});

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (maxCount == 0) return;
//     final barW   = size.width / buckets.length * 0.5;
//     final gap    = size.width / buckets.length;
//     const topPad = 20.0;

//     for (int i = 0; i < buckets.length; i++) {
//       final b   = buckets[i];
//       final cx  = gap * i + gap / 2;
//       final maxH = size.height - topPad;
//       final bH  = (b.count / maxCount) * maxH * progress;
//       final rect = RRect.fromRectAndRadius(
//           Rect.fromLTWH(cx - barW / 2, size.height - bH, barW, bH),
//           const Radius.circular(6));
//       canvas.drawRRect(rect,
//           Paint()..color = b.color.withOpacity(0.85)
//             ..style = PaintingStyle.fill);
//       if (b.count > 0 && progress > 0.7) {
//         final tp = TextPainter(
//           text: TextSpan(text: '${b.count}',
//               style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
//                   color: b.color)),
//           textDirection: TextDirection.ltr,
//         )..layout();
//         tp.paint(canvas, Offset(cx - tp.width / 2, size.height - bH - topPad));
//       }
//     }
//     final gridPaint = Paint()
//       ..color = AppColors.border.withOpacity(0.4)
//       ..strokeWidth = 0.5;
//     for (int i = 1; i <= 3; i++) {
//       final y = size.height - (size.height - topPad) * i / 3;
//       canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
//     }
//   }

//   @override
//   bool shouldRepaint(_BarChartPainter old) =>
//       old.progress != progress || old.maxCount != maxCount;
// }

// // ── Learner detail card (unchanged, now also tappable) ───────────────────────
// class _LearnerDetailCard extends StatelessWidget {
//   final LearnerProgress learner;
//   const _LearnerDetailCard({required this.learner});

//   Color get _scoreColor => learner.averageScore >= 80
//       ? AppColors.green
//       : learner.averageScore >= 60 ? AppColors.amber : AppColors.orange;

//   String get _scoreLabel => learner.averageScore >= 80
//       ? 'Excellent'
//       : learner.averageScore >= 60
//           ? 'Good'
//           : learner.averageScore >= 40 ? 'Average' : 'Needs work';

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           border: const Border.fromBorderSide(
//               BorderSide(color: AppColors.border))),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(children: [
//           CircleAvatar(
//               backgroundColor: AppColors.primaryLight,
//               radius: 22,
//               child: Text(
//                   learner.name.isNotEmpty ? learner.name[0].toUpperCase() : 'L',
//                   style: const TextStyle(color: AppColors.primary,
//                       fontWeight: FontWeight.w800, fontSize: 16))),
//           const SizedBox(width: 12),
//           Expanded(child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Text(learner.name, style: const TextStyle(fontSize: 14,
//                 fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
//             Row(children: [
//               const Icon(Icons.phone, size: 12, color: AppColors.textSecondary),
//               const SizedBox(width: 4),
//               Text(learner.phoneNumber, style: const TextStyle(
//                   fontSize: 11, color: AppColors.textSecondary)),
//             ]),
//             if (learner.department != null || learner.jobRole != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 2),
//                 child: Text(
//                   [learner.jobRole, learner.department]
//                       .where((s) => s != null && s.isNotEmpty)
//                       .join(' · '),
//                   style: const TextStyle(
//                       fontSize: 10, color: AppColors.textSecondary),
//                 ),
//               ),
//           ])),
//           Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//             Text('${learner.averageScore}%',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900,
//                     color: _scoreColor)),
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//               decoration: BoxDecoration(
//                   color: _scoreColor.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10)),
//               child: Text(_scoreLabel, style: TextStyle(fontSize: 9,
//                   fontWeight: FontWeight.w700, color: _scoreColor)),
//             ),
//           ]),
//         ]),
//         const SizedBox(height: 12),
//         ClipRRect(
//           borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(
//               value: learner.averageScore / 100,
//               backgroundColor: AppColors.primaryLight,
//               valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
//               minHeight: 6)),
//         const SizedBox(height: 10),
//         Row(children: [
//           _StatChip(icon: Icons.menu_book, label: '${learner.coursesTaken} courses',
//               color: AppColors.primary),
//           const SizedBox(width: 8),
//           _StatChip(icon: Icons.quiz, label: '${learner.quizzesTaken} quizzes',
//               color: AppColors.amber),
//           const SizedBox(width: 8),
//           _StatChip(icon: Icons.check_circle,
//               label: '${learner.modulesCompleted} modules',
//               color: AppColors.green),
//         ]),
//       ]),
//     );
//   }
// }

// class _MiniStat extends StatelessWidget {
//   final String value, label;
//   final Color color;
//   final IconData icon;
//   const _MiniStat({required this.value, required this.label,
//       required this.color, required this.icon});

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
//         Text(value, style: TextStyle(fontSize: 18,
//             fontWeight: FontWeight.w800, color: color)),
//         const SizedBox(height: 2),
//         Text(label, style: const TextStyle(fontSize: 9,
//             color: AppColors.textSecondary, fontWeight: FontWeight.w600),
//             textAlign: TextAlign.center),
//       ]),
//     );
//   }
// }

// class _StatChip extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   const _StatChip({required this.icon, required this.label, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//           color: color.withOpacity(0.08),
//           borderRadius: BorderRadius.circular(20)),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, size: 11, color: color),
//         const SizedBox(width: 4),
//         Text(label, style: TextStyle(fontSize: 10,
//             color: color, fontWeight: FontWeight.w700)),
//       ]),
//     );
//   }
// }










import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html show AnchorElement, Blob, Url;
import '../services/api_service.dart';
import '../services/app_theme.dart';
import '../models/models.dart';

class ProgressScreen extends StatefulWidget {
  final List<LearnerProgress> learners;
  final VoidCallback? onRefresh;
  final bool embedded; // true = no AppBar (used inside LearnersScreen tab)
  const ProgressScreen({super.key, required this.learners, this.onRefresh, this.embedded = false});
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  List<LearnerProgress> _learners = [];
  bool _loading = false;
  late AnimationController _animCtrl;
  late Animation<double> _anim;

  // ── Report filter/sort state ─────────────────────────────────────────────
  String _search = '';
  String _sortBy = 'name'; // name | score | courses | modules
  bool _showReportView = false; // toggle between chart view and report view

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _learners = widget.learners;
    if (_learners.isEmpty) {
      _load();
    } else {
      _animCtrl.forward();
    }
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProgressScreen old) {
    super.didUpdateWidget(old);
    if (widget.learners != old.learners) {
      setState(() => _learners = widget.learners);
      _animCtrl.forward(from: 0);
    }
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    _learners = await ApiService.getAllProgress();
    setState(() => _loading = false);
    _animCtrl.forward(from: 0);
  }

  // ── Computed stats ───────────────────────────────────────────────────────
  int get _avgScore => _learners.isEmpty
      ? 0
      : _learners.fold(0, (s, l) => s + l.averageScore) ~/ _learners.length;
  int get _totalQuizzes =>
      _learners.fold(0, (s, l) => s + l.quizzesTaken);
  int get _totalModules =>
      _learners.fold(0, (s, l) => s + l.modulesCompleted);

  List<_BarData> get _scoreBuckets => [
        _BarData('0–39', _learners.where((l) => l.averageScore < 40).length,
            AppColors.orange),
        _BarData('40–59',
            _learners.where((l) => l.averageScore >= 40 && l.averageScore < 60).length,
            AppColors.amber),
        _BarData('60–79',
            _learners.where((l) => l.averageScore >= 60 && l.averageScore < 80).length,
            AppColors.primary),
        _BarData('80+',
            _learners.where((l) => l.averageScore >= 80).length,
            AppColors.green),
      ];

  // ── Filtered + sorted list for report view ───────────────────────────────
  List<LearnerProgress> get _filteredLearners {
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
      case 'score':
        list.sort((a, b) => b.averageScore.compareTo(a.averageScore));
        break;
      case 'courses':
        list.sort((a, b) => b.coursesTaken.compareTo(a.coursesTaken));
        break;
      case 'modules':
        list.sort((a, b) => b.modulesCompleted.compareTo(a.modulesCompleted));
        break;
      default:
        list.sort((a, b) => a.name.compareTo(b.name));
    }
    return list;
  }

  // ── CSV export ────────────────────────────────────────────────────────────
  void _exportCSV() {
    final rows = <String>[
      'Name,Phone,Department,Job Role,Courses,Quizzes,Modules,Avg Score (%)',
    ];
    for (final l in _filteredLearners) {
      rows.add([
        '"${l.name}"',
        '"${l.phoneNumber}"',
        '"${l.department ?? '-'}"',
        '"${l.jobRole ?? '-'}"',
        '${l.coursesTaken}',
        '${l.quizzesTaken}',
        '${l.modulesCompleted}',
        '${l.averageScore}',
      ].join(','));
    }
    final csv = rows.join('\n');

    if (kIsWeb) {
      final blob   = html.Blob([csv], 'text/csv');
      final url    = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'progress_report.csv')
        ..click();
      html.Url.revokeObjectUrl(url);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('✅ CSV downloaded!'),
            backgroundColor: AppColors.green),
      );
    }
  }

  // ── Detail bottom sheet ───────────────────────────────────────────────────
  void _showDetail(LearnerProgress l) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        final scoreColor = l.averageScore >= 80
            ? AppColors.green
            : l.averageScore >= 60
                ? AppColors.primary
                : AppColors.orange;
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                radius: 24,
                child: Text(
                  l.name.isNotEmpty ? l.name[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.name, style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800)),
                Text(l.phoneNumber, style: const TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
              ])),
              Text('${l.averageScore}%', style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w900,
                  color: scoreColor)),
            ]),
            const SizedBox(height: 20),
            _detailRow('Department', l.department ?? '-'),
            _detailRow('Job Role',   l.jobRole ?? '-'),
            _detailRow('Avg Score',  '${l.averageScore}%'),
            _detailRow('Courses',    '${l.coursesTaken}'),
            _detailRow('Quizzes',    '${l.quizzesTaken}'),
            _detailRow('Modules',    '${l.modulesCompleted}'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: l.averageScore / 100,
                  minHeight: 8,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(
          fontSize: 12, color: AppColors.textSecondary)),
      Text(value, style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600,
          color: AppColors.textPrimary)),
    ]),
  );

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: widget.embedded ? null : AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Learner Progress'),
        actions: [
          IconButton(
            icon: Icon(_showReportView
                ? Icons.bar_chart_rounded
                : Icons.table_rows_rounded),
            tooltip: _showReportView ? 'Chart view' : 'Report view',
            onPressed: () =>
                setState(() => _showReportView = !_showReportView),
          ),
          if (_showReportView)
            IconButton(
              icon: const Icon(Icons.download_rounded),
              tooltip: 'Export CSV',
              onPressed: _learners.isEmpty ? null : _exportCSV,
            ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(height: 1, color: AppColors.border)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _showReportView
              ? _buildReportView()
              : _buildChartView(),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // CHART VIEW  (your original UI, unchanged)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildChartView() {
    return RefreshIndicator(
      onRefresh: _load,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSummaryCards(),
            const SizedBox(height: 24),
            if (_learners.isNotEmpty) ...[
              _sectionTitle('Overall Avg Score'),
              const SizedBox(height: 12),
              _buildRingChart(),
              const SizedBox(height: 24),
              _sectionTitle('Score Distribution'),
              const SizedBox(height: 12),
              _buildBarChart(),
              const SizedBox(height: 24),
              _sectionTitle('Quizzes Taken per Learner'),
              const SizedBox(height: 12),
              _buildQuizBars(),
              const SizedBox(height: 24),
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionTitle('All Learners'),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('${_learners.length} total',
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700,
                          color: AppColors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_learners.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(children: [
                    Text('👥', style: TextStyle(fontSize: 48)),
                    SizedBox(height: 12),
                    Text('No learners yet',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    SizedBox(height: 6),
                    Text(
                        'Learners join by sending a WhatsApp\nmessage to your bot number',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary)),
                  ]),
                ),
              )
            else
              ..._learners.map((l) => GestureDetector(
                    onTap: () => _showDetail(l),
                    child: _LearnerDetailCard(learner: l),
                  )),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // REPORT VIEW  (new: search + sort + table + export)
  // ══════════════════════════════════════════════════════════════════════════
  Widget _buildReportView() {
    final filtered = _filteredLearners;
    final avg = filtered.isEmpty
        ? 0.0
        : filtered.fold(0, (s, l) => s + l.averageScore) / filtered.length;

    return Column(children: [
      // ── Summary banner ───────────────────────────────────────────────────
      Container(
        color: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          _topStat('Learners', '${filtered.length}', Icons.people_rounded),
          _topStat('Avg Score', '${avg.toStringAsFixed(1)}%',
              Icons.bar_chart_rounded),
          _topStat('Quizzes',
              '${filtered.fold(0, (s, l) => s + l.quizzesTaken)}',
              Icons.quiz_rounded),
          _topStat('Modules',
              '${filtered.fold(0, (s, l) => s + l.modulesCompleted)}',
              Icons.check_circle_rounded),
        ]),
      ),

      // ── Search + sort ────────────────────────────────────────────────────
      Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search name, phone, dept...',
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(Icons.search, size: 18),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        const BorderSide(color: AppColors.border)),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          const SizedBox(width: 10),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _sortBy,
              isDense: true,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textPrimary),
              items: const [
                DropdownMenuItem(value: 'name',    child: Text('Name ↑')),
                DropdownMenuItem(value: 'score',   child: Text('Score ↓')),
                DropdownMenuItem(value: 'courses', child: Text('Courses ↓')),
                DropdownMenuItem(value: 'modules', child: Text('Modules ↓')),
              ],
              onChanged: (v) => setState(() => _sortBy = v ?? 'name'),
            ),
          ),
        ]),
      ),
      const Divider(height: 1, color: AppColors.border),

      // ── Table header ─────────────────────────────────────────────────────
      Container(
        color: const Color(0xFFF8F9FA),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: const [
          Expanded(flex: 3,
              child: Text('Learner', style: _headerStyle)),
          Expanded(flex: 2,
              child: Text('Dept / Role', style: _headerStyle)),
          SizedBox(width: 50,
              child: Text('Crs', textAlign: TextAlign.center,
                  style: _headerStyle)),
          SizedBox(width: 50,
              child: Text('Qz', textAlign: TextAlign.center,
                  style: _headerStyle)),
          SizedBox(width: 64,
              child: Text('Score', textAlign: TextAlign.right,
                  style: _headerStyle)),
        ]),
      ),
      const Divider(height: 1, color: AppColors.border),

      // ── Rows ─────────────────────────────────────────────────────────────
      Expanded(
        child: filtered.isEmpty
            ? Center(
                child: Text(
                  _search.isNotEmpty
                      ? 'No results for "$_search"'
                      : 'No learner data yet',
                  style: const TextStyle(color: AppColors.textSecondary),
                ))
            : ListView.separated(
                itemCount: filtered.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.border),
                itemBuilder: (_, i) => _buildReportRow(filtered[i]),
              ),
      ),

      // ── Export footer ─────────────────────────────────────────────────────
      Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.download_rounded),
            label: Text(
              'Export ${filtered.length} learners as CSV',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            onPressed: filtered.isEmpty ? null : _exportCSV,
          ),
        ),
      ),
    ]);
  }

  Widget _buildReportRow(LearnerProgress l) {
    final scoreColor = l.averageScore >= 80
        ? AppColors.green
        : l.averageScore >= 60
            ? AppColors.primary
            : l.averageScore >= 40
                ? AppColors.orange
                : Colors.red;

    return InkWell(
      onTap: () => _showDetail(l),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(children: [
          // Avatar + name + phone
          Expanded(
            flex: 3,
            child: Row(children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                radius: 16,
                child: Text(
                  l.name.isNotEmpty ? l.name[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w800, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(l.name,
                    style: const TextStyle(fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(l.phoneNumber,
                    style: const TextStyle(fontSize: 10,
                        color: AppColors.textSecondary)),
              ])),
            ]),
          ),
          // Dept / role
          Expanded(
            flex: 2,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(l.department ?? '-',
                  style: const TextStyle(fontSize: 11,
                      color: AppColors.textPrimary),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(l.jobRole ?? '-',
                  style: const TextStyle(fontSize: 10,
                      color: AppColors.textSecondary),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ]),
          ),
          // Courses
          SizedBox(
            width: 50,
            child: Text('${l.coursesTaken}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ),
          // Quizzes
          SizedBox(
            width: 50,
            child: Text('${l.quizzesTaken}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ),
          // Score
          SizedBox(
            width: 64,
            child: Text('${l.averageScore}%',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 15,
                    fontWeight: FontWeight.w800, color: scoreColor)),
          ),
        ]),
      ),
    );
  }

  Widget _topStat(String label, String value, IconData icon) {
    return Expanded(
      child: Row(children: [
        Icon(icon, color: Colors.white60, size: 16),
        const SizedBox(width: 6),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value, style: const TextStyle(color: Colors.white,
              fontSize: 16, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(
              color: Colors.white60, fontSize: 9)),
        ]),
      ]),
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ORIGINAL chart helpers — unchanged
  // ══════════════════════════════════════════════════════════════════════════
  Widget _sectionTitle(String t) => Text(t,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
          color: AppColors.textPrimary, letterSpacing: -0.3));

  Widget _buildSummaryCards() {
    return Row(children: [
      Expanded(child: _MiniStat(value: '${_learners.length}',
          label: 'Learners', color: AppColors.primary, icon: Icons.people)),
      const SizedBox(width: 8),
      Expanded(child: _MiniStat(value: '$_avgScore%',
          label: 'Avg Score', color: AppColors.green, icon: Icons.star)),
      const SizedBox(width: 8),
      Expanded(child: _MiniStat(value: '$_totalQuizzes',
          label: 'Quizzes\nTaken', color: AppColors.amber, icon: Icons.quiz)),
      const SizedBox(width: 8),
      Expanded(child: _MiniStat(value: '$_totalModules',
          label: 'Modules\nDone', color: AppColors.orange,
          icon: Icons.check_circle)),
    ]);
  }

  Widget _buildRingChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: const Border.fromBorderSide(
              BorderSide(color: AppColors.border))),
      child: Row(children: [
        SizedBox(
          width: 120, height: 120,
          child: CustomPaint(
            painter: _RingPainter(
              value: _avgScore / 100.0,
              progress: _anim.value,
              color: _avgScore >= 80
                  ? AppColors.green
                  : _avgScore >= 60 ? AppColors.primary : AppColors.orange,
              bgColor: AppColors.border,
            ),
            child: Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('$_avgScore%',
                    style: TextStyle(fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: _avgScore >= 80
                            ? AppColors.green
                            : _avgScore >= 60
                                ? AppColors.primary
                                : AppColors.orange)),
                const Text('avg',
                    style: TextStyle(fontSize: 11,
                        color: AppColors.textSecondary)),
              ]),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            _legendDot(AppColors.green,   'Excellent (80–100%)'),
            const SizedBox(height: 8),
            _legendDot(AppColors.primary, 'Good (60–79%)'),
            const SizedBox(height: 8),
            _legendDot(AppColors.amber,   'Average (40–59%)'),
            const SizedBox(height: 8),
            _legendDot(AppColors.orange,  'Needs work (<40%)'),
            const SizedBox(height: 14),
            Text(
              _avgScore >= 80
                  ? '🎉 Great cohort performance!'
                  : _avgScore >= 60
                      ? '👍 On track — keep pushing'
                      : '📚 More practice needed',
              style: const TextStyle(fontSize: 12,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _legendDot(Color color, String label) => Row(children: [
        Container(width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(
            fontSize: 12, color: AppColors.textSecondary)),
      ]);

  Widget _buildBarChart() {
    final buckets  = _scoreBuckets;
    final maxCount = buckets.map((b) => b.count).reduce((a, b) => a > b ? a : b);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: const Border.fromBorderSide(
              BorderSide(color: AppColors.border))),
      child: Column(children: [
        SizedBox(
          height: 140,
          child: CustomPaint(
            painter: _BarChartPainter(
                buckets: buckets, maxCount: maxCount,
                progress: _anim.value),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: buckets.map((b) => Column(children: [
                Container(width: 10, height: 10,
                    decoration: BoxDecoration(
                        color: b.color, shape: BoxShape.circle)),
                const SizedBox(height: 4),
                Text(b.label, style: const TextStyle(fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600)),
              ])).toList(),
        ),
        const SizedBox(height: 8),
        Text('Total learners: ${_learners.length}',
            style: const TextStyle(
                fontSize: 11, color: AppColors.textSecondary)),
      ]),
    );
  }

  Widget _buildQuizBars() {
    if (_learners.isEmpty) return const SizedBox.shrink();
    final maxQ = _learners
        .map((l) => l.quizzesTaken)
        .reduce((a, b) => a > b ? a : b);
    if (maxQ == 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: const Border.fromBorderSide(
                BorderSide(color: AppColors.border))),
        child: const Center(
            child: Text('No quizzes taken yet',
                style: TextStyle(color: AppColors.textSecondary))),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: const Border.fromBorderSide(
              BorderSide(color: AppColors.border))),
      child: Column(
          children: _learners.map((l) {
        final frac = maxQ > 0 ? (l.quizzesTaken / maxQ) * _anim.value : 0.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(children: [
            SizedBox(
              width: 32, height: 32,
              child: CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Text(
                    l.name.isNotEmpty ? l.name[0].toUpperCase() : 'L',
                    style: const TextStyle(color: AppColors.primary,
                        fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  Text(l.name, style: const TextStyle(fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
                  Text(
                      '${l.quizzesTaken} quiz${l.quizzesTaken == 1 ? '' : 'zes'}',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 5),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                      value: frac,
                      minHeight: 8,
                      backgroundColor: AppColors.primaryLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary)),
                ),
              ]),
            ),
          ]),
        );
      }).toList()),
    );
  }
}

// ── Header style constant ────────────────────────────────────────────────────
const _headerStyle = TextStyle(
    fontSize: 11, fontWeight: FontWeight.w700,
    color: AppColors.textSecondary);

// ── Custom painters (unchanged) ──────────────────────────────────────────────
class _BarData {
  final String label;
  final int count;
  final Color color;
  const _BarData(this.label, this.count, this.color);
}

class _RingPainter extends CustomPainter {
  final double value, progress;
  final Color color, bgColor;
  const _RingPainter({required this.value, required this.progress,
      required this.color, required this.bgColor});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = min(cx, cy) - 10;
    const stroke = 12.0;
    canvas.drawCircle(Offset(cx, cy), r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = bgColor.withOpacity(0.3));
    final sweep = 2 * pi * value * progress;
    canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        -pi / 2, sweep, false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round
          ..color = color);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.value != value || old.progress != progress;
}

class _BarChartPainter extends CustomPainter {
  final List<_BarData> buckets;
  final int maxCount;
  final double progress;
  const _BarChartPainter({required this.buckets, required this.maxCount,
      required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (maxCount == 0) return;
    final barW   = size.width / buckets.length * 0.5;
    final gap    = size.width / buckets.length;
    const topPad = 20.0;

    for (int i = 0; i < buckets.length; i++) {
      final b   = buckets[i];
      final cx  = gap * i + gap / 2;
      final maxH = size.height - topPad;
      final bH  = (b.count / maxCount) * maxH * progress;
      final rect = RRect.fromRectAndRadius(
          Rect.fromLTWH(cx - barW / 2, size.height - bH, barW, bH),
          const Radius.circular(6));
      canvas.drawRRect(rect,
          Paint()..color = b.color.withOpacity(0.85)
            ..style = PaintingStyle.fill);
      if (b.count > 0 && progress > 0.7) {
        final tp = TextPainter(
          text: TextSpan(text: '${b.count}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
                  color: b.color)),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(cx - tp.width / 2, size.height - bH - topPad));
      }
    }
    final gridPaint = Paint()
      ..color = AppColors.border.withOpacity(0.4)
      ..strokeWidth = 0.5;
    for (int i = 1; i <= 3; i++) {
      final y = size.height - (size.height - topPad) * i / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(_BarChartPainter old) =>
      old.progress != progress || old.maxCount != maxCount;
}

// ── Learner detail card (unchanged, now also tappable) ───────────────────────
class _LearnerDetailCard extends StatelessWidget {
  final LearnerProgress learner;
  const _LearnerDetailCard({required this.learner});

  Color get _scoreColor => learner.averageScore >= 80
      ? AppColors.green
      : learner.averageScore >= 60 ? AppColors.amber : AppColors.orange;

  String get _scoreLabel => learner.averageScore >= 80
      ? 'Excellent'
      : learner.averageScore >= 60
          ? 'Good'
          : learner.averageScore >= 40 ? 'Average' : 'Needs work';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: const Border.fromBorderSide(
              BorderSide(color: AppColors.border))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              radius: 22,
              child: Text(
                  learner.name.isNotEmpty ? learner.name[0].toUpperCase() : 'L',
                  style: const TextStyle(color: AppColors.primary,
                      fontWeight: FontWeight.w800, fontSize: 16))),
          const SizedBox(width: 12),
          Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(learner.name, style: const TextStyle(fontSize: 14,
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Row(children: [
              const Icon(Icons.phone, size: 12, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(learner.phoneNumber, style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
            ]),
            if (learner.department != null || learner.jobRole != null)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  [learner.jobRole, learner.department]
                      .where((s) => s != null && s.isNotEmpty)
                      .join(' · '),
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
              ),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('${learner.averageScore}%',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900,
                    color: _scoreColor)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                  color: _scoreColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(_scoreLabel, style: TextStyle(fontSize: 9,
                  fontWeight: FontWeight.w700, color: _scoreColor)),
            ),
          ]),
        ]),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
              value: learner.averageScore / 100,
              backgroundColor: AppColors.primaryLight,
              valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
              minHeight: 6)),
        const SizedBox(height: 10),
        Row(children: [
          _StatChip(icon: Icons.menu_book, label: '${learner.coursesTaken} courses',
              color: AppColors.primary),
          const SizedBox(width: 8),
          _StatChip(icon: Icons.quiz, label: '${learner.quizzesTaken} quizzes',
              color: AppColors.amber),
          const SizedBox(width: 8),
          _StatChip(icon: Icons.check_circle,
              label: '${learner.modulesCompleted} modules',
              color: AppColors.green),
        ]),
      ]),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value, label;
  final Color color;
  final IconData icon;
  const _MiniStat({required this.value, required this.label,
      required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: const Border.fromBorderSide(
              BorderSide(color: AppColors.border))),
      child: Column(children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 18,
            fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9,
            color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center),
      ]),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 11, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10,
            color: color, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}