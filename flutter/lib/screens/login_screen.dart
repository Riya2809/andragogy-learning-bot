

// import 'package:flutter/material.dart';
// import '../services/api_service.dart';
// import '../services/app_theme.dart';
// import 'dashboard_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   final _formKey   = GlobalKey<FormState>();
//   final _emailCtrl = TextEditingController();
//   final _passCtrl  = TextEditingController();
//   final _nameCtrl  = TextEditingController();
//   final _orgCtrl   = TextEditingController();
//   final _phoneCtrl = TextEditingController();

//   bool _obscure    = true;
//   bool _loading    = false;
//   bool _isRegister = false;

//   late AnimationController _animCtrl;
//   late Animation<double>   _fadeAnim;
//   late Animation<Offset>   _slideAnim;

//   @override
//   void initState() {
//     super.initState();
//     _animCtrl = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 600));
//     _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
//     _slideAnim = Tween<Offset>(
//             begin: const Offset(0, 0.06), end: Offset.zero)
//         .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
//     _animCtrl.forward();
//   }

//   @override
//   void dispose() {
//     _animCtrl.dispose();
//     _emailCtrl.dispose();
//     _passCtrl.dispose();
//     _nameCtrl.dispose();
//     _orgCtrl.dispose();
//     _phoneCtrl.dispose();
//     super.dispose();
//   }

//   void _toggleMode() {
//     _animCtrl.reverse().then((_) {
//       setState(() => _isRegister = !_isRegister);
//       _animCtrl.forward();
//     });
//   }

//   Future<void> _submit() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _loading = true);
//     try {
//       Map<String, dynamic> result;
//       if (_isRegister) {
//         result = await ApiService.register(
//           _nameCtrl.text.trim(),
//           _emailCtrl.text.trim(),
//           _phoneCtrl.text.trim(),
//           _passCtrl.text,
//         );
//       } else {
//         result = await ApiService.login(
//             _emailCtrl.text.trim(), _passCtrl.text);
//       }
//       if (!mounted) return;
//       if (result['success'] == true) {
//         Navigator.pushReplacement(
//           context,
//           PageRouteBuilder(
//             pageBuilder: (_, __, ___) => const DashboardScreen(),
//             transitionsBuilder: (_, anim, __, child) =>
//                 FadeTransition(opacity: anim, child: child),
//             transitionDuration: const Duration(milliseconds: 400),
//           ),
//         );
//       } else {
//         final msg = result['message'] ??
//             result['errors']?[0]?['msg'] ??
//             'Authentication failed';
//         _showError(msg);
//       }
//     } catch (e) {
//       if (!mounted) return;
//       _showError('Connection error. Check your network.');
//     } finally {
//       if (mounted) setState(() => _loading = false);
//     }
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Row(children: [
//         const Icon(Icons.error_outline_rounded,
//             color: Colors.white, size: 16),
//         const SizedBox(width: 8),
//         Expanded(child: Text(msg)),
//       ]),
//       backgroundColor: AppColors.orange,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       margin: const EdgeInsets.all(12),
//     ));
//   }

//   // ─── Input decoration ──────────────────────────────────────────────────────
//   InputDecoration _inputDec(String hint, IconData icon,
//       {Widget? suffix}) =>
//       InputDecoration(
//         hintText: hint,
//         hintStyle: const TextStyle(
//             fontSize: 13, color: AppColors.textSecondary),
//         prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
//         suffixIcon: suffix,
//         filled: true,
//         fillColor: const Color(0xFFF7F8FC),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: AppColors.border)),
//         enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: AppColors.border)),
//         focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide:
//                 const BorderSide(color: AppColors.primary, width: 1.5)),
//         errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide:
//                 const BorderSide(color: AppColors.orange, width: 1.2)),
//         focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide:
//                 const BorderSide(color: AppColors.orange, width: 1.5)),
//       );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F2FF),
//       body: Stack(children: [
//         // ── Background decorations ──────────────────────────────────────
//         Positioned(
//           top: -80, right: -60,
//           child: Container(
//             width: 260, height: 260,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: AppColors.primary.withOpacity(0.07),
//             ),
//           ),
//         ),
//         Positioned(
//           bottom: -100, left: -80,
//           child: Container(
//             width: 320, height: 320,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: const Color(0xFF4B3FD8).withOpacity(0.05),
//             ),
//           ),
//         ),

//         // ── Main content ────────────────────────────────────────────────
//         SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(
//                   horizontal: 24, vertical: 24),
//               child: FadeTransition(
//                 opacity: _fadeAnim,
//                 child: SlideTransition(
//                   position: _slideAnim,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       // ── Brand header ──────────────────────────────
//                       _buildBrandHeader(),
//                       const SizedBox(height: 28),

//                       // ── Form card ─────────────────────────────────
//                       _buildFormCard(),
//                       const SizedBox(height: 20),

//                       // ── Footer ────────────────────────────────────
//                       _buildFooter(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ]),
//     );
//   }

//   // ── Brand header ────────────────────────────────────────────────────────────
//   Widget _buildBrandHeader() {
//     return Column(children: [
//       // Logo mark
//       Container(
//         width: 72, height: 72,
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [Color(0xFF1348D4), Color(0xFF4B3FD8)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//                 color: AppColors.primary.withOpacity(0.35),
//                 blurRadius: 20,
//                 offset: const Offset(0, 8)),
//           ],
//         ),
//         child: const Center(
//             child: Text('🎓',
//                 style: TextStyle(fontSize: 34))),
//       ),
//       const SizedBox(height: 16),
//       const Text('Andragogy',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.w900,
//               color: AppColors.primaryDark,
//               letterSpacing: -1.2,
//               height: 1.1)),
//       const SizedBox(height: 5),
//       const Text('Facilitator Dashboard',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//               fontSize: 13,
//               color: AppColors.textSecondary,
//               fontWeight: FontWeight.w500,
//               letterSpacing: 0.2)),
//       const SizedBox(height: 14),

//       // Badge
//       Container(
//         padding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//               colors: [Color(0xFF1A5C38), Color(0xFF00875A)]),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//                 color: const Color(0xFF1A5C38).withOpacity(0.3),
//                 blurRadius: 8,
//                 offset: const Offset(0, 3)),
//           ],
//         ),
//         child: const Row(mainAxisSize: MainAxisSize.min, children: [
//           Text('💬', style: TextStyle(fontSize: 12)),
//           SizedBox(width: 6),
//           Text('WhatsApp-Powered Adult Learning',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700)),
//         ]),
//       ),
//     ]);
//   }

//   // ── Form card ────────────────────────────────────────────────────────────────
//   Widget _buildFormCard() {
//     return Container(
//       padding: const EdgeInsets.all(28),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(24),
//         boxShadow: [
//           BoxShadow(
//               color: AppColors.primary.withOpacity(0.08),
//               blurRadius: 40,
//               offset: const Offset(0, 10)),
//           BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 8,
//               offset: const Offset(0, 2)),
//         ],
//       ),
//       child: Form(
//         key: _formKey,
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//           // Card header
//           Row(children: [
//             Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                 Text(
//                   _isRegister ? 'Create Account' : 'Welcome back',
//                   style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w900,
//                       color: AppColors.textPrimary,
//                       letterSpacing: -0.5),
//                 ),
//                 const SizedBox(height: 3),
//                 Text(
//                   _isRegister
//                       ? 'Set up your facilitator profile'
//                       : 'Sign in to manage your learners',
//                   style: const TextStyle(
//                       fontSize: 12,
//                       color: AppColors.textSecondary),
//                 ),
//               ]),
//             ),
//             Container(
//               width: 42, height: 42,
//               decoration: BoxDecoration(
//                   color: AppColors.primaryLight,
//                   borderRadius: BorderRadius.circular(12)),
//               child: Icon(
//                 _isRegister
//                     ? Icons.person_add_rounded
//                     : Icons.login_rounded,
//                 color: AppColors.primary,
//                 size: 20,
//               ),
//             ),
//           ]),

//           const SizedBox(height: 24),

//           // ── Register extra fields ────────────────────────────────
//           if (_isRegister) ...[
//             // Full name
//             TextFormField(
//               controller: _nameCtrl,
//               textCapitalization: TextCapitalization.words,
//               decoration:
//                   _inputDec('Full name', Icons.person_outline_rounded),
//               validator: (v) =>
//                   v!.trim().isEmpty ? 'Enter your full name' : null,
//             ),
//             const SizedBox(height: 12),

//             // Organisation
//             TextFormField(
//               controller: _orgCtrl,
//               textCapitalization: TextCapitalization.words,
//               decoration: _inputDec(
//                   'Organisation / Company', Icons.business_rounded),
//             ),
//             const SizedBox(height: 12),

//             // Phone
//             TextFormField(
//               controller: _phoneCtrl,
//               keyboardType: TextInputType.phone,
//               decoration:
//                   _inputDec('WhatsApp number', Icons.phone_rounded),
//               validator: (v) =>
//                   v!.trim().isEmpty ? 'Enter your phone number' : null,
//             ),
//             const SizedBox(height: 12),
//           ],

//           // Email
//           TextFormField(
//             controller: _emailCtrl,
//             keyboardType: TextInputType.emailAddress,
//             decoration:
//                 _inputDec('Work email address', Icons.email_outlined),
//             validator: (v) {
//               if (v!.trim().isEmpty) return 'Enter your email';
//               if (!v.contains('@')) return 'Enter a valid email';
//               return null;
//             },
//           ),
//           const SizedBox(height: 12),

//           // Password
//           TextFormField(
//             controller: _passCtrl,
//             obscureText: _obscure,
//             decoration: _inputDec(
//               'Password',
//               Icons.lock_outline_rounded,
//               suffix: IconButton(
//                 icon: Icon(
//                   _obscure
//                       ? Icons.visibility_off_outlined
//                       : Icons.visibility_outlined,
//                   size: 18,
//                   color: AppColors.textSecondary,
//                 ),
//                 onPressed: () =>
//                     setState(() => _obscure = !_obscure),
//               ),
//             ),
//             validator: (v) =>
//                 v!.length < 6 ? 'Minimum 6 characters' : null,
//           ),

//           const SizedBox(height: 24),

//           // ── Submit button ────────────────────────────────────────
//           SizedBox(
//             height: 52,
//             child: ElevatedButton(
//               onPressed: _loading ? null : _submit,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//                 disabledBackgroundColor:
//                     AppColors.primary.withOpacity(0.5),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14)),
//                 elevation: _loading ? 0 : 3,
//                 shadowColor:
//                     AppColors.primary.withOpacity(0.4),
//               ),
//               child: _loading
//                   ? const SizedBox(
//                       width: 22, height: 22,
//                       child: CircularProgressIndicator(
//                           strokeWidth: 2.5,
//                           color: Colors.white))
//                   : Row(
//                       mainAxisAlignment:
//                           MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           _isRegister
//                               ? 'Create Account'
//                               : 'Sign In',
//                           style: const TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: 0.2),
//                         ),
//                         const SizedBox(width: 8),
//                         const Icon(Icons.arrow_forward_rounded,
//                             size: 18),
//                       ],
//                     ),
//             ),
//           ),

//           const SizedBox(height: 16),

//           // ── Divider ──────────────────────────────────────────────
//           Row(children: [
//             const Expanded(
//                 child: Divider(color: AppColors.border)),
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 12),
//               child: Text(
//                 _isRegister
//                     ? 'Already have an account?'
//                     : 'New facilitator?',
//                 style: const TextStyle(
//                     fontSize: 11,
//                     color: AppColors.textSecondary),
//               ),
//             ),
//             const Expanded(
//                 child: Divider(color: AppColors.border)),
//           ]),

//           const SizedBox(height: 14),

//           // ── Toggle mode button ───────────────────────────────────
//           SizedBox(
//             height: 46,
//             child: OutlinedButton(
//               onPressed: _loading ? null : _toggleMode,
//               style: OutlinedButton.styleFrom(
//                 foregroundColor: AppColors.primary,
//                 side: const BorderSide(
//                     color: AppColors.primary, width: 1.5),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14)),
//               ),
//               child: Text(
//                 _isRegister
//                     ? 'Sign In Instead'
//                     : 'Create New Account',
//                 style: const TextStyle(
//                     fontSize: 13, fontWeight: FontWeight.w700),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }

//   // ── Footer ───────────────────────────────────────────────────────────────────
//   Widget _buildFooter() {
//     return Column(children: [
//       // Trust badges
//       Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           _trustBadge(Icons.lock_rounded, 'Secure'),
//           const SizedBox(width: 20),
//           _trustBadge(Icons.verified_rounded, 'Verified'),
//           const SizedBox(width: 20),
//           _trustBadge(Icons.support_agent_rounded, 'Support'),
//         ],
//       ),
//       const SizedBox(height: 16),
//       const Text(
//         'Andragogy  ·  Adult Learning Platform  ·  v2.0',
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
//       ),
//       const SizedBox(height: 4),
//       const Text(
//         'Built for facilitators who care about real impact.',
//         textAlign: TextAlign.center,
//         style: TextStyle(
//             fontSize: 10,
//             color: AppColors.textSecondary,
//             fontStyle: FontStyle.italic),
//       ),
//     ]);
//   }

//   Widget _trustBadge(IconData icon, String label) {
//     return Column(children: [
//       Container(
//         width: 36, height: 36,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//                 color: Colors.black.withOpacity(0.05),
//                 blurRadius: 6,
//                 offset: const Offset(0, 2)),
//           ],
//         ),
//         child: Icon(icon, size: 17, color: AppColors.primary),
//       ),
//       const SizedBox(height: 4),
//       Text(label,
//           style: const TextStyle(
//               fontSize: 9,
//               color: AppColors.textSecondary,
//               fontWeight: FontWeight.w600)),
//     ]);
//   }
// }
























import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/app_theme.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey   = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _nameCtrl  = TextEditingController();
  final _orgCtrl   = TextEditingController();
  final _phoneCtrl = TextEditingController();

  bool _obscure    = true;
  bool _loading    = false;
  bool _isRegister = false;

  late AnimationController _animCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    _orgCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _toggleMode() {
    _animCtrl.reverse().then((_) {
      setState(() => _isRegister = !_isRegister);
      _animCtrl.forward();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      Map<String, dynamic> result;
      if (_isRegister) {
        result = await ApiService.register(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _phoneCtrl.text.trim(),
          _passCtrl.text,
        );
      } else {
        result = await ApiService.login(
            _emailCtrl.text.trim(), _passCtrl.text);
      }
      if (!mounted) return;
      if (result['success'] == true) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const DashboardScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      } else {
        final msg = result['message'] ??
            result['errors']?[0]?['msg'] ??
            'Authentication failed';
        _showError(msg);
      }
    } catch (e) {
      if (!mounted) return;
      _showError('Connection error. Check your network.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        const Icon(Icons.error_outline_rounded,
            color: Colors.white, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(msg)),
      ]),
      backgroundColor: AppColors.orange,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(12),
    ));
  }

  InputDecoration _inputDec(String hint, IconData icon,
      {Widget? suffix}) =>
      InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
            fontSize: 13, color: AppColors.textSecondary),
        prefixIcon: Icon(icon, size: 18, color: AppColors.textSecondary),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF7F8FC),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.orange, width: 1.2)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.orange, width: 1.5)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      body: Stack(children: [
        Positioned(
          top: -80, right: -60,
          child: Container(
            width: 260, height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.07),
            ),
          ),
        ),
        Positioned(
          bottom: -100, left: -80,
          child: Container(
            width: 320, height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF4B3FD8).withOpacity(0.05),
            ),
          ),
        ),
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 24),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildBrandHeader(),
                      const SizedBox(height: 28),
                      _buildFormCard(),
                      const SizedBox(height: 20),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildBrandHeader() {
    return Column(children: [
      Container(
        width: 72, height: 72,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1348D4), Color(0xFF4B3FD8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8)),
          ],
        ),
        child: const Center(
            child: Text('🎓',
                style: TextStyle(fontSize: 34))),
      ),
      const SizedBox(height: 16),
      const Text('Andragogy Insight',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDark,
              letterSpacing: -1.2,
              height: 1.1)),
      const SizedBox(height: 5),
      const Text('Facilitator Dashboard',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2)),
      const SizedBox(height: 14),
      Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF1A5C38), Color(0xFF00875A)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF1A5C38).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3)),
          ],
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          Text('💬', style: TextStyle(fontSize: 12)),
          SizedBox(width: 6),
          Text('WhatsApp-Powered Adult Learning',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
        ]),
      ),
    ]);
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 40,
              offset: const Offset(0, 10)),
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Row(children: [
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  _isRegister ? 'Create Account' : 'Welcome back',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5),
                ),
                const SizedBox(height: 3),
                Text(
                  _isRegister
                      ? 'Set up your facilitator profile'
                      : 'Sign in to manage your learners',
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary),
                ),
              ]),
            ),
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(
                _isRegister
                    ? Icons.person_add_rounded
                    : Icons.login_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ]),
          const SizedBox(height: 24),
          if (_isRegister) ...[
            TextFormField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration:
                  _inputDec('Full name', Icons.person_outline_rounded),
              validator: (v) =>
                  v!.trim().isEmpty ? 'Enter your full name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _orgCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: _inputDec(
                  'Organisation / Company', Icons.business_rounded),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration:
                  _inputDec('WhatsApp number', Icons.phone_rounded),
              validator: (v) =>
                  v!.trim().isEmpty ? 'Enter your phone number' : null,
            ),
            const SizedBox(height: 12),
          ],
          TextFormField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration:
                _inputDec('Work email address', Icons.email_outlined),
            validator: (v) {
              if (v!.trim().isEmpty) return 'Enter your email';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _passCtrl,
            obscureText: _obscure,
            decoration: _inputDec(
              'Password',
              Icons.lock_outline_rounded,
              suffix: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                onPressed: () =>
                    setState(() => _obscure = !_obscure),
              ),
            ),
            validator: (v) =>
                v!.length < 6 ? 'Minimum 6 characters' : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    AppColors.primary.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: _loading ? 0 : 3,
                shadowColor:
                    AppColors.primary.withOpacity(0.4),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 22, height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white))
                  : Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text(
                          _isRegister
                              ? 'Create Account'
                              : 'Sign In',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded,
                            size: 18),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            const Expanded(
                child: Divider(color: AppColors.border)),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                _isRegister
                    ? 'Already have an account?'
                    : 'New facilitator?',
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary),
              ),
            ),
            const Expanded(
                child: Divider(color: AppColors.border)),
          ]),
          const SizedBox(height: 14),
          SizedBox(
            height: 46,
            child: OutlinedButton(
              onPressed: _loading ? null : _toggleMode,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(
                    color: AppColors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                _isRegister
                    ? 'Sign In Instead'
                    : 'Create New Account',
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _trustBadge(Icons.lock_rounded, 'Secure'),
          const SizedBox(width: 20),
          _trustBadge(Icons.verified_rounded, 'Verified'),
          const SizedBox(width: 20),
          _trustBadge(Icons.support_agent_rounded, 'Support'),
        ],
      ),
      const SizedBox(height: 16),
      const Text(
        'Andragogy Insight  ·  Adult Learning Platform  ·  v2.0',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
      ),
      const SizedBox(height: 4),
      const Text(
        'Built for facilitators who care about real impact.',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic),
      ),
    ]);
  }

  Widget _trustBadge(IconData icon, String label) {
    return Column(children: [
      Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Icon(icon, size: 17, color: AppColors.primary),
      ),
      const SizedBox(height: 4),
      Text(label,
          style: const TextStyle(
              fontSize: 9,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600)),
    ]);
  }
}