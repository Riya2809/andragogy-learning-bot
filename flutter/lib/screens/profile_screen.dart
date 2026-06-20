import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/app_theme.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _user;
  bool _loading = true;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final user = await ApiService.getUserData();
    if (mounted) setState(() { _user = user; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final name  = _user?['name']  ?? 'Facilitator';
    final email = _user?['email'] ?? '';
    final phone = _user?['phone_number'] ?? '';
    final initials = name.isNotEmpty
      ? name.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
      : 'F';

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context)),
        title: const Text('Profile', style: TextStyle(
          fontSize: 18, fontWeight: FontWeight.w800,
          color: AppColors.textPrimary)),
        bottom: const PreferredSize(preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.border))),
      body: _loading
        ? const Center(child: CircularProgressIndicator(
            color: AppColors.primary))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(children: [

              // ── Avatar ────────────────────────────────────────
              const SizedBox(height: 10),
              CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.primary,
                child: Text(initials, style: const TextStyle(
                  color: Colors.white, fontSize: 28,
                  fontWeight: FontWeight.w800))),
              const SizedBox(height: 14),
              Text(name, style: const TextStyle(fontSize: 20,
                fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(20)),
                child: const Text('Facilitator',
                  style: TextStyle(fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary))),
              const SizedBox(height: 28),

              // ── Info card ─────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: const Border.fromBorderSide(
                    BorderSide(color: AppColors.border))),
                child: Column(children: [
                  _infoRow(Icons.email_outlined, 'Email', email),
                  const Divider(height: 1, color: AppColors.border,
                    indent: 56),
                  _infoRow(Icons.phone_outlined, 'Phone',
                    phone.isNotEmpty ? phone : 'Not set'),
                  const Divider(height: 1, color: AppColors.border,
                    indent: 56),
                  _infoRow(Icons.shield_outlined, 'Role', 'Facilitator'),
                ])),
              const SizedBox(height: 20),

              // ── App info ──────────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: const Border.fromBorderSide(
                    BorderSide(color: AppColors.border))),
                child: Column(children: [
                  _infoRow(Icons.info_outline_rounded,
                    'App', 'Andragogy v1.0'),
                  const Divider(height: 1, color: AppColors.border,
                    indent: 56),
                  _infoRow(Icons.storage_outlined,
                    'Backend', 'MongoDB Atlas'),
                  const Divider(height: 1, color: AppColors.border,
                    indent: 56),
                  _infoRow(Icons.chat_outlined,
                    'Channel', 'WhatsApp Bot'),
                ])),
              const SizedBox(height: 28),

              // ── Logout ────────────────────────────────────────
              SizedBox(width: double.infinity, height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: Colors.red.shade200))),
                  onPressed: () async {
                    await ApiService.clearToken();
                    if (!mounted) return;
                    Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen()),
                      (_) => false);
                  },
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: const Text('Sign Out',
                    style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.w700)))),
              const SizedBox(height: 20),
            ])));
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(children: [
        Container(width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.primary, size: 18)),
        const SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: const TextStyle(fontSize: 11,
            color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          Text(value, style: const TextStyle(fontSize: 14,
            fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ])),
      ]));
  }
}