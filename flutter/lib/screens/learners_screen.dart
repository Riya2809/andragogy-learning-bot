import 'dart:math';
import 'dart:async';
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
  Timer? _autoRefresh;

  @override
  void initState() {
    super.initState();
    _autoRefresh = Timer.periodic(const Duration(seconds: 30), (_) => _load());
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(() => setState(() {}));
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _anim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic);
    _learners = List.from(widget.learners);
    _load();
  }

  @override
  void dispose() {
    _autoRefresh?.cancel();
    _tabs.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LearnersScreen old) {
    super.didUpdateWidget(old);
    if (widget.learners != old.learners) {
      setState(() => _learners = List.from(widget.learners));
      _animCtrl.forward(from: 0);
    }
  }

  List<Map<String, dynamic>> _courseStats = [];

  Future<void> _loadCourseStats() async {
    try {
      final r = await ApiService.get('/progress/course-stats');
      if (mounted) setState(() => _courseStats = List<Map<String, dynamic>>.from(r['data'] ?? []));
    } catch (_) {}
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
      await _loadCourseStats();
    } catch (_) {}
    setState(() => _loading = false);
    _animCtrl.forward(from: 0);
  }

  int get _avgScore => _learners.isEmpty ? 0
      : _learners.fold(0, (int s, l) => s + l.averageScore) ~/ _learners.length;
  int get _totalQuizzes => _learners.fold(0, (int s, l) => s + l.quizzesTaken);
  int get _totalModules => _learners.fold(0, (int s, l) => s + l.modulesCompleted);

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
    final fl = _filtered;
    final rows = ['Name,Phone,Department,Job Role,Courses,Quizzes,Modules,Avg Score (%),Status,Pass/Fail,Certificate,Joining Date'];
    for (final l in fl) {
      final status      = l.quizzesTaken > 0 ? 'Active' : 'Inactive';
      final passFail    = l.averageScore >= 60 ? 'Pass' : l.quizzesTaken == 0 ? 'Pending' : 'Fail';
      final certificate = l.averageScore >= 60 && l.quizzesTaken > 0 ? 'Yes' : 'No';
      final joined      = l.joinedAt != null
          ? '${l.joinedAt!.day}/${l.joinedAt!.month}/${l.joinedAt!.year}'
          : '-';
      rows.add([
        '"${l.name}"',
        '"${l.phoneNumber}"',
        '"${l.department ?? '-'}"',
        '"${l.jobRole ?? '-'}"',
        '${l.coursesTaken}',
        '${l.quizzesTaken}',
        '${l.modulesCompleted}',
        '${l.averageScore}',
        '"$status"',
        '"$passFail"',
        '"$certificate"',
        '"$joined"',
      ].join(','));
    }
    if (kIsWeb) {
      final blob = html.Blob([rows.join('\n')], 'text/csv');
      final url  = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', 'learner_report.csv')
        ..click();
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

  Widget _buildProgressTab() {
    return RefreshIndicator(onRefresh: _load,
      child: AnimatedBuilder(animation: _anim,
        builder: (_, __) => ListView(padding: const EdgeInsets.all(16), children: [
          Row(children: [
            Expanded(child: _MiniStatCard('${_learners.length}', 'Learners',  _blue,  Icons.people)),
            const SizedBox(width: 8),
            Expanded(child: _MiniStatCard('$_avgScore%',         'Avg Score', _green, Icons.star)),
            const SizedBox(width: 8),
            Expanded(child: _MiniStatCard('$_totalQuizzes',      'Quizzes',   _amber, Icons.quiz)),
            const SizedBox(width: 8),
            Expanded(child: _MiniStatCard('$_totalModules',      'Modules',   _orange, Icons.check_circle)),
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
            _secTitle('Course Enrollment & Completion'),
            const SizedBox(height: 12),
            _buildCourseStats(),
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

  Widget _buildReportTab() {
    final fl  = _filtered;
    final avg = fl.isEmpty ? 0.0
      : fl.fold(0, (int s, l) => s + l.averageScore) / fl.length;

    return Column(children: [
      Container(color: _blue, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          _BannerStat('Learners', '${fl.length}',                                      Icons.people_rounded),
          _BannerStat('Avg',      '${avg.toStringAsFixed(1)}%',                        Icons.bar_chart_rounded),
          _BannerStat('Quizzes',  '${fl.fold(0,(int s,l) => s + l.quizzesTaken)}',     Icons.quiz_rounded),
          _BannerStat('Modules',  '${fl.fold(0,(int s,l) => s + l.modulesCompleted)}', Icons.check_circle_rounded),
        ])),

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
                DropdownMenuItem(value: 'name',    child: Text('Name ↑')),
                DropdownMenuItem(value: 'score',   child: Text('Score ↓')),
                DropdownMenuItem(value: 'courses', child: Text('Courses ↓')),
              ],
              onChanged: (v) => setState(() => _sortBy = v ?? 'name'))),
        ])),
      const Divider(height: 1, color: _border),

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

  Widget _buildCourseStats() {
    if (_courseStats.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: const Border.fromBorderSide(BorderSide(color: _border))),
        child: const Center(child: Text('No course data yet',
          style: TextStyle(color: _sub))));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: const Border.fromBorderSide(BorderSide(color: _border))),
      child: Column(children: [
        const Row(children: [
          Expanded(flex: 3, child: Text('Course', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _sub))),
          SizedBox(width: 60, child: Text('Enrolled', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _sub))),
          SizedBox(width: 60, child: Text('Completed', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _sub))),
          SizedBox(width: 55, child: Text('Rate', textAlign: TextAlign.right, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _sub))),
        ]),
        const SizedBox(height: 10),
        const Divider(height: 1, color: _border),
        const SizedBox(height: 10),
        ..._courseStats.map((s) {
          final enrolled  = s['enrolled'] as int? ?? 0;
          final completed = s['completed'] as int? ?? 0;
          final rate      = s['completion_rate'] as int? ?? 0;
          final rateColor = rate >= 70 ? _green : rate >= 40 ? _amber : _orange;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(flex: 3, child: Text(
                  s['course_title'] as String? ?? '',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _text),
                  overflow: TextOverflow.ellipsis)),
                SizedBox(width: 60, child: Text('$enrolled',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _blue))),
                SizedBox(width: 60, child: Text('$completed',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: rateColor))),
                SizedBox(width: 55, child: Text('$rate%',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: rateColor))),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: rate / 100,
                  minHeight: 6,
                  backgroundColor: _pLight,
                  valueColor: AlwaysStoppedAnimation<Color>(rateColor))),
            ]));
        }),
        const Divider(height: 1, color: _border),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Total Learners', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _text)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: _pLight, borderRadius: BorderRadius.circular(20)),
            child: Text('${_learners.length} registered',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _blue))),
        ]),
      ]));
  }

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

// ── Profile Sheet ─────────────────────────────────────────────
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
      Row(children: [
        _PStat('Courses',  '${learner.coursesTaken}',     Icons.menu_book,    _blue),
        const SizedBox(width: 8),
        _PStat('Quizzes',  '${learner.quizzesTaken}',     Icons.quiz,         _amber),
        const SizedBox(width: 8),
        _PStat('Modules',  '${learner.modulesCompleted}', Icons.check_circle, _green),
        const SizedBox(width: 8),
        _PStat('Score',    '${learner.averageScore}%',    Icons.star,         _orange),
      ]),
      const SizedBox(height: 20),
      Container(padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFFF4F6FB),
          borderRadius: BorderRadius.circular(14)),
        child: Column(children: [
          _IR('Department', learner.department ?? '—'),
          _IR('Job Role',   learner.jobRole ?? '—'),
          _IR('Phone',      learner.phoneNumber),
          if (learner.joinedAt != null)
            _IR('Joined',
              '${learner.joinedAt!.day}/${learner.joinedAt!.month}/${learner.joinedAt!.year}'),
        ])),
      const SizedBox(height: 20),

      // Enrolled Courses
      if (learner.enrolledCourses.isNotEmpty) ...[
        const Text('Enrolled Courses',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: _text)),
        const SizedBox(height: 10),
        ...learner.enrolledCourses.map((c) {
          final title    = c['course_title'] as String? ?? 'Unknown Course';
          final modsDone = c['modules_done'] as int? ?? 0;
          // Find quiz score for this course
          final qr = learner.quizResults.where(
            (q) => q['course_id'] == c['course_id']).toList();
          final score   = qr.isNotEmpty ? qr.first['score'] as int? ?? 0 : null;
          final passed  = score != null && score >= 60;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: passed ? _green.withOpacity(0.4) : _border)),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: passed ? _green.withOpacity(0.1) : _pLight,
                  borderRadius: BorderRadius.circular(10)),
                child: Center(child: Text(
                  passed ? '🏆' : '📚',
                  style: const TextStyle(fontSize: 18)))),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title,
                  style: const TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w700, color: _text)),
                const SizedBox(height: 3),
                Text('$modsDone modules completed',
                  style: const TextStyle(fontSize: 11, color: _sub)),
              ])),
              if (score != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: passed ? _green.withOpacity(0.1) : _orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20)),
                  child: Text('$score%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: passed ? _green : _orange)))
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _pLight,
                    borderRadius: BorderRadius.circular(20)),
                  child: const Text('In Progress',
                    style: TextStyle(fontSize: 11,
                      fontWeight: FontWeight.w700, color: _blue))),
            ]));
        }),
        const SizedBox(height: 10),
      ],

      // Certificate button — only show if passed
      if (learner.averageScore >= 60 && learner.quizzesTaken > 0)
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _green.withOpacity(0.3))),
          child: Column(children: [
            const Row(children: [
              Text('🎓', style: TextStyle(fontSize: 20)),
              SizedBox(width: 8),
              Text('Certificate Earned!',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF00875A))),
            ]),
            const SizedBox(height: 8),
            const Text('This learner has passed the assessment and is eligible for a certificate.',
              style: TextStyle(fontSize: 12, color: _sub)),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00875A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: () => _downloadCertificate(context),
                icon: const Icon(Icons.download_rounded, color: Colors.white, size: 18),
                label: const Text('Download Certificate (PDF)',
                  style: TextStyle(color: Colors.white,
                    fontSize: 13, fontWeight: FontWeight.w700)))),
          ])),
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
              : learner.averageScore >= 60 ? 'Good Progress' : 'Needs Attention',
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

  void _downloadCertificate(BuildContext context) {
    // Generate simple certificate as text for now
    // In production this connects to CertificateService
    final name   = learner.name;
    final score  = learner.averageScore;
    final now    = DateTime.now();
    final date   = '${now.day}/${now.month}/${now.year}';

    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('🎓 Certificate Ready',
        style: TextStyle(fontWeight: FontWeight.w800)),
      content: Column(mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Certificate for: $name',
          style: const TextStyle(fontWeight: FontWeight.w700)),
        Text('Score: $score%'),
        Text('Date: $date'),
        const SizedBox(height: 8),
        const Text('To download as PDF, use the certificate feature in the WhatsApp simulator or contact your admin.',
          style: TextStyle(fontSize: 12, color: _sub)),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context),
          child: const Text('Close')),
      ]));
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

// ── Broadcast Tab ─────────────────────────────────────────────
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
    '📢 Quiz reminder':  '📢 *Reminder:* Your quiz deadline is approaching!\n\nType *QUIZ* to complete your assessment now.\n\n_Andragogy Learning Platform_',
    '🎉 New module':     '🎉 *New Content Available!*\n\nA new module has been added to your course.\n\nType *NEXT* to access it now.\n\n_Andragogy Learning Platform_',
    '⏰ Course ending':  '⏰ *Course Ending Soon!*\n\nYour course ends in 3 days. Complete all modules.\n\nType *PROGRESS* to check your status.\n\n_Andragogy Learning Platform_',
    '📊 Check progress': '📊 *Check Your Progress!*\n\nType *PROGRESS* to view your scores and completed modules.\n\n_Andragogy Learning Platform_',
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
        'message': _msgCtrl.text.trim(),
        'filter': _filter,
        'course_id': _courseId ?? '',
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

          if (_filter == 'enrolled') ...[
            DropdownButtonFormField<String>(
              value: _courseId,
              hint: const Text('Select a course'),
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: _border)),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                filled: true, fillColor: Colors.white),
              items: widget.courses.map((c) =>
                DropdownMenuItem(value: c.id, child: Text(c.title, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (v) => setState(() => _courseId = v)),
            const SizedBox(height: 12),
          ],

          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFFE8EEFF), borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.people_outline, color: _blue, size: 18),
              const SizedBox(width: 8),
              Text('$_recipientCount learner(s) will receive this message',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _blue)),
            ])),
          const SizedBox(height: 14),

          TextField(controller: _msgCtrl, maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Type your broadcast message...',
              hintStyle: const TextStyle(fontSize: 12, color: _sub),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _border)),
              filled: true, fillColor: const Color(0xFFF4F6FB),
              contentPadding: const EdgeInsets.all(14))),
          const SizedBox(height: 12),

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

// ── Shared widgets ────────────────────────────────────────────
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