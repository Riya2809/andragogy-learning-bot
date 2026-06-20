
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class CertificateService {
//   // Fixed colors — no const, no withOpacity, no fromInt
//   static const _blue       = PdfColor(0.075, 0.282, 0.831);      // #1348D4
//   static const _darkBlue   = PdfColor(0.024, 0.196, 0.639);      // #0532A3
//   static const _green      = PdfColor(0.153, 0.682, 0.376);      // #27AE60
//   static const _amber      = PdfColor(1.0,   0.757, 0.027);      // #FFC107
//   static const _white      = PdfColors.white;
//   static const _white70    = PdfColor(1.0, 1.0, 1.0, 0.70);
//   static const _white50    = PdfColor(1.0, 1.0, 1.0, 0.50);
//   static const _white20    = PdfColor(1.0, 1.0, 1.0, 0.20);
//   static const _white10    = PdfColor(1.0, 1.0, 1.0, 0.10);
//   static const _white05    = PdfColor(1.0, 1.0, 1.0, 0.05);

//   static Future<void> downloadCertificate({
//     required String learnerName,
//     required String courseTitle,
//     required int score,
//     required String date,
//   }) async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4.landscape,
//         margin: pw.EdgeInsets.zero,
//         build: (pw.Context ctx) {
//           return pw.Stack(
//             children: [

//               // ── Full background ───────────────────────────────
//               pw.Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 color: _blue,
//               ),

//               // ── Top-right decorative circle ───────────────────
//               pw.Positioned(
//                 top: -60, right: -60,
//                 left: null, bottom: null,
//                 child: pw.Container(
//                   width: 200, height: 200,
//                   decoration: const pw.BoxDecoration(
//                     shape: pw.BoxShape.circle,
//                     color: _white05,
//                   ),
//                 ),
//               ),

//               // ── Bottom-left decorative circle ─────────────────
//               pw.Positioned(
//                 bottom: -80, left: -40,
//                 top: null, right: null,
//                 child: pw.Container(
//                   width: 250, height: 250,
//                   decoration: const pw.BoxDecoration(
//                     shape: pw.BoxShape.circle,
//                     color: _white05,
//                   ),
//                 ),
//               ),

//               // ── Border frame ──────────────────────────────────
//               pw.Positioned(
//                 top: 20, left: 20, right: 20, bottom: 20,
//                 child: pw.Container(
//                   decoration: pw.BoxDecoration(
//                     border: pw.Border.all(
//                       color: _white20,
//                       width: 1.5,
//                     ),
//                     borderRadius: pw.BorderRadius.circular(16),
//                   ),
//                 ),
//               ),

//               // ── Main content ──────────────────────────────────
//               pw.Center(
//                 child: pw.Column(
//                   mainAxisAlignment: pw.MainAxisAlignment.center,
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   children: [

//                     // Top badge
//                     pw.Container(
//                       padding: const pw.EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 6),
//                       decoration: pw.BoxDecoration(
//                         color: _white20,
//                         borderRadius: pw.BorderRadius.circular(20),
//                         border: pw.Border.all(color: _white20, width: 1),
//                       ),
//                       child: pw.Text(
//                         'CERTIFICATE OF COMPLETION',
//                         style: pw.TextStyle(
//                           color: _white,
//                           fontSize: 10,
//                           fontWeight: pw.FontWeight.bold,
//                           letterSpacing: 2,
//                         ),
//                       ),
//                     ),

//                     pw.SizedBox(height: 24),

//                     // Trophy circle (no emoji — use text)
//                     pw.Container(
//                       width: 80, height: 80,
//                       decoration: const pw.BoxDecoration(
//                         color: _amber,
//                         shape: pw.BoxShape.circle,
//                       ),
//                       child: pw.Center(
//                         child: pw.Text(
//                           '1ST',
//                           style: pw.TextStyle(
//                             color: _white,
//                             fontSize: 22,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),

//                     pw.SizedBox(height: 20),

//                     // Congratulations
//                     pw.Text(
//                       'Congratulations!',
//                       style: pw.TextStyle(
//                         color: _white,
//                         fontSize: 32,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                     ),

//                     pw.SizedBox(height: 8),

//                     // Learner name
//                     pw.Text(
//                       learnerName,
//                       style: pw.TextStyle(
//                         color: _white70,
//                         fontSize: 20,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                     ),

//                     pw.SizedBox(height: 20),

//                     // Divider
//                     pw.Container(
//                       width: 400, height: 1,
//                       color: _white20,
//                     ),

//                     pw.SizedBox(height: 20),

//                     pw.Text(
//                       'has successfully completed',
//                       style: pw.TextStyle(
//                         color: _white70,
//                         fontSize: 13,
//                       ),
//                     ),

//                     pw.SizedBox(height: 8),

//                     // Course title box
//                     pw.Container(
//                       padding: const pw.EdgeInsets.symmetric(
//                           horizontal: 24, vertical: 10),
//                       decoration: pw.BoxDecoration(
//                         color: _white10,
//                         borderRadius: pw.BorderRadius.circular(10),
//                       ),
//                       child: pw.Text(
//                         courseTitle,
//                         textAlign: pw.TextAlign.center,
//                         style: pw.TextStyle(
//                           color: _white,
//                           fontSize: 22,
//                           fontWeight: pw.FontWeight.bold,
//                         ),
//                       ),
//                     ),

//                     pw.SizedBox(height: 28),

//                     // Score + Date row
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.center,
//                       children: [

//                         // Score box
//                         pw.Container(
//                           width: 120,
//                           padding: const pw.EdgeInsets.symmetric(
//                               vertical: 12),
//                           decoration: pw.BoxDecoration(
//                             color: _white10,
//                             borderRadius: pw.BorderRadius.circular(10),
//                           ),
//                           child: pw.Column(
//                             children: [
//                               pw.Text(
//                                 '$score%',
//                                 style: pw.TextStyle(
//                                   color: _white,
//                                   fontSize: 28,
//                                   fontWeight: pw.FontWeight.bold,
//                                 ),
//                               ),
//                               pw.SizedBox(height: 4),
//                               pw.Text(
//                                 'Final Score',
//                                 style: pw.TextStyle(
//                                   color: _white70,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         pw.SizedBox(width: 20),

//                         // Vertical divider
//                         pw.Container(
//                           width: 1, height: 60,
//                           color: _white20,
//                         ),

//                         pw.SizedBox(width: 20),

//                         // Date box
//                         pw.Container(
//                           width: 140,
//                           padding: const pw.EdgeInsets.symmetric(
//                               vertical: 12),
//                           decoration: pw.BoxDecoration(
//                             color: _white10,
//                             borderRadius: pw.BorderRadius.circular(10),
//                           ),
//                           child: pw.Column(
//                             children: [
//                               pw.Text(
//                                 date,
//                                 style: pw.TextStyle(
//                                   color: _white,
//                                   fontSize: 16,
//                                   fontWeight: pw.FontWeight.bold,
//                                 ),
//                               ),
//                               pw.SizedBox(height: 4),
//                               pw.Text(
//                                 'Date Issued',
//                                 style: pw.TextStyle(
//                                   color: _white70,
//                                   fontSize: 10,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),

//                     pw.SizedBox(height: 24),

//                     // Excellence badge
//                     pw.Container(
//                       padding: const pw.EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 8),
//                       decoration: pw.BoxDecoration(
//                         color: _green,
//                         borderRadius: pw.BorderRadius.circular(20),
//                       ),
//                       child: pw.Text(
//                         'Excellence Award',
//                         style: pw.TextStyle(
//                           color: _white,
//                           fontSize: 12,
//                           fontWeight: pw.FontWeight.bold,
//                         ),
//                       ),
//                     ),

//                     pw.SizedBox(height: 14),

//                     // Footer
//                     pw.Text(
//                       'Issued by Andragogy Learning Platform · WhatsApp-Based Adult Education',
//                       style: pw.TextStyle(
//                         color: _white50,
//                         fontSize: 9,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     // Save and share/download the PDF
//     final Uint8List bytes = await pdf.save();
//     await Printing.sharePdf(
//       bytes: bytes,
//       filename: 'Andragogy_Certificate_${learnerName.replaceAll(' ', '_')}.pdf',
//     );
//   }
// }







// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class CertificateService {
//   // ── Colour palette ─────────────────────────────────────────────────────────
//   static const _blue      = PdfColor(0.075, 0.282, 0.831);   // #1348D4
//   static const _darkBlue  = PdfColor(0.024, 0.196, 0.639);   // #0532A3
//   static const _deepBlue  = PdfColor(0.012, 0.118, 0.431);   // #031E6E
//   static const _green     = PdfColor(0.153, 0.682, 0.376);   // #27AE60
//   static const _amber     = PdfColor(1.0,   0.757, 0.027);   // #FFC107
//   static const _white     = PdfColors.white;
//   static const _white80   = PdfColor(1.0, 1.0, 1.0, 0.80);
//   static const _white70   = PdfColor(1.0, 1.0, 1.0, 0.70);
//   static const _white50   = PdfColor(1.0, 1.0, 1.0, 0.50);
//   static const _white30   = PdfColor(1.0, 1.0, 1.0, 0.30);
//   static const _white20   = PdfColor(1.0, 1.0, 1.0, 0.20);
//   static const _white12   = PdfColor(1.0, 1.0, 1.0, 0.12);
//   static const _white08   = PdfColor(1.0, 1.0, 1.0, 0.08);
//   static const _white05   = PdfColor(1.0, 1.0, 1.0, 0.05);

//   // ── A4 landscape dimensions (pt) ──────────────────────────────────────────
//   static const double _W = 841.89;
//   static const double _H = 595.28;

//   static Future<void> downloadCertificate({
//     required String learnerName,
//     required String courseTitle,
//     required int score,
//     required String date,
//   }) async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4.landscape,
//         margin: pw.EdgeInsets.zero,
//         build: (pw.Context ctx) {
//           return pw.Stack(
//             children: [

//               // ── 1. Full deep-blue background ────────────────────────────
//               pw.Container(
//                 width: double.infinity,
//                 height: double.infinity,
//                 color: _deepBlue,
//               ),

//               // ── 2. Left accent panel ────────────────────────────────────
//               pw.Positioned(
//                 top: 0, left: 0, bottom: 0,
//                 right: null,
//                 child: pw.Container(
//                   width: _W * 0.32,
//                   color: _blue,
//                   child: pw.Stack(
//                     children: [
//                       // large circle — top-left
//                       pw.Positioned(
//                         top: -50, left: -50,
//                         right: null, bottom: null,
//                         child: pw.Container(
//                           width: 220, height: 220,
//                           decoration: const pw.BoxDecoration(
//                             shape: pw.BoxShape.circle,
//                             color: _white05,
//                           ),
//                         ),
//                       ),
//                       // medium circle — bottom-right
//                       pw.Positioned(
//                         bottom: -40, right: -40,
//                         top: null, left: null,
//                         child: pw.Container(
//                           width: 180, height: 180,
//                           decoration: const pw.BoxDecoration(
//                             shape: pw.BoxShape.circle,
//                             color: _white08,
//                           ),
//                         ),
//                       ),
//                       // Left-panel content
//                       pw.Center(
//                         child: pw.Column(
//                           mainAxisAlignment: pw.MainAxisAlignment.center,
//                           crossAxisAlignment: pw.CrossAxisAlignment.center,
//                           children: [
//                             // Trophy / medal circle
//                             pw.Container(
//                               width: 90, height: 90,
//                               decoration: const pw.BoxDecoration(
//                                 shape: pw.BoxShape.circle,
//                                 color: _amber,
//                               ),
//                               child: pw.Center(
//                                 child: pw.Text(
//                                   '1ST',
//                                   style: pw.TextStyle(
//                                     color: _white,
//                                     fontSize: 26,
//                                     fontWeight: pw.FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             pw.SizedBox(height: 18),

//                             // Score circle
//                             pw.Container(
//                               width: 80, height: 80,
//                               decoration: pw.BoxDecoration(
//                                 shape: pw.BoxShape.circle,
//                                 border: pw.Border.all(
//                                     color: _white30, width: 2),
//                                 color: _white08,
//                               ),
//                               child: pw.Center(
//                                 child: pw.Column(
//                                   mainAxisAlignment:
//                                       pw.MainAxisAlignment.center,
//                                   children: [
//                                     pw.Text(
//                                       '$score%',
//                                       style: pw.TextStyle(
//                                         color: _white,
//                                         fontSize: 22,
//                                         fontWeight: pw.FontWeight.bold,
//                                       ),
//                                     ),
//                                     pw.Text(
//                                       'SCORE',
//                                       style: pw.TextStyle(
//                                         color: _white70,
//                                         fontSize: 8,
//                                         letterSpacing: 1,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                             pw.SizedBox(height: 22),

//                             // Decorative thin line
//                             pw.Container(
//                                 width: 60, height: 1, color: _white30),

//                             pw.SizedBox(height: 16),

//                             // Excellence badge
//                             pw.Container(
//                               padding: const pw.EdgeInsets.symmetric(
//                                   horizontal: 14, vertical: 6),
//                               decoration: pw.BoxDecoration(
//                                 color: _green,
//                                 borderRadius:
//                                     pw.BorderRadius.circular(20),
//                               ),
//                               child: pw.Text(
//                                 'Excellence Award',
//                                 style: pw.TextStyle(
//                                   color: _white,
//                                   fontSize: 10,
//                                   fontWeight: pw.FontWeight.bold,
//                                 ),
//                               ),
//                             ),

//                             pw.SizedBox(height: 16),

//                             // Date issued
//                             pw.Container(
//                               padding: const pw.EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               decoration: pw.BoxDecoration(
//                                 color: _white12,
//                                 borderRadius:
//                                     pw.BorderRadius.circular(8),
//                               ),
//                               child: pw.Column(
//                                 children: [
//                                   pw.Text(
//                                     date,
//                                     style: pw.TextStyle(
//                                       color: _white,
//                                       fontSize: 11,
//                                       fontWeight: pw.FontWeight.bold,
//                                     ),
//                                   ),
//                                   pw.SizedBox(height: 2),
//                                   pw.Text(
//                                     'DATE ISSUED',
//                                     style: pw.TextStyle(
//                                       color: _white70,
//                                       fontSize: 7,
//                                       letterSpacing: 1,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // ── 3. Thin vertical accent line ───────────────────────────
//               pw.Positioned(
//                 top: 0, bottom: 0,
//                 left: _W * 0.32,
//                 right: null,
//                 child: pw.Container(
//                   width: 4,
//                   color: _amber,
//                 ),
//               ),

//               // ── 4. Right panel — decorative circles ────────────────────
//               pw.Positioned(
//                 top: -70, right: -70,
//                 left: null, bottom: null,
//                 child: pw.Container(
//                   width: 220, height: 220,
//                   decoration: const pw.BoxDecoration(
//                     shape: pw.BoxShape.circle,
//                     color: _white05,
//                   ),
//                 ),
//               ),
//               pw.Positioned(
//                 bottom: -60, right: 60,
//                 top: null, left: null,
//                 child: pw.Container(
//                   width: 160, height: 160,
//                   decoration: const pw.BoxDecoration(
//                     shape: pw.BoxShape.circle,
//                     color: _white08,
//                   ),
//                 ),
//               ),

//               // ── 5. Top stripe label ─────────────────────────────────────
//               pw.Positioned(
//                 top: 28, left: _W * 0.32 + 32,
//                 right: 32, bottom: null,
//                 child: pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: pw.CrossAxisAlignment.center,
//                   children: [
//                     pw.Container(
//                       padding: const pw.EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 5),
//                       decoration: pw.BoxDecoration(
//                         color: _white12,
//                         borderRadius: pw.BorderRadius.circular(20),
//                         border:
//                             pw.Border.all(color: _white20, width: 1),
//                       ),
//                       child: pw.Text(
//                         'CERTIFICATE OF COMPLETION',
//                         style: pw.TextStyle(
//                           color: _white80,
//                           fontSize: 8,
//                           fontWeight: pw.FontWeight.bold,
//                           letterSpacing: 2,
//                         ),
//                       ),
//                     ),
//                     pw.Text(
//                       'Andragogy Learning Platform',
//                       style: pw.TextStyle(
//                         color: _white50,
//                         fontSize: 8,
//                         letterSpacing: 1,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // ── 6. Main right-panel content ─────────────────────────────
//               pw.Positioned(
//                 top: 70,
//                 left: _W * 0.32 + 32,
//                 right: 40,
//                 bottom: 50,
//                 child: pw.Column(
//                   mainAxisAlignment: pw.MainAxisAlignment.center,
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [

//                     // "Congratulations!"
//                     pw.Text(
//                       'Congratulations!',
//                       style: pw.TextStyle(
//                         color: _amber,
//                         fontSize: 30,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                     ),

//                     pw.SizedBox(height: 4),

//                     // "This certificate is proudly presented to"
//                     pw.Text(
//                       'This certificate is proudly presented to',
//                       style: pw.TextStyle(
//                         color: _white70,
//                         fontSize: 11,
//                       ),
//                     ),

//                     pw.SizedBox(height: 10),

//                     // Learner name — large, prominent
//                     pw.Container(
//                       padding: const pw.EdgeInsets.symmetric(
//                           horizontal: 0, vertical: 8),
//                       decoration: const pw.BoxDecoration(
//                         border: pw.Border(
//                           bottom: pw.BorderSide(
//                               color: _amber, width: 2),
//                         ),
//                       ),
//                       child: pw.Text(
//                         learnerName,
//                         style: pw.TextStyle(
//                           color: _white,
//                           fontSize: 34,
//                           fontWeight: pw.FontWeight.bold,
//                         ),
//                       ),
//                     ),

//                     pw.SizedBox(height: 18),

//                     // "has successfully completed"
//                     pw.Text(
//                       'has successfully completed the course',
//                       style: pw.TextStyle(
//                         color: _white70,
//                         fontSize: 11,
//                       ),
//                     ),

//                     pw.SizedBox(height: 10),

//                     // Course title box — fills space beautifully
//                     pw.Container(
//                       padding: const pw.EdgeInsets.symmetric(
//                           horizontal: 18, vertical: 12),
//                       decoration: pw.BoxDecoration(
//                         color: _white08,
//                         borderRadius: pw.BorderRadius.circular(10),
//                         border: pw.Border.all(
//                             color: _white20, width: 1),
//                       ),
//                       child: pw.Row(
//                         children: [
//                           // Left colored bar
//                           pw.Container(
//                             width: 4,
//                             height: 40,
//                             decoration: pw.BoxDecoration(
//                               color: _amber,
//                               borderRadius:
//                                   pw.BorderRadius.circular(2),
//                             ),
//                           ),
//                           pw.SizedBox(width: 14),
//                           pw.Expanded(
//                             child: pw.Column(
//                               crossAxisAlignment:
//                                   pw.CrossAxisAlignment.start,
//                               children: [
//                                 pw.Text(
//                                   'COURSE',
//                                   style: pw.TextStyle(
//                                     color: _white50,
//                                     fontSize: 7,
//                                     letterSpacing: 2,
//                                   ),
//                                 ),
//                                 pw.SizedBox(height: 4),
//                                 pw.Text(
//                                   courseTitle,
//                                   style: pw.TextStyle(
//                                     color: _white,
//                                     fontSize: 16,
//                                     fontWeight: pw.FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     pw.SizedBox(height: 22),

//                     // Horizontal stats row
//                     pw.Row(
//                       children: [
//                         _statChip(label: 'SCORE', value: '$score%'),
//                         pw.SizedBox(width: 12),
//                         _statChip(label: 'STATUS', value: 'PASSED'),
//                         pw.SizedBox(width: 12),
//                         _statChip(
//                             label: 'PLATFORM',
//                             value: 'WhatsApp LMS'),
//                       ],
//                     ),

//                     pw.SizedBox(height: 22),

//                     // Signature line row
//                     pw.Row(
//                       children: [
//                         pw.Column(
//                           crossAxisAlignment:
//                               pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Container(
//                                 width: 120,
//                                 height: 1,
//                                 color: _white30),
//                             pw.SizedBox(height: 4),
//                             pw.Text(
//                               'Authorized Signatory',
//                               style: pw.TextStyle(
//                                   color: _white50, fontSize: 8),
//                             ),
//                           ],
//                         ),
//                         pw.SizedBox(width: 40),
//                         pw.Column(
//                           crossAxisAlignment:
//                               pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Container(
//                                 width: 120,
//                                 height: 1,
//                                 color: _white30),
//                             pw.SizedBox(height: 4),
//                             pw.Text(
//                               'Program Director',
//                               style: pw.TextStyle(
//                                   color: _white50, fontSize: 8),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),

//               // ── 7. Bottom footer bar ────────────────────────────────────
//               pw.Positioned(
//                 bottom: 0, left: _W * 0.32 + 4,
//                 right: 0,
//                 child: pw.Container(
//                   height: 34,
//                   color: _white05,
//                   padding: const pw.EdgeInsets.symmetric(horizontal: 24),
//                   child: pw.Center(
//                     child: pw.Text(
//                       'Andragogy Learning Platform  ·  WhatsApp-Based Adult Education  ·  ${date}',
//                       style: pw.TextStyle(
//                         color: _white50,
//                         fontSize: 8,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               // ── 8. Outer border frame ───────────────────────────────────
//               pw.Positioned(
//                 top: 12, left: 12, right: 12, bottom: 12,
//                 child: pw.Container(
//                   decoration: pw.BoxDecoration(
//                     border: pw.Border.all(
//                       color: _white20,
//                       width: 1,
//                     ),
//                     borderRadius: pw.BorderRadius.circular(6),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     final Uint8List bytes = await pdf.save();
//     await Printing.sharePdf(
//       bytes: bytes,
//       filename:
//           'Andragogy_Certificate_${learnerName.replaceAll(' ', '_')}.pdf',
//     );
//   }

//   // ── Helper widget: small stat chip ───────────────────────────────────────
//   static pw.Widget _statChip({
//     required String label,
//     required String value,
//   }) {
//     return pw.Container(
//       padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//       decoration: pw.BoxDecoration(
//         color: _white08,
//         borderRadius: pw.BorderRadius.circular(8),
//         border: pw.Border.all(color: _white20, width: 1),
//       ),
//       child: pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text(
//             label,
//             style: pw.TextStyle(
//               color: _white50,
//               fontSize: 7,
//               letterSpacing: 1.5,
//             ),
//           ),
//           pw.SizedBox(height: 2),
//           pw.Text(
//             value,
//             style: pw.TextStyle(
//               color: _white,
//               fontSize: 12,
//               fontWeight: pw.FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }








import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CertificateService {
  // ── Colour palette ─────────────────────────────────────────────────────────
  static const _blue      = PdfColor(0.075, 0.282, 0.831);   // #1348D4
  static const _darkBlue  = PdfColor(0.024, 0.196, 0.639);   // #0532A3
  static const _deepBlue  = PdfColor(0.012, 0.118, 0.431);   // #031E6E
  static const _green     = PdfColor(0.153, 0.682, 0.376);   // #27AE60
  static const _amber     = PdfColor(1.0,   0.757, 0.027);   // #FFC107
  static const _white     = PdfColors.white;
  static const _white80   = PdfColor(1.0, 1.0, 1.0, 0.80);
  static const _white70   = PdfColor(1.0, 1.0, 1.0, 0.70);
  static const _white50   = PdfColor(1.0, 1.0, 1.0, 0.50);
  static const _white30   = PdfColor(1.0, 1.0, 1.0, 0.30);
  static const _white20   = PdfColor(1.0, 1.0, 1.0, 0.20);
  static const _white12   = PdfColor(1.0, 1.0, 1.0, 0.12);
  static const _white08   = PdfColor(1.0, 1.0, 1.0, 0.08);
  static const _white05   = PdfColor(1.0, 1.0, 1.0, 0.05);

  // ── A4 landscape dimensions (pt) ──────────────────────────────────────────
  static const double _W = 841.89;
  static const double _H = 595.28;

  static Future<void> downloadCertificate({
    required String learnerName,
    required String courseTitle,
    required String companyName,
    required int score,
    required String date,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context ctx) {
          return pw.Stack(
            children: [

              // ── 1. Full deep-blue background ────────────────────────────
              pw.Container(
                width: double.infinity,
                height: double.infinity,
                color: _deepBlue,
              ),

              // ── 2. Left accent panel ────────────────────────────────────
              pw.Positioned(
                top: 0, left: 0, bottom: 0,
                right: null,
                child: pw.Container(
                  width: _W * 0.32,
                  color: _blue,
                  child: pw.Stack(
                    children: [
                      // large circle — top-left
                      pw.Positioned(
                        top: -50, left: -50,
                        right: null, bottom: null,
                        child: pw.Container(
                          width: 220, height: 220,
                          decoration: const pw.BoxDecoration(
                            shape: pw.BoxShape.circle,
                            color: _white05,
                          ),
                        ),
                      ),
                      // medium circle — bottom-right
                      pw.Positioned(
                        bottom: -40, right: -40,
                        top: null, left: null,
                        child: pw.Container(
                          width: 180, height: 180,
                          decoration: const pw.BoxDecoration(
                            shape: pw.BoxShape.circle,
                            color: _white08,
                          ),
                        ),
                      ),
                      // Left-panel content
                      pw.Center(
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            // Trophy / medal circle
                            pw.Container(
                              width: 90, height: 90,
                              decoration: const pw.BoxDecoration(
                                shape: pw.BoxShape.circle,
                                color: _amber,
                              ),
                              child: pw.Center(
                                child: pw.Text(
                                  '1ST',
                                  style: pw.TextStyle(
                                    color: _white,
                                    fontSize: 26,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            pw.SizedBox(height: 18),

                            // Score circle
                            pw.Container(
                              width: 80, height: 80,
                              decoration: pw.BoxDecoration(
                                shape: pw.BoxShape.circle,
                                border: pw.Border.all(
                                    color: _white30, width: 2),
                                color: _white08,
                              ),
                              child: pw.Center(
                                child: pw.Column(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      '$score%',
                                      style: pw.TextStyle(
                                        color: _white,
                                        fontSize: 22,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                    pw.Text(
                                      'SCORE',
                                      style: pw.TextStyle(
                                        color: _white70,
                                        fontSize: 8,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            pw.SizedBox(height: 22),

                            // Decorative thin line
                            pw.Container(
                                width: 60, height: 1, color: _white30),

                            pw.SizedBox(height: 16),

                            // Excellence badge
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: pw.BoxDecoration(
                                color: _green,
                                borderRadius:
                                    pw.BorderRadius.circular(20),
                              ),
                              child: pw.Text(
                                'Excellence Award',
                                style: pw.TextStyle(
                                  color: _white,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ),

                            pw.SizedBox(height: 16),

                            // Date issued
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: pw.BoxDecoration(
                                color: _white12,
                                borderRadius:
                                    pw.BorderRadius.circular(8),
                              ),
                              child: pw.Column(
                                children: [
                                  pw.Text(
                                    date,
                                    style: pw.TextStyle(
                                      color: _white,
                                      fontSize: 11,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    'DATE ISSUED',
                                    style: pw.TextStyle(
                                      color: _white70,
                                      fontSize: 7,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            pw.SizedBox(height: 12),

                            // Company name chip
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 7),
                              decoration: pw.BoxDecoration(
                                color: _amber,
                                borderRadius: pw.BorderRadius.circular(8),
                              ),
                              child: pw.Column(
                                children: [
                                  pw.Text(
                                    companyName,
                                    style: pw.TextStyle(
                                      color: _white,
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.SizedBox(height: 2),
                                  pw.Text(
                                    'ORGANISATION',
                                    style: pw.TextStyle(
                                      color: _white80,
                                      fontSize: 7,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── 3. Thin vertical accent line ───────────────────────────
              pw.Positioned(
                top: 0, bottom: 0,
                left: _W * 0.32,
                right: null,
                child: pw.Container(
                  width: 4,
                  color: _amber,
                ),
              ),

              // ── 4. Right panel — decorative circles ────────────────────
              pw.Positioned(
                top: -70, right: -70,
                left: null, bottom: null,
                child: pw.Container(
                  width: 220, height: 220,
                  decoration: const pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    color: _white05,
                  ),
                ),
              ),
              pw.Positioned(
                bottom: -60, right: 60,
                top: null, left: null,
                child: pw.Container(
                  width: 160, height: 160,
                  decoration: const pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    color: _white08,
                  ),
                ),
              ),

              // ── 5. Top stripe label ─────────────────────────────────────
              pw.Positioned(
                top: 28, left: _W * 0.32 + 32,
                right: 32, bottom: null,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 16, vertical: 5),
                      decoration: pw.BoxDecoration(
                        color: _white12,
                        borderRadius: pw.BorderRadius.circular(20),
                        border:
                            pw.Border.all(color: _white20, width: 1),
                      ),
                      child: pw.Text(
                        'CERTIFICATE OF COMPLETION',
                        style: pw.TextStyle(
                          color: _white80,
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    pw.Text(
                      'Andragogy Learning Platform',
                      style: pw.TextStyle(
                        color: _white50,
                        fontSize: 8,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              // ── 6. Main right-panel content ─────────────────────────────
              pw.Positioned(
                top: 70,
                left: _W * 0.32 + 32,
                right: 40,
                bottom: 50,
                child: pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [

                    // "Congratulations!"
                    pw.Text(
                      'Congratulations!',
                      style: pw.TextStyle(
                        color: _amber,
                        fontSize: 30,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),

                    pw.SizedBox(height: 4),

                    // "This certificate is proudly presented to"
                    pw.Text(
                      'This certificate is proudly presented to',
                      style: pw.TextStyle(
                        color: _white70,
                        fontSize: 11,
                      ),
                    ),

                    pw.SizedBox(height: 10),

                    // Learner name — large, prominent
                    pw.Container(
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8),
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(
                          bottom: pw.BorderSide(
                              color: _amber, width: 2),
                        ),
                      ),
                      child: pw.Text(
                        learnerName,
                        style: pw.TextStyle(
                          color: _white,
                          fontSize: 34,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),

                    pw.SizedBox(height: 18),

                    // "has successfully completed"
                    pw.Text(
                      'has successfully completed the course',
                      style: pw.TextStyle(
                        color: _white70,
                        fontSize: 11,
                      ),
                    ),

                    pw.SizedBox(height: 10),

                    // Course title — prominent, full-width, amber-accented
                    pw.Container(
                      width: double.infinity,
                      padding: const pw.EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      decoration: pw.BoxDecoration(
                        color: _white08,
                        borderRadius: pw.BorderRadius.circular(10),
                        border: pw.Border.all(color: _white20, width: 1),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          // Label row
                          pw.Row(
                            children: [
                              pw.Container(
                                width: 3, height: 10,
                                color: _amber,
                              ),
                              pw.SizedBox(width: 6),
                              pw.Text(
                                'COURSE NAME',
                                style: pw.TextStyle(
                                  color: _amber,
                                  fontSize: 7,
                                  letterSpacing: 2,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 8),
                          // Course name — large and bold
                          pw.Text(
                            courseTitle,
                            style: pw.TextStyle(
                              color: _white,
                              fontSize: 22,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    pw.SizedBox(height: 22),

                    // Horizontal stats row
                    pw.Row(
                      children: [
                        _statChip(label: 'SCORE', value: '$score%'),
                        pw.SizedBox(width: 12),
                        _statChip(label: 'STATUS', value: 'PASSED'),
                        pw.SizedBox(width: 12),
                        _statChip(label: 'COMPANY', value: companyName),
                        pw.SizedBox(width: 12),
                        _statChip(label: 'PLATFORM', value: 'WhatsApp LMS'),
                      ],
                    ),

                    pw.SizedBox(height: 22),

                    // Signature line row
                    pw.Row(
                      children: [
                        pw.Column(
                          crossAxisAlignment:
                              pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                                width: 120,
                                height: 1,
                                color: _white30),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              'Authorized Signatory',
                              style: pw.TextStyle(
                                  color: _white50, fontSize: 8),
                            ),
                          ],
                        ),
                        pw.SizedBox(width: 40),
                        pw.Column(
                          crossAxisAlignment:
                              pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                                width: 120,
                                height: 1,
                                color: _white30),
                            pw.SizedBox(height: 4),
                            pw.Text(
                              'Program Director',
                              style: pw.TextStyle(
                                  color: _white50, fontSize: 8),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── 7. Bottom footer bar ────────────────────────────────────
              pw.Positioned(
                bottom: 0, left: _W * 0.32 + 4,
                right: 0,
                child: pw.Container(
                  height: 34,
                  color: _white05,
                  padding: const pw.EdgeInsets.symmetric(horizontal: 24),
                  child: pw.Center(
                    child: pw.Text(
                      'Andragogy Learning Platform  ·  $companyName  ·  WhatsApp-Based Adult Education  ·  $date',
                      style: pw.TextStyle(
                        color: _white50,
                        fontSize: 8,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),

              // ── 8. Outer border frame ───────────────────────────────────
              pw.Positioned(
                top: 12, left: 12, right: 12, bottom: 12,
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                      color: _white20,
                      width: 1,
                    ),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    final Uint8List bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename:
          'Andragogy_Certificate_${learnerName.replaceAll(' ', '_')}.pdf',
    );
  }

  // ── Helper widget: small stat chip ───────────────────────────────────────
  static pw.Widget _statChip({
    required String label,
    required String value,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: pw.BoxDecoration(
        color: _white08,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: _white20, width: 1),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              color: _white50,
              fontSize: 7,
              letterSpacing: 1.5,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            value,
            style: pw.TextStyle(
              color: _white,
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
