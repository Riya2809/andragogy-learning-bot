// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/models.dart';

// const _blue   = Color(0xFF1348D4);
// const _green  = Color(0xFF00875A);
// const _orange = Color(0xFFFF5630);
// const _amber  = Color(0xFFFF991F);
// const _bg     = Color(0xFFF4F6FB);
// const _border = Color(0xFFE4E9F2);
// const _text   = Color(0xFF0A1628);
// const _sub    = Color(0xFF6B7A99);
// const _pLight = Color(0xFFE8EEFF);

// // ── Drop into Home tab as a widget ────────────────────────────
// // Usage: AnalyticsDashboardWidget(courses: _courses, learners: _learners)

// class AnalyticsDashboardWidget extends StatefulWidget {
//   final List<Course> courses;
//   final List<LearnerProgress> learners;
//   const AnalyticsDashboardWidget({
//     super.key,
//     required this.courses,
//     required this.learners,
//   });

//   @override
//   State<AnalyticsDashboardWidget> createState() => _AnalyticsDashboardState();
// }

// class _AnalyticsDashboardState extends State<AnalyticsDashboardWidget> {
//   List<dynamic> _bestCourses = [];
//   Map<String, dynamic> _dashStats = {};
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     try {
//       final results = await Future.wait([
//         ApiService.get('/analytics/best-courses'),
//         ApiService.get('/analytics/dashboard'),
//       ]);
//       setState(() {
//         _bestCourses = results[0]['data'] ?? [];
//         _dashStats   = results[1]['data'] ?? {};
//       });
//     } catch (_) {}
//     setState(() => _loading = false);
//   }

//   // ── Computed from learner list ─────────────────────────────
//   int get _totalLearners => widget.learners.length;
//   int get _completedCount => widget.learners.where((l) => l.coursesTaken > 0 && l.averageScore >= 60).length;
//   double get _completionRate => _totalLearners == 0 ? 0 : (_completedCount / _totalLearners) * 100;

//   int get _avgScore => widget.learners.isEmpty ? 0
//     : widget.learners.fold(0, (int s, l) => s + l.averageScore) ~/ widget.learners.length;

//   int get _activeCount => widget.learners.where((l) => l.quizzesTaken > 0).length;
//   int get _inactiveCount => _totalLearners - _activeCount;

//   // Drop-off: learners enrolled but no quiz taken
//   int get _dropOffCount => widget.learners.where((l) => l.coursesTaken > 0 && l.quizzesTaken == 0).length;
//   double get _dropOffRate => _totalLearners == 0 ? 0 : (_dropOffCount / _totalLearners) * 100;

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return Container(
//         height: 200,
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
//           border: const Border.fromBorderSide(BorderSide(color: _border))),
//         child: const Center(child: CircularProgressIndicator(color: _blue)));
//     }

//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       // ── Section header ─────────────────────────────────────
//       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         const Text('Analytics Overview',
//           style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _text)),
//         GestureDetector(
//           onTap: _load,
//           child: const Icon(Icons.refresh, color: _blue, size: 20)),
//       ]),
//       const SizedBox(height: 12),

//       // ── Metric cards row ───────────────────────────────────
//       SizedBox(height: 90,
//         child: ListView(scrollDirection: Axis.horizontal, children: [
//           _MetricCard(
//             label: 'Completion Rate',
//             value: '${_completionRate.toStringAsFixed(1)}%',
//             icon: Icons.check_circle_outline_rounded,
//             color: _green,
//             sub: '$_completedCount of $_totalLearners passed',
//             trend: _completionRate >= 60 ? '↑ Good' : '↓ Low'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Avg Score',
//             value: '$_avgScore%',
//             icon: Icons.star_outline_rounded,
//             color: _avgScore >= 70 ? _green : _avgScore >= 50 ? _amber : _orange,
//             sub: 'Across all quizzes',
//             trend: _avgScore >= 70 ? '↑ Strong' : _avgScore >= 50 ? '→ Fair' : '↓ Weak'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Active Learners',
//             value: '$_activeCount',
//             icon: Icons.people_outline_rounded,
//             color: _blue,
//             sub: '$_inactiveCount not started yet',
//             trend: _activeCount > 0 ? '↑ Engaged' : '→ None yet'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Drop-off Rate',
//             value: '${_dropOffRate.toStringAsFixed(1)}%',
//             icon: Icons.trending_down_rounded,
//             color: _dropOffRate > 30 ? _orange : _amber,
//             sub: '$_dropOffCount enrolled, no quiz',
//             trend: _dropOffRate > 30 ? '↑ High risk' : '✓ Acceptable'),
//         ])),
//       const SizedBox(height: 16),

//       // ── Completion funnel ──────────────────────────────────
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//           border: const Border.fromBorderSide(BorderSide(color: _border))),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('Learner Funnel',
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
//           const SizedBox(height: 4),
//           const Text('How learners progress through the platform',
//             style: TextStyle(fontSize: 11, color: _sub)),
//           const SizedBox(height: 14),
//           _FunnelBar('Registered',      _totalLearners, _totalLearners, _blue),
//           const SizedBox(height: 8),
//           _FunnelBar('Started Course',  _activeCount,   _totalLearners, _blue),
//           const SizedBox(height: 8),
//           _FunnelBar('Took Quiz',       widget.learners.where((l) => l.quizzesTaken > 0).length, _totalLearners, _amber),
//           const SizedBox(height: 8),
//           _FunnelBar('Passed (≥60%)',   _completedCount, _totalLearners, _green),
//         ])),
//       const SizedBox(height: 16),

//       // ── Course performance table ───────────────────────────
//       if (_bestCourses.isNotEmpty) ...[
//         const Text('Course Performance',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//             border: const Border.fromBorderSide(BorderSide(color: _border))),
//           child: Column(children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF8F9FA),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(14), topRight: Radius.circular(14))),
//               child: const Row(children: [
//                 Expanded(flex: 4, child: Text('Course', style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Attempts', textAlign: TextAlign.center, style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Pass %', textAlign: TextAlign.center, style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Avg', textAlign: TextAlign.right, style: _hStyle)),
//               ])),
//             // Rows
//             ..._bestCourses.take(5).asMap().entries.map((e) {
//               final c    = e.value as Map<String, dynamic>;
//               final rank = e.key;
//               final avg  = (c['avg_score'] as num?)?.toDouble() ?? 0;
//               final pass = (c['pass_rate'] as num?)?.toDouble() ?? 0;
//               final att  = c['total_attempts'] ?? 0;
//               final color= avg >= 80 ? _green : avg >= 60 ? _blue : _orange;
//               return Column(children: [
//                 const Divider(height: 1, color: _border),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   child: Row(children: [
//                     // Rank + title
//                     Expanded(flex: 4, child: Row(children: [
//                       Container(width: 24, height: 24,
//                         decoration: BoxDecoration(
//                           color: rank == 0 ? const Color(0xFFFFF3CD)
//                             : rank == 1 ? const Color(0xFFF0F0F0)
//                             : const Color(0xFFFFF0E6),
//                           borderRadius: BorderRadius.circular(6)),
//                         child: Center(child: Text(
//                           rank == 0 ? '🥇' : rank == 1 ? '🥈' : rank == 2 ? '🥉' : '#${rank+1}',
//                           style: const TextStyle(fontSize: 12)))),
//                       const SizedBox(width: 8),
//                       Expanded(child: Text(c['course_title'] ?? '',
//                         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _text),
//                         maxLines: 1, overflow: TextOverflow.ellipsis)),
//                     ])),
//                     SizedBox(width: 56, child: Text('$att',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 12, color: _text))),
//                     SizedBox(width: 56, child: Text('$pass%',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
//                         color: pass >= 60 ? _green : _orange))),
//                     SizedBox(width: 56, child: Text('${avg.toStringAsFixed(1)}%',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color))),
//                   ])),
//               ]);
//             }),
//           ])),
//       ],
//       const SizedBox(height: 16),

//       // ── Drop-off alert ─────────────────────────────────────
//       if (_dropOffRate > 20)
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFFFF4E6),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _orange.withOpacity(0.3))),
//           child: Row(children: [
//             const Icon(Icons.warning_amber_rounded, color: _orange, size: 22),
//             const SizedBox(width: 12),
//             Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const Text('High Drop-off Rate Detected',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _orange)),
//               const SizedBox(height: 3),
//               Text('$_dropOffCount learner(s) enrolled but haven\'t taken any quiz yet. '
//                 'Consider sending a broadcast reminder.',
//                 style: const TextStyle(fontSize: 11, color: _text, height: 1.4)),
//             ])),
//           ])),

//       if (_completionRate < 50 && _totalLearners > 0)
//         Container(
//           margin: const EdgeInsets.only(top: 10),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFE8EEFF),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _blue.withOpacity(0.3))),
//           child: Row(children: [
//             const Icon(Icons.lightbulb_outline, color: _blue, size: 22),
//             const SizedBox(width: 12),
//             const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text('Tip: Improve Completion',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _blue)),
//               SizedBox(height: 3),
//               Text('Add more modules, schedule quiz reminders, or broadcast motivation messages to increase completion.',
//                 style: TextStyle(fontSize: 11, color: _text, height: 1.4)),
//             ])),
//           ])),
//     ]);
//   }
// }

// // ── Funnel bar ─────────────────────────────────────────────────
// class _FunnelBar extends StatelessWidget {
//   final String label;
//   final int count, total;
//   final Color color;
//   const _FunnelBar(this.label, this.count, this.total, this.color);

//   @override
//   Widget build(BuildContext context) {
//     final pct = total == 0 ? 0.0 : count / total;
//     return Row(children: [
//       SizedBox(width: 110, child: Text(label,
//         style: const TextStyle(fontSize: 12, color: _sub, fontWeight: FontWeight.w600))),
//       Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         ClipRRect(borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(value: pct, minHeight: 10,
//             backgroundColor: const Color(0xFFE8EEFF),
//             valueColor: AlwaysStoppedAnimation<Color>(color))),
//       ])),
//       const SizedBox(width: 10),
//       SizedBox(width: 48, child: Text('$count (${(pct*100).toStringAsFixed(0)}%)',
//         textAlign: TextAlign.right,
//         style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color))),
//     ]);
//   }
// }

// // ── Metric card ────────────────────────────────────────────────
// class _MetricCard extends StatelessWidget {
//   final String label, value, sub, trend;
//   final IconData icon;
//   final Color color;
//   const _MetricCard({
//     required this.label, required this.value, required this.icon,
//     required this.color, required this.sub, required this.trend});

//   @override
//   Widget build(BuildContext context) {
//     final trendColor = trend.startsWith('↑') ? _green
//       : trend.startsWith('↓') ? _orange : _amber;
//     return Container(
//       width: 155, height: 90,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white, borderRadius: BorderRadius.circular(14),
//         border: Border(left: BorderSide(color: color, width: 4),
//           right: const BorderSide(color: _border),
//           top: const BorderSide(color: _border),
//           bottom: const BorderSide(color: _border))),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Icon(icon, color: color, size: 16),
//           Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//             decoration: BoxDecoration(color: trendColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10)),
//             child: Text(trend,
//               style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: trendColor))),
//         ]),
//         const Spacer(),
//         Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
//         Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _text)),
//         Text(sub, style: const TextStyle(fontSize: 9, color: _sub),
//           maxLines: 1, overflow: TextOverflow.ellipsis),
//       ]));
//   }
// }

// const _hStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _sub);



























// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/models.dart';

// const _blue   = Color(0xFF1348D4);
// const _green  = Color(0xFF00875A);
// const _orange = Color(0xFFFF5630);
// const _amber  = Color(0xFFFF991F);
// const _bg     = Color(0xFFF4F6FB);
// const _border = Color(0xFFE4E9F2);
// const _text   = Color(0xFF0A1628);
// const _sub    = Color(0xFF6B7A99);
// const _pLight = Color(0xFFE8EEFF);

// // ── Drop into Home tab as a widget ────────────────────────────
// // Usage: AnalyticsDashboardWidget(courses: _courses, learners: _learners)

// class AnalyticsDashboardWidget extends StatefulWidget {
//   final List<Course> courses;
//   final List<LearnerProgress> learners;
//   const AnalyticsDashboardWidget({
//     super.key,
//     required this.courses,
//     required this.learners,
//   });

//   @override
//   State<AnalyticsDashboardWidget> createState() => _AnalyticsDashboardState();
// }

// class _AnalyticsDashboardState extends State<AnalyticsDashboardWidget> {
//   List<dynamic> _bestCourses = [];
//   Map<String, dynamic> _dashStats = {};
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     try {
//       final results = await Future.wait([
//         ApiService.get('/analytics/best-courses'),
//         ApiService.get('/analytics/dashboard'),
//       ]);
//       setState(() {
//         _bestCourses = results[0]['data'] ?? [];
//         _dashStats   = results[1]['data'] ?? {};
//       });
//     } catch (_) {}
//     setState(() => _loading = false);
//   }

//   // ── Computed from learner list ─────────────────────────────
//   int get _totalLearners => widget.learners.length;
//   int get _completedCount => widget.learners.where((l) => l.coursesTaken > 0 && l.averageScore >= 60).length;
//   double get _completionRate => _totalLearners == 0 ? 0 : (_completedCount / _totalLearners) * 100;

//   int get _avgScore => widget.learners.isEmpty ? 0
//     : widget.learners.fold(0, (int s, l) => s + l.averageScore) ~/ widget.learners.length;

//   int get _activeCount => widget.learners.where((l) => l.quizzesTaken > 0).length;
//   int get _inactiveCount => _totalLearners - _activeCount;

//   // Drop-off: learners enrolled but no quiz taken
//   int get _dropOffCount => widget.learners.where((l) => l.coursesTaken > 0 && l.quizzesTaken == 0).length;
//   double get _dropOffRate => _totalLearners == 0 ? 0 : (_dropOffCount / _totalLearners) * 100;

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return Container(
//         height: 200,
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
//           border: const Border.fromBorderSide(BorderSide(color: _border))),
//         child: const Center(child: CircularProgressIndicator(color: _blue)));
//     }

//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       // ── Section header ─────────────────────────────────────
//       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         const Text('Analytics Overview',
//           style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _text)),
//         GestureDetector(
//           onTap: _load,
//           child: const Icon(Icons.refresh, color: _blue, size: 20)),
//       ]),
//       const SizedBox(height: 12),

//       // ── Metric cards row ───────────────────────────────────
//       SizedBox(height: 90,
//         child: ListView(scrollDirection: Axis.horizontal, children: [
//           _MetricCard(
//             label: 'Completion Rate',
//             value: '${_completionRate.toStringAsFixed(1)}%',
//             icon: Icons.check_circle_outline_rounded,
//             color: _green,
//             sub: '$_completedCount of $_totalLearners passed',
//             trend: _completionRate >= 60 ? '↑ Good' : '↓ Low'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Avg Score',
//             value: '$_avgScore%',
//             icon: Icons.star_outline_rounded,
//             color: _avgScore >= 70 ? _green : _avgScore >= 50 ? _amber : _orange,
//             sub: 'Across all quizzes',
//             trend: _avgScore >= 70 ? '↑ Strong' : _avgScore >= 50 ? '→ Fair' : '↓ Weak'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Active Learners',
//             value: '$_activeCount',
//             icon: Icons.people_outline_rounded,
//             color: _blue,
//             sub: '$_inactiveCount not started yet',
//             trend: _activeCount > 0 ? '↑ Engaged' : '→ None yet'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Drop-off Rate',
//             value: '${_dropOffRate.toStringAsFixed(1)}%',
//             icon: Icons.trending_down_rounded,
//             color: _dropOffRate > 30 ? _orange : _amber,
//             sub: '$_dropOffCount enrolled, no quiz',
//             trend: _dropOffRate > 30 ? '↑ High risk' : '✓ Acceptable'),
//         ])),
//       const SizedBox(height: 16),

//       // ── Completion funnel ──────────────────────────────────
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//           border: const Border.fromBorderSide(BorderSide(color: _border))),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('Learner Funnel',
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
//           const SizedBox(height: 4),
//           const Text('How learners progress through the platform',
//             style: TextStyle(fontSize: 11, color: _sub)),
//           const SizedBox(height: 14),
//           _FunnelBar('Registered',      _totalLearners, _totalLearners, _blue),
//           const SizedBox(height: 8),
//           _FunnelBar('Started Course',  _activeCount,   _totalLearners, _blue),
//           const SizedBox(height: 8),
//           _FunnelBar('Took Quiz',       widget.learners.where((l) => l.quizzesTaken > 0).length, _totalLearners, _amber),
//           const SizedBox(height: 8),
//           _FunnelBar('Passed (≥60%)',   _completedCount, _totalLearners, _green),
//         ])),
//       const SizedBox(height: 16),

//       // ── Course performance table ───────────────────────────
//       if (_bestCourses.isNotEmpty) ...[
//         const Text('Course Performance',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//             border: const Border.fromBorderSide(BorderSide(color: _border))),
//           child: Column(children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF8F9FA),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(14), topRight: Radius.circular(14))),
//               child: const Row(children: [
//                 Expanded(flex: 4, child: Text('Course', style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Attempts', textAlign: TextAlign.center, style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Pass %', textAlign: TextAlign.center, style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Avg', textAlign: TextAlign.right, style: _hStyle)),
//               ])),
//             // Rows
//             ..._bestCourses.take(5).asMap().entries.map((e) {
//               final c    = e.value as Map<String, dynamic>;
//               final rank = e.key;
//               final avg  = (c['avg_score'] as num?)?.toDouble() ?? 0;
//               final pass = (c['pass_rate'] as num?)?.toDouble() ?? 0;
//               final att  = c['total_attempts'] ?? 0;
//               final color= avg >= 80 ? _green : avg >= 60 ? _blue : _orange;
//               return Column(children: [
//                 const Divider(height: 1, color: _border),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   child: Row(children: [
//                     // Rank + title
//                     Expanded(flex: 4, child: Row(children: [
//                       Container(width: 24, height: 24,
//                         decoration: BoxDecoration(
//                           color: rank == 0 ? const Color(0xFFFFF3CD)
//                             : rank == 1 ? const Color(0xFFF0F0F0)
//                             : const Color(0xFFFFF0E6),
//                           borderRadius: BorderRadius.circular(6)),
//                         child: Center(child: Text(
//                           rank == 0 ? '🥇' : rank == 1 ? '🥈' : rank == 2 ? '🥉' : '#${rank+1}',
//                           style: const TextStyle(fontSize: 12)))),
//                       const SizedBox(width: 8),
//                       Expanded(child: Text(c['course_title'] ?? '',
//                         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _text),
//                         maxLines: 1, overflow: TextOverflow.ellipsis)),
//                     ])),
//                     SizedBox(width: 56, child: Text('$att',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 12, color: _text))),
//                     SizedBox(width: 56, child: Text('$pass%',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
//                         color: pass >= 60 ? _green : _orange))),
//                     SizedBox(width: 56, child: Text('${avg.toStringAsFixed(1)}%',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color))),
//                   ])),
//               ]);
//             }),
//           ])),
//       ],
//       const SizedBox(height: 16),

//       // ── Drop-off alert ─────────────────────────────────────
//       if (_dropOffRate > 20)
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFFFF4E6),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _orange.withOpacity(0.3))),
//           child: Row(children: [
//             const Icon(Icons.warning_amber_rounded, color: _orange, size: 22),
//             const SizedBox(width: 12),
//             Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const Text('High Drop-off Rate Detected',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _orange)),
//               const SizedBox(height: 3),
//               Text('$_dropOffCount learner(s) enrolled but haven\'t taken any quiz yet. '
//                 'Consider sending a broadcast reminder.',
//                 style: const TextStyle(fontSize: 11, color: _text, height: 1.4)),
//             ])),
//           ])),

//       if (_completionRate < 50 && _totalLearners > 0)
//         Container(
//           margin: const EdgeInsets.only(top: 10),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFE8EEFF),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _blue.withOpacity(0.3))),
//           child: Row(children: [
//             const Icon(Icons.lightbulb_outline, color: _blue, size: 22),
//             const SizedBox(width: 12),
//             const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text('Tip: Improve Completion',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _blue)),
//               SizedBox(height: 3),
//               Text('Add more modules, schedule quiz reminders, or broadcast motivation messages to increase completion.',
//                 style: TextStyle(fontSize: 11, color: _text, height: 1.4)),
//             ])),
//           ])),
//     ]);
//   }
// }

// // ── Funnel bar ─────────────────────────────────────────────────
// class _FunnelBar extends StatelessWidget {
//   final String label;
//   final int count, total;
//   final Color color;
//   const _FunnelBar(this.label, this.count, this.total, this.color);

//   @override
//   Widget build(BuildContext context) {
//     final pct = total == 0 ? 0.0 : count / total;
//     return Row(children: [
//       SizedBox(width: 110, child: Text(label,
//         style: const TextStyle(fontSize: 12, color: _sub, fontWeight: FontWeight.w600))),
//       Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         ClipRRect(borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(value: pct, minHeight: 10,
//             backgroundColor: const Color(0xFFE8EEFF),
//             valueColor: AlwaysStoppedAnimation<Color>(color))),
//       ])),
//       const SizedBox(width: 10),
//       SizedBox(width: 48, child: Text('$count (${(pct*100).toStringAsFixed(0)}%)',
//         textAlign: TextAlign.right,
//         style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color))),
//     ]);
//   }
// }

// // ── Metric card ────────────────────────────────────────────────
// class _MetricCard extends StatelessWidget {
//   final String label, value, sub, trend;
//   final IconData icon;
//   final Color color;
//   const _MetricCard({
//     required this.label, required this.value, required this.icon,
//     required this.color, required this.sub, required this.trend});

//   @override
//   Widget build(BuildContext context) {
//     final trendColor = trend.startsWith('↑') ? _green
//       : trend.startsWith('↓') ? _orange : _amber;
//     return Container(
//       width: 155, height: 90,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white, borderRadius: BorderRadius.circular(14),
//         border: Border(left: BorderSide(color: color, width: 4),
//           right: const BorderSide(color: _border),
//           top: const BorderSide(color: _border),
//           bottom: const BorderSide(color: _border))),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Icon(icon, color: color, size: 16),
//           Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//             decoration: BoxDecoration(color: trendColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10)),
//             child: Text(trend,
//               style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: trendColor))),
//         ]),
//         const Spacer(),
//         Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
//         Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _text)),
//         Text(sub, style: const TextStyle(fontSize: 9, color: _sub),
//           maxLines: 1, overflow: TextOverflow.ellipsis),
//       ]));
//   }
// }

// const _hStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _sub);


















// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/models.dart';

// const _blue   = Color(0xFF1348D4);
// const _green  = Color(0xFF00875A);
// const _orange = Color(0xFFFF5630);
// const _amber  = Color(0xFFFF991F);
// const _bg     = Color(0xFFF4F6FB);
// const _border = Color(0xFFE4E9F2);
// const _text   = Color(0xFF0A1628);
// const _sub    = Color(0xFF6B7A99);
// const _pLight = Color(0xFFE8EEFF);

// // ── Drop into Home tab as a widget ────────────────────────────
// // Usage: AnalyticsDashboardWidget(courses: _courses, learners: _learners)

// class AnalyticsDashboardWidget extends StatefulWidget {
//   final List<Course> courses;
//   final List<LearnerProgress> learners;
//   const AnalyticsDashboardWidget({
//     super.key,
//     required this.courses,
//     required this.learners,
//   });

//   @override
//   State<AnalyticsDashboardWidget> createState() => _AnalyticsDashboardState();
// }

// class _AnalyticsDashboardState extends State<AnalyticsDashboardWidget> {
//   List<dynamic> _bestCourses = [];
//   Map<String, dynamic> _dashStats = {};
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     try {
//       final results = await Future.wait([
//         ApiService.get('/analytics/best-courses'),
//         ApiService.get('/analytics/dashboard'),
//       ]);
//       setState(() {
//         _bestCourses = results[0]['data'] ?? [];
//         _dashStats   = results[1]['data'] ?? {};
//       });
//     } catch (_) {}
//     setState(() => _loading = false);
//   }

//   // ── Computed from learner list ─────────────────────────────
//   int get _totalLearners => widget.learners.length;
//   int get _completedCount => widget.learners.where((l) => l.coursesTaken > 0 && l.averageScore >= 60).length;
//   double get _completionRate => _totalLearners == 0 ? 0 : (_completedCount / _totalLearners) * 100;

//   int get _avgScore => widget.learners.isEmpty ? 0
//     : widget.learners.fold(0, (int s, l) => s + l.averageScore) ~/ widget.learners.length;

//   int get _activeCount => widget.learners.where((l) => l.quizzesTaken > 0).length;
//   int get _inactiveCount => _totalLearners - _activeCount;

//   // Drop-off: learners enrolled but no quiz taken
//   int get _dropOffCount => widget.learners.where((l) => l.coursesTaken > 0 && l.quizzesTaken == 0).length;
//   double get _dropOffRate => _totalLearners == 0 ? 0 : (_dropOffCount / _totalLearners) * 100;

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return Container(
//         height: 200,
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
//           border: const Border.fromBorderSide(BorderSide(color: _border))),
//         child: const Center(child: CircularProgressIndicator(color: _blue)));
//     }

//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       // ── Section header ─────────────────────────────────────
//       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         const Text('Analytics Overview',
//           style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _text)),
//         GestureDetector(
//           onTap: _load,
//           child: const Icon(Icons.refresh, color: _blue, size: 20)),
//       ]),
//       const SizedBox(height: 12),

//       // ── Metric cards row ───────────────────────────────────
//       SizedBox(height: 90,
//         child: ListView(scrollDirection: Axis.horizontal, children: [
//           _MetricCard(
//             label: 'Completion Rate',
//             value: '${_completionRate.toStringAsFixed(1)}%',
//             icon: Icons.check_circle_outline_rounded,
//             color: _green,
//             sub: '$_completedCount of $_totalLearners passed',
//             trend: _completionRate >= 60 ? '↑ Good' : '↓ Low'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Avg Score',
//             value: '$_avgScore%',
//             icon: Icons.star_outline_rounded,
//             color: _avgScore >= 70 ? _green : _avgScore >= 50 ? _amber : _orange,
//             sub: 'Across all quizzes',
//             trend: _avgScore >= 70 ? '↑ Strong' : _avgScore >= 50 ? '→ Fair' : '↓ Weak'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Active Learners',
//             value: '$_activeCount',
//             icon: Icons.people_outline_rounded,
//             color: _blue,
//             sub: '$_inactiveCount not started yet',
//             trend: _activeCount > 0 ? '↑ Engaged' : '→ None yet'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Drop-off Rate',
//             value: '${_dropOffRate.toStringAsFixed(1)}%',
//             icon: Icons.trending_down_rounded,
//             color: _dropOffRate > 30 ? _orange : _amber,
//             sub: '$_dropOffCount enrolled, no quiz',
//             trend: _dropOffRate > 30 ? '↑ High risk' : '✓ Acceptable'),
//         ])),
//       const SizedBox(height: 16),

//       // ── Completion funnel ──────────────────────────────────
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//           border: const Border.fromBorderSide(BorderSide(color: _border))),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('Learner Funnel',
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
//           const SizedBox(height: 4),
//           const Text('How learners progress through the platform',
//             style: TextStyle(fontSize: 11, color: _sub)),
//           const SizedBox(height: 14),
//           _FunnelBar('Registered',      _totalLearners, _totalLearners, _blue),
//           const SizedBox(height: 8),
//           _FunnelBar('Started Course',  _activeCount,   _totalLearners, _blue),
//           const SizedBox(height: 8),
//           _FunnelBar('Took Quiz',       widget.learners.where((l) => l.quizzesTaken > 0).length, _totalLearners, _amber),
//           const SizedBox(height: 8),
//           _FunnelBar('Passed (≥60%)',   _completedCount, _totalLearners, _green),
//         ])),
//       const SizedBox(height: 16),

//       // ── Course performance table ───────────────────────────
//       if (_bestCourses.isNotEmpty) ...[
//         const Text('Course Performance',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//             border: const Border.fromBorderSide(BorderSide(color: _border))),
//           child: Column(children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF8F9FA),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(14), topRight: Radius.circular(14))),
//               child: const Row(children: [
//                 Expanded(flex: 4, child: Text('Course', style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Attempts', textAlign: TextAlign.center, style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Pass %', textAlign: TextAlign.center, style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Avg', textAlign: TextAlign.right, style: _hStyle)),
//               ])),
//             // Rows
//             ...List.from(_bestCourses.take(5)).asMap().entries.map((e) {
//               final c    = e.value as Map<String, dynamic>;
//               final rank = e.key;
//               final avg  = (c['avg_score'] as num?)?.toDouble() ?? 0;
//               final pass = (c['pass_rate'] as num?)?.toDouble() ?? 0;
//               final att  = c['total_attempts'] ?? 0;
//               final color= avg >= 80 ? _green : avg >= 60 ? _blue : _orange;
//               return Column(children: [
//                 const Divider(height: 1, color: _border),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   child: Row(children: [
//                     // Rank + title
//                     Expanded(flex: 4, child: Row(children: [
//                       Container(width: 24, height: 24,
//                         decoration: BoxDecoration(
//                           color: rank == 0 ? const Color(0xFFFFF3CD)
//                             : rank == 1 ? const Color(0xFFF0F0F0)
//                             : const Color(0xFFFFF0E6),
//                           borderRadius: BorderRadius.circular(6)),
//                         child: Center(child: Text(
//                           rank == 0 ? '🥇' : rank == 1 ? '🥈' : rank == 2 ? '🥉' : '#${rank+1}',
//                           style: const TextStyle(fontSize: 12)))),
//                       const SizedBox(width: 8),
//                       Expanded(child: Text(c['course_title'] ?? '',
//                         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _text),
//                         maxLines: 1, overflow: TextOverflow.ellipsis)),
//                     ])),
//                     SizedBox(width: 56, child: Text('$att',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 12, color: _text))),
//                     SizedBox(width: 56, child: Text('$pass%',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
//                         color: pass >= 60 ? _green : _orange))),
//                     SizedBox(width: 56, child: Text('${avg.toStringAsFixed(1)}%',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color))),
//                   ])),
//               ]);
//             }),
//           ])),
//       ],
//       const SizedBox(height: 16),

//       // ── Drop-off alert ─────────────────────────────────────
//       if (_dropOffRate > 20)
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFFFF4E6),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _orange.withOpacity(0.3))),
//           child: Row(children: [
//             const Icon(Icons.warning_amber_rounded, color: _orange, size: 22),
//             const SizedBox(width: 12),
//             Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const Text('High Drop-off Rate Detected',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _orange)),
//               const SizedBox(height: 3),
//               Text('$_dropOffCount learner(s) enrolled but haven\'t taken any quiz yet. '
//                 'Consider sending a broadcast reminder.',
//                 style: const TextStyle(fontSize: 11, color: _text, height: 1.4)),
//             ])),
//           ])),

//       if (_completionRate < 50 && _totalLearners > 0)
//         Container(
//           margin: const EdgeInsets.only(top: 10),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFE8EEFF),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _blue.withOpacity(0.3))),
//           child: Row(children: [
//             const Icon(Icons.lightbulb_outline, color: _blue, size: 22),
//             const SizedBox(width: 12),
//             const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text('Tip: Improve Completion',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _blue)),
//               SizedBox(height: 3),
//               Text('Add more modules, schedule quiz reminders, or broadcast motivation messages to increase completion.',
//                 style: TextStyle(fontSize: 11, color: _text, height: 1.4)),
//             ])),
//           ])),
//     ]);
//   }
// }

// // ── Funnel bar ─────────────────────────────────────────────────
// class _FunnelBar extends StatelessWidget {
//   final String label;
//   final int count, total;
//   final Color color;
//   const _FunnelBar(this.label, this.count, this.total, this.color);

//   @override
//   Widget build(BuildContext context) {
//     final pct = total == 0 ? 0.0 : count / total;
//     return Row(children: [
//       SizedBox(width: 110, child: Text(label,
//         style: const TextStyle(fontSize: 12, color: _sub, fontWeight: FontWeight.w600))),
//       Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         ClipRRect(borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(value: pct, minHeight: 10,
//             backgroundColor: const Color(0xFFE8EEFF),
//             valueColor: AlwaysStoppedAnimation<Color>(color))),
//       ])),
//       const SizedBox(width: 10),
//       SizedBox(width: 48, child: Text('$count (${(pct*100).toStringAsFixed(0)}%)',
//         textAlign: TextAlign.right,
//         style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color))),
//     ]);
//   }
// }

// // ── Metric card ────────────────────────────────────────────────
// class _MetricCard extends StatelessWidget {
//   final String label, value, sub, trend;
//   final IconData icon;
//   final Color color;
//   const _MetricCard({
//     required this.label, required this.value, required this.icon,
//     required this.color, required this.sub, required this.trend});

//   @override
//   Widget build(BuildContext context) {
//     final trendColor = trend.startsWith('↑') ? _green
//       : trend.startsWith('↓') ? _orange : _amber;
//     return Container(
//       width: 155, height: 90,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white, borderRadius: BorderRadius.circular(14),
//         border: Border(left: BorderSide(color: color, width: 4),
//           right: const BorderSide(color: _border),
//           top: const BorderSide(color: _border),
//           bottom: const BorderSide(color: _border))),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Icon(icon, color: color, size: 16),
//           Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//             decoration: BoxDecoration(color: trendColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10)),
//             child: Text(trend,
//               style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: trendColor))),
//         ]),
//         const Spacer(),
//         Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
//         Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _text)),
//         Text(sub, style: const TextStyle(fontSize: 9, color: _sub),
//           maxLines: 1, overflow: TextOverflow.ellipsis),
//       ]));
//   }
// }

// const _hStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _sub);

























// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/models.dart';

// const _blue   = Color(0xFF1348D4);
// const _green  = Color(0xFF00875A);
// const _orange = Color(0xFFFF5630);
// const _amber  = Color(0xFFFF991F);
// const _bg     = Color(0xFFF4F6FB);
// const _border = Color(0xFFE4E9F2);
// const _text   = Color(0xFF0A1628);
// const _sub    = Color(0xFF6B7A99);
// const _pLight = Color(0xFFE8EEFF);

// // ── Drop into Home tab as a widget ────────────────────────────
// // Usage: AnalyticsDashboardWidget(courses: _courses, learners: _learners)

// class AnalyticsDashboardWidget extends StatefulWidget {
//   final List<Course> courses;
//   final List<LearnerProgress> learners;
//   const AnalyticsDashboardWidget({
//     super.key,
//     required this.courses,
//     required this.learners,
//   });

//   @override
//   State<AnalyticsDashboardWidget> createState() => _AnalyticsDashboardState();
// }

// class _AnalyticsDashboardState extends State<AnalyticsDashboardWidget> {
//   List<dynamic> _bestCourses = [];
//   Map<String, dynamic> _dashStats = {};
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     try {
//       final results = await Future.wait([
//         ApiService.get('/analytics/best-courses'),
//         ApiService.get('/analytics/dashboard'),
//       ]);
//       setState(() {
//         _bestCourses = results[0]['data'] ?? [];
//         _dashStats   = results[1]['data'] ?? {};
//       });
//     } catch (_) {}
//     setState(() => _loading = false);
//   }

//   // ── Computed from learner list ─────────────────────────────
//   int get _totalLearners => widget.learners.length;
//   int get _completedCount => widget.learners.where((l) => l.coursesTaken > 0 && l.averageScore >= 60).length;
//   double get _completionRate => _totalLearners == 0 ? 0 : (_completedCount / _totalLearners) * 100;

//   int get _avgScore => widget.learners.isEmpty ? 0
//     : widget.learners.fold(0, (int s, l) => s + l.averageScore) ~/ widget.learners.length;

//   int get _activeCount => widget.learners.where((l) => l.quizzesTaken > 0).length;
//   int get _inactiveCount => _totalLearners - _activeCount;

//   // Drop-off: learners enrolled but no quiz taken
//   int get _dropOffCount => widget.learners.where((l) => l.coursesTaken > 0 && l.quizzesTaken == 0).length;
//   double get _dropOffRate => _totalLearners == 0 ? 0 : (_dropOffCount / _totalLearners) * 100;

//   @override
//   Widget build(BuildContext context) {
//     if (_loading) {
//       return Container(
//         height: 200,
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
//           border: const Border.fromBorderSide(BorderSide(color: _border))),
//         child: const Center(child: CircularProgressIndicator(color: _blue)));
//     }

//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       // ── Section header ─────────────────────────────────────
//       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         const Text('Analytics Overview',
//           style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _text)),
//         GestureDetector(
//           onTap: _load,
//           child: const Icon(Icons.refresh, color: _blue, size: 20)),
//       ]),
//       const SizedBox(height: 12),

//       // ── Metric cards row ───────────────────────────────────
//       SizedBox(height: 90,
//         child: ListView(scrollDirection: Axis.horizontal, children: [
//           _MetricCard(
//             label: 'Completion Rate',
//             value: '${_completionRate.toStringAsFixed(1)}%',
//             icon: Icons.check_circle_outline_rounded,
//             color: _green,
//             sub: '$_completedCount of $_totalLearners passed',
//             trend: _completionRate >= 60 ? '↑ Good' : '↓ Low'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Avg Score',
//             value: '$_avgScore%',
//             icon: Icons.star_outline_rounded,
//             color: _avgScore >= 70 ? _green : _avgScore >= 50 ? _amber : _orange,
//             sub: 'Across all quizzes',
//             trend: _avgScore >= 70 ? '↑ Strong' : _avgScore >= 50 ? '→ Fair' : '↓ Weak'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Active Learners',
//             value: '$_activeCount',
//             icon: Icons.people_outline_rounded,
//             color: _blue,
//             sub: '$_inactiveCount not started yet',
//             trend: _activeCount > 0 ? '↑ Engaged' : '→ None yet'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Drop-off Rate',
//             value: '${_dropOffRate.toStringAsFixed(1)}%',
//             icon: Icons.trending_down_rounded,
//             color: _dropOffRate > 30 ? _orange : _amber,
//             sub: '$_dropOffCount enrolled, no quiz',
//             trend: _dropOffRate > 30 ? '↑ High risk' : '✓ Acceptable'),
//         ])),
//       const SizedBox(height: 16),

//       // ── Completion funnel ──────────────────────────────────
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//           border: const Border.fromBorderSide(BorderSide(color: _border))),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('Learner Funnel',
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
//           const SizedBox(height: 4),
//           const Text('How learners progress through the platform',
//             style: TextStyle(fontSize: 11, color: _sub)),
//           const SizedBox(height: 14),
//           _FunnelBar('Registered',      _totalLearners, _totalLearners, _blue),
//           const SizedBox(height: 8),
//           _FunnelBar('Started Course',  _activeCount,   _totalLearners, _blue),
//           const SizedBox(height: 8),
//           _FunnelBar('Took Quiz',       widget.learners.where((l) => l.quizzesTaken > 0).length, _totalLearners, _amber),
//           const SizedBox(height: 8),
//           _FunnelBar('Passed (≥60%)',   _completedCount, _totalLearners, _green),
//         ])),
//       const SizedBox(height: 16),

//       // ── Course performance table ───────────────────────────
//       if (_bestCourses.isNotEmpty) ...[
//         const Text('Course Performance',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//             border: const Border.fromBorderSide(BorderSide(color: _border))),
//           child: Column(children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF8F9FA),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(14), topRight: Radius.circular(14))),
//               child: const Row(children: [
//                 Expanded(flex: 4, child: Text('Course', style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Attempts', textAlign: TextAlign.center, style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Pass %', textAlign: TextAlign.center, style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Avg', textAlign: TextAlign.right, style: _hStyle)),
//               ])),
//             // Rows
//             ...List.from(_bestCourses.take(5)).asMap().entries.map((e) {
//               final c    = e.value as Map<String, dynamic>;
//               final rank = e.key;
//               final avg  = (c['avg_score'] as num?)?.toDouble() ?? 0;
//               final pass = (c['pass_rate'] as num?)?.toDouble() ?? 0;
//               final att  = c['total_attempts'] ?? 0;
//               final color= avg >= 80 ? _green : avg >= 60 ? _blue : _orange;
//               return Column(children: [
//                 const Divider(height: 1, color: _border),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   child: Row(children: [
//                     // Rank + title
//                     Expanded(flex: 4, child: Row(children: [
//                       Container(width: 24, height: 24,
//                         decoration: BoxDecoration(
//                           color: rank == 0 ? const Color(0xFFFFF3CD)
//                             : rank == 1 ? const Color(0xFFF0F0F0)
//                             : const Color(0xFFFFF0E6),
//                           borderRadius: BorderRadius.circular(6)),
//                         child: Center(child: Text(
//                           rank == 0 ? '🥇' : rank == 1 ? '🥈' : rank == 2 ? '🥉' : '#${rank+1}',
//                           style: const TextStyle(fontSize: 12)))),
//                       const SizedBox(width: 8),
//                       Expanded(child: Text(c['course_title'] ?? '',
//                         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _text),
//                         maxLines: 1, overflow: TextOverflow.ellipsis)),
//                     ])),
//                     SizedBox(width: 56, child: Text('$att',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 12, color: _text))),
//                     SizedBox(width: 56, child: Text('$pass%',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
//                         color: pass >= 60 ? _green : _orange))),
//                     SizedBox(width: 56, child: Text('${avg.toStringAsFixed(1)}%',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color))),
//                   ])),
//               ]);
//             }),
//           ])),
//       ],
//       const SizedBox(height: 16),

//       // ── Drop-off alert ─────────────────────────────────────
//       if (_dropOffRate > 20)
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFFFF4E6),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _orange.withOpacity(0.3))),
//           child: Row(children: [
//             const Icon(Icons.warning_amber_rounded, color: _orange, size: 22),
//             const SizedBox(width: 12),
//             Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const Text('High Drop-off Rate Detected',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _orange)),
//               const SizedBox(height: 3),
//               Text('$_dropOffCount learner(s) enrolled but haven\'t taken any quiz yet. '
//                 'Consider sending a broadcast reminder.',
//                 style: const TextStyle(fontSize: 11, color: _text, height: 1.4)),
//             ])),
//           ])),

//       if (_completionRate < 50 && _totalLearners > 0)
//         Container(
//           margin: const EdgeInsets.only(top: 10),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFE8EEFF),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _blue.withOpacity(0.3))),
//           child: Row(children: [
//             const Icon(Icons.lightbulb_outline, color: _blue, size: 22),
//             const SizedBox(width: 12),
//             const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text('Tip: Improve Completion',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _blue)),
//               SizedBox(height: 3),
//               Text('Add more modules, schedule quiz reminders, or broadcast motivation messages to increase completion.',
//                 style: TextStyle(fontSize: 11, color: _text, height: 1.4)),
//             ])),
//           ])),
//     ]);
//   }
// }

// // ── Funnel bar ─────────────────────────────────────────────────
// class _FunnelBar extends StatelessWidget {
//   final String label;
//   final int count, total;
//   final Color color;
//   const _FunnelBar(this.label, this.count, this.total, this.color);

//   @override
//   Widget build(BuildContext context) {
//     final pct = total == 0 ? 0.0 : count / total;
//     return Row(children: [
//       SizedBox(width: 110, child: Text(label,
//         style: const TextStyle(fontSize: 12, color: _sub, fontWeight: FontWeight.w600))),
//       Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         ClipRRect(borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(value: pct, minHeight: 10,
//             backgroundColor: const Color(0xFFE8EEFF),
//             valueColor: AlwaysStoppedAnimation<Color>(color))),
//       ])),
//       const SizedBox(width: 10),
//       SizedBox(width: 48, child: Text('$count (${(pct*100).toStringAsFixed(0)}%)',
//         textAlign: TextAlign.right,
//         style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color))),
//     ]);
//   }
// }

// // ── Metric card ────────────────────────────────────────────────
// class _MetricCard extends StatelessWidget {
//   final String label, value, sub, trend;
//   final IconData icon;
//   final Color color;
//   const _MetricCard({
//     required this.label, required this.value, required this.icon,
//     required this.color, required this.sub, required this.trend});

//   @override
//   Widget build(BuildContext context) {
//     final trendColor = trend.startsWith('↑') ? _green
//       : trend.startsWith('↓') ? _orange : _amber;
//     return Container(
//       width: 155, height: 90,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white, borderRadius: BorderRadius.circular(14),
//         border: Border(left: BorderSide(color: color, width: 4),
//           right: const BorderSide(color: _border),
//           top: const BorderSide(color: _border),
//           bottom: const BorderSide(color: _border))),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Icon(icon, color: color, size: 16),
//           Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//             decoration: BoxDecoration(color: trendColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10)),
//             child: Text(trend,
//               style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: trendColor))),
//         ]),
//         const Spacer(),
//         Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
//         Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _text)),
//         Text(sub, style: const TextStyle(fontSize: 9, color: _sub),
//           maxLines: 1, overflow: TextOverflow.ellipsis),
//       ]));
//   }
// }

// const _hStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _sub);

























// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/models.dart';

// const _blue   = Color(0xFF1348D4);
// const _green  = Color(0xFF00875A);
// const _orange = Color(0xFFFF5630);
// const _amber  = Color(0xFFFF991F);
// const _bg     = Color(0xFFF4F6FB);
// const _border = Color(0xFFE4E9F2);
// const _text   = Color(0xFF0A1628);
// const _sub    = Color(0xFF6B7A99);
// const _pLight = Color(0xFFE8EEFF);

// // ── Drop into Home tab as a widget ────────────────────────────
// // Usage: AnalyticsDashboardWidget(courses: _courses, learners: _learners)

// class AnalyticsDashboardWidget extends StatefulWidget {
//   final List<Course> courses;
//   final List<LearnerProgress> learners;
//   const AnalyticsDashboardWidget({
//     super.key,
//     required this.courses,
//     required this.learners,
//   });

//   @override
//   State<AnalyticsDashboardWidget> createState() => _AnalyticsDashboardState();
// }

// class _AnalyticsDashboardState extends State<AnalyticsDashboardWidget> {
//   List<dynamic> _bestCourses = [];
//   Map<String, dynamic> _dashStats = {};
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     try {
//       final results = await Future.wait([
//         ApiService.get('/analytics/best-courses'),
//         ApiService.get('/analytics/dashboard'),
//       ]);
//       setState(() {
//         _bestCourses = results[0]['data'] ?? [];
//         _dashStats   = results[1]['data'] ?? {};
//       });
//     } catch (_) {}
//     setState(() => _loading = false);
//   }

//   // ── Computed from learner list ─────────────────────────────
//   int get _totalLearners => widget.learners.length;
//   int get _completedCount => widget.learners.where((l) => l.coursesTaken > 0 && l.averageScore >= 60).length;
//   double get _completionRate => _totalLearners == 0 ? 0 : (_completedCount / _totalLearners) * 100;

//   int get _avgScore => widget.learners.isEmpty ? 0
//     : widget.learners.fold(0, (int s, l) => s + l.averageScore) ~/ widget.learners.length;

//   int get _activeCount => widget.learners.where((l) => l.quizzesTaken > 0).length;
//   int get _inactiveCount => _totalLearners - _activeCount;

//   // Drop-off: learners enrolled but no quiz taken
//   int get _dropOffCount => widget.learners.where((l) => l.coursesTaken > 0 && l.quizzesTaken == 0).length;
//   double get _dropOffRate => _totalLearners == 0 ? 0 : (_dropOffCount / _totalLearners) * 100;

//   @override
//   Widget build(BuildContext context) {
//     // Always render - API data (best courses) loads async, but learner metrics show immediately

//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       // ── Section header ─────────────────────────────────────
//       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         const Text('Analytics Overview',
//           style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _text)),
//         GestureDetector(
//           onTap: _load,
//           child: const Icon(Icons.refresh, color: _blue, size: 20)),
//       ]),
//       const SizedBox(height: 12),

//       // ── Metric cards row ───────────────────────────────────
//       SizedBox(height: 90,
//         child: ListView(scrollDirection: Axis.horizontal, children: [
//           _MetricCard(
//             label: 'Completion Rate',
//             value: '${_completionRate.toStringAsFixed(1)}%',
//             icon: Icons.check_circle_outline_rounded,
//             color: _green,
//             sub: '$_completedCount of $_totalLearners passed',
//             trend: _completionRate >= 60 ? '↑ Good' : '↓ Low'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Avg Score',
//             value: '$_avgScore%',
//             icon: Icons.star_outline_rounded,
//             color: _avgScore >= 70 ? _green : _avgScore >= 50 ? _amber : _orange,
//             sub: 'Across all quizzes',
//             trend: _avgScore >= 70 ? '↑ Strong' : _avgScore >= 50 ? '→ Fair' : '↓ Weak'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Active Learners',
//             value: '$_activeCount',
//             icon: Icons.people_outline_rounded,
//             color: _blue,
//             sub: '$_inactiveCount not started yet',
//             trend: _activeCount > 0 ? '↑ Engaged' : '→ None yet'),
//           const SizedBox(width: 10),
//           _MetricCard(
//             label: 'Drop-off Rate',
//             value: '${_dropOffRate.toStringAsFixed(1)}%',
//             icon: Icons.trending_down_rounded,
//             color: _dropOffRate > 30 ? _orange : _amber,
//             sub: '$_dropOffCount enrolled, no quiz',
//             trend: _dropOffRate > 30 ? '↑ High risk' : '✓ Acceptable'),
//         ])),
//       const SizedBox(height: 16),

//       // ── Completion funnel ──────────────────────────────────
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//           border: const Border.fromBorderSide(BorderSide(color: _border))),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('Learner Funnel',
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
//           const SizedBox(height: 4),
//           const Text('How learners progress through the platform',
//             style: TextStyle(fontSize: 11, color: _sub)),
//           const SizedBox(height: 14),
//           _FunnelBar('Registered',      _totalLearners, _totalLearners, _blue),
//           const SizedBox(height: 8),
//           _FunnelBar('Started Course',  _activeCount,   _totalLearners, _blue),
//           const SizedBox(height: 8),
//           _FunnelBar('Took Quiz',       widget.learners.where((l) => l.quizzesTaken > 0).length, _totalLearners, _amber),
//           const SizedBox(height: 8),
//           _FunnelBar('Passed (≥60%)',   _completedCount, _totalLearners, _green),
//         ])),
//       const SizedBox(height: 16),

//       // ── Course performance table ───────────────────────────
//       if (_bestCourses.isNotEmpty) ...[
//         const Text('Course Performance',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//             border: const Border.fromBorderSide(BorderSide(color: _border))),
//           child: Column(children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF8F9FA),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(14), topRight: Radius.circular(14))),
//               child: const Row(children: [
//                 Expanded(flex: 4, child: Text('Course', style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Attempts', textAlign: TextAlign.center, style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Pass %', textAlign: TextAlign.center, style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Avg', textAlign: TextAlign.right, style: _hStyle)),
//               ])),
//             // Rows
//             ...List.from(_bestCourses.take(5)).asMap().entries.map((e) {
//               final c    = e.value as Map<String, dynamic>;
//               final rank = e.key;
//               final avg  = (c['avg_score'] as num?)?.toDouble() ?? 0;
//               final pass = (c['pass_rate'] as num?)?.toDouble() ?? 0;
//               final att  = c['total_attempts'] ?? 0;
//               final color= avg >= 80 ? _green : avg >= 60 ? _blue : _orange;
//               return Column(children: [
//                 const Divider(height: 1, color: _border),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   child: Row(children: [
//                     // Rank + title
//                     Expanded(flex: 4, child: Row(children: [
//                       Container(width: 24, height: 24,
//                         decoration: BoxDecoration(
//                           color: rank == 0 ? const Color(0xFFFFF3CD)
//                             : rank == 1 ? const Color(0xFFF0F0F0)
//                             : const Color(0xFFFFF0E6),
//                           borderRadius: BorderRadius.circular(6)),
//                         child: Center(child: Text(
//                           rank == 0 ? '🥇' : rank == 1 ? '🥈' : rank == 2 ? '🥉' : '#${rank+1}',
//                           style: const TextStyle(fontSize: 12)))),
//                       const SizedBox(width: 8),
//                       Expanded(child: Text(c['course_title'] ?? '',
//                         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _text),
//                         maxLines: 1, overflow: TextOverflow.ellipsis)),
//                     ])),
//                     SizedBox(width: 56, child: Text('$att',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 12, color: _text))),
//                     SizedBox(width: 56, child: Text('$pass%',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
//                         color: pass >= 60 ? _green : _orange))),
//                     SizedBox(width: 56, child: Text('${avg.toStringAsFixed(1)}%',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color))),
//                   ])),
//               ]);
//             }),
//           ])),
//       ],
//       const SizedBox(height: 16),

//       // ── Drop-off alert ─────────────────────────────────────
//       if (_dropOffRate > 20)
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFFFF4E6),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _orange.withOpacity(0.3))),
//           child: Row(children: [
//             const Icon(Icons.warning_amber_rounded, color: _orange, size: 22),
//             const SizedBox(width: 12),
//             Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const Text('High Drop-off Rate Detected',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _orange)),
//               const SizedBox(height: 3),
//               Text('$_dropOffCount learner(s) enrolled but haven\'t taken any quiz yet. '
//                 'Consider sending a broadcast reminder.',
//                 style: const TextStyle(fontSize: 11, color: _text, height: 1.4)),
//             ])),
//           ])),

//       if (_completionRate < 50 && _totalLearners > 0)
//         Container(
//           margin: const EdgeInsets.only(top: 10),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFE8EEFF),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _blue.withOpacity(0.3))),
//           child: Row(children: [
//             const Icon(Icons.lightbulb_outline, color: _blue, size: 22),
//             const SizedBox(width: 12),
//             const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text('Tip: Improve Completion',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _blue)),
//               SizedBox(height: 3),
//               Text('Add more modules, schedule quiz reminders, or broadcast motivation messages to increase completion.',
//                 style: TextStyle(fontSize: 11, color: _text, height: 1.4)),
//             ])),
//           ])),
//     ]);
//   }
// }

// // ── Funnel bar ─────────────────────────────────────────────────
// class _FunnelBar extends StatelessWidget {
//   final String label;
//   final int count, total;
//   final Color color;
//   const _FunnelBar(this.label, this.count, this.total, this.color);

//   @override
//   Widget build(BuildContext context) {
//     final pct = total == 0 ? 0.0 : count / total;
//     return Row(children: [
//       SizedBox(width: 110, child: Text(label,
//         style: const TextStyle(fontSize: 12, color: _sub, fontWeight: FontWeight.w600))),
//       Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         ClipRRect(borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(value: pct, minHeight: 10,
//             backgroundColor: const Color(0xFFE8EEFF),
//             valueColor: AlwaysStoppedAnimation<Color>(color))),
//       ])),
//       const SizedBox(width: 10),
//       SizedBox(width: 48, child: Text('$count (${(pct*100).toStringAsFixed(0)}%)',
//         textAlign: TextAlign.right,
//         style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color))),
//     ]);
//   }
// }

// // ── Metric card ────────────────────────────────────────────────
// class _MetricCard extends StatelessWidget {
//   final String label, value, sub, trend;
//   final IconData icon;
//   final Color color;
//   const _MetricCard({
//     required this.label, required this.value, required this.icon,
//     required this.color, required this.sub, required this.trend});

//   @override
//   Widget build(BuildContext context) {
//     final trendColor = trend.startsWith('↑') ? _green
//       : trend.startsWith('↓') ? _orange : _amber;
//     return Container(
//       width: 155, height: 90,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white, borderRadius: BorderRadius.circular(14),
//         border: Border(left: BorderSide(color: color, width: 4),
//           right: const BorderSide(color: _border),
//           top: const BorderSide(color: _border),
//           bottom: const BorderSide(color: _border))),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Icon(icon, color: color, size: 16),
//           Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
//             decoration: BoxDecoration(color: trendColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10)),
//             child: Text(trend,
//               style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: trendColor))),
//         ]),
//         const Spacer(),
//         Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: color)),
//         Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _text)),
//         Text(sub, style: const TextStyle(fontSize: 9, color: _sub),
//           maxLines: 1, overflow: TextOverflow.ellipsis),
//       ]));
//   }
// }

// const _hStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _sub);





















// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/models.dart';

// const _blue   = Color(0xFF1348D4);
// const _green  = Color(0xFF00875A);
// const _orange = Color(0xFFFF5630);
// const _amber  = Color(0xFFFF991F);
// const _bg     = Color(0xFFF4F6FB);
// const _border = Color(0xFFE4E9F2);
// const _text   = Color(0xFF0A1628);
// const _sub    = Color(0xFF6B7A99);
// const _pLight = Color(0xFFE8EEFF);

// // ── Drop into Home tab as a widget ────────────────────────────
// // Usage: AnalyticsDashboardWidget(courses: _courses, learners: _learners)

// class AnalyticsDashboardWidget extends StatefulWidget {
//   final List<Course> courses;
//   final List<LearnerProgress> learners;
//   const AnalyticsDashboardWidget({
//     super.key,
//     required this.courses,
//     required this.learners,
//   });

//   @override
//   State<AnalyticsDashboardWidget> createState() => _AnalyticsDashboardState();
// }

// class _AnalyticsDashboardState extends State<AnalyticsDashboardWidget> {
//   List<dynamic> _bestCourses = [];
//   Map<String, dynamic> _dashStats = {};
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     try {
//       final results = await Future.wait([
//         ApiService.get('/analytics/best-courses'),
//         ApiService.get('/analytics/dashboard'),
//       ]);
//       setState(() {
//         _bestCourses = results[0]['data'] ?? [];
//         _dashStats   = results[1]['data'] ?? {};
//       });
//     } catch (_) {}
//     setState(() => _loading = false);
//   }

//   // ── Computed from learner list ─────────────────────────────
//   int get _totalLearners => widget.learners.length;
//   int get _completedCount => widget.learners.where((l) => l.coursesTaken > 0 && l.averageScore >= 60).length;
//   double get _completionRate => _totalLearners == 0 ? 0 : (_completedCount / _totalLearners) * 100;

//   int get _avgScore => widget.learners.isEmpty ? 0
//     : widget.learners.fold(0, (int s, l) => s + l.averageScore) ~/ widget.learners.length;

//   int get _activeCount => widget.learners.where((l) => l.quizzesTaken > 0).length;
//   int get _inactiveCount => _totalLearners - _activeCount;

//   // Drop-off: learners enrolled but no quiz taken
//   int get _dropOffCount => widget.learners.where((l) => l.coursesTaken > 0 && l.quizzesTaken == 0).length;
//   double get _dropOffRate => _totalLearners == 0 ? 0 : (_dropOffCount / _totalLearners) * 100;

//   @override
//   Widget build(BuildContext context) {
//     // Always render - API data (best courses) loads async, but learner metrics show immediately

//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       // ── Section header ─────────────────────────────────────
//       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//         const Text('Analytics Overview',
//           style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _text)),
//         GestureDetector(
//           onTap: _load,
//           child: const Icon(Icons.refresh, color: _blue, size: 20)),
//       ]),
//       const SizedBox(height: 12),

//       // ── Metric cards — 2x2 explicit layout ────────────────
//       Row(children: [
//         Expanded(child: _MetricCard(
//           label: 'Completion',
//           value: '${_completionRate.toStringAsFixed(0)}%',
//           icon: Icons.check_circle_outline_rounded,
//           color: _green,
//           sub: '$_completedCount / $_totalLearners passed',
//           trend: _completionRate >= 60 ? '↑ Good' : '↓ Low')),
//         const SizedBox(width: 10),
//         Expanded(child: _MetricCard(
//           label: 'Avg Score',
//           value: '$_avgScore%',
//           icon: Icons.star_outline_rounded,
//           color: _avgScore >= 70 ? _green : _avgScore >= 50 ? _amber : _orange,
//           sub: 'Across all quizzes',
//           trend: _avgScore >= 70 ? '↑ Strong' : _avgScore >= 50 ? '→ Fair' : '↓ Weak')),
//       ]),
//       const SizedBox(height: 10),
//       Row(children: [
//         Expanded(child: _MetricCard(
//           label: 'Active',
//           value: '$_activeCount',
//           icon: Icons.people_outline_rounded,
//           color: _blue,
//           sub: '$_inactiveCount not started',
//           trend: _activeCount > 0 ? '↑ Engaged' : '→ None yet')),
//         const SizedBox(width: 10),
//         Expanded(child: _MetricCard(
//           label: 'Drop-off',
//           value: '${_dropOffRate.toStringAsFixed(0)}%',
//           icon: Icons.trending_down_rounded,
//           color: _dropOffRate > 30 ? _orange : _amber,
//           sub: '$_dropOffCount no quiz yet',
//           trend: _dropOffRate > 30 ? '↑ High risk' : '✓ Ok')),
//       ]),
//       const SizedBox(height: 16),

//       // ── Completion funnel ──────────────────────────────────
//       Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//           border: const Border.fromBorderSide(BorderSide(color: _border))),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('Learner Funnel',
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
//           const SizedBox(height: 4),
//           const Text('How learners progress through the platform',
//             style: TextStyle(fontSize: 11, color: _sub)),
//           const SizedBox(height: 14),
//           _FunnelBar('Registered',      _totalLearners, _totalLearners, _blue),
//           const SizedBox(height: 8),
//           _FunnelBar('Started Course',  _activeCount,   _totalLearners, _blue),
//           const SizedBox(height: 8),
//           _FunnelBar('Took Quiz',       widget.learners.where((l) => l.quizzesTaken > 0).length, _totalLearners, _amber),
//           const SizedBox(height: 8),
//           _FunnelBar('Passed (≥60%)',   _completedCount, _totalLearners, _green),
//         ])),
//       const SizedBox(height: 16),

//       // ── Course performance table ───────────────────────────
//       if (_bestCourses.isNotEmpty) ...[
//         const Text('Course Performance',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//             border: const Border.fromBorderSide(BorderSide(color: _border))),
//           child: Column(children: [
//             // Header
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF8F9FA),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(14), topRight: Radius.circular(14))),
//               child: const Row(children: [
//                 Expanded(flex: 4, child: Text('Course', style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Attempts', textAlign: TextAlign.center, style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Pass %', textAlign: TextAlign.center, style: _hStyle)),
//                 SizedBox(width: 56, child: Text('Avg', textAlign: TextAlign.right, style: _hStyle)),
//               ])),
//             // Rows
//             ...List.from(_bestCourses.take(5)).asMap().entries.map((e) {
//               final c    = e.value as Map<String, dynamic>;
//               final rank = e.key;
//               final avg  = (c['avg_score'] as num?)?.toDouble() ?? 0;
//               final pass = (c['pass_rate'] as num?)?.toDouble() ?? 0;
//               final att  = c['total_attempts'] ?? 0;
//               final color= avg >= 80 ? _green : avg >= 60 ? _blue : _orange;
//               return Column(children: [
//                 const Divider(height: 1, color: _border),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                   child: Row(children: [
//                     // Rank + title
//                     Expanded(flex: 4, child: Row(children: [
//                       Container(width: 24, height: 24,
//                         decoration: BoxDecoration(
//                           color: rank == 0 ? const Color(0xFFFFF3CD)
//                             : rank == 1 ? const Color(0xFFF0F0F0)
//                             : const Color(0xFFFFF0E6),
//                           borderRadius: BorderRadius.circular(6)),
//                         child: Center(child: Text(
//                           rank == 0 ? '🥇' : rank == 1 ? '🥈' : rank == 2 ? '🥉' : '#${rank+1}',
//                           style: const TextStyle(fontSize: 12)))),
//                       const SizedBox(width: 8),
//                       Expanded(child: Text(c['course_title'] ?? '',
//                         style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _text),
//                         maxLines: 1, overflow: TextOverflow.ellipsis)),
//                     ])),
//                     SizedBox(width: 56, child: Text('$att',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(fontSize: 12, color: _text))),
//                     SizedBox(width: 56, child: Text('$pass%',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
//                         color: pass >= 60 ? _green : _orange))),
//                     SizedBox(width: 56, child: Text('${avg.toStringAsFixed(1)}%',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color))),
//                   ])),
//               ]);
//             }),
//           ])),
//       ],
//       const SizedBox(height: 16),

//       // ── Drop-off alert ─────────────────────────────────────
//       if (_dropOffRate > 20)
//         Container(
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFFFF4E6),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _orange.withOpacity(0.3))),
//           child: Row(children: [
//             const Icon(Icons.warning_amber_rounded, color: _orange, size: 22),
//             const SizedBox(width: 12),
//             Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               const Text('High Drop-off Rate Detected',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _orange)),
//               const SizedBox(height: 3),
//               Text('$_dropOffCount learner(s) enrolled but haven\'t taken any quiz yet. '
//                 'Consider sending a broadcast reminder.',
//                 style: const TextStyle(fontSize: 11, color: _text, height: 1.4)),
//             ])),
//           ])),

//       if (_completionRate < 50 && _totalLearners > 0)
//         Container(
//           margin: const EdgeInsets.only(top: 10),
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFE8EEFF),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: _blue.withOpacity(0.3))),
//           child: Row(children: [
//             const Icon(Icons.lightbulb_outline, color: _blue, size: 22),
//             const SizedBox(width: 12),
//             const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text('Tip: Improve Completion',
//                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _blue)),
//               SizedBox(height: 3),
//               Text('Add more modules, schedule quiz reminders, or broadcast motivation messages to increase completion.',
//                 style: TextStyle(fontSize: 11, color: _text, height: 1.4)),
//             ])),
//           ])),
//     ]);
//   }
// }

// // ── Funnel bar ─────────────────────────────────────────────────
// class _FunnelBar extends StatelessWidget {
//   final String label;
//   final int count, total;
//   final Color color;
//   const _FunnelBar(this.label, this.count, this.total, this.color);

//   @override
//   Widget build(BuildContext context) {
//     final pct = total == 0 ? 0.0 : count / total;
//     return Row(children: [
//       SizedBox(width: 110, child: Text(label,
//         style: const TextStyle(fontSize: 12, color: _sub, fontWeight: FontWeight.w600))),
//       Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         ClipRRect(borderRadius: BorderRadius.circular(4),
//           child: LinearProgressIndicator(value: pct, minHeight: 10,
//             backgroundColor: const Color(0xFFE8EEFF),
//             valueColor: AlwaysStoppedAnimation<Color>(color))),
//       ])),
//       const SizedBox(width: 10),
//       SizedBox(width: 48, child: Text('$count (${(pct*100).toStringAsFixed(0)}%)',
//         textAlign: TextAlign.right,
//         style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color))),
//     ]);
//   }
// }

// // ── Metric card ────────────────────────────────────────────────
// class _MetricCard extends StatelessWidget {
//   final String label, value, sub, trend;
//   final IconData icon;
//   final Color color;
//   const _MetricCard({
//     required this.label, required this.value, required this.icon,
//     required this.color, required this.sub, required this.trend});

//   @override
//   Widget build(BuildContext context) {
//     final trendColor = trend.startsWith('↑') ? _green
//       : trend.startsWith('↓') ? _orange : _amber;
//     return Container(
//       height: 100,
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border(
//           left: BorderSide(color: color, width: 4),
//           right: const BorderSide(color: _border),
//           top: const BorderSide(color: _border),
//           bottom: const BorderSide(color: _border))),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Icon(icon, color: color, size: 18),
//           Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//             decoration: BoxDecoration(color: trendColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10)),
//             child: Text(trend,
//               style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: trendColor))),
//         ]),
//         const SizedBox(height: 8),
//         Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
//         const SizedBox(height: 2),
//         Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _text)),
//         Text(sub, style: const TextStyle(fontSize: 9, color: _sub),
//           maxLines: 1, overflow: TextOverflow.ellipsis),
//       ]));
//   }
// }

// const _hStyle = TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _sub);























import 'package:flutter/material.dart';
import '../models/models.dart';

const _blue   = Color(0xFF1348D4);
const _green  = Color(0xFF00875A);
const _orange = Color(0xFFFF5630);
const _amber  = Color(0xFFFF991F);
const _border = Color(0xFFE4E9F2);
const _text   = Color(0xFF0A1628);
const _sub    = Color(0xFF6B7A99);
const _bg     = Color(0xFFF4F6FB);

class AnalyticsDashboardWidget extends StatelessWidget {
  final List<Course> courses;
  final List<LearnerProgress> learners;
  const AnalyticsDashboardWidget({
    super.key,
    required this.courses,
    required this.learners,
  });

  int get _total    => learners.length;
  int get _passed   => learners.where((l) => l.averageScore >= 60).length;
  int get _active   => learners.where((l) => l.quizzesTaken > 0).length;
  int get _inactive => _total - _active;
  int get _dropOff  => learners.where((l) => l.coursesTaken > 0 && l.quizzesTaken == 0).length;
  int get _avgScore => learners.isEmpty ? 0
    : learners.fold(0, (int s, l) => s + l.averageScore) ~/ learners.length;

  double get _completionRate =>
    _total == 0 ? 0 : (_passed / _total) * 100;
  double get _dropOffRate =>
    _total == 0 ? 0 : (_dropOff / _total) * 100;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Header ───────────────────────────────────────────
        const Text('Analytics Overview',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _text)),
        const SizedBox(height: 12),

        // ── 4 metric cards 2x2 ───────────────────────────────
        _twoCards(
          _card('Completion', '${_completionRate.toStringAsFixed(0)}%',
            Icons.check_circle_outline, _green,
            '$_passed of $_total passed'),
          _card('Avg Score', '$_avgScore%',
            Icons.star_outline, _avgScore >= 70 ? _green : _avgScore >= 50 ? _amber : _orange,
            'Across all quizzes'),
        ),
        const SizedBox(height: 10),
        _twoCards(
          _card('Active', '$_active',
            Icons.people_outline, _blue,
            '$_inactive not started yet'),
          _card('Drop-off', '${_dropOffRate.toStringAsFixed(0)}%',
            Icons.trending_down, _dropOffRate > 30 ? _orange : _amber,
            '$_dropOff enrolled, no quiz'),
        ),
        const SizedBox(height: 16),

        // ── Learner Funnel ────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: const Border.fromBorderSide(BorderSide(color: _border))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Learner Funnel',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text)),
              const SizedBox(height: 4),
              const Text('How learners progress through the platform',
                style: TextStyle(fontSize: 11, color: _sub)),
              const SizedBox(height: 14),
              _funnelBar('Registered',   _total,   _total, _blue),
              const SizedBox(height: 8),
              _funnelBar('Started Course', _active, _total, _blue),
              const SizedBox(height: 8),
              _funnelBar('Took Quiz',
                learners.where((l) => l.quizzesTaken > 0).length, _total, _amber),
              const SizedBox(height: 8),
              _funnelBar('Passed (≥60%)', _passed,  _total, _green),
            ])),

        // ── Drop-off warning ──────────────────────────────────
        if (_dropOffRate > 20) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4E6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _orange.withOpacity(0.3))),
            child: Row(children: [
              const Icon(Icons.warning_amber_rounded, color: _orange, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Text(
                '$_dropOff learner(s) enrolled but haven\'t taken any quiz. Send a broadcast reminder!',
                style: const TextStyle(fontSize: 12, color: _text))),
            ])),
        ],
      ]);
  }

  Widget _twoCards(Widget a, Widget b) => IntrinsicHeight(
    child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(child: a),
      const SizedBox(width: 10),
      Expanded(child: b),
    ]));

  Widget _card(String label, String value, IconData icon, Color color, String sub) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: color, width: 4),
          top: const BorderSide(color: _border),
          right: const BorderSide(color: _border),
          bottom: const BorderSide(color: _border))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 2),
          Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _text)),
          const SizedBox(height: 2),
          Text(sub,
            style: const TextStyle(fontSize: 10, color: _sub),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        ]));
  }

  Widget _funnelBar(String label, int count, int total, Color color) {
    final pct = total == 0 ? 0.0 : count / total;
    return Row(children: [
      SizedBox(width: 100,
        child: Text(label,
          style: const TextStyle(fontSize: 12, color: _sub, fontWeight: FontWeight.w600))),
      Expanded(child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: pct, minHeight: 10,
          backgroundColor: const Color(0xFFE8EEFF),
          valueColor: AlwaysStoppedAnimation<Color>(color)))),
      const SizedBox(width: 10),
      SizedBox(width: 56,
        child: Text('$count (${(pct * 100).toStringAsFixed(0)}%)',
          textAlign: TextAlign.right,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color))),
    ]);
  }
}