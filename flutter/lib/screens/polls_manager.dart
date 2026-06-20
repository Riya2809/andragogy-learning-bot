import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/app_theme.dart';

// ── Entry point: call this from dashboard ─────────────────────
void showPollsManager(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => const _PollsManagerSheet());
}

class _PollsManagerSheet extends StatefulWidget {
  const _PollsManagerSheet();
  @override
  State<_PollsManagerSheet> createState() => _PollsManagerSheetState();
}

class _PollsManagerSheetState extends State<_PollsManagerSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override
  void initState() { super.initState(); _tab = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92, maxChildSize: 0.97, minChildSize: 0.5,
      expand: false,
      builder: (_, ctrl) => Column(children: [
        // ── Header ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 12, 0),
          child: Row(children: [
            const Text('📊', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            const Expanded(child: Text('Polls',
              style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.w800, color: AppColors.textPrimary))),
            IconButton(icon: const Icon(Icons.close, color: AppColors.textSecondary),
              onPressed: () => Navigator.pop(context)),
          ])),

        // ── Tabs ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.bg, borderRadius: BorderRadius.circular(10),
              border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
            child: TabBar(
              controller: _tab,
              indicator: BoxDecoration(
                color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(fontSize: 13),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              tabs: const [
                Tab(text: '✏️  Create Poll'),
                Tab(text: '📈  Results'),
              ]))),

        const Divider(height: 1, color: AppColors.border),

        // ── Tab views ─────────────────────────────────────────
        Expanded(child: TabBarView(
          controller: _tab,
          children: [
            _CreatePollTab(onCreated: () => _tab.animateTo(1)),
            _PollResultsTab(),
          ])),
      ]));
  }
}

// ══════════════════════════════════════════════════════════════
// TAB 1 — Create Poll
// ══════════════════════════════════════════════════════════════
class _CreatePollTab extends StatefulWidget {
  final VoidCallback onCreated;
  const _CreatePollTab({required this.onCreated});
  @override
  State<_CreatePollTab> createState() => _CreatePollTabState();
}

class _CreatePollTabState extends State<_CreatePollTab> {
  final _questionCtrl = TextEditingController();
  final List<TextEditingController> _optionCtrls = [
    TextEditingController(), TextEditingController()];
  bool _multiSelect = false;
  bool _sending = false;

  bool get _canSend =>
    _questionCtrl.text.trim().isNotEmpty &&
    _optionCtrls.every((c) => c.text.trim().isNotEmpty);

  void _snack(String msg, Color color) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg), backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(12)));

  Future<void> _send() async {
    setState(() => _sending = true);
    try {
      await ApiService.post('/polls', {
        'question': _questionCtrl.text.trim(),
        'options': _optionCtrls.map((c) => c.text.trim())
          .where((t) => t.isNotEmpty).toList(),
        'multi_select': _multiSelect,
      });
      // Reset form
      _questionCtrl.clear();
      for (final c in _optionCtrls) c.clear();
      setState(() { _multiSelect = false; _sending = false; });
      _snack('✅ Poll sent to all learners!', AppColors.green);
      widget.onCreated(); // switch to Results tab
    } catch (_) {
      if (mounted) setState(() => _sending = false);
      _snack('Failed to send poll', AppColors.orange);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, children: [

        // Question input
        const Text('Question', style: TextStyle(fontSize: 13,
          fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        TextField(
          controller: _questionCtrl,
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'e.g. Which topic should we cover next?',
            hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
            filled: true, fillColor: AppColors.bg,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
            contentPadding: const EdgeInsets.all(14))),
        const SizedBox(height: 20),

        // Options
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Options', style: TextStyle(fontSize: 13,
            fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          if (_optionCtrls.length < 6)
            GestureDetector(
              onTap: () => setState(() =>
                _optionCtrls.add(TextEditingController())),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.add_rounded, size: 14, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text('Add Option', style: TextStyle(fontSize: 11,
                    fontWeight: FontWeight.w700, color: AppColors.primary)),
                ]))),
        ]),
        const SizedBox(height: 10),

        ..._optionCtrls.asMap().entries.map((e) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(children: [
            Container(width: 30, height: 30,
              decoration: BoxDecoration(color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text(
                String.fromCharCode(65 + e.key),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800,
                  color: AppColors.primary)))),
            const SizedBox(width: 10),
            Expanded(child: TextField(
              controller: e.value,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Option ${String.fromCharCode(65 + e.key)}',
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                filled: true, fillColor: Colors.white,
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12)))),
            if (_optionCtrls.length > 2) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => setState(() => _optionCtrls.removeAt(e.key)),
                child: const Icon(Icons.remove_circle_outline,
                  color: AppColors.textSecondary, size: 20)),
            ],
          ]))),
        const SizedBox(height: 8),

        // Multi-select toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(color: AppColors.bg,
            borderRadius: BorderRadius.circular(12),
            border: const Border.fromBorderSide(BorderSide(color: AppColors.border))),
          child: Row(children: [
            const Icon(Icons.check_box_outlined, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            const Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Allow multiple selections', style: TextStyle(fontSize: 13,
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text('Learners can pick more than one option',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ])),
            Switch.adaptive(value: _multiSelect, activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _multiSelect = v)),
          ])),
        const SizedBox(height: 24),

        // Send button
        SizedBox(width: double.infinity, height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _canSend ? AppColors.primary : AppColors.border,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0),
            onPressed: (_canSend && !_sending) ? _send : null,
            icon: _sending
              ? const SizedBox(width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
            label: Text(_sending ? 'Sending...' : 'Send Poll to All Learners',
              style: const TextStyle(color: Colors.white,
                fontSize: 15, fontWeight: FontWeight.w700)))),
        const SizedBox(height: 8),
      ]));
  }
}

// ══════════════════════════════════════════════════════════════
// TAB 2 — Results
// ══════════════════════════════════════════════════════════════
class _PollResultsTab extends StatefulWidget {
  @override
  State<_PollResultsTab> createState() => _PollResultsTabState();
}

class _PollResultsTabState extends State<_PollResultsTab> {
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

  Future<void> _delete(String id) async {
    try {
      await ApiService.delete('/polls/$id');
      _load();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(
      child: CircularProgressIndicator(color: AppColors.primary));

    if (_polls.isEmpty) return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('📊', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        const Text('No polls yet', style: TextStyle(fontSize: 16,
          fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        const SizedBox(height: 6),
        const Text('Create your first poll in the Create tab',
          style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        TextButton.icon(onPressed: _load,
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Refresh')),
      ]));

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _polls.length,
        itemBuilder: (_, i) {
          final poll    = _polls[i] as Map<String, dynamic>;
          final options = (poll['options'] as List? ?? []);
          final counts  = (poll['counts'] as Map? ?? {});
          final total   = (poll['response_count'] ?? 0) as int;
          final maxCount = counts.values.fold(0,
            (int a, b) => (b as int) > a ? b : a);

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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

                // Question row
                Row(children: [
                  const Text('📊', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(poll['question'] ?? '',
                    style: const TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary))),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: total > 0
                        ? AppColors.greenLight : AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20)),
                    child: Text('$total vote${total == 1 ? '' : 's'}',
                      style: TextStyle(fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: total > 0
                          ? AppColors.green : AppColors.primary))),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _delete(poll['id'] ?? ''),
                    child: const Icon(Icons.delete_outline,
                      size: 18, color: AppColors.textSecondary)),
                ]),
                const SizedBox(height: 14),

                // Results bars
                if (total == 0)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.bg,
                      borderRadius: BorderRadius.circular(8)),
                    child: const Center(child: Text('No responses yet',
                      style: TextStyle(fontSize: 12,
                        color: AppColors.textSecondary))))
                else
                  ...options.map((opt) {
                    final c = (counts[opt] ?? 0) as int;
                    final pct = total > 0 ? c / total : 0.0;
                    final isWinner = c == maxCount && c > 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, children: [
                        Row(children: [
                          if (isWinner) const Text('🏆 ',
                            style: TextStyle(fontSize: 12)),
                          Expanded(child: Text(opt.toString(),
                            style: TextStyle(fontSize: 13,
                              fontWeight: isWinner
                                ? FontWeight.w700 : FontWeight.normal,
                              color: isWinner
                                ? AppColors.primary : AppColors.textPrimary))),
                          Text(
                            '$c  ·  ${(pct * 100).toStringAsFixed(1)}%',
                            style: TextStyle(fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isWinner
                                ? AppColors.primary : AppColors.textSecondary)),
                        ]),
                        const SizedBox(height: 5),
                        ClipRRect(borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: pct.toDouble(), minHeight: 12,
                            backgroundColor: AppColors.primaryLight,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isWinner ? AppColors.primary
                                : const Color(0xFF9BA8BF)))),
                      ]));
                  }),

                // Footer
                const SizedBox(height: 4),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: poll['multi_select'] == true
                        ? AppColors.amberLight : AppColors.bg,
                      borderRadius: BorderRadius.circular(20),
                      border: const Border.fromBorderSide(
                        BorderSide(color: AppColors.border))),
                    child: Text(
                      poll['multi_select'] == true
                        ? 'Multi-select' : 'Single choice',
                      style: TextStyle(fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: poll['multi_select'] == true
                          ? AppColors.amber : AppColors.textSecondary))),
                  const Spacer(),
                  Text('by ${poll['created_by'] ?? 'Facilitator'}',
                    style: const TextStyle(fontSize: 10,
                      color: AppColors.textSecondary)),
                ]),
              ])));
        }));
  }
}