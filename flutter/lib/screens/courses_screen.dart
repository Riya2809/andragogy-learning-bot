import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/app_theme.dart';
import '../models/models.dart';

// ── Thumbnail colour palette ──────────────────────────────────────────────────
const _palette = [
  Color(0xFF1348D4), // Blue
  Color(0xFF00875A), // Green
  Color(0xFFFF5630), // Orange
  Color(0xFF6554C0), // Purple
  Color(0xFFFF991F), // Amber
  Color(0xFF00B8D9), // Cyan
  Color(0xFFE91E8C), // Pink
  Color(0xFF172B4D), // Dark navy
];

const _categories = [
  'General',
  'Technology',
  'Business',
  'Health',
  'Language',
  'Science',
  'Arts',
  'Leadership',
];

const _categoryEmojis = {
  'General': '📚',
  'Technology': '💻',
  'Business': '💼',
  'Health': '🏥',
  'Language': '🌐',
  'Science': '🔬',
  'Arts': '🎨',
  'Leadership': '🎯',
};

class CoursesScreen extends StatefulWidget {
  final VoidCallback? onRefresh;
  const CoursesScreen({super.key, this.onRefresh});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<Course> _courses = [];
  bool _loading = true;
  String _error = '';
  String _filterCategory = 'All';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (mounted) setState(() { _loading = true; _error = ''; });
    try {
      final result = await ApiService.getCourses();
      if (mounted) setState(() { _courses = result; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
    ));
  }

  List<Course> get _filteredCourses {
    if (_filterCategory == 'All') return _courses;
    return _courses.where((c) => c.category == _filterCategory).toList();
  }

  // ── Delete ─────────────────────────────────────────────────────────────────
  void _confirmDelete(Course course) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Course',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            children: [
              const TextSpan(text: 'Are you sure you want to delete '),
              TextSpan(text: '"${course.title}"',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
              const TextSpan(text: '?\n\nThis will permanently remove the course and all its modules.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _courses.removeWhere((c) => c.id == course.id));
              widget.onRefresh?.call();
              final success = await ApiService.deleteCourse(course.id);
              if (mounted) {
                if (success) {
                  _snack('Course deleted', Colors.red.shade400);
                } else {
                  _load();
                  _snack('Failed to delete', Colors.red);
                }
              }
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── Create course bottom sheet ─────────────────────────────────────────────
  void _showCreateCourse() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final tagsCtrl = TextEditingController();
    String selectedCategory = 'General';
    int selectedColor = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Handle bar
            Container(width: 40, height: 4,
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Create New Course',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
            const SizedBox(height: 16),

            // Thumbnail colour picker
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Course Colour',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary))),
            const SizedBox(height: 8),
            _ColorPicker(
              selected: selectedColor,
              onSelect: (i) => setModal(() => selectedColor = i),
            ),
            const SizedBox(height: 16),

            TextField(controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Course Title',
                    border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description',
                    border: OutlineInputBorder())),
            const SizedBox(height: 12),

            // Category dropdown
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Category',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary))),
            const SizedBox(height: 6),
            _CategoryDropdown(
              value: selectedCategory,
              onChanged: (v) => setModal(() => selectedCategory = v!),
            ),
            const SizedBox(height: 12),

            // Tags input
            TextField(controller: tagsCtrl,
                decoration: const InputDecoration(
                    labelText: 'Tags (comma separated)',
                    hintText: 'e.g. beginner, marketing, online',
                    border: OutlineInputBorder())),
            const SizedBox(height: 20),

            Row(children: [
              Expanded(child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary),
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty) return;
                  final tags = tagsCtrl.text
                      .split(',')
                      .map((t) => t.trim())
                      .where((t) => t.isNotEmpty)
                      .toList();
                  Navigator.pop(context);
                  final r = await ApiService.createCourse(
                    titleCtrl.text.trim(),
                    descCtrl.text.trim(),
                    category: selectedCategory,
                    tags: tags,
                    thumbnailColorIndex: selectedColor,
                  );
                  if (r['success'] == true) {
                    _load();
                    widget.onRefresh?.call();
                    if (mounted) _snack('Course created!', AppColors.green);
                  } else {
                    if (mounted) _snack('Error: ${r['message']}', Colors.red);
                  }
                },
                child: const Text('Create',
                    style: TextStyle(color: Colors.white)))),
            ]),
          ]),
        ),
      ),
    );
  }

  // ── Edit course bottom sheet ───────────────────────────────────────────────
  void _showEditCourse(Course course) {
    final titleCtrl = TextEditingController(text: course.title);
    final descCtrl = TextEditingController(text: course.description);
    final tagsCtrl = TextEditingController(text: course.tags.join(', '));
    String selectedCategory = course.category;
    int selectedColor = course.thumbnailColorIndex;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setModal) => SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40, height: 4,
                decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Edit Course',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
            const SizedBox(height: 16),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Course Colour',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary))),
            const SizedBox(height: 8),
            _ColorPicker(
              selected: selectedColor,
              onSelect: (i) => setModal(() => selectedColor = i),
            ),
            const SizedBox(height: 16),

            TextField(controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Course Title',
                    border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, maxLines: 3,
                decoration: const InputDecoration(labelText: 'Description',
                    border: OutlineInputBorder())),
            const SizedBox(height: 12),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Category',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary))),
            const SizedBox(height: 6),
            _CategoryDropdown(
              value: selectedCategory,
              onChanged: (v) => setModal(() => selectedCategory = v!),
            ),
            const SizedBox(height: 12),

            TextField(controller: tagsCtrl,
                decoration: const InputDecoration(
                    labelText: 'Tags (comma separated)',
                    border: OutlineInputBorder())),
            const SizedBox(height: 20),

            Row(children: [
              Expanded(child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'))),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary),
                onPressed: () async {
                  if (titleCtrl.text.trim().isEmpty) return;
                  final tags = tagsCtrl.text
                      .split(',')
                      .map((t) => t.trim())
                      .where((t) => t.isNotEmpty)
                      .toList();
                  Navigator.pop(context);
                  final r = await ApiService.updateCourse(
                    course.id,
                    title: titleCtrl.text.trim(),
                    description: descCtrl.text.trim(),
                    category: selectedCategory,
                    tags: tags,
                    thumbnailColorIndex: selectedColor,
                  );
                  if (r['success'] == true) {
                    _load();
                    widget.onRefresh?.call();
                    if (mounted) _snack('Course updated!', AppColors.green);
                  } else {
                    if (mounted) _snack('Error: ${r['message']}', Colors.red);
                  }
                },
                child: const Text('Save Changes',
                    style: TextStyle(color: Colors.white)))),
            ]),
          ]),
        ),
      ),
    );
  }

  // ── Module management bottom sheet (with edit + drag reorder) ──────────────
  void _showManageModules(Course course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => _ModulesSheet(course: course),
    );
  }

  // ── Add module ─────────────────────────────────────────────────────────────
  void _showAddModule(Course course) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final pdfCtrl = TextEditingController();
    final videoCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Add Module to "${course.title}"',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
          const SizedBox(height: 16),
          TextField(controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Module Title',
                  border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: descCtrl, maxLines: 3,
              decoration: const InputDecoration(labelText: 'Content',
                  border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: pdfCtrl,
              decoration: const InputDecoration(labelText: 'PDF Link (optional)',
                  border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: videoCtrl,
              decoration: const InputDecoration(labelText: 'Video Link (optional)',
                  border: OutlineInputBorder())),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'))),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty) return;
                Navigator.pop(context);
                final r = await ApiService.createModule(
                  courseId: course.id,
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  pdfLink: pdfCtrl.text.trim(),
                  videoLink: videoCtrl.text.trim(),
                );
                if (mounted) {
                  _snack(r['success'] == true ? 'Module added!' : 'Error',
                      r['success'] == true ? AppColors.green : Colors.red);
                }
              },
              child: const Text('Add Module',
                  style: TextStyle(color: Colors.white)))),
          ]),
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Courses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800,
                color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
              onPressed: _showCreateCourse,
              icon: const Icon(Icons.add, size: 16, color: Colors.white),
              label: const Text('New Course',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                      color: Colors.white)))),
        ]),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error.isNotEmpty
              ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('Error: $_error', textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _load, child: const Text('Retry')),
                ]))
              : _courses.isEmpty
                  ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Text('📚', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      const Text('No courses yet',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      const Text('Tap New Course to get started',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary),
                        onPressed: _showCreateCourse,
                        child: const Text('Create First Course',
                            style: TextStyle(color: Colors.white))),
                    ]))
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: Column(children: [
                        // ── Category filter chips ──────────────────────────
                        _CategoryFilter(
                          selected: _filterCategory,
                          courses: _courses,
                          onSelect: (c) => setState(() => _filterCategory = c),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            itemCount: _filteredCourses.length,
                            itemBuilder: (_, i) =>
                                _buildCourseCard(_filteredCourses[i]),
                          ),
                        ),
                      ]),
                    ),
    );
  }

  Widget _buildCourseCard(Course c) {
    final color = _palette[c.thumbnailColorIndex % _palette.length];
    final emoji = _categoryEmojis[c.category] ?? '📚';

    return Dismissible(
      key: Key(c.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        bool confirmed = false;
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            title: const Text('Delete Course',
                style: TextStyle(fontWeight: FontWeight.w800)),
            content: Text('Delete "${c.title}"? This cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () { confirmed = false; Navigator.pop(context); },
                child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red,
                    elevation: 0),
                onPressed: () { confirmed = true; Navigator.pop(context); },
                child: const Text('Delete',
                    style: TextStyle(color: Colors.white))),
            ],
          ),
        );
        return confirmed;
      },
      onDismissed: (_) {
        setState(() => _courses.removeWhere((x) => x.id == c.id));
        ApiService.deleteCourse(c.id).then((ok) {
          if (!ok && mounted) { _load(); _snack('Failed to delete', Colors.red); }
        });
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(color: Colors.red.shade500,
            borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_rounded, color: Colors.white, size: 26),
              SizedBox(height: 4),
              Text('Delete', style: TextStyle(color: Colors.white,
                  fontSize: 11, fontWeight: FontWeight.w700)),
            ]),
      ),
      child: Card(
        margin: const EdgeInsets.only(bottom: 14),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ── Thumbnail banner ─────────────────────────────────────────────
          Container(
            height: 72,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 28)),
                const Spacer(),
                // Category chip
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(c.category,
                      style: const TextStyle(color: Colors.white,
                          fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),

          // ── Card body ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.title,
                              style: const TextStyle(fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black87)),
                          const SizedBox(height: 2),
                          Text('by ${c.facilitatorName}',
                              style: const TextStyle(fontSize: 12,
                                  color: Colors.grey)),
                        ]),
                  ),
                  // Edit + Delete icons
                  Row(children: [
                    _IconBtn(
                      icon: Icons.edit_outlined,
                      color: AppColors.primary,
                      bg: AppColors.primaryLight,
                      onTap: () => _showEditCourse(c),
                    ),
                    const SizedBox(width: 6),
                    _IconBtn(
                      icon: Icons.delete_outline_rounded,
                      color: Colors.red,
                      bg: Colors.red.shade50,
                      onTap: () => _confirmDelete(c),
                    ),
                  ]),
                ]),

                // Tags
                if (c.tags.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(spacing: 6, runSpacing: 4,
                    children: c.tags.map((t) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Text(t,
                          style: TextStyle(fontSize: 10,
                              fontWeight: FontWeight.w600, color: color)),
                    )).toList()),
                ],

                const SizedBox(height: 12),

                // Action buttons
                Row(children: [
                  Expanded(child: SizedBox(height: 38,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      onPressed: () => _showManageModules(c),
                      icon: const Icon(Icons.view_list_rounded,
                          size: 14, color: Colors.white),
                      label: const Text('Modules',
                          style: TextStyle(fontSize: 12,
                              color: Colors.white))))),
                  const SizedBox(width: 8),
                  Expanded(child: SizedBox(height: 38,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.whatsapp,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      onPressed: () =>
                          _snack('WhatsApp update sent!', AppColors.green),
                      icon: const Icon(Icons.send_rounded,
                          size: 14, color: Colors.white),
                      label: const Text('Send Update',
                          style: TextStyle(fontSize: 12,
                              color: Colors.white))))),
                ]),
              ]),
          ),
        ]),
      ),
    );
  }
}

// ── Modules sheet with drag-reorder + edit ────────────────────────────────────
class _ModulesSheet extends StatefulWidget {
  final Course course;
  const _ModulesSheet({required this.course});

  @override
  State<_ModulesSheet> createState() => _ModulesSheetState();
}

class _ModulesSheetState extends State<_ModulesSheet> {
  List<CourseModule> _modules = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadModules();
  }

  Future<void> _loadModules() async {
    setState(() => _loading = true);
    final result = await ApiService.getModules(widget.course.id);
    result.sort((a, b) => a.order.compareTo(b.order));
    if (mounted) setState(() { _modules = result; _loading = false; });
  }

  void _snack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: color,
      behavior: SnackBarBehavior.floating, margin: const EdgeInsets.all(12)));
  }

  void _showAddModule() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final pdfCtrl = TextEditingController();
    final videoCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Add Module to "${widget.course.title}"',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
          const SizedBox(height: 16),

          // Module title
          TextField(
            controller: titleCtrl,
            decoration: const InputDecoration(
              labelText: 'Module Title *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title_rounded),
            ),
          ),
          const SizedBox(height: 12),

          // Content
          TextField(
            controller: descCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Content / Description *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.notes_rounded),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),

          // PDF link
          TextField(
            controller: pdfCtrl,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'PDF Link (optional)',
              hintText: 'https://example.com/file.pdf',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.picture_as_pdf_rounded, color: Colors.red),
            ),
          ),
          const SizedBox(height: 12),

          // YouTube link
          TextField(
            controller: videoCtrl,
            keyboardType: TextInputType.url,
            decoration: const InputDecoration(
              labelText: 'YouTube / Video Link (optional)',
              hintText: 'https://youtube.com/watch?v=...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.play_circle_rounded, color: Colors.red),
            ),
          ),
          const SizedBox(height: 20),

          Row(children: [
            Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'))),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary),
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty ||
                    descCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title and content are required')));
                  return;
                }
                Navigator.pop(context);
                final r = await ApiService.createModule(
                  courseId: widget.course.id,
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  pdfLink: pdfCtrl.text.trim(),
                  videoLink: videoCtrl.text.trim(),
                  order: _modules.length + 1,
                );
                if (mounted) {
                  _snack(
                    r['success'] == true ? 'Module added!' : 'Error: ${r['message']}',
                    r['success'] == true ? AppColors.green : Colors.red,
                  );
                  if (r['success'] == true) _loadModules();
                }
              },
              child: const Text('Add Module',
                  style: TextStyle(color: Colors.white)))),
          ]),
        ]),
      ),
    );
  }

  Future<void> _saveOrder() async {
    final ids = _modules.map((m) => m.id).toList();
    final ok = await ApiService.reorderModules(widget.course.id, ids);
    if (mounted) {
      _snack(ok ? 'Order saved!' : 'Failed to save order',
          ok ? AppColors.green : Colors.red);
    }
  }

  void _showEditModule(CourseModule module) {
    final titleCtrl = TextEditingController(text: module.title);
    final descCtrl = TextEditingController(text: module.description);
    final pdfCtrl = TextEditingController(text: module.pdfLink);
    final videoCtrl = TextEditingController(text: module.videoLink);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          const Align(alignment: Alignment.centerLeft,
              child: Text('Edit Module',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800))),
          const SizedBox(height: 16),
          TextField(controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Module Title',
                  border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: descCtrl, maxLines: 3,
              decoration: const InputDecoration(labelText: 'Content',
                  border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: pdfCtrl,
              decoration: const InputDecoration(labelText: 'PDF Link (optional)',
                  border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: videoCtrl,
              decoration: const InputDecoration(labelText: 'Video Link (optional)',
                  border: OutlineInputBorder())),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'))),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary),
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty) return;
                Navigator.pop(context);
                final r = await ApiService.updateModule(
                  moduleId: module.id,
                  title: titleCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  pdfLink: pdfCtrl.text.trim(),
                  videoLink: videoCtrl.text.trim(),
                );
                if (mounted) {
                  _snack(r['success'] == true ? 'Module updated!' : 'Error',
                      r['success'] == true ? AppColors.green : Colors.red);
                  if (r['success'] == true) _loadModules();
                }
              },
              child: const Text('Save Changes',
                  style: TextStyle(color: Colors.white)))),
          ]),
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollCtrl) => Column(children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(children: [
            Container(width: 40, height: 4,
                decoration: BoxDecoration(color: AppColors.border,
                    borderRadius: BorderRadius.circular(2))),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 16, 12),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Modules — ${widget.course.title}',
                        style: const TextStyle(fontSize: 16,
                            fontWeight: FontWeight.w800)),
                    const Text('Hold & drag to reorder',
                        style: TextStyle(fontSize: 11,
                            color: AppColors.textSecondary)),
                  ]),
            ),
            // Save order button
            if (_modules.isNotEmpty)
              TextButton.icon(
                onPressed: _saveOrder,
                icon: const Icon(Icons.save_rounded, size: 16),
                label: const Text('Save Order'),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary),
              ),
            // Add module button
            ElevatedButton.icon(
              onPressed: _showAddModule,
              icon: const Icon(Icons.add, size: 15, color: Colors.white),
              label: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
            ),
          ]),
        ),
        const Divider(height: 1, color: AppColors.border),

        if (_loading)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (_modules.isEmpty)
          Expanded(child: Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('📦', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            const Text('No modules yet',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ])))
        else
          Expanded(
            child: ReorderableListView.builder(
              scrollController: scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _modules.length,
              onReorder: (oldIdx, newIdx) {
                setState(() {
                  if (newIdx > oldIdx) newIdx--;
                  final item = _modules.removeAt(oldIdx);
                  _modules.insert(newIdx, item);
                });
              },
              itemBuilder: (_, i) {
                final m = _modules[i];
                return Card(
                  key: Key(m.id),
                  margin: const EdgeInsets.only(bottom: 10),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    leading: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('${i + 1}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                fontSize: 13)),
                      ),
                    ),
                    title: Text(m.title,
                        style: const TextStyle(fontSize: 13,
                            fontWeight: FontWeight.w700)),
                    subtitle: m.description.isNotEmpty
                        ? Text(m.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 11,
                            color: AppColors.textSecondary))
                        : null,
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      // Edit button
                      GestureDetector(
                        onTap: () => _showEditModule(m),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.edit_outlined,
                              size: 15, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Drag handle
                      const Icon(Icons.drag_handle_rounded,
                          color: AppColors.textSecondary, size: 20),
                    ]),
                  ),
                );
              },
            ),
          ),
      ]),
    );
  }
}

// ── Reusable colour picker ────────────────────────────────────────────────────
class _ColorPicker extends StatelessWidget {
  final int selected;
  final void Function(int) onSelect;
  const _ColorPicker({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_palette.length, (i) {
        final isSelected = i == selected;
        return GestureDetector(
          onTap: () => onSelect(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            width: isSelected ? 34 : 28,
            height: isSelected ? 34 : 28,
            decoration: BoxDecoration(
              color: _palette[i],
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: _palette[i].withOpacity(0.5),
                  blurRadius: 8, spreadRadius: 1)]
                  : [],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        );
      }),
    );
  }
}

// ── Category dropdown ─────────────────────────────────────────────────────────
class _CategoryDropdown extends StatelessWidget {
  final String value;
  final void Function(String?) onChanged;
  const _CategoryDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          onChanged: onChanged,
          items: _categories.map((cat) => DropdownMenuItem(
            value: cat,
            child: Row(children: [
              Text(_categoryEmojis[cat] ?? '📚',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(cat, style: const TextStyle(fontSize: 14)),
            ]),
          )).toList(),
        ),
      ),
    );
  }
}

// ── Category filter chips row ─────────────────────────────────────────────────
class _CategoryFilter extends StatelessWidget {
  final String selected;
  final List<Course> courses;
  final void Function(String) onSelect;
  const _CategoryFilter(
      {required this.selected, required this.courses, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final cats = ['All', ..._categories
        .where((c) => courses.any((course) => course.category == c))
        .toList()];

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = cats[i];
          final isSelected = cat == selected;
          return GestureDetector(
            onTap: () => onSelect(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                cat == 'All' ? 'All' : '${_categoryEmojis[cat] ?? ''} $cat',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Small icon button helper ──────────────────────────────────────────────────
class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
  const _IconBtn(
      {required this.icon, required this.color, required this.bg,
        required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 17),
      ),
    );
  }
}


















// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/models.dart';

// const _blue   = Color(0xFF1348D4);
// const _green  = Color(0xFF00875A);
// const _orange = Color(0xFFFF5630);
// const _bg     = Color(0xFFF4F6FB);
// const _border = Color(0xFFE4E9F2);
// const _text   = Color(0xFF0A1628);
// const _sub    = Color(0xFF6B7A99);
// const _pLight = Color(0xFFE8EEFF);

// class CoursesScreen extends StatefulWidget {
//   final VoidCallback? onRefresh;
//   final String? selectedCourseId;
//   const CoursesScreen({super.key, this.onRefresh, this.selectedCourseId});
//   @override
//   State<CoursesScreen> createState() => _CoursesScreenState();
// }

// class _CoursesScreenState extends State<CoursesScreen> {
//   List<Course> _courses = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load().then((_) {
//       // Auto-open course if navigated from Home card
//       if (widget.selectedCourseId != null && mounted) {
//         final match = _courses.where((c) => c.id == widget.selectedCourseId);
//         if (match.isNotEmpty) {
//           Future.delayed(const Duration(milliseconds: 300), () {
//             if (mounted) _showAddModule(match.first, 0);
//           });
//         }
//       }
//     });
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final r = await ApiService.getCourses();
//     if (mounted) setState(() { _courses = r; _loading = false; });
//   }

//   void _snack(String m, Color c) => ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text(m), backgroundColor: c,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.all(12)));

//   void _showCreate() {
//     final tc = TextEditingController();
//     final dc = TextEditingController();
//     showModalBottomSheet(
//       context: context, isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => Padding(
//         padding: EdgeInsets.only(
//           left: 20, right: 20, top: 24,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20),
//         child: Column(mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('Create New Course',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text)),
//           const SizedBox(height: 16),
//           _inp(tc, 'Course Title *', Icons.menu_book_outlined),
//           const SizedBox(height: 12),
//           _inpMulti(dc, 'Description *'),
//           const SizedBox(height: 18),
//           Row(children: [
//             Expanded(child: OutlinedButton(
//               style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'))),
//             const SizedBox(width: 12),
//             Expanded(child: ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: _blue,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//               onPressed: () async {
//                 if (tc.text.trim().isEmpty || dc.text.trim().isEmpty) return;
//                 Navigator.pop(context);
//                 final r = await ApiService.createCourse(tc.text.trim(), dc.text.trim());
//                 if (r['success'] == true) {
//                   _load(); widget.onRefresh?.call();
//                   if (mounted) _snack('Course created!', _green);
//                 } else {
//                   if (mounted) _snack(r['message'] ?? 'Error', _orange);
//                 }
//               },
//               child: const Text('Create',
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
//           ]),
//         ])));
//   }

//   void _showAddModule(Course course, int currentCount) {
//     final tc    = TextEditingController();
//     final dc    = TextEditingController();
//     final pdfC  = TextEditingController();
//     final vidC  = TextEditingController();
//     final orderC = TextEditingController(text: '${currentCount + 1}');

//     showModalBottomSheet(
//       context: context, isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => DraggableScrollableSheet(
//         initialChildSize: 0.92, maxChildSize: 0.97, minChildSize: 0.5,
//         expand: false,
//         builder: (ctx, scrollCtrl) => ListView(
//           controller: scrollCtrl,
//           padding: EdgeInsets.only(
//             left: 20, right: 20, top: 20,
//             bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
//           children: [
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//               Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 const Text('Add New Module',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text)),
//                 Text(course.title, style: const TextStyle(fontSize: 12, color: _sub)),
//               ])),
//               IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
//             ]),
//             const Divider(color: _border),
//             const SizedBox(height: 8),
//             _sectionLabel('📋 Basic Info'),
//             const SizedBox(height: 10),
//             _inp(tc, 'Module Title *', Icons.article_outlined),
//             const SizedBox(height: 10),
//             _inpMulti(dc, 'Description / Content *'),
//             const SizedBox(height: 10),
//             Row(children: [
//               Expanded(child: TextFormField(
//                 controller: orderC,
//                 keyboardType: TextInputType.number,
//                 decoration: _inputDeco('Order', Icons.format_list_numbered))),
//             ]),
//             const SizedBox(height: 16),
//             _sectionLabel('📄 PDF Attachment'),
//             const SizedBox(height: 4),
//             const Text('Paste a Google Drive or public PDF link.',
//               style: TextStyle(fontSize: 11, color: _sub)),
//             const SizedBox(height: 10),
//             _inp(pdfC, 'PDF Link (optional)', Icons.picture_as_pdf,
//               hint: 'https://drive.google.com/file/d/...'),
//             const SizedBox(height: 16),
//             _sectionLabel('🎥 Video Link'),
//             const SizedBox(height: 4),
//             const Text('Paste a YouTube link.',
//               style: TextStyle(fontSize: 11, color: _sub)),
//             const SizedBox(height: 10),
//             _inp(vidC, 'YouTube / Video Link (optional)',
//               Icons.play_circle_outline,
//               hint: 'https://youtube.com/watch?v=...'),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity, height: 50,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(backgroundColor: _blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12))),
//                 onPressed: () async {
//                   if (tc.text.trim().isEmpty || dc.text.trim().isEmpty) {
//                     _snack('Title and description are required', _orange);
//                     return;
//                   }
//                   Navigator.pop(ctx);
//                   final r = await ApiService.createModule(
//                     courseId:    course.id,
//                     title:       tc.text.trim(),
//                     description: dc.text.trim(),
//                     pdfLink:     pdfC.text.trim(),
//                     videoLink:   vidC.text.trim(),
//                     order:       int.tryParse(orderC.text) ?? 1,
//                   );
//                   if (mounted) {
//                     _snack(r['success'] == true ? '✅ Module added!' : 'Error',
//                       r['success'] == true ? _green : _orange);
//                   }
//                 },
//                 icon: const Icon(Icons.save_outlined, color: Colors.white),
//                 label: const Text('Save Module',
//                   style: TextStyle(
//                     color: Colors.white, fontSize: 15,
//                     fontWeight: FontWeight.w700)))),
//             const SizedBox(height: 8),
//           ])));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white, elevation: 0,
//         title: const Text('My Courses',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text)),
//         actions: [
//           Padding(padding: const EdgeInsets.only(right: 12),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(backgroundColor: _blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8)),
//               onPressed: _showCreate,
//               icon: const Icon(Icons.add, size: 16, color: Colors.white),
//               label: const Text('New Course',
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)))),
//         ],
//         bottom: const PreferredSize(
//           preferredSize: Size.fromHeight(1),
//           child: Divider(height: 1, color: _border))),
//       body: _loading
//         ? const Center(child: CircularProgressIndicator(color: _blue))
//         : RefreshIndicator(
//             onRefresh: _load,
//             child: _courses.isEmpty
//               ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   const Text('📚', style: TextStyle(fontSize: 48)),
//                   const SizedBox(height: 12),
//                   const Text('No courses yet',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _text)),
//                   const SizedBox(height: 6),
//                   const Text('Tap "New Course" to get started',
//                     style: TextStyle(color: _sub)),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: _blue),
//                     onPressed: _showCreate,
//                     child: const Text('Create First Course',
//                       style: TextStyle(color: Colors.white))),
//                 ]))
//               : ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: _courses.length,
//                   itemBuilder: (_, i) => _CourseCard(
//                     course: _courses[i],
//                     onAddModule: (count) => _showAddModule(_courses[i], count),
//                     onDelete: () async {
//                       final ok = await ApiService.deleteCourse(_courses[i].id);
//                       if (ok) { _load(); widget.onRefresh?.call(); }
//                     }))));
//   }

//   Widget _sectionLabel(String t) => Text(t,
//     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text));

//   Widget _inp(TextEditingController c, String label, IconData icon, {String? hint}) =>
//     TextFormField(controller: c,
//       decoration: _inputDeco(label, icon, hint: hint));

//   Widget _inpMulti(TextEditingController c, String label, {int lines = 3}) =>
//     TextFormField(controller: c, maxLines: lines,
//       decoration: InputDecoration(labelText: label, alignLabelWithHint: true,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: _border)),
//         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: _border)),
//         filled: true, fillColor: Colors.white));

//   InputDecoration _inputDeco(String label, IconData icon, {String? hint}) =>
//     InputDecoration(labelText: label, hintText: hint,
//       hintStyle: const TextStyle(fontSize: 12, color: _sub),
//       prefixIcon: Icon(icon, size: 20, color: _sub),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: _border)),
//       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: _border)),
//       filled: true, fillColor: Colors.white);
// }

// // ── Course Card ───────────────────────────────────────────────
// class _CourseCard extends StatefulWidget {
//   final Course course;
//   final void Function(int count) onAddModule;
//   final VoidCallback onDelete;
//   const _CourseCard({
//     required this.course,
//     required this.onAddModule,
//     required this.onDelete});
//   @override
//   State<_CourseCard> createState() => _CourseCardState();
// }

// class _CourseCardState extends State<_CourseCard> {
//   List<CourseModule> _modules = [];
//   bool _expanded = false;
//   bool _loadingModules = false;

//   Future<void> _loadModules() async {
//     setState(() => _loadingModules = true);
//     _modules = await ApiService.getModules(widget.course.id);
//     if (mounted) setState(() => _loadingModules = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 10, offset: const Offset(0, 2))],
//         border: const Border(
//           left: BorderSide(color: _blue, width: 5),
//           right: BorderSide(color: _border),
//           top: BorderSide(color: _border),
//           bottom: BorderSide(color: _border))),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Row(children: [
//               Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Text(widget.course.title,
//                   style: const TextStyle(fontSize: 15,
//                     fontWeight: FontWeight.w700, color: _text)),
//                 const SizedBox(height: 3),
//                 Text('by ${widget.course.facilitatorName}',
//                   style: const TextStyle(fontSize: 11, color: _sub)),
//               ])),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: _pLight, borderRadius: BorderRadius.circular(20)),
//                 child: const Text('Active',
//                   style: TextStyle(fontSize: 10,
//                     fontWeight: FontWeight.w700, color: _blue))),
//             ]),
//             const SizedBox(height: 12),
//             Row(children: [
//               Expanded(child: SizedBox(height: 36,
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(backgroundColor: _blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20))),
//                   onPressed: () => widget.onAddModule(_modules.length),
//                   icon: const Icon(Icons.add, size: 14, color: Colors.white),
//                   label: const Text('Add Module',
//                     style: TextStyle(fontSize: 12,
//                       fontWeight: FontWeight.w700, color: Colors.white))))),
//               const SizedBox(width: 8),
//               Expanded(child: SizedBox(height: 36,
//                 child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: _blue),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20))),
//                   onPressed: () async {
//                     setState(() => _expanded = !_expanded);
//                     if (_expanded && _modules.isEmpty) await _loadModules();
//                   },
//                   icon: Icon(
//                     _expanded ? Icons.expand_less : Icons.expand_more,
//                     size: 14, color: _blue),
//                   label: Text('Modules (${_modules.length})',
//                     style: const TextStyle(fontSize: 12,
//                       fontWeight: FontWeight.w700, color: _blue))))),
//             ]),
//           ])),
//         if (_expanded) ...[
//           const Divider(height: 1, color: _border),
//           if (_loadingModules)
//             const Padding(padding: EdgeInsets.all(16),
//               child: Center(child: CircularProgressIndicator(color: _blue)))
//           else if (_modules.isEmpty)
//             Padding(padding: const EdgeInsets.all(16),
//               child: Column(children: [
//                 const Text('📭 No modules yet',
//                   style: TextStyle(color: _sub, fontSize: 13)),
//                 const SizedBox(height: 8),
//                 ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(backgroundColor: _blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20))),
//                   onPressed: () => widget.onAddModule(0),
//                   icon: const Icon(Icons.add, size: 14, color: Colors.white),
//                   label: const Text('Add First Module',
//                     style: TextStyle(fontSize: 12, color: Colors.white,
//                       fontWeight: FontWeight.w700))),
//               ]))
//           else
//             Column(children: [
//               ..._modules.map((m) => _ModuleTile(
//                 module: m,
//                 index: _modules.indexOf(m) + 1)),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
//                 child: SizedBox(width: double.infinity,
//                   child: OutlinedButton.icon(
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: _blue),
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10))),
//                     onPressed: () => widget.onAddModule(_modules.length),
//                     icon: const Icon(Icons.add_circle_outline,
//                       size: 16, color: _blue),
//                     label: const Text('Add Another Module',
//                       style: TextStyle(fontSize: 13, color: _blue,
//                         fontWeight: FontWeight.w700))))),
//             ]),
//         ],
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//           child: GestureDetector(
//             onTap: widget.onDelete,
//             child: const Text('Delete course',
//               style: TextStyle(fontSize: 11, color: _sub,
//                 decoration: TextDecoration.underline)))),
//       ]));
//   }
// }

// // ── Module tile ───────────────────────────────────────────────
// class _ModuleTile extends StatelessWidget {
//   final CourseModule module;
//   final int index;
//   const _ModuleTile({required this.module, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     final hasPdf   = module.pdfLink.isNotEmpty;
//     final hasVideo = module.videoLink.isNotEmpty;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         border: Border(top: BorderSide(color: _border))),
//       child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Container(width: 32, height: 32,
//           decoration: BoxDecoration(
//             color: _pLight, borderRadius: BorderRadius.circular(8)),
//           child: Center(child: Text('$index',
//             style: const TextStyle(
//               fontWeight: FontWeight.w800, color: _blue, fontSize: 13)))),
//         const SizedBox(width: 12),
//         Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//           Text(module.title,
//             style: const TextStyle(
//               fontSize: 13, fontWeight: FontWeight.w700, color: _text)),
//           if (module.description.isNotEmpty) ...[
//             const SizedBox(height: 2),
//             Text(module.description,
//               maxLines: 2, overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontSize: 11, color: _sub)),
//           ],
//           const SizedBox(height: 6),
//           Row(children: [
//             if (hasPdf) _Badge(Icons.picture_as_pdf, 'PDF', _orange),
//             if (hasPdf && hasVideo) const SizedBox(width: 6),
//             if (hasVideo) _Badge(Icons.play_circle_outline, 'Video', Colors.red),
//             if (!hasPdf && !hasVideo)
//               const Text('No attachments',
//                 style: TextStyle(fontSize: 10, color: _sub)),
//           ]),
//         ])),
//       ]));
//   }
// }

// // ── Badge ─────────────────────────────────────────────────────
// class _Badge extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   const _Badge(this.icon, this.label, this.color);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.3))),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, size: 11, color: color),
//         const SizedBox(width: 4),
//         Text(label,
//           style: TextStyle(
//             fontSize: 10, color: color, fontWeight: FontWeight.w700)),
//       ]));
//   }
// }





















// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../models/models.dart';

// const _blue   = Color(0xFF1348D4);
// const _green  = Color(0xFF00875A);
// const _orange = Color(0xFFFF5630);
// const _bg     = Color(0xFFF4F6FB);
// const _border = Color(0xFFE4E9F2);
// const _text   = Color(0xFF0A1628);
// const _sub    = Color(0xFF6B7A99);
// const _pLight = Color(0xFFE8EEFF);

// class CoursesScreen extends StatefulWidget {
//   final VoidCallback? onRefresh;
//   final String? selectedCourseId;
//   const CoursesScreen({super.key, this.onRefresh, this.selectedCourseId});
//   @override
//   State<CoursesScreen> createState() => _CoursesScreenState();
// }

// class _CoursesScreenState extends State<CoursesScreen> {
//   List<Course> _courses = [];
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _load().then((_) {
//       // Auto-open course if navigated from Home card
//       if (widget.selectedCourseId != null && mounted) {
//         final match = _courses.where((c) => c.id == widget.selectedCourseId);
//         if (match.isNotEmpty) {
//           Future.delayed(const Duration(milliseconds: 300), () {
//             if (mounted) _showAddModule(match.first, 0);
//           });
//         }
//       }
//     });
//   }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     final r = await ApiService.getCourses();
//     if (mounted) setState(() { _courses = r; _loading = false; });
//   }

//   void _snack(String m, Color c) => ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text(m), backgroundColor: c,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.all(12)));

//   void _showCreate() {
//     final tc = TextEditingController();
//     final dc = TextEditingController();
//     showModalBottomSheet(
//       context: context, isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => Padding(
//         padding: EdgeInsets.only(
//           left: 20, right: 20, top: 24,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20),
//         child: Column(mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start, children: [
//           const Text('Create New Course',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text)),
//           const SizedBox(height: 16),
//           _inp(tc, 'Course Title *', Icons.menu_book_outlined),
//           const SizedBox(height: 12),
//           _inpMulti(dc, 'Description *'),
//           const SizedBox(height: 18),
//           Row(children: [
//             Expanded(child: OutlinedButton(
//               style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'))),
//             const SizedBox(width: 12),
//             Expanded(child: ElevatedButton(
//               style: ElevatedButton.styleFrom(backgroundColor: _blue,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//               onPressed: () async {
//                 if (tc.text.trim().isEmpty || dc.text.trim().isEmpty) return;
//                 Navigator.pop(context);
//                 final r = await ApiService.createCourse(tc.text.trim(), dc.text.trim());
//                 if (r['success'] == true) {
//                   _load(); widget.onRefresh?.call();
//                   if (mounted) _snack('Course created!', _green);
//                 } else {
//                   if (mounted) _snack(r['message'] ?? 'Error', _orange);
//                 }
//               },
//               child: const Text('Create',
//                 style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
//           ]),
//         ])));
//   }

//   void _showAddModule(Course course, int currentCount) {
//     final tc    = TextEditingController();
//     final dc    = TextEditingController();
//     final pdfC  = TextEditingController();
//     final vidC  = TextEditingController();
//     final orderC = TextEditingController(text: '${currentCount + 1}');

//     showModalBottomSheet(
//       context: context, isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
//       builder: (_) => DraggableScrollableSheet(
//         initialChildSize: 0.92, maxChildSize: 0.97, minChildSize: 0.5,
//         expand: false,
//         builder: (ctx, scrollCtrl) => ListView(
//           controller: scrollCtrl,
//           padding: EdgeInsets.only(
//             left: 20, right: 20, top: 20,
//             bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
//           children: [
//             Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//               Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 const Text('Add New Module',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text)),
//                 Text(course.title, style: const TextStyle(fontSize: 12, color: _sub)),
//               ])),
//               IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
//             ]),
//             const Divider(color: _border),
//             const SizedBox(height: 8),
//             _sectionLabel('📋 Basic Info'),
//             const SizedBox(height: 10),
//             _inp(tc, 'Module Title *', Icons.article_outlined),
//             const SizedBox(height: 10),
//             _inpMulti(dc, 'Description / Content *'),
//             const SizedBox(height: 10),
//             Row(children: [
//               Expanded(child: TextFormField(
//                 controller: orderC,
//                 keyboardType: TextInputType.number,
//                 decoration: _inputDeco('Order', Icons.format_list_numbered))),
//             ]),
//             const SizedBox(height: 16),
//             _sectionLabel('📄 PDF Attachment'),
//             const SizedBox(height: 4),
//             const Text('Paste a Google Drive or public PDF link.',
//               style: TextStyle(fontSize: 11, color: _sub)),
//             const SizedBox(height: 10),
//             _inp(pdfC, 'PDF Link (optional)', Icons.picture_as_pdf,
//               hint: 'https://drive.google.com/file/d/...'),
//             const SizedBox(height: 16),
//             _sectionLabel('🎥 Video Link'),
//             const SizedBox(height: 4),
//             const Text('Paste a YouTube link.',
//               style: TextStyle(fontSize: 11, color: _sub)),
//             const SizedBox(height: 10),
//             _inp(vidC, 'YouTube / Video Link (optional)',
//               Icons.play_circle_outline,
//               hint: 'https://youtube.com/watch?v=...'),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity, height: 50,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(backgroundColor: _blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12))),
//                 onPressed: () async {
//                   if (tc.text.trim().isEmpty || dc.text.trim().isEmpty) {
//                     _snack('Title and description are required', _orange);
//                     return;
//                   }
//                   Navigator.pop(ctx);
//                   final r = await ApiService.createModule(
//                     courseId:    course.id,
//                     title:       tc.text.trim(),
//                     description: dc.text.trim(),
//                     pdfLink:     pdfC.text.trim(),
//                     videoLink:   vidC.text.trim(),
//                     order:       int.tryParse(orderC.text) ?? 1,
//                   );
//                   if (mounted) {
//                     _snack(r['success'] == true ? '✅ Module added!' : 'Error',
//                       r['success'] == true ? _green : _orange);
//                   }
//                 },
//                 icon: const Icon(Icons.save_outlined, color: Colors.white),
//                 label: const Text('Save Module',
//                   style: TextStyle(
//                     color: Colors.white, fontSize: 15,
//                     fontWeight: FontWeight.w700)))),
//             const SizedBox(height: 8),
//           ])));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _bg,
//       appBar: AppBar(
//         backgroundColor: Colors.white, elevation: 0,
//         title: const Text('My Courses',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _text)),
//         actions: [
//           Padding(padding: const EdgeInsets.only(right: 12),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(backgroundColor: _blue,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20)),
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8)),
//               onPressed: _showCreate,
//               icon: const Icon(Icons.add, size: 16, color: Colors.white),
//               label: const Text('New Course',
//                 style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)))),
//         ],
//         bottom: const PreferredSize(
//           preferredSize: Size.fromHeight(1),
//           child: Divider(height: 1, color: _border))),
//       body: _loading
//         ? const Center(child: CircularProgressIndicator(color: _blue))
//         : RefreshIndicator(
//             onRefresh: _load,
//             child: _courses.isEmpty
//               ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
//                   const Text('📚', style: TextStyle(fontSize: 48)),
//                   const SizedBox(height: 12),
//                   const Text('No courses yet',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _text)),
//                   const SizedBox(height: 6),
//                   const Text('Tap "New Course" to get started',
//                     style: TextStyle(color: _sub)),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: _blue),
//                     onPressed: _showCreate,
//                     child: const Text('Create First Course',
//                       style: TextStyle(color: Colors.white))),
//                 ]))
//               : ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: _courses.length,
//                   itemBuilder: (_, i) => _CourseCard(
//                     course: _courses[i],
//                     onAddModule: (count) => _showAddModule(_courses[i], count),
//                     onDelete: () async {
//                       final ok = await ApiService.deleteCourse(_courses[i].id);
//                       if (ok) { _load(); widget.onRefresh?.call(); }
//                     }))));
//   }

//   Widget _sectionLabel(String t) => Text(t,
//     style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: _text));

//   Widget _inp(TextEditingController c, String label, IconData icon, {String? hint}) =>
//     TextFormField(controller: c,
//       decoration: _inputDeco(label, icon, hint: hint));

//   Widget _inpMulti(TextEditingController c, String label, {int lines = 3}) =>
//     TextFormField(controller: c, maxLines: lines,
//       decoration: InputDecoration(labelText: label, alignLabelWithHint: true,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: _border)),
//         enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
//           borderSide: const BorderSide(color: _border)),
//         filled: true, fillColor: Colors.white));

//   InputDecoration _inputDeco(String label, IconData icon, {String? hint}) =>
//     InputDecoration(labelText: label, hintText: hint,
//       hintStyle: const TextStyle(fontSize: 12, color: _sub),
//       prefixIcon: Icon(icon, size: 20, color: _sub),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: _border)),
//       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
//         borderSide: const BorderSide(color: _border)),
//       filled: true, fillColor: Colors.white);
// }

// // ── Course Card ───────────────────────────────────────────────
// class _CourseCard extends StatefulWidget {
//   final Course course;
//   final void Function(int count) onAddModule;
//   final VoidCallback onDelete;
//   const _CourseCard({
//     required this.course,
//     required this.onAddModule,
//     required this.onDelete});
//   @override
//   State<_CourseCard> createState() => _CourseCardState();
// }

// class _CourseCardState extends State<_CourseCard> {
//   List<CourseModule> _modules = [];
//   bool _expanded = false;
//   bool _loadingModules = false;

//   Future<void> _loadModules() async {
//     setState(() => _loadingModules = true);
//     _modules = await ApiService.getModules(widget.course.id);
//     if (mounted) setState(() => _loadingModules = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [BoxShadow(
//           color: Colors.black.withOpacity(0.05),
//           blurRadius: 10, offset: const Offset(0, 2))],
//         border: const Border(
//           left: BorderSide(color: _blue, width: 5),
//           right: BorderSide(color: _border),
//           top: BorderSide(color: _border),
//           bottom: BorderSide(color: _border))),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             Row(children: [
//               Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                 Text(widget.course.title,
//                   style: const TextStyle(fontSize: 15,
//                     fontWeight: FontWeight.w700, color: _text)),
//                 const SizedBox(height: 3),
//                 Text('by ${widget.course.facilitatorName}',
//                   style: const TextStyle(fontSize: 11, color: _sub)),
//               ])),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                 decoration: BoxDecoration(
//                   color: _pLight, borderRadius: BorderRadius.circular(20)),
//                 child: const Text('Active',
//                   style: TextStyle(fontSize: 10,
//                     fontWeight: FontWeight.w700, color: _blue))),
//             ]),
//             const SizedBox(height: 12),
//             Row(children: [
//               Expanded(child: SizedBox(height: 36,
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(backgroundColor: _blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20))),
//                   onPressed: () => widget.onAddModule(_modules.length),
//                   icon: const Icon(Icons.add, size: 14, color: Colors.white),
//                   label: const Text('Add Module',
//                     style: TextStyle(fontSize: 12,
//                       fontWeight: FontWeight.w700, color: Colors.white))))),
//               const SizedBox(width: 8),
//               Expanded(child: SizedBox(height: 36,
//                 child: OutlinedButton.icon(
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: _blue),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20))),
//                   onPressed: () async {
//                     setState(() => _expanded = !_expanded);
//                     if (_expanded && _modules.isEmpty) await _loadModules();
//                   },
//                   icon: Icon(
//                     _expanded ? Icons.expand_less : Icons.expand_more,
//                     size: 14, color: _blue),
//                   label: Text('Modules (${_modules.length})',
//                     style: const TextStyle(fontSize: 12,
//                       fontWeight: FontWeight.w700, color: _blue))))),
//             ]),
//           ])),
//         if (_expanded) ...[
//           const Divider(height: 1, color: _border),
//           if (_loadingModules)
//             const Padding(padding: EdgeInsets.all(16),
//               child: Center(child: CircularProgressIndicator(color: _blue)))
//           else if (_modules.isEmpty)
//             Padding(padding: const EdgeInsets.all(16),
//               child: Column(children: [
//                 const Text('📭 No modules yet',
//                   style: TextStyle(color: _sub, fontSize: 13)),
//                 const SizedBox(height: 8),
//                 ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(backgroundColor: _blue,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20))),
//                   onPressed: () => widget.onAddModule(0),
//                   icon: const Icon(Icons.add, size: 14, color: Colors.white),
//                   label: const Text('Add First Module',
//                     style: TextStyle(fontSize: 12, color: Colors.white,
//                       fontWeight: FontWeight.w700))),
//               ]))
//           else
//             Column(children: [
//               ..._modules.map((m) => _ModuleTile(
//                 module: m,
//                 index: _modules.indexOf(m) + 1)),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
//                 child: SizedBox(width: double.infinity,
//                   child: OutlinedButton.icon(
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: _blue),
//                       padding: const EdgeInsets.symmetric(vertical: 10),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10))),
//                     onPressed: () => widget.onAddModule(_modules.length),
//                     icon: const Icon(Icons.add_circle_outline,
//                       size: 16, color: _blue),
//                     label: const Text('Add Another Module',
//                       style: TextStyle(fontSize: 13, color: _blue,
//                         fontWeight: FontWeight.w700))))),
//             ]),
//         ],
//         Padding(
//           padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
//           child: GestureDetector(
//             onTap: widget.onDelete,
//             child: const Text('Delete course',
//               style: TextStyle(fontSize: 11, color: _sub,
//                 decoration: TextDecoration.underline)))),
//       ]));
//   }
// }

// // ── Module tile ───────────────────────────────────────────────
// class _ModuleTile extends StatelessWidget {
//   final CourseModule module;
//   final int index;
//   const _ModuleTile({required this.module, required this.index});

//   @override
//   Widget build(BuildContext context) {
//     final hasPdf   = module.pdfLink.isNotEmpty;
//     final hasVideo = module.videoLink.isNotEmpty;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: const BoxDecoration(
//         border: Border(top: BorderSide(color: _border))),
//       child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Container(width: 32, height: 32,
//           decoration: BoxDecoration(
//             color: _pLight, borderRadius: BorderRadius.circular(8)),
//           child: Center(child: Text('$index',
//             style: const TextStyle(
//               fontWeight: FontWeight.w800, color: _blue, fontSize: 13)))),
//         const SizedBox(width: 12),
//         Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//           Text(module.title,
//             style: const TextStyle(
//               fontSize: 13, fontWeight: FontWeight.w700, color: _text)),
//           if (module.description.isNotEmpty) ...[
//             const SizedBox(height: 2),
//             Text(module.description,
//               maxLines: 2, overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontSize: 11, color: _sub)),
//           ],
//           const SizedBox(height: 6),
//           Row(children: [
//             if (hasPdf) _Badge(Icons.picture_as_pdf, 'PDF', _orange),
//             if (hasPdf && hasVideo) const SizedBox(width: 6),
//             if (hasVideo) _Badge(Icons.play_circle_outline, 'Video', Colors.red),
//             if (!hasPdf && !hasVideo)
//               const Text('No attachments',
//                 style: TextStyle(fontSize: 10, color: _sub)),
//           ]),
//         ])),
//       ]));
//   }
// }

// // ── Badge ─────────────────────────────────────────────────────
// class _Badge extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final Color color;
//   const _Badge(this.icon, this.label, this.color);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.3))),
//       child: Row(mainAxisSize: MainAxisSize.min, children: [
//         Icon(icon, size: 11, color: color),
//         const SizedBox(width: 4),
//         Text(label,
//           style: TextStyle(
//             fontSize: 10, color: color, fontWeight: FontWeight.w700)),
//       ]));
//   }
// }