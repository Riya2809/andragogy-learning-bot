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

// class DeadlineSchedulerWidget extends StatefulWidget {
//   final List<Course> courses;
//   const DeadlineSchedulerWidget({super.key, required this.courses});

//   @override
//   State<DeadlineSchedulerWidget> createState() => _DeadlineSchedulerState();
// }

// class _DeadlineSchedulerState extends State<DeadlineSchedulerWidget> {
//   List<dynamic> _deadlines = [];
//   bool _loading = true;
//   bool _creating = false;

//   // form state
//   String? _selectedCourseId;
//   String _titleCtrl = '';
//   DateTime? _selectedDate;
//   bool _remind24h = true;
//   bool _remind1h  = true;

//   @override
//   void initState() { super.initState(); _load(); }

//   Future<void> _load() async {
//     setState(() => _loading = true);
//     try {
//       final r = await ApiService.get('/deadlines');
//       setState(() => _deadlines = r['data'] ?? []);
//     } catch (_) {}
//     setState(() => _loading = false);
//   }

//   Future<void> _pickDate() async {
//     final now  = DateTime.now();
//     final date = await showDatePicker(
//       context: context,
//       initialDate: now.add(const Duration(days: 3)),
//       firstDate: now,
//       lastDate: now.add(const Duration(days: 365)),
//       builder: (ctx, child) => Theme(
//         data: Theme.of(ctx).copyWith(
//           colorScheme: const ColorScheme.light(primary: _blue)),
//         child: child!));
//     if (date == null || !mounted) return;
//     final time = await showTimePicker(
//       context: context, initialTime: const TimeOfDay(hour: 23, minute: 59));
//     if (time == null || !mounted) return;
//     setState(() => _selectedDate = DateTime(
//       date.year, date.month, date.day, time.hour, time.minute));
//   }

//   Future<void> _create() async {
//     if (_selectedCourseId == null || _titleCtrl.isEmpty || _selectedDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Please fill all fields'), backgroundColor: _orange,
//         behavior: SnackBarBehavior.floating));
//       return;
//     }
//     setState(() => _creating = true);
//     try {
//       await ApiService.post('/deadlines', {
//         'course_id':    _selectedCourseId,
//         'title':        _titleCtrl,
//         'deadline_date': _selectedDate!.toIso8601String(),
//         'reminder_24h': _remind24h,
//         'reminder_1h':  _remind1h,
//       });
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('✅ Deadline scheduled! Reminders will auto-send.'),
//           backgroundColor: _green, behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))));
//         setState(() {
//           _selectedCourseId = null; _titleCtrl = ''; _selectedDate = null;
//           _remind24h = true; _remind1h = true;
//         });
//         _load();
//       }
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Error: $e'), backgroundColor: _orange, behavior: SnackBarBehavior.floating));
//     }
//     if (mounted) setState(() => _creating = false);
//   }

//   Future<void> _delete(String id) async {
//     try {
//       await ApiService.delete('/deadlines/$id');
//       _load();
//     } catch (_) {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         // ── Create deadline card ───────────────────────────
//         Container(
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//             border: const Border.fromBorderSide(BorderSide(color: _border))),
//           child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             const Row(children: [
//               Icon(Icons.alarm_add_rounded, color: _blue, size: 22),
//               SizedBox(width: 8),
//               Text('Schedule a Deadline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _text)),
//             ]),
//             const SizedBox(height: 4),
//             const Text('Set a deadline and auto-send WhatsApp reminders to learners.',
//               style: TextStyle(fontSize: 12, color: _sub)),
//             const SizedBox(height: 16),

//             // Course selector
//             DropdownButtonFormField<String>(
//               value: _selectedCourseId,
//               hint: const Text('Select Course *'),
//               decoration: _dropDeco('Course', Icons.menu_book_outlined),
//               items: widget.courses.map((c) =>
//                 DropdownMenuItem(value: c.id, child: Text(c.title, overflow: TextOverflow.ellipsis))).toList(),
//               onChanged: (v) => setState(() => _selectedCourseId = v)),
//             const SizedBox(height: 12),

//             // Deadline title
//             TextFormField(
//               initialValue: _titleCtrl,
//               decoration: _inputDeco('Deadline Title *', Icons.edit_outlined,
//                 hint: 'e.g. SEO Module Quiz Deadline'),
//               onChanged: (v) => _titleCtrl = v),
//             const SizedBox(height: 12),

//             // Date/time picker
//             GestureDetector(
//               onTap: _pickDate,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//                 decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
//                   border: const Border.fromBorderSide(BorderSide(color: _border))),
//                 child: Row(children: [
//                   const Icon(Icons.calendar_today_outlined, color: _sub, size: 20),
//                   const SizedBox(width: 12),
//                   Expanded(child: Text(
//                     _selectedDate == null
//                       ? 'Select Deadline Date & Time *'
//                       : _formatDate(_selectedDate!),
//                     style: TextStyle(fontSize: 14,
//                       color: _selectedDate == null ? _sub : _text,
//                       fontWeight: _selectedDate == null ? FontWeight.normal : FontWeight.w600))),
//                   const Icon(Icons.chevron_right, color: _sub),
//                 ]))),
//             const SizedBox(height: 14),

//             // Reminder toggles
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(10)),
//               child: Column(children: [
//                 Row(children: [
//                   const Icon(Icons.notifications_active_outlined, color: _amber, size: 18),
//                   const SizedBox(width: 8),
//                   const Text('Auto Reminders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _text)),
//                 ]),
//                 const SizedBox(height: 10),
//                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                   const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                     Text('24 hours before', style: TextStyle(fontSize: 13, color: _text)),
//                     Text('Sent to learners who haven\'t submitted', style: TextStyle(fontSize: 10, color: _sub)),
//                   ]),
//                   Switch.adaptive(value: _remind24h, activeColor: _blue,
//                     onChanged: (v) => setState(() => _remind24h = v)),
//                 ]),
//                 const Divider(color: _border),
//                 Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                   const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//                     Text('1 hour before', style: TextStyle(fontSize: 13, color: _text)),
//                     Text('Final reminder before deadline', style: TextStyle(fontSize: 10, color: _sub)),
//                   ]),
//                   Switch.adaptive(value: _remind1h, activeColor: _blue,
//                     onChanged: (v) => setState(() => _remind1h = v)),
//                 ]),
//               ])),
//             const SizedBox(height: 16),

//             // Schedule button
//             SizedBox(width: double.infinity, height: 50,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(backgroundColor: _blue,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
//                 onPressed: _creating ? null : _create,
//                 icon: _creating
//                   ? const SizedBox(width: 18, height: 18,
//                       child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                   : const Icon(Icons.alarm_on_rounded, color: Colors.white),
//                 label: Text(_creating ? 'Scheduling...' : 'Schedule Deadline',
//                   style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)))),
//           ])),

//         // ── Existing deadlines ─────────────────────────────
//         const SizedBox(height: 20),
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           const Text('Scheduled Deadlines',
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _text)),
//           IconButton(icon: const Icon(Icons.refresh, color: _blue, size: 20), onPressed: _load),
//         ]),
//         const SizedBox(height: 10),

//         if (_loading)
//           const Center(child: CircularProgressIndicator(color: _blue))
//         else if (_deadlines.isEmpty)
//           Container(padding: const EdgeInsets.all(24),
//             decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
//               border: const Border.fromBorderSide(BorderSide(color: _border))),
//             child: const Center(child: Column(children: [
//               Text('⏰', style: TextStyle(fontSize: 40)),
//               SizedBox(height: 8),
//               Text('No deadlines scheduled', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _text)),
//               Text('Create one above to auto-send reminders', style: TextStyle(fontSize: 12, color: _sub)),
//             ])))
//         else
//           ..._deadlines.map((d) => _DeadlineCard(deadline: d, onDelete: () => _delete(d['id'] ?? ''))),
//       ]);
//   }

//   String _formatDate(DateTime dt) {
//     const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
//     final h = dt.hour > 12 ? dt.hour - 12 : dt.hour;
//     final ampm = dt.hour >= 12 ? 'PM' : 'AM';
//     final min = dt.minute.toString().padLeft(2, '0');
//     return '${months[dt.month-1]} ${dt.day}, ${dt.year} at $h:$min $ampm';
//   }

//   InputDecoration _inputDeco(String label, IconData icon, {String? hint}) {
//     return InputDecoration(labelText: label, hintText: hint,
//       hintStyle: const TextStyle(fontSize: 12, color: _sub),
//       prefixIcon: Icon(icon, size: 20, color: _sub),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
//       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
//       filled: true, fillColor: Colors.white);
//   }

//   InputDecoration _dropDeco(String label, IconData icon) {
//     return InputDecoration(labelText: label,
//       prefixIcon: Icon(icon, size: 20, color: _sub),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
//       enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
//       filled: true, fillColor: Colors.white);
//   }
// }

// class _DeadlineCard extends StatelessWidget {
//   final Map<String, dynamic> deadline;
//   final VoidCallback onDelete;
//   const _DeadlineCard({required this.deadline, required this.onDelete});

//   @override
//   Widget build(BuildContext context) {
//     final ddStr    = deadline['deadline_date'] as String? ?? '';
//     final dd       = ddStr.isNotEmpty ? DateTime.tryParse(ddStr) : null;
//     final isPast   = dd != null && dd.isBefore(DateTime.now());
//     final reminders= (deadline['reminders_sent'] as List?)?.length ?? 0;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white, borderRadius: BorderRadius.circular(12),
//         border: Border(
//           left: BorderSide(color: isPast ? _sub : _orange, width: 4),
//           right: const BorderSide(color: _border),
//           top: const BorderSide(color: _border),
//           bottom: const BorderSide(color: _border))),
//       child: Row(children: [
//         Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           Text(deadline['title'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _text)),
//           const SizedBox(height: 3),
//           Text(deadline['course_title'] ?? '', style: const TextStyle(fontSize: 12, color: _sub)),
//           const SizedBox(height: 6),
//           Row(children: [
//             const Icon(Icons.calendar_today, size: 12, color: _sub),
//             const SizedBox(width: 4),
//             Text(dd != null ? _fmt(dd) : 'Unknown date',
//               style: const TextStyle(fontSize: 11, color: _sub)),
//           ]),
//           if (reminders > 0) ...[
//             const SizedBox(height: 4),
//             Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//               decoration: BoxDecoration(color: _green.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
//               child: Text('$reminders reminder(s) sent',
//                 style: const TextStyle(fontSize: 10, color: _green, fontWeight: FontWeight.w700))),
//           ],
//         ])),
//         Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
//           Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: isPast ? _sub.withOpacity(0.1) : _orange.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20)),
//             child: Text(isPast ? 'Expired' : 'Active',
//               style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
//                 color: isPast ? _sub : _orange))),
//           const SizedBox(height: 8),
//           GestureDetector(
//             onTap: onDelete,
//             child: const Icon(Icons.delete_outline, color: _sub, size: 18)),
//         ]),
//       ]));
//   }

//   String _fmt(DateTime dt) {
//     const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
//     final h = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
//     final ap = dt.hour >= 12 ? 'PM' : 'AM';
//     return '${m[dt.month-1]} ${dt.day}, ${dt.year} · $h:${dt.minute.toString().padLeft(2,'0')} $ap';
//   }
// }





























import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';

const _blue   = Color(0xFF1348D4);
const _green  = Color(0xFF00875A);
const _orange = Color(0xFFFF5630);
const _amber  = Color(0xFFFF991F);
const _bg     = Color(0xFFF4F6FB);
const _border = Color(0xFFE4E9F2);
const _text   = Color(0xFF0A1628);
const _sub    = Color(0xFF6B7A99);
const _pLight = Color(0xFFE8EEFF);

class DeadlineSchedulerWidget extends StatefulWidget {
  final List<Course> courses;
  const DeadlineSchedulerWidget({super.key, required this.courses});

  @override
  State<DeadlineSchedulerWidget> createState() => _DeadlineSchedulerState();
}

class _DeadlineSchedulerState extends State<DeadlineSchedulerWidget> {
  List<dynamic> _deadlines = [];
  bool _loading = true;
  bool _creating = false;

  // form state
  String? _selectedCourseId;
  String _titleCtrl = '';
  DateTime? _selectedDate;
  bool _remind24h = true;
  bool _remind1h  = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final r = await ApiService.get('/deadlines');
      setState(() => _deadlines = r['data'] ?? []);
    } catch (_) {}
    setState(() => _loading = false);
  }

  Future<void> _pickDate() async {
    final now  = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 3)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: _blue)),
        child: child!));
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context, initialTime: const TimeOfDay(hour: 23, minute: 59));
    if (time == null || !mounted) return;
    setState(() => _selectedDate = DateTime(
      date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _create() async {
    if (_selectedCourseId == null || _titleCtrl.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all fields'), backgroundColor: _orange,
        behavior: SnackBarBehavior.floating));
      return;
    }
    setState(() => _creating = true);
    try {
      await ApiService.post('/deadlines', {
        'course_id':    _selectedCourseId,
        'title':        _titleCtrl,
        'deadline_date': _selectedDate!.toIso8601String(),
        'reminder_24h': _remind24h,
        'reminder_1h':  _remind1h,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('✅ Deadline scheduled! Reminders will auto-send.'),
          backgroundColor: _green, behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))));
        setState(() {
          _selectedCourseId = null; _titleCtrl = ''; _selectedDate = null;
          _remind24h = true; _remind1h = true;
        });
        _load();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'), backgroundColor: _orange, behavior: SnackBarBehavior.floating));
    }
    if (mounted) setState(() => _creating = false);
  }

  Future<void> _delete(String id) async {
    try {
      await ApiService.delete('/deadlines/$id');
      _load();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Create deadline card ───────────────────────────
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
            border: const Border.fromBorderSide(BorderSide(color: _border))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Row(children: [
              Icon(Icons.alarm_add_rounded, color: _blue, size: 22),
              SizedBox(width: 8),
              Text('Schedule a Deadline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _text)),
            ]),
            const SizedBox(height: 4),
            const Text('Set a deadline and auto-send WhatsApp reminders to learners.',
              style: TextStyle(fontSize: 12, color: _sub)),
            const SizedBox(height: 16),

            // Course selector
            DropdownButtonFormField<String>(
              value: _selectedCourseId,
              hint: const Text('Select Course *'),
              decoration: _dropDeco('Course', Icons.menu_book_outlined),
              items: { for (var c in widget.courses) c.id: c }.values
                .map((c) => DropdownMenuItem(value: c.id,
                  child: Text(c.title, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (v) => setState(() => _selectedCourseId = v)),
            const SizedBox(height: 12),

            // Deadline title
            TextFormField(
              initialValue: _titleCtrl,
              decoration: _inputDeco('Deadline Title *', Icons.edit_outlined,
                hint: 'e.g. SEO Module Quiz Deadline'),
              onChanged: (v) => _titleCtrl = v),
            const SizedBox(height: 12),

            // Date/time picker
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
                  border: const Border.fromBorderSide(BorderSide(color: _border))),
                child: Row(children: [
                  const Icon(Icons.calendar_today_outlined, color: _sub, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(
                    _selectedDate == null
                      ? 'Select Deadline Date & Time *'
                      : _formatDate(_selectedDate!),
                    style: TextStyle(fontSize: 14,
                      color: _selectedDate == null ? _sub : _text,
                      fontWeight: _selectedDate == null ? FontWeight.normal : FontWeight.w600))),
                  const Icon(Icons.chevron_right, color: _sub),
                ]))),
            const SizedBox(height: 14),

            // Reminder toggles
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(10)),
              child: Column(children: [
                Row(children: [
                  const Icon(Icons.notifications_active_outlined, color: _amber, size: 18),
                  const SizedBox(width: 8),
                  const Text('Auto Reminders', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _text)),
                ]),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('24 hours before', style: TextStyle(fontSize: 13, color: _text)),
                    Text('Sent to learners who haven\'t submitted', style: TextStyle(fontSize: 10, color: _sub)),
                  ]),
                  Switch.adaptive(value: _remind24h, activeColor: _blue,
                    onChanged: (v) => setState(() => _remind24h = v)),
                ]),
                const Divider(color: _border),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('1 hour before', style: TextStyle(fontSize: 13, color: _text)),
                    Text('Final reminder before deadline', style: TextStyle(fontSize: 10, color: _sub)),
                  ]),
                  Switch.adaptive(value: _remind1h, activeColor: _blue,
                    onChanged: (v) => setState(() => _remind1h = v)),
                ]),
              ])),
            const SizedBox(height: 16),

            // Schedule button
            SizedBox(width: double.infinity, height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: _blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: _creating ? null : _create,
                icon: _creating
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.alarm_on_rounded, color: Colors.white),
                label: Text(_creating ? 'Scheduling...' : 'Schedule Deadline',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)))),
          ])),

        // ── Existing deadlines ─────────────────────────────
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Scheduled Deadlines',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _text)),
          IconButton(icon: const Icon(Icons.refresh, color: _blue, size: 20), onPressed: _load),
        ]),
        const SizedBox(height: 10),

        if (_loading)
          const Center(child: CircularProgressIndicator(color: _blue))
        else if (_deadlines.isEmpty)
          Container(padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
              border: const Border.fromBorderSide(BorderSide(color: _border))),
            child: const Center(child: Column(children: [
              Text('⏰', style: TextStyle(fontSize: 40)),
              SizedBox(height: 8),
              Text('No deadlines scheduled', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _text)),
              Text('Create one above to auto-send reminders', style: TextStyle(fontSize: 12, color: _sub)),
            ])))
        else
          ..._deadlines.map((d) => _DeadlineCard(deadline: d, onDelete: () => _delete(d['id'] ?? ''))),
      ]);
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month-1]} ${dt.day}, ${dt.year} at $h:$min $ampm';
  }

  InputDecoration _inputDeco(String label, IconData icon, {String? hint}) {
    return InputDecoration(labelText: label, hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: _sub),
      prefixIcon: Icon(icon, size: 20, color: _sub),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
      filled: true, fillColor: Colors.white);
  }

  InputDecoration _dropDeco(String label, IconData icon) {
    return InputDecoration(labelText: label,
      prefixIcon: Icon(icon, size: 20, color: _sub),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _border)),
      filled: true, fillColor: Colors.white);
  }
}

class _DeadlineCard extends StatelessWidget {
  final Map<String, dynamic> deadline;
  final VoidCallback onDelete;
  const _DeadlineCard({required this.deadline, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final ddStr    = deadline['deadline_date'] as String? ?? '';
    final dd       = ddStr.isNotEmpty ? DateTime.tryParse(ddStr) : null;
    final isPast   = dd != null && dd.isBefore(DateTime.now());
    final reminders= (deadline['reminders_sent'] as List?)?.length ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: isPast ? _sub : _orange, width: 4),
          right: const BorderSide(color: _border),
          top: const BorderSide(color: _border),
          bottom: const BorderSide(color: _border))),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(deadline['title'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _text)),
          const SizedBox(height: 3),
          Text(deadline['course_title'] ?? '', style: const TextStyle(fontSize: 12, color: _sub)),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.calendar_today, size: 12, color: _sub),
            const SizedBox(width: 4),
            Text(dd != null ? _fmt(dd) : 'Unknown date',
              style: const TextStyle(fontSize: 11, color: _sub)),
          ]),
          if (reminders > 0) ...[
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: _green.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
              child: Text('$reminders reminder(s) sent',
                style: const TextStyle(fontSize: 10, color: _green, fontWeight: FontWeight.w700))),
          ],
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPast ? _sub.withOpacity(0.1) : _orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20)),
            child: Text(isPast ? 'Expired' : 'Active',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                color: isPast ? _sub : _orange))),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.delete_outline, color: _sub, size: 18)),
        ]),
      ]));
  }

  String _fmt(DateTime dt) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    final h = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final ap = dt.hour >= 12 ? 'PM' : 'AM';
    return '${m[dt.month-1]} ${dt.day}, ${dt.year} · $h:${dt.minute.toString().padLeft(2,'0')} $ap';
  }
}