import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/app_theme.dart';
import '../models/models.dart';

class QuizScreen extends StatefulWidget {
  final List<Course> courses;
  const QuizScreen({super.key, required this.courses});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Quizzes & Deadlines',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary)),
        bottom: TabBar(
            controller: _tabs,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle:
                const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            tabs: const [
              Tab(text: '📝 Quiz Builder'),
              Tab(text: '⏰ Deadlines'),
            ])),
      body: TabBarView(
        controller: _tabs,
        children: [
          _QuizBuilderTab(courses: widget.courses),
          _DeadlineTab(courses: widget.courses),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
// QUIZ BUILDER TAB
// ════════════════════════════════════════════════════════════
class _QuizBuilderTab extends StatefulWidget {
  final List<Course> courses;
  const _QuizBuilderTab({required this.courses});
  @override
  State<_QuizBuilderTab> createState() => _QuizBuilderTabState();
}

class _QuizBuilderTabState extends State<_QuizBuilderTab> {
  Course? _selectedCourse;
  List<QuizQuestion> _questions = [];
  bool _loading = false;

  Future<void> _loadQuestions() async {
    if (_selectedCourse == null) return;
    setState(() => _loading = true);
    _questions = await ApiService.getQuizzes(_selectedCourse!.id);
    if (mounted) setState(() => _loading = false);
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12)));
  }

  void _showAddQuestion() {
    final qCtrl = TextEditingController();
    final aCtrl = TextEditingController();
    final bCtrl = TextEditingController();
    final cCtrl = TextEditingController();
    final dCtrl = TextEditingController();
    String correct = 'A';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, ss) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(2))),
                ),
                const SizedBox(height: 16),
                const Text('Add Quiz Question',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),

                _inputField(qCtrl, 'Question *', Icons.help_outline,
                    hint: 'e.g. What does SEO stand for?'),
                const SizedBox(height: 12),

                const Text('Answer Options',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                _inputField(aCtrl, 'A — Option', Icons.radio_button_unchecked),
                const SizedBox(height: 8),
                _inputField(bCtrl, 'B — Option', Icons.radio_button_unchecked),
                const SizedBox(height: 8),
                _inputField(cCtrl, 'C — Option', Icons.radio_button_unchecked),
                const SizedBox(height: 8),
                _inputField(dCtrl, 'D — Option', Icons.radio_button_unchecked),
                const SizedBox(height: 14),

                // Correct answer only (no difficulty)
                const Text('Correct Answer',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Row(children: [
                  for (final opt in ['A', 'B', 'C', 'D'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => ss(() => correct = opt),
                        child: Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: correct == opt ? AppColors.green : AppColors.bg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: correct == opt ? AppColors.green : AppColors.border,
                              width: correct == opt ? 2 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(opt,
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                  color: correct == opt ? Colors.white : AppColors.textPrimary,
                                )),
                          ),
                        ),
                      ),
                    ),
                ]),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () async {
                      if (qCtrl.text.trim().isEmpty || aCtrl.text.trim().isEmpty) return;
                      Navigator.pop(ctx);
                      await ApiService.createQuizQuestion(
                        courseId: _selectedCourse!.id,
                        question: qCtrl.text.trim(),
                        options: {
                          'A': aCtrl.text.trim(),
                          'B': bCtrl.text.trim(),
                          'C': cCtrl.text.trim(),
                          'D': dCtrl.text.trim()
                        },
                        correctAnswer: correct,
                      );
                      _loadQuestions();
                      if (mounted) _snack('✅ Question added!', AppColors.green);
                    },
                    child: const Text('Add Question',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<Course>(
          value: _selectedCourse,
          hint: const Text('Select a course to manage quizzes'),
          decoration: _deco('Course'),
          items: widget.courses
              .map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.title, overflow: TextOverflow.ellipsis)))
              .toList(),
          onChanged: (c) {
            setState(() {
              _selectedCourse = c;
              _questions = [];
            });
            _loadQuestions();
          },
        ),
      ),
      const Divider(height: 1, color: AppColors.border),

      Expanded(
        child: _selectedCourse == null
            ? const Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('📝', style: TextStyle(fontSize: 48)),
                SizedBox(height: 12),
                Text('Select a course above',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary)),
                Text('Then add quiz questions for learners',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ]))
            : _loading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _questions.isEmpty
                    ? Center(
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text('📭', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 12),
                        Text('No questions for ${_selectedCourse!.title}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          onPressed: _showAddQuestion,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text('Add First Question',
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                      ]))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _questions.length + 1,
                        itemBuilder: (_, i) {
                          if (i == _questions.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12))),
                                  onPressed: _showAddQuestion,
                                  icon: const Icon(Icons.add, color: Colors.white),
                                  label: const Text('Add Another Question',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                            );
                          }
                          return _QuestionCard(
                            question: _questions[i],
                            index: i + 1,
                            onDelete: () async {
                              await ApiService.deleteQuizQuestion(_questions[i].id);
                              _loadQuestions();
                            },
                          );
                        },
                      ),
      ),
    ]);
  }
}

// ── Question card ─────────────────────────────────────────────
class _QuestionCard extends StatelessWidget {
  final QuizQuestion question;
  final int index;
  final VoidCallback onDelete;
  const _QuestionCard({required this.question, required this.index, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8)),
            child: Center(
                child: Text('$index',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(question.question,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
          ),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete_outline, size: 18, color: AppColors.textSecondary),
          ),
        ]),
        const SizedBox(height: 10),
        ...question.options.entries.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    color: e.key == question.correctAnswer ? AppColors.greenLight : AppColors.bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: e.key == question.correctAnswer
                            ? AppColors.green
                            : AppColors.border)),
                child: Row(children: [
                  Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                        color: e.key == question.correctAnswer
                            ? AppColors.green
                            : AppColors.border,
                        shape: BoxShape.circle),
                    child: Center(
                      child: Text(e.key,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: e.key == question.correctAnswer
                                  ? Colors.white
                                  : AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(e.value,
                        style: TextStyle(
                            fontSize: 12,
                            color: e.key == question.correctAnswer
                                ? AppColors.green
                                : AppColors.textPrimary,
                            fontWeight: e.key == question.correctAnswer
                                ? FontWeight.w700
                                : FontWeight.normal)),
                  ),
                  if (e.key == question.correctAnswer)
                    const Icon(Icons.check_circle, color: AppColors.green, size: 16),
                ]),
              ),
            )),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════════════
// DEADLINE TAB
// ════════════════════════════════════════════════════════════
class _DeadlineTab extends StatefulWidget {
  final List<Course> courses;
  const _DeadlineTab({required this.courses});
  @override
  State<_DeadlineTab> createState() => _DeadlineTabState();
}

class _DeadlineTabState extends State<_DeadlineTab> {
  List<dynamic> _deadlines = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await ApiService.get('/deadlines');
      if (mounted) {
        setState(() {
          _deadlines = r['data'] ?? [];
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12)));
  }

  void _showAddDeadline() {
    if (widget.courses.isEmpty) {
      _snack('Create a course first', AppColors.orange);
      return;
    }

    Course? selectedCourse;
    final titleCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    DateTime? deadline;
    bool remind24h = true;
    bool remind1h = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, ss) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                        width: 40, height: 4,
                        decoration: BoxDecoration(
                            color: AppColors.border,
                            borderRadius: BorderRadius.circular(2))),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Set Quiz Deadline',
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary)),
                      IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<Course>(
                    value: selectedCourse,
                    hint: const Text('Select Course'),
                    decoration: _deco('Course *'),
                    items: widget.courses
                        .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.title, overflow: TextOverflow.ellipsis)))
                        .toList(),
                    onChanged: (c) => ss(() => selectedCourse = c),
                  ),
                  const SizedBox(height: 10),

                  _inputField(titleCtrl, 'Deadline Title *', Icons.title,
                      hint: 'e.g. Module 2 Quiz'),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () async {
                      final d = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now().add(const Duration(days: 3)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (d != null && ctx.mounted) {
                        final t = await showTimePicker(
                            context: ctx, initialTime: TimeOfDay.now());
                        if (t != null) {
                          ss(() => deadline = DateTime(d.year, d.month, d.day, t.hour, t.minute));
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: deadline != null ? AppColors.primary : AppColors.border),
                      ),
                      child: Row(children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 18,
                            color: deadline != null ? AppColors.primary : AppColors.textSecondary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            deadline != null
                                ? '${deadline!.day}/${deadline!.month}/${deadline!.year}'
                                    ' at ${deadline!.hour}:'
                                    '${deadline!.minute.toString().padLeft(2, '0')}'
                                : 'Set deadline date & time',
                            style: TextStyle(
                              fontSize: 14,
                              color: deadline != null ? AppColors.primary : AppColors.textSecondary,
                              fontWeight: deadline != null ? FontWeight.w700 : FontWeight.normal,
                            ),
                          ),
                        ),
                        Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 18),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 10),

                  _inputField(msgCtrl, 'Custom Reminder Message (optional)',
                      Icons.message_outlined,
                      lines: 2, hint: 'Leave blank to use default'),
                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(10),
                      border: const Border.fromBorderSide(BorderSide(color: AppColors.border)),
                    ),
                    child: Column(children: [
                      const Row(children: [
                        Icon(Icons.notifications_active_outlined,
                            size: 16, color: AppColors.amber),
                        SizedBox(width: 8),
                        Text('Auto Reminders',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary)),
                      ]),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(child: Row(children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          const Expanded(child: Text('24h before',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                          Switch.adaptive(
                            value: remind24h,
                            activeColor: AppColors.primary,
                            onChanged: (v) => ss(() => remind24h = v),
                          ),
                        ])),
                        const SizedBox(width: 16),
                        Expanded(child: Row(children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          const Expanded(child: Text('1h before',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                          Switch.adaptive(
                            value: remind1h,
                            activeColor: AppColors.primary,
                            onChanged: (v) => ss(() => remind1h = v),
                          ),
                        ])),
                      ]),
                      const SizedBox(height: 4),
                      const Text('Reminders sent via WhatsApp automatically',
                          style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ]),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        if (selectedCourse == null ||
                            titleCtrl.text.trim().isEmpty ||
                            deadline == null) {
                          ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                            content: Text('Fill all required fields'),
                            backgroundColor: AppColors.orange,
                          ));
                          return;
                        }
                        Navigator.pop(ctx);
                        await ApiService.post('/deadlines', {
                          'course_id': selectedCourse!.id,
                          'title': titleCtrl.text.trim(),
                          'deadline_date': deadline!.toIso8601String(),
                          'reminder_24h': remind24h,
                          'reminder_1h': remind1h,
                          'message': msgCtrl.text.trim(),
                        });
                        _load();
                        if (mounted) {
                          _snack('✅ Deadline set! Reminders scheduled.', AppColors.green);
                        }
                      },
                      icon: const Icon(Icons.alarm_add, color: Colors.white),
                      label: const Text('Set Deadline & Schedule Reminders',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDeadline,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.alarm_add, color: Colors.white),
        label: const Text('Set Deadline',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _deadlines.isEmpty
              ? Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('⏰', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  const Text('No deadlines scheduled',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  const Text('Tap Set Deadline to auto-send WhatsApp reminders',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: _showAddDeadline,
                    icon: const Icon(Icons.alarm_add, color: Colors.white),
                    label: const Text('Set First Deadline',
                        style: TextStyle(color: Colors.white)),
                  ),
                ]))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _deadlines.length,
                  itemBuilder: (_, i) {
                    final d = _deadlines[i] as Map<String, dynamic>;
                    return _DeadlineCard(
                      data: d,
                      onDelete: () async {
                        await ApiService.delete('/deadlines/${d['id']}');
                        _load();
                      },
                    );
                  },
                ),
    );
  }
}

// ── Deadline card ─────────────────────────────────────────────
class _DeadlineCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onDelete;
  const _DeadlineCard({required this.data, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final ddStr = data['deadline_date'] as String? ?? '';
    final deadline = ddStr.isNotEmpty ? DateTime.tryParse(ddStr) : null;
    final isOverdue = deadline != null && deadline.isBefore(DateTime.now());
    final borderColor = isOverdue ? AppColors.orange : AppColors.primary;

    String timeLeft = '';
    if (deadline != null && !isOverdue) {
      final diff = deadline.difference(DateTime.now());
      if (diff.inDays > 0) {
        timeLeft = '${diff.inDays}d remaining';
      } else if (diff.inHours > 0) {
        timeLeft = '${diff.inHours}h remaining';
      } else {
        timeLeft = '${diff.inMinutes}m remaining';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
          right: const BorderSide(color: AppColors.border),
          top: const BorderSide(color: AppColors.border),
          bottom: const BorderSide(color: AppColors.border),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(data['title'] ?? '',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              Text(data['course_title'] ?? '',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              if (deadline != null) ...[
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.calendar_today, size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                      '${deadline.day}/${deadline.month}/${deadline.year}'
                      ' at ${deadline.hour}:'
                      '${deadline.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ]),
              ],
              if ((data['reminders_sent'] as List?)?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: AppColors.greenLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                      '${(data['reminders_sent'] as List).length} reminder(s) sent',
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.green,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: isOverdue ? AppColors.orangeLight : AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(isOverdue ? 'Overdue' : 'Active',
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isOverdue ? AppColors.orange : AppColors.primary)),
            ),
            if (timeLeft.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(timeLeft,
                  style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700, color: borderColor)),
            ],
            const SizedBox(height: 8),
            GestureDetector(
              onTap: onDelete,
              child: const Icon(Icons.delete_outline, size: 18, color: AppColors.textSecondary),
            ),
          ]),
        ]),
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────
Widget _inputField(TextEditingController ctrl, String label, IconData? icon,
    {int lines = 1, String? hint}) {
  return TextFormField(
    controller: ctrl,
    maxLines: lines,
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      prefixIcon: icon != null ? Icon(icon, size: 18, color: AppColors.textSecondary) : null,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border)),
      filled: true,
      fillColor: Colors.white,
    ),
  );
}

InputDecoration _deco(String label) => InputDecoration(
      labelText: label,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border)),
      filled: true,
      fillColor: Colors.white,
    );