import 'package:flutter/material.dart';
import 'dart:async';
import '../services/api_service.dart';
import '../services/app_theme.dart';
import '../models/models.dart';
import 'courses_screen.dart';
import 'quiz_screen.dart';
import 'learners_screen.dart';
import 'whatsapp_sim_screen.dart';
import 'send_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;
  List<LearnerProgress> _learners = [];
  List<Course> _courses = [];
  List<Map<String, dynamic>> _courseStats = [];
  bool _loading = true;
  Timer? _autoRefresh;

  @override
  void initState() {
    super.initState();
    _loadData();
    _autoRefresh = Timer.periodic(const Duration(seconds: 30), (_) => _loadData());
  }

  @override
  void dispose() {
    _autoRefresh?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final courses  = await ApiService.getCourses();
      final learners = await ApiService.getAllProgress();
      if (mounted) setState(() { _courses = courses; _learners = learners; });
      // Load real course enrollment stats
      try {
        final statsRes = await ApiService.get('/progress/course-stats');
        final data = List<Map<String, dynamic>>.from(statsRes['data'] ?? []);
        if (mounted) setState(() => _courseStats = data);
        print('Course stats loaded: ${data.length} courses');
        for (final s in data) {
          print('  ${s['course_title']}: enrolled=${s['enrolled']}');
        }
      } catch (e) {
        print('Course stats error: $e');
      }
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  int _enrolledCount(String courseId) {
    final stat = _courseStats.where((s) => s['course_id'].toString() == courseId).toList();
    return stat.isNotEmpty ? (stat.first['enrolled'] as int? ?? 0) : 0;
  }
  int get _totalLearners => _learners.length;
  int get _totalCourses  => _courses.length;
  int get _totalQuizzes  => _learners.fold(0, (int s, l) => s + l.quizzesTaken);
  int get _avgScore => _learners.isEmpty ? 0
      : _learners.fold(0, (int s, l) => s + l.averageScore) ~/ _learners.length;

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHome(),
      CoursesScreen(onRefresh: _loadData),
      QuizScreen(courses: _courses),
      LearnersScreen(learners: _learners, onRefresh: _loadData),
      SendScreen(courses: _courses, learners: _learners),
      const WhatsAppSimScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _navIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (i) => setState(() => _navIndex = i),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE8EEFF),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFF1348D4)), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book, color: Color(0xFF1348D4)), label: 'Courses'),
          NavigationDestination(icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz, color: Color(0xFF1348D4)), label: 'Quizzes'),
          NavigationDestination(icon: Icon(Icons.people_outlined),
            selectedIcon: Icon(Icons.people, color: Color(0xFF1348D4)), label: 'Learners'),
          NavigationDestination(icon: Icon(Icons.send_outlined),
            selectedIcon: Icon(Icons.send, color: Color(0xFF1348D4)), label: 'Send'),
        ]));
  }

  void _showPollsResults() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.97,
        minChildSize: 0.5,
        expand: false,
        builder: (_, ctrl) => Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
            child: Row(children: [
              const Text('📊', style: TextStyle(fontSize: 22)),
              const SizedBox(width: 10),
              const Expanded(child: Text('Poll Results',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary))),
              IconButton(icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context)),
            ])),
          const Divider(height: 1, color: AppColors.border),
          // Polls list
          Expanded(child: _PollResultsList(scrollController: ctrl)),
        ])));
  }

  void _showCreatePoll() {
    final questionCtrl = TextEditingController();
    final List<TextEditingController> optionCtrls = [
      TextEditingController(), TextEditingController()];
    bool isMultiSelect = false;
    bool sending = false;

    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, ss) => SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border,
                borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Create Poll', style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              IconButton(icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(ctx)),
            ]),
            const SizedBox(height: 4),
            const Text('Send a poll to your learners via WhatsApp',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            const Text('Poll Question *', style: TextStyle(fontSize: 13,
              fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            TextField(controller: questionCtrl, maxLines: 2,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'e.g. Which topic should we cover next?',
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                filled: true, fillColor: AppColors.bg, contentPadding: const EdgeInsets.all(14)),
              onChanged: (_) => ss(() {})),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Options *', style: TextStyle(fontSize: 13,
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              if (optionCtrls.length < 6)
                GestureDetector(
                  onTap: () => ss(() => optionCtrls.add(TextEditingController())),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.add_rounded, size: 14, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text('Add Option', style: TextStyle(fontSize: 11,
                        fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ]))),
            ]),
            const SizedBox(height: 8),
            ...optionCtrls.asMap().entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(children: [
                Container(width: 28, height: 28,
                  decoration: BoxDecoration(color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8)),
                  child: Center(child: Text(String.fromCharCode(65 + e.key),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800,
                      color: AppColors.primary)))),
                const SizedBox(width: 10),
                Expanded(child: TextField(controller: e.value,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Option ${String.fromCharCode(65 + e.key)}',
                    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border)),
                    filled: true, fillColor: Colors.white, isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
                  onChanged: (_) => ss(() {}))),
                if (optionCtrls.length > 2) ...[
                  const SizedBox(width: 8),
                  GestureDetector(onTap: () => ss(() => optionCtrls.removeAt(e.key)),
                    child: const Icon(Icons.remove_circle_outline,
                      color: AppColors.textSecondary, size: 20)),
                ],
              ]))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: AppColors.bg,
                borderRadius: BorderRadius.circular(10),
                border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
              child: Row(children: [
                const Icon(Icons.check_box_outlined, size: 18, color: AppColors.primary),
                const SizedBox(width: 10),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Allow multiple selections', style: TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text('Learners can pick more than one option',
                    style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ])),
                Switch.adaptive(value: isMultiSelect, activeColor: AppColors.primary,
                  onChanged: (v) => ss(() => isMultiSelect = v)),
              ])),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0),
                onPressed: (sending || questionCtrl.text.trim().isEmpty ||
                  optionCtrls.any((c) => c.text.trim().isEmpty)) ? null
                  : () async {
                    ss(() => sending = true);
                    try {
                      await ApiService.post('/polls', {
                        'question': questionCtrl.text.trim(),
                        'options': optionCtrls.map((c) => c.text.trim())
                          .where((t) => t.isNotEmpty).toList(),
                        'multi_select': isMultiSelect,
                      });
                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('✅ Poll sent to all learners!'),
                          backgroundColor: AppColors.green,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(12)));
                      }
                    } catch (_) {
                      if (ctx.mounted) {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Poll saved locally'),
                          backgroundColor: AppColors.amber,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(12)));
                      }
                    }
                  },
                icon: sending
                  ? const SizedBox(width: 18, height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                label: Text(sending ? 'Sending...' : 'Send Poll to All Learners',
                  style: const TextStyle(color: Colors.white, fontSize: 15,
                    fontWeight: FontWeight.w700)))),
          ]))));
  }

  Widget _buildHome() {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        title: const Text('Andragogy Insight', style: TextStyle(fontSize: 22,
          fontWeight: FontWeight.w900, color: Color(0xFF0D3AAA), letterSpacing: -0.8)),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined,
              color: AppColors.textPrimary, size: 26),
            onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()))),
          IconButton(icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _loadData),

        ],
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border))),
      body: _loading
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : RefreshIndicator(onRefresh: _loadData,
            child: ListView(padding: const EdgeInsets.all(16), children: [

              Container(padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1348D4), Color(0xFF4B3FD8)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white24,
                      borderRadius: BorderRadius.circular(20)),
                    child: const Text('⚡ Facilitator Portal',
                      style: TextStyle(color: Colors.white, fontSize: 10,
                        fontWeight: FontWeight.w700))),
                  const SizedBox(height: 10),
                  const Text('Welcome back! 🎓', style: TextStyle(color: Colors.white,
                    fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  const Text('Manage courses, track learners\nand deliver content via WhatsApp',
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5)),
                ])),
              const SizedBox(height: 16),

              GridView.count(crossAxisCount: 2, shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.6,
                children: [
                  _StatCard('$_totalLearners', 'Total Learners', Icons.people, AppColors.primary),
                  _StatCard('$_totalCourses', 'Active Courses', Icons.menu_book, AppColors.green),
                  _StatCard('$_totalQuizzes', 'Quizzes Taken', Icons.quiz, AppColors.amber),
                  _StatCard('$_avgScore%', 'Avg Score', Icons.star, AppColors.orange),
                ]),
              const SizedBox(height: 24),

              // ── NO Analytics Overview ──────────────────────

              _buildBestPerformance(),
              const SizedBox(height: 24),

              _buildSectionHeader('Recent Courses',
                action: TextButton(
                  onPressed: () => setState(() => _navIndex = 1),
                  child: const Text('See all', style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700)))),
              const SizedBox(height: 10),
              if (_courses.isEmpty)
                _buildEmpty('📚', 'No courses yet', 'Go to Courses tab to create one')
              else
                ..._courses.take(3).map((c) => _buildCourseCard(c)),
              const SizedBox(height: 24),

              _buildSectionHeader('Recent Learners',
                action: TextButton(
                  onPressed: () => setState(() => _navIndex = 3),
                  child: const Text('See all', style: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.w700)))),
              const SizedBox(height: 10),
              if (_learners.isEmpty)
                _buildEmpty('👥', 'No learners yet', 'Learners register via WhatsApp bot')
              else
                ..._learners.take(4).map((l) => _buildLearnerCard(l)),
              const SizedBox(height: 20),
            ])));
  }

  Widget _buildBestPerformance() {
    final registered = _learners.where((l) => !l.name.startsWith('Learner_')).toList();
    final topLearner = registered.isEmpty ? null
      : registered.reduce((a, b) => a.averageScore > b.averageScore ? a : b);
    final topCourse  = _courses.isEmpty ? null : _courses.first;
    if (topLearner == null && topCourse == null) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionHeader('🏆 Best Performance',
        action: TextButton(
          onPressed: () => setState(() => _navIndex = 3),
          child: const Text('Full leaderboard', style: TextStyle(
            color: AppColors.primary, fontWeight: FontWeight.w700)))),
      const SizedBox(height: 10),
      Row(children: [
        if (topLearner != null)
          Expanded(child: Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1348D4), Color(0xFF4B3FD8)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: const Color(0xFF1348D4).withOpacity(0.3),
                blurRadius: 8, offset: const Offset(0, 3))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, children: [
              const Row(children: [
                Text('👑', style: TextStyle(fontSize: 16)), SizedBox(width: 6),
                Text('Top Learner', style: TextStyle(color: Colors.white70,
                  fontSize: 10, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 8),
              CircleAvatar(radius: 20, backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(topLearner.name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w800, fontSize: 16))),
              const SizedBox(height: 8),
              Text(topLearner.name, style: const TextStyle(color: Colors.white,
                fontSize: 13, fontWeight: FontWeight.w800),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text('${topLearner.averageScore}%', style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
              const Text('avg score', style: TextStyle(color: Colors.white70, fontSize: 9)),
            ]))),
        if (topLearner != null && topCourse != null) const SizedBox(width: 10),
        if (topCourse != null)
          Expanded(child: Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00875A), Color(0xFF00A36C)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: const Color(0xFF00875A).withOpacity(0.3),
                blurRadius: 8, offset: const Offset(0, 3))]),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, children: [
              const Row(children: [
                Text('🔥', style: TextStyle(fontSize: 16)), SizedBox(width: 6),
                Text('Top Course', style: TextStyle(color: Colors.white70,
                  fontSize: 10, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 8),
              Container(width: 40, height: 40,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Text('📚', style: TextStyle(fontSize: 20)))),
              const SizedBox(height: 8),
              Text(topCourse.title, style: const TextStyle(color: Colors.white,
                fontSize: 13, fontWeight: FontWeight.w800),
                maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 6),
              Text('${_learners.where((l) => l.coursesTaken > 0).length}',
                style: const TextStyle(color: Colors.white, fontSize: 24,
                  fontWeight: FontWeight.w900)),
              const Text('active learners', style: TextStyle(color: Colors.white70, fontSize: 9)),
            ]))),
      ]),
    ]);
  }

  Widget _buildSectionHeader(String title, {Widget? action}) =>
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800,
        color: AppColors.textPrimary, letterSpacing: -0.3)),
      if (action != null) action,
    ]);

  Widget _buildCourseCard(Course c) {
    const emojis = ['📊','🎯','📚','🧠','💡','🚀','🎓','🌐'];
    final emoji    = c.title.isNotEmpty ? emojis[c.title.length % emojis.length] : '📚';
    final enrolled = _enrolledCount(c.id);
    final stat     = _courseStats.where((s) => s['course_id'].toString() == c.id).toList();
    final rate     = stat.isNotEmpty ? (stat.first['completion_rate'] as int? ?? 0) : 0;
    final progress = rate / 100.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06),
          blurRadius: 10, offset: const Offset(0, 3))],
        border: Border.all(color: const Color(0xFFE4E9F2))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Row(children: [
          Container(width: 5, color: const Color(0xFF1348D4)),
          Expanded(child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  Text(c.title.isNotEmpty ? c.title : 'Untitled Course',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800,
                      color: Color(0xFF0A1628)),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text('by ${c.facilitatorName.isNotEmpty ? c.facilitatorName : "Facilitator"}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7A99))),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFE8EEFF),
                    borderRadius: BorderRadius.circular(20)),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text('$enrolled', style: const TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w900, color: Color(0xFF1348D4))),
                    const Text('enrolled', style: TextStyle(fontSize: 9,
                      color: Color(0xFF1348D4), fontWeight: FontWeight.w600)),
                  ])),
              ]),
              const SizedBox(height: 14),
              Row(children: [
                Expanded(child: SizedBox(height: 38,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1348D4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0),
                    onPressed: () => setState(() => _navIndex = 1),
                    child: const Text('Manage Content', style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))))),
                const SizedBox(width: 10),
                Expanded(child: SizedBox(height: 38,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A5C38),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0),
                    onPressed: () => setState(() => _navIndex = 4),
                    icon: const Icon(Icons.send_rounded, size: 13, color: Colors.white),
                    label: const Text('Send Update', style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white))))),
              ]),
              const SizedBox(height: 10),
              ClipRRect(borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: progress, minHeight: 5,
                  backgroundColor: const Color(0xFFE8F5E9),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00875A)))),
            ]))),
        ])));
  }

    Widget _buildLearnerCard(LearnerProgress l) {
    final sc = l.averageScore >= 80 ? AppColors.green
      : l.averageScore >= 60 ? AppColors.amber : AppColors.orange;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
      child: Row(children: [
        CircleAvatar(backgroundColor: AppColors.primaryLight, radius: 20,
          child: Text(l.name.isNotEmpty ? l.name[0].toUpperCase() : 'L',
            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          Text(l.phoneNumber,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(l.averageScore > 0 ? '${l.averageScore}%' : '--',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800,
              color: l.averageScore > 0 ? sc : AppColors.textSecondary)),
          const Text('avg score',
            style: TextStyle(fontSize: 9, color: AppColors.textSecondary)),
        ]),
      ]));
  }

  Widget _buildEmpty(String emoji, String title, String subtitle) =>
    Padding(padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 40)),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 15,
          fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ]));
}

class _StatCard extends StatelessWidget {
  final String value, label; final IconData icon; final Color color;
  const _StatCard(this.value, this.label, this.icon, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
      border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(icon, color: color, size: 22),
        Container(width: 8, height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      ]),
      const Spacer(),
      Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: color)),
      Text(label, style: const TextStyle(fontSize: 10,
        color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
    ]));
}

// ── Poll results list (used inside bottom sheet) ───────────────
class _PollResultsList extends StatefulWidget {
  final ScrollController scrollController;
  const _PollResultsList({required this.scrollController});
  @override
  State<_PollResultsList> createState() => _PollResultsListState();
}

class _PollResultsListState extends State<_PollResultsList> {
  List<dynamic> _polls = [];
  bool _loading = true;

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

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    if (_polls.isEmpty) return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('📊', style: TextStyle(fontSize: 48)),
      SizedBox(height: 12),
      Text('No polls yet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      SizedBox(height: 6),
      Text('Create a poll from Quick Actions',
        style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
    ]));

    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _polls.length,
      itemBuilder: (_, i) {
        final poll    = _polls[i] as Map<String, dynamic>;
        final options = (poll['options'] as List? ?? []);
        final counts  = (poll['counts'] as Map? ?? {});
        final total   = (poll['response_count'] ?? 0) as int;
        final maxCount = counts.values.fold(0, (int a, b) => (b as int) > a ? b : a);

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(14),
            border: const Border(
              left: BorderSide(color: AppColors.primary, width: 4),
              right: BorderSide(color: AppColors.border),
              top: BorderSide(color: AppColors.border),
              bottom: BorderSide(color: AppColors.border))),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, children: [
              // Question + response count
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

              // Bar chart for each option
              ...options.map((opt) {
                final c   = (counts[opt] ?? 0) as int;
                final pct = total > 0 ? c / total : 0.0;
                final isWinner = c == maxCount && c > 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, children: [
                    Row(children: [
                      if (isWinner) const Text('🏆 ', style: TextStyle(fontSize: 12)),
                      Expanded(child: Text(opt.toString(),
                        style: TextStyle(fontSize: 13,
                          fontWeight: isWinner ? FontWeight.w700 : FontWeight.normal,
                          color: isWinner ? AppColors.primary : AppColors.textPrimary))),
                      Text('$c vote${c == 1 ? '' : 's'} · ${(pct * 100).toStringAsFixed(1)}%',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                          color: isWinner ? AppColors.primary : AppColors.textSecondary)),
                    ]),
                    const SizedBox(height: 5),
                    ClipRRect(borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: pct.toDouble(), minHeight: 12,
                        backgroundColor: AppColors.primaryLight,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isWinner ? AppColors.primary : const Color(0xFF6B7A99)))),
                  ]));
              }),

              if (total == 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.bg,
                    borderRadius: BorderRadius.circular(8)),
                  child: const Center(child: Text('No responses yet',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary)))),
            ])));
      });
  }
}