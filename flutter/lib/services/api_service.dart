// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/models.dart';

// class ApiService {
//   static const String baseUrl = 'http://localhost:5000/api';

//   static String? _token;

//   static Future<String?> getToken() async {
//     if (_token != null) return _token;
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('auth_token');
//     return _token;
//   }

//   static Future<void> saveToken(String token) async {
//     _token = token;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', token);
//   }

//   static Future<void> clearToken() async {
//     _token = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//     await prefs.remove('user_data');
//   }

//   static Future<Map<String, String>> _headers() async {
//     final token = await getToken();
//     return {
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };
//   }

//   // ── Auth ───────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> login(
//       String email, String password) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email, 'password': password}),
//     );
//     final data = jsonDecode(res.body);
//     if (res.statusCode == 200 && data['success'] == true) {
//       await saveToken(data['token']);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_data', jsonEncode(data['user']));
//     }
//     return data;
//   }

//   static Future<Map<String, dynamic>> register(
//       String name, String email, String phone, String password) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/register'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'name': name,
//         'email': email,
//         'phone_number': phone,
//         'password': password
//       }),
//     );
//     final data = jsonDecode(res.body);
//     if (res.statusCode == 201 && data['success'] == true) {
//       await saveToken(data['token']);
//     }
//     return data;
//   }

//   // ── Courses ────────────────────────────────────────────────
//   static Future<List<Course>> getCourses() async {
//     final res = await http.get(
//         Uri.parse('$baseUrl/courses'),
//         headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return (data['data'] as List).map((c) => Course.fromJson(c)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> createCourse(
//       String title, String description,
//       {String category = 'General',
//       List<String> tags = const [],
//       int thumbnailColorIndex = 0}) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/courses'),
//       headers: await _headers(),
//       body: jsonEncode({
//         'title': title,
//         'description': description,
//         'category': category,
//         'tags': tags,
//         'thumbnail_color_index': thumbnailColorIndex,
//       }),
//     );
//     return jsonDecode(res.body);
//   }

//   /// ── NEW: Edit an existing course ────────────────────────────
//   static Future<Map<String, dynamic>> updateCourse(
//       String courseId, {
//       required String title,
//       required String description,
//       required String category,
//       required List<String> tags,
//       required int thumbnailColorIndex,
//   }) async {
//     final res = await http.put(
//       Uri.parse('$baseUrl/courses/$courseId'),
//       headers: await _headers(),
//       body: jsonEncode({
//         'title': title,
//         'description': description,
//         'category': category,
//         'tags': tags,
//         'thumbnail_color_index': thumbnailColorIndex,
//       }),
//     );
//     return jsonDecode(res.body);
//   }

//   static Future<bool> deleteCourse(String courseId) async {
//     final res = await http.delete(
//         Uri.parse('$baseUrl/courses/$courseId'),
//         headers: await _headers());
//     final data = jsonDecode(res.body);
//     return data['success'] == true;
//   }

//   // ── Modules ────────────────────────────────────────────────
//   static Future<List<CourseModule>> getModules(String courseId) async {
//     final res = await http.get(
//         Uri.parse('$baseUrl/modules/$courseId'),
//         headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return (data['data'] as List)
//           .map((m) => CourseModule.fromJson(m))
//           .toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> createModule({
//     required String courseId,
//     required String title,
//     required String description,
//     String pdfLink = '',
//     String videoLink = '',
//     int order = 1,
//   }) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/modules'),
//       headers: await _headers(),
//       body: jsonEncode({
//         'course_id': courseId,
//         'title': title,
//         'description': description,
//         'pdf_link': pdfLink,
//         'video_link': videoLink,
//         'order': order,
//       }),
//     );
//     return jsonDecode(res.body);
//   }

//   /// ── NEW: Edit an existing module ────────────────────────────
//   static Future<Map<String, dynamic>> updateModule({
//     required String moduleId,
//     required String title,
//     required String description,
//     String pdfLink = '',
//     String videoLink = '',
//   }) async {
//     final res = await http.put(
//       Uri.parse('$baseUrl/modules/$moduleId'),
//       headers: await _headers(),
//       body: jsonEncode({
//         'title': title,
//         'description': description,
//         'pdf_link': pdfLink,
//         'video_link': videoLink,
//       }),
//     );
//     return jsonDecode(res.body);
//   }

//   /// ── NEW: Save new module order after drag-reorder ───────────
//   /// [orderedIds] is the list of module IDs in the new order
//   static Future<bool> reorderModules(
//       String courseId, List<String> orderedIds) async {
//     final res = await http.put(
//       Uri.parse('$baseUrl/modules/$courseId/reorder'),
//       headers: await _headers(),
//       body: jsonEncode({'ordered_ids': orderedIds}),
//     );
//     final data = jsonDecode(res.body);
//     return data['success'] == true;
//   }

//   // ── Quizzes ────────────────────────────────────────────────
//   static Future<List<QuizQuestion>> getQuizzes(String courseId) async {
//     final res = await http.get(
//         Uri.parse('$baseUrl/quizzes/$courseId'),
//         headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return (data['data'] as List)
//           .map((q) => QuizQuestion.fromJson(q))
//           .toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> createQuizQuestion({
//     required String courseId,
//     required String question,
//     required Map<String, String> options,
//     required String correctAnswer,
//   }) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/quizzes'),
//       headers: await _headers(),
//       body: jsonEncode({
//         'course_id': courseId,
//         'question': question,
//         'options': options,
//         'correct_answer': correctAnswer,
//       }),
//     );
//     return jsonDecode(res.body);
//   }

//   // ── Progress ───────────────────────────────────────────────
//   static Future<List<LearnerProgress>> getAllProgress() async {
//     final res = await http.get(
//         Uri.parse('$baseUrl/progress'),
//         headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return (data['data'] as List)
//           .map((p) => LearnerProgress.fromJson(p))
//           .toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> getLearnerProgress(
//       String phone) async {
//     final res = await http.get(
//         Uri.parse('$baseUrl/progress/$phone'),
//         headers: await _headers());
//     return jsonDecode(res.body);
//   }

//   // ── WhatsApp Simulation ────────────────────────────────────
//   static Future<String> sendWhatsAppMessage(
//       String phone, String message) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/whatsapp/message'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'phone': phone, 'message': message}),
//     );
//     final data = jsonDecode(res.body);
//     return data['response'] ?? 'No response';
//   }
// }





// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/models.dart';

// class ApiService {
//   static const String baseUrl = 'http://localhost:5000/api';
//   static String? _token;

//   static Future<String?> getToken() async {
//     if (_token != null) return _token;
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('auth_token');
//     return _token;
//   }

//   static Future<void> saveToken(String token) async {
//     _token = token;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', token);
//   }

//   static Future<void> clearToken() async {
//     _token = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//     await prefs.remove('user_data');
//   }

//   static Future<Map<String, String>> _headers() async {
//     final token = await getToken();
//     return {
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };
//   }

//   // ── Auth ───────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> login(String email, String password) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email, 'password': password}),
//     );
//     final data = jsonDecode(res.body);
//     if (res.statusCode == 200 && data['success'] == true) {
//       await saveToken(data['token']);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_data', jsonEncode(data['user']));
//     }
//     return data;
//   }

//   static Future<Map<String, dynamic>> register(
//       String name, String email, String phone, String password) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/register'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'name': name, 'email': email, 'phone_number': phone, 'password': password}),
//     );
//     final data = jsonDecode(res.body);
//     if (res.statusCode == 201 && data['success'] == true) {
//       await saveToken(data['token']);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_data', jsonEncode(data['user']));
//     }
//     return data;
//   }

//   // ── NEW: Get saved user data from SharedPreferences ─────────
//   static Future<Map<String, dynamic>?> getUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final data = prefs.getString('user_data');
//     if (data == null) return null;
//     return jsonDecode(data);
//   }

//   // ── Courses ────────────────────────────────────────────────
//   static Future<List<Course>> getCourses() async {
//     final res = await http.get(Uri.parse('$baseUrl/courses'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return (data['data'] as List).map((c) => Course.fromJson(c)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> createCourse(String title, String description,
//       {String category = 'General', List<String> tags = const [], int thumbnailColorIndex = 0}) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/courses'),
//       headers: await _headers(),
//       body: jsonEncode({'title': title, 'description': description,
//           'category': category, 'tags': tags, 'thumbnail_color_index': thumbnailColorIndex}),
//     );
//     return jsonDecode(res.body);
//   }

//   static Future<Map<String, dynamic>> updateCourse(String courseId,
//       {required String title, required String description, required String category,
//        required List<String> tags, required int thumbnailColorIndex}) async {
//     final res = await http.put(
//       Uri.parse('$baseUrl/courses/$courseId'),
//       headers: await _headers(),
//       body: jsonEncode({'title': title, 'description': description,
//           'category': category, 'tags': tags, 'thumbnail_color_index': thumbnailColorIndex}),
//     );
//     return jsonDecode(res.body);
//   }

//   static Future<bool> deleteCourse(String courseId) async {
//     final res = await http.delete(Uri.parse('$baseUrl/courses/$courseId'), headers: await _headers());
//     final data = jsonDecode(res.body);
//     return data['success'] == true;
//   }

//   // ── Modules ────────────────────────────────────────────────
//   static Future<List<CourseModule>> getModules(String courseId) async {
//     final res = await http.get(Uri.parse('$baseUrl/modules/$courseId'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return (data['data'] as List).map((m) => CourseModule.fromJson(m)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> createModule({
//     required String courseId, required String title, required String description,
//     String pdfLink = '', String videoLink = '', int order = 1,
//   }) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/modules'),
//       headers: await _headers(),
//       body: jsonEncode({'course_id': courseId, 'title': title, 'description': description,
//           'pdf_link': pdfLink, 'video_link': videoLink, 'order': order}),
//     );
//     return jsonDecode(res.body);
//   }

//   static Future<Map<String, dynamic>> updateModule({
//     required String moduleId, required String title, required String description,
//     String pdfLink = '', String videoLink = '',
//   }) async {
//     final res = await http.put(
//       Uri.parse('$baseUrl/modules/$moduleId'),
//       headers: await _headers(),
//       body: jsonEncode({'title': title, 'description': description,
//           'pdf_link': pdfLink, 'video_link': videoLink}),
//     );
//     return jsonDecode(res.body);
//   }

//   static Future<bool> reorderModules(String courseId, List<String> orderedIds) async {
//     final res = await http.put(
//       Uri.parse('$baseUrl/modules/$courseId/reorder'),
//       headers: await _headers(),
//       body: jsonEncode({'ordered_ids': orderedIds}),
//     );
//     final data = jsonDecode(res.body);
//     return data['success'] == true;
//   }

//   // ── Quizzes ────────────────────────────────────────────────
//   static Future<List<QuizQuestion>> getQuizzes(String courseId) async {
//     final res = await http.get(Uri.parse('$baseUrl/quizzes/$courseId'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return (data['data'] as List).map((q) => QuizQuestion.fromJson(q)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> createQuizQuestion({
//     required String courseId, required String question,
//     required Map<String, String> options, required String correctAnswer,
//   }) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/quizzes'),
//       headers: await _headers(),
//       body: jsonEncode({'course_id': courseId, 'question': question,
//           'options': options, 'correct_answer': correctAnswer}),
//     );
//     return jsonDecode(res.body);
//   }

//   // ── Quiz Submit ────────────────────────────────────────────
//   static Future<QuizSubmitResult> submitQuiz({
//     required String phoneNumber, required String learnerName,
//     required String courseId, required Map<String, String> answers,
//   }) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/quizzes/submit'),
//       headers: await _headers(),
//       body: jsonEncode({'phone_number': phoneNumber, 'learner_name': learnerName,
//           'course_id': courseId, 'answers': answers}),
//     );
//     final data = jsonDecode(res.body);
//     return QuizSubmitResult.fromJson(data['data'] ?? data);
//   }

//   // ── Leaderboard ────────────────────────────────────────────
//   static Future<List<LeaderboardEntry>> getLeaderboard(String courseId) async {
//     final res = await http.get(
//         Uri.parse('$baseUrl/quizzes/$courseId/leaderboard'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return (data['data'] as List).map((e) => LeaderboardEntry.fromJson(e)).toList();
//     }
//     return [];
//   }

//   // ── Enroll ─────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> enrollLearner({
//     required String phoneNumber, required String courseId,
//   }) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/enroll'),
//       headers: await _headers(),
//       body: jsonEncode({'phone_number': phoneNumber, 'course_id': courseId}),
//     );
//     return jsonDecode(res.body);
//   }

//   static Future<List<dynamic>> getEnrolledLearners(String courseId) async {
//     final res = await http.get(
//         Uri.parse('$baseUrl/enroll/$courseId'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return data['data'] as List;
//     }
//     return [];
//   }

//   // ── Progress ───────────────────────────────────────────────
//   static Future<List<LearnerProgress>> getAllProgress() async {
//     final res = await http.get(Uri.parse('$baseUrl/progress'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = jsonDecode(res.body);
//       return (data['data'] as List).map((p) => LearnerProgress.fromJson(p)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> getLearnerProgress(String phone) async {
//     final res = await http.get(
//         Uri.parse('$baseUrl/progress/$phone'), headers: await _headers());
//     return jsonDecode(res.body);
//   }

//   // ── WhatsApp Simulation ────────────────────────────────────
//   static Future<String> sendWhatsAppMessage(String phone, String message) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/whatsapp/message'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'phone': phone, 'message': message}),
//     );
//     final data = jsonDecode(res.body);
//     return data['response'] ?? 'No response';
//   }
// }
























// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/models.dart';

// class ApiService {
//   static const String baseUrl = 'http://localhost:5000/api';
//   static String? _token;

//   // ── Token management ───────────────────────────────────────
//   static Future<String?> getToken() async {
//     if (_token != null) return _token;
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('auth_token');
//     return _token;
//   }

//   static Future<void> saveToken(String token) async {
//     _token = token;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', token);
//   }

//   static Future<void> clearToken() async {
//     _token = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//     await prefs.remove('user_data');
//   }

//   static Future<Map<String, String>> _headers() async {
//     final token = await getToken();
//     return {
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };
//   }

//   // ── Generic HTTP methods ───────────────────────────────────
//   static Future<Map<String, dynamic>> get(String path) async {
//     final res = await http.get(
//       Uri.parse('$baseUrl$path'),
//       headers: await _headers());
//     return _decode(res);
//   }

//   static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl$path'),
//       headers: await _headers(),
//       body: jsonEncode(body));
//     return _decode(res);
//   }

//   static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
//     final res = await http.put(
//       Uri.parse('$baseUrl$path'),
//       headers: await _headers(),
//       body: jsonEncode(body));
//     return _decode(res);
//   }

//   static Future<Map<String, dynamic>> delete(String path) async {
//     final res = await http.delete(
//       Uri.parse('$baseUrl$path'),
//       headers: await _headers());
//     return _decode(res);
//   }

//   static Map<String, dynamic> _decode(http.Response res) {
//     try {
//       return jsonDecode(res.body) as Map<String, dynamic>;
//     } catch (_) {
//       return {'success': false, 'message': 'Invalid response from server'};
//     }
//   }

//   // ── Auth ───────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> login(String email, String password) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email, 'password': password}));
//     final data = _decode(res);
//     if (res.statusCode == 200 && data['success'] == true) {
//       await saveToken(data['token']);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_data', jsonEncode(data['user']));
//     }
//     return data;
//   }

//   static Future<Map<String, dynamic>> register(
//       String name, String email, String phone, String password) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/register'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'name': name, 'email': email,
//         'phone_number': phone, 'password': password}));
//     final data = _decode(res);
//     if (res.statusCode == 201 && data['success'] == true) {
//       await saveToken(data['token']);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_data', jsonEncode(data['user']));
//     }
//     return data;
//   }

//   static Future<Map<String, dynamic>?> getUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final data  = prefs.getString('user_data');
//     if (data == null) return null;
//     return jsonDecode(data) as Map<String, dynamic>;
//   }

//   // ── Courses ────────────────────────────────────────────────
//   static Future<List<Course>> getCourses() async {
//     final res = await http.get(Uri.parse('$baseUrl/courses'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = _decode(res);
//       return (data['data'] as List? ?? []).map((c) => Course.fromJson(c)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> createCourse(String title, String description,
//       {String category = 'General'}) async {
//     return post('/courses', {'title': title, 'description': description, 'category': category});
//   }

//   static Future<Map<String, dynamic>> updateCourse(String courseId,
//       {required String title, required String description, required String category}) async {
//     return put('/courses/$courseId', {'title': title, 'description': description, 'category': category});
//   }

//   static Future<bool> deleteCourse(String courseId) async {
//     final r = await delete('/courses/$courseId');
//     return r['success'] == true;
//   }

//   // ── Modules ────────────────────────────────────────────────
//   static Future<List<CourseModule>> getModules(String courseId) async {
//     final res = await http.get(
//       Uri.parse('$baseUrl/modules/$courseId'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = _decode(res);
//       return (data['data'] as List? ?? []).map((m) => CourseModule.fromJson(m)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> createModule({
//     required String courseId,
//     required String title,
//     required String description,
//     String pdfLink   = '',
//     String videoLink = '',
//     int    order     = 1,
//   }) async {
//     return post('/modules', {
//       'course_id':   courseId,
//       'title':       title,
//       'description': description,
//       'pdf_link':    pdfLink,
//       'video_link':  videoLink,
//       'order':       order,
//     });
//   }

//   static Future<Map<String, dynamic>> updateModule({
//     required String moduleId,
//     required String title,
//     required String description,
//     String pdfLink   = '',
//     String videoLink = '',
//   }) async {
//     return put('/modules/$moduleId', {
//       'title': title, 'description': description,
//       'pdf_link': pdfLink, 'video_link': videoLink,
//     });
//   }

//   // ── Quizzes ────────────────────────────────────────────────
//   static Future<List<QuizQuestion>> getQuizzes(String courseId) async {
//     final res = await http.get(
//       Uri.parse('$baseUrl/quizzes/$courseId'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = _decode(res);
//       return (data['data'] as List? ?? []).map((q) => QuizQuestion.fromJson(q)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> createQuizQuestion({
//     required String courseId,
//     required String question,
//     required Map<String, String> options,
//     required String correctAnswer,
//   }) async {
//     return post('/quizzes', {
//       'course_id': courseId, 'question': question,
//       'options': options, 'correct_answer': correctAnswer,
//     });
//   }

//   static Future<Map<String, dynamic>> deleteQuizQuestion(String questionId) async {
//     return delete('/quizzes/$questionId');
//   }

//   // ── Progress ───────────────────────────────────────────────
//   static Future<List<LearnerProgress>> getAllProgress() async {
//     final res = await http.get(Uri.parse('$baseUrl/progress'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = _decode(res);
//       return (data['data'] as List? ?? []).map((p) => LearnerProgress.fromJson(p)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> getLearnerProgress(String phone) async {
//     return get('/progress/$phone');
//   }

//   // ── Analytics ──────────────────────────────────────────────
//   static Future<Map<String, dynamic>> getDashboardStats() async {
//     return get('/analytics/dashboard');
//   }

//   static Future<List<dynamic>> getBestCourses() async {
//     final r = await get('/analytics/best-courses');
//     return r['data'] ?? [];
//   }

//   static Future<List<dynamic>> getBestEmployees() async {
//     final r = await get('/analytics/best-employees');
//     return r['data'] ?? [];
//   }

//   static Future<List<dynamic>> getAllProgressReport() async {
//     final r = await get('/analytics/all-progress');
//     return r['data'] ?? [];
//   }

//   // ── Broadcast ──────────────────────────────────────────────
//   static Future<Map<String, dynamic>> sendBroadcast({
//     required String message,
//     String filter    = 'all',
//     String courseId  = '',
//   }) async {
//     return post('/broadcast', {
//       'message':   message,
//       'filter':    filter,
//       'course_id': courseId,
//     });
//   }

//   static Future<List<dynamic>> getBroadcastLogs() async {
//     final r = await get('/broadcast/logs');
//     return r['data'] ?? [];
//   }

//   // ── Deadlines ──────────────────────────────────────────────
//   static Future<Map<String, dynamic>> createDeadline({
//     required String courseId,
//     required String title,
//     required String deadlineDate,
//     bool remind24h = true,
//     bool remind1h  = true,
//   }) async {
//     return post('/deadlines', {
//       'course_id':     courseId,
//       'title':         title,
//       'deadline_date': deadlineDate,
//       'reminder_24h':  remind24h,
//       'reminder_1h':   remind1h,
//     });
//   }

//   static Future<List<dynamic>> getDeadlines() async {
//     final r = await get('/deadlines');
//     return r['data'] ?? [];
//   }

//   static Future<bool> deleteDeadline(String id) async {
//     final r = await delete('/deadlines/$id');
//     return r['success'] == true;
//   }

//   // ── Leaderboard ────────────────────────────────────────────
//   static Future<List<LeaderboardEntry>> getLeaderboard(String courseId) async {
//     final res = await http.get(
//       Uri.parse('$baseUrl/quizzes/$courseId/leaderboard'),
//       headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = _decode(res);
//       return (data['data'] as List? ?? []).map((e) => LeaderboardEntry.fromJson(e)).toList();
//     }
//     return [];
//   }

//   // ── WhatsApp ───────────────────────────────────────────────
//   static Future<String> sendWhatsAppMessage(String phone, String message) async {
//     try {
//       final res = await http.post(
//         Uri.parse('$baseUrl/whatsapp/message'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'phone': phone, 'message': message}));
//       final data = _decode(res);
//       return data['response'] as String? ?? 'No response';
//     } catch (e) {
//       return '❌ Error: $e';
//     }
//   }

//   // ── Quiz Submit ────────────────────────────────────────────
//   static Future<QuizSubmitResult> submitQuiz({
//     required String phoneNumber,
//     required String learnerName,
//     required String courseId,
//     required Map<String, String> answers,
//   }) async {
//     final data = await post('/quizzes/submit', {
//       'phone_number': phoneNumber,
//       'learner_name': learnerName,
//       'course_id':    courseId,
//       'answers':      answers,
//     });
//     return QuizSubmitResult.fromJson(data['data'] ?? data);
//   }
// }























// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../models/models.dart';

// class ApiService {
//   static const String baseUrl = 'http://localhost:5000/api';
//   static String? _token;

//   // ── Token management ───────────────────────────────────────
//   static Future<String?> getToken() async {
//     if (_token != null) return _token;
//     final prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('auth_token');
//     return _token;
//   }

//   static Future<void> saveToken(String token) async {
//     _token = token;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', token);
//   }

//   static Future<void> clearToken() async {
//     _token = null;
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('auth_token');
//     await prefs.remove('user_data');
//   }

//   static Future<Map<String, String>> _headers() async {
//     final token = await getToken();
//     return {
//       'Content-Type': 'application/json',
//       if (token != null) 'Authorization': 'Bearer $token',
//     };
//   }

//   // ── Generic HTTP methods ───────────────────────────────────
//   static Future<Map<String, dynamic>> get(String path) async {
//     final res = await http.get(
//       Uri.parse('$baseUrl$path'),
//       headers: await _headers());
//     return _decode(res);
//   }

//   static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl$path'),
//       headers: await _headers(),
//       body: jsonEncode(body));
//     return _decode(res);
//   }

//   static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
//     final res = await http.put(
//       Uri.parse('$baseUrl$path'),
//       headers: await _headers(),
//       body: jsonEncode(body));
//     return _decode(res);
//   }

//   static Future<Map<String, dynamic>> delete(String path) async {
//     final res = await http.delete(
//       Uri.parse('$baseUrl$path'),
//       headers: await _headers());
//     return _decode(res);
//   }

//   static Map<String, dynamic> _decode(http.Response res) {
//     try {
//       return jsonDecode(res.body) as Map<String, dynamic>;
//     } catch (_) {
//       return {'success': false, 'message': 'Invalid response from server'};
//     }
//   }

//   // ── Auth ───────────────────────────────────────────────────
//   static Future<Map<String, dynamic>> login(String email, String password) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/login'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'email': email, 'password': password}));
//     final data = _decode(res);
//     if (res.statusCode == 200 && data['success'] == true) {
//       await saveToken(data['token']);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_data', jsonEncode(data['user']));
//     }
//     return data;
//   }

//   static Future<Map<String, dynamic>> register(
//       String name, String email, String phone, String password) async {
//     final res = await http.post(
//       Uri.parse('$baseUrl/register'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'name': name, 'email': email,
//         'phone_number': phone, 'password': password}));
//     final data = _decode(res);
//     if (res.statusCode == 201 && data['success'] == true) {
//       await saveToken(data['token']);
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('user_data', jsonEncode(data['user']));
//     }
//     return data;
//   }

//   static Future<Map<String, dynamic>?> getUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final data  = prefs.getString('user_data');
//     if (data == null) return null;
//     return jsonDecode(data) as Map<String, dynamic>;
//   }

//   // ── Courses ────────────────────────────────────────────────
//   static Future<List<Course>> getCourses() async {
//     final res = await http.get(Uri.parse('$baseUrl/courses'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = _decode(res);
//       return (data['data'] as List? ?? []).map((c) => Course.fromJson(c)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> createCourse(String title, String description,
//       {String category = 'General',
//        List<String> tags = const [],
//        int thumbnailColorIndex = 0}) async {
//     return post('/courses', {
//       'title': title, 'description': description,
//       'category': category, 'tags': tags,
//       'thumbnail_color_index': thumbnailColorIndex,
//     });
//   }

//   static Future<Map<String, dynamic>> updateCourse(String courseId,
//       {required String title,
//        required String description,
//        required String category,
//        List<String> tags = const [],
//        int thumbnailColorIndex = 0}) async {
//     return put('/courses/$courseId', {
//       'title': title, 'description': description,
//       'category': category, 'tags': tags,
//       'thumbnail_color_index': thumbnailColorIndex,
//     });
//   }

//   static Future<bool> deleteCourse(String courseId) async {
//     final r = await delete('/courses/$courseId');
//     return r['success'] == true;
//   }

//   // ── Modules ────────────────────────────────────────────────
//   static Future<List<CourseModule>> getModules(String courseId) async {
//     final res = await http.get(
//       Uri.parse('$baseUrl/modules/$courseId'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = _decode(res);
//       return (data['data'] as List? ?? []).map((m) => CourseModule.fromJson(m)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> createModule({
//     required String courseId,
//     required String title,
//     required String description,
//     String pdfLink   = '',
//     String videoLink = '',
//     int    order     = 1,
//   }) async {
//     return post('/modules', {
//       'course_id':   courseId,
//       'title':       title,
//       'description': description,
//       'pdf_link':    pdfLink,
//       'video_link':  videoLink,
//       'order':       order,
//     });
//   }

//   static Future<Map<String, dynamic>> updateModule({
//     required String moduleId,
//     required String title,
//     required String description,
//     String pdfLink   = '',
//     String videoLink = '',
//   }) async {
//     return put('/modules/$moduleId', {
//       'title': title, 'description': description,
//       'pdf_link': pdfLink, 'video_link': videoLink,
//     });
//   }

//   static Future<bool> reorderModules(String courseId, List<String> orderedIds) async {
//     final r = await put('/modules/$courseId/reorder', {'ordered_ids': orderedIds});
//     return r['success'] == true;
//   }

//   // ── Quizzes ────────────────────────────────────────────────
//   static Future<List<QuizQuestion>> getQuizzes(String courseId) async {
//     final res = await http.get(
//       Uri.parse('$baseUrl/quizzes/$courseId'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = _decode(res);
//       return (data['data'] as List? ?? []).map((q) => QuizQuestion.fromJson(q)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> createQuizQuestion({
//     required String courseId,
//     required String question,
//     required Map<String, String> options,
//     required String correctAnswer,
//   }) async {
//     return post('/quizzes', {
//       'course_id': courseId, 'question': question,
//       'options': options, 'correct_answer': correctAnswer,
//     });
//   }

//   static Future<Map<String, dynamic>> deleteQuizQuestion(String questionId) async {
//     return delete('/quizzes/$questionId');
//   }

//   // ── Progress ───────────────────────────────────────────────
//   static Future<List<LearnerProgress>> getAllProgress() async {
//     final res = await http.get(Uri.parse('$baseUrl/progress'), headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = _decode(res);
//       return (data['data'] as List? ?? []).map((p) => LearnerProgress.fromJson(p)).toList();
//     }
//     return [];
//   }

//   static Future<Map<String, dynamic>> getLearnerProgress(String phone) async {
//     return get('/progress/$phone');
//   }

//   // ── Analytics ──────────────────────────────────────────────
//   static Future<Map<String, dynamic>> getDashboardStats() async {
//     return get('/analytics/dashboard');
//   }

//   static Future<List<dynamic>> getBestCourses() async {
//     final r = await get('/analytics/best-courses');
//     return r['data'] ?? [];
//   }

//   static Future<List<dynamic>> getBestEmployees() async {
//     final r = await get('/analytics/best-employees');
//     return r['data'] ?? [];
//   }

//   static Future<List<dynamic>> getAllProgressReport() async {
//     final r = await get('/analytics/all-progress');
//     return r['data'] ?? [];
//   }

//   // ── Broadcast ──────────────────────────────────────────────
//   static Future<Map<String, dynamic>> sendBroadcast({
//     required String message,
//     String filter    = 'all',
//     String courseId  = '',
//   }) async {
//     return post('/broadcast', {
//       'message':   message,
//       'filter':    filter,
//       'course_id': courseId,
//     });
//   }

//   static Future<List<dynamic>> getBroadcastLogs() async {
//     final r = await get('/broadcast/logs');
//     return r['data'] ?? [];
//   }

//   // ── Deadlines ──────────────────────────────────────────────
//   static Future<Map<String, dynamic>> createDeadline({
//     required String courseId,
//     required String title,
//     required String deadlineDate,
//     bool remind24h = true,
//     bool remind1h  = true,
//   }) async {
//     return post('/deadlines', {
//       'course_id':     courseId,
//       'title':         title,
//       'deadline_date': deadlineDate,
//       'reminder_24h':  remind24h,
//       'reminder_1h':   remind1h,
//     });
//   }

//   static Future<List<dynamic>> getDeadlines() async {
//     final r = await get('/deadlines');
//     return r['data'] ?? [];
//   }

//   static Future<bool> deleteDeadline(String id) async {
//     final r = await delete('/deadlines/$id');
//     return r['success'] == true;
//   }

//   // ── Leaderboard ────────────────────────────────────────────
//   static Future<List<LeaderboardEntry>> getLeaderboard(String courseId) async {
//     final res = await http.get(
//       Uri.parse('$baseUrl/quizzes/$courseId/leaderboard'),
//       headers: await _headers());
//     if (res.statusCode == 200) {
//       final data = _decode(res);
//       return (data['data'] as List? ?? []).map((e) => LeaderboardEntry.fromJson(e)).toList();
//     }
//     return [];
//   }

//   // ── WhatsApp ───────────────────────────────────────────────
//   static Future<String> sendWhatsAppMessage(String phone, String message) async {
//     try {
//       final res = await http.post(
//         Uri.parse('$baseUrl/whatsapp/message'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'phone': phone, 'message': message}));
//       final data = _decode(res);
//       return data['response'] as String? ?? 'No response';
//     } catch (e) {
//       return '❌ Error: $e';
//     }
//   }

//   // ── Quiz Submit ────────────────────────────────────────────
//   static Future<QuizSubmitResult> submitQuiz({
//     required String phoneNumber,
//     required String learnerName,
//     required String courseId,
//     required Map<String, String> answers,
//   }) async {
//     final data = await post('/quizzes/submit', {
//       'phone_number': phoneNumber,
//       'learner_name': learnerName,
//       'course_id':    courseId,
//       'answers':      answers,
//     });
//     return QuizSubmitResult.fromJson(data['data'] ?? data);
//   }
// }































import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api';
  static String? _token;

  // ── Token management ───────────────────────────────────────
  static Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  static Future<void> saveToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  static Future<Map<String, String>> _headers() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ── Generic HTTP methods ───────────────────────────────────
  static Future<Map<String, dynamic>> get(String path) async {
    final res = await http.get(
      Uri.parse('$baseUrl$path'),
      headers: await _headers());
    return _decode(res);
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final res = await http.post(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body));
    return _decode(res);
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> body) async {
    final res = await http.put(
      Uri.parse('$baseUrl$path'),
      headers: await _headers(),
      body: jsonEncode(body));
    return _decode(res);
  }

  static Future<Map<String, dynamic>> delete(String path) async {
    final res = await http.delete(
      Uri.parse('$baseUrl$path'),
      headers: await _headers());
    return _decode(res);
  }

  static Map<String, dynamic> _decode(http.Response res) {
    try {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      return {'success': false, 'message': 'Invalid response from server'};
    }
  }

  // ── Auth ───────────────────────────────────────────────────
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}));
    final data = _decode(res);
    if (res.statusCode == 200 && data['success'] == true) {
      await saveToken(data['token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(data['user']));
    }
    return data;
  }

  static Future<Map<String, dynamic>> register(
      String name, String email, String phone, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email,
        'phone_number': phone, 'password': password}));
    final data = _decode(res);
    if (res.statusCode == 201 && data['success'] == true) {
      await saveToken(data['token']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(data['user']));
    }
    return data;
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final data  = prefs.getString('user_data');
    if (data == null) return null;
    return jsonDecode(data) as Map<String, dynamic>;
  }

  // ── Courses ────────────────────────────────────────────────
  static Future<List<Course>> getCourses() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/courses'), headers: await _headers());
      final data = _decode(res);
      final list = data['data'] as List? ?? data['courses'] as List? ?? [];
      return list.map((c) {
        try { return Course.fromJson(c as Map<String, dynamic>); }
        catch (_) { return null; }
      }).whereType<Course>().toList();
    } catch (_) { return []; }
  }

  static Future<Map<String, dynamic>> createCourse(String title, String description,
      {String category = 'General',
       List<String> tags = const [],
       int thumbnailColorIndex = 0}) async {
    return post('/courses', {
      'title': title, 'description': description,
      'category': category, 'tags': tags,
      'thumbnail_color_index': thumbnailColorIndex,
    });
  }

  static Future<Map<String, dynamic>> updateCourse(String courseId,
      {required String title,
       required String description,
       required String category,
       List<String> tags = const [],
       int thumbnailColorIndex = 0}) async {
    return put('/courses/$courseId', {
      'title': title, 'description': description,
      'category': category, 'tags': tags,
      'thumbnail_color_index': thumbnailColorIndex,
    });
  }

  static Future<bool> deleteCourse(String courseId) async {
    final r = await delete('/courses/$courseId');
    return r['success'] == true;
  }

  // ── Modules ────────────────────────────────────────────────
  static Future<List<CourseModule>> getModules(String courseId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/modules/$courseId'), headers: await _headers());
    if (res.statusCode == 200) {
      final data = _decode(res);
      return (data['data'] as List? ?? []).map((m) => CourseModule.fromJson(m)).toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>> createModule({
    required String courseId,
    required String title,
    required String description,
    String pdfLink   = '',
    String videoLink = '',
    int    order     = 1,
  }) async {
    return post('/modules', {
      'course_id':   courseId,
      'title':       title,
      'description': description,
      'pdf_link':    pdfLink,
      'video_link':  videoLink,
      'order':       order,
    });
  }

  static Future<Map<String, dynamic>> updateModule({
    required String moduleId,
    required String title,
    required String description,
    String pdfLink   = '',
    String videoLink = '',
  }) async {
    return put('/modules/$moduleId', {
      'title': title, 'description': description,
      'pdf_link': pdfLink, 'video_link': videoLink,
    });
  }

  static Future<bool> reorderModules(String courseId, List<String> orderedIds) async {
    final r = await put('/modules/$courseId/reorder', {'ordered_ids': orderedIds});
    return r['success'] == true;
  }

  // ── Quizzes ────────────────────────────────────────────────
  static Future<List<QuizQuestion>> getQuizzes(String courseId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/quizzes/$courseId'), headers: await _headers());
    if (res.statusCode == 200) {
      final data = _decode(res);
      return (data['data'] as List? ?? []).map((q) => QuizQuestion.fromJson(q)).toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>> createQuizQuestion({
    required String courseId,
    required String question,
    required Map<String, String> options,
    required String correctAnswer,
  }) async {
    return post('/quizzes', {
      'course_id': courseId, 'question': question,
      'options': options, 'correct_answer': correctAnswer,
    });
  }

  static Future<Map<String, dynamic>> deleteQuizQuestion(String questionId) async {
    return delete('/quizzes/$questionId');
  }

  // ── Progress ───────────────────────────────────────────────
  static Future<List<LearnerProgress>> getAllProgress() async {
    final res = await http.get(Uri.parse('$baseUrl/progress'), headers: await _headers());
    if (res.statusCode == 200) {
      final data = _decode(res);
      return (data['data'] as List? ?? []).map((p) => LearnerProgress.fromJson(p)).toList();
    }
    return [];
  }

  static Future<Map<String, dynamic>> getLearnerProgress(String phone) async {
    return get('/progress/$phone');
  }

  // ── Analytics ──────────────────────────────────────────────
  static Future<Map<String, dynamic>> getDashboardStats() async {
    return get('/analytics/dashboard');
  }

  static Future<List<dynamic>> getBestCourses() async {
    final r = await get('/analytics/best-courses');
    return r['data'] ?? [];
  }

  static Future<List<dynamic>> getBestEmployees() async {
    final r = await get('/analytics/best-employees');
    return r['data'] ?? [];
  }

  static Future<List<dynamic>> getAllProgressReport() async {
    final r = await get('/analytics/all-progress');
    return r['data'] ?? [];
  }

  // ── Broadcast ──────────────────────────────────────────────
  static Future<Map<String, dynamic>> sendBroadcast({
    required String message,
    String filter    = 'all',
    String courseId  = '',
  }) async {
    return post('/broadcast', {
      'message':   message,
      'filter':    filter,
      'course_id': courseId,
    });
  }

  static Future<List<dynamic>> getBroadcastLogs() async {
    final r = await get('/broadcast/logs');
    return r['data'] ?? [];
  }

  // ── Deadlines ──────────────────────────────────────────────
  static Future<Map<String, dynamic>> createDeadline({
    required String courseId,
    required String title,
    required String deadlineDate,
    bool remind24h = true,
    bool remind1h  = true,
  }) async {
    return post('/deadlines', {
      'course_id':     courseId,
      'title':         title,
      'deadline_date': deadlineDate,
      'reminder_24h':  remind24h,
      'reminder_1h':   remind1h,
    });
  }

  static Future<List<dynamic>> getDeadlines() async {
    final r = await get('/deadlines');
    return r['data'] ?? [];
  }

  static Future<bool> deleteDeadline(String id) async {
    final r = await delete('/deadlines/$id');
    return r['success'] == true;
  }

  // ── Leaderboard ────────────────────────────────────────────
  static Future<List<LeaderboardEntry>> getLeaderboard(String courseId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/quizzes/$courseId/leaderboard'),
      headers: await _headers());
    if (res.statusCode == 200) {
      final data = _decode(res);
      return (data['data'] as List? ?? []).map((e) => LeaderboardEntry.fromJson(e)).toList();
    }
    return [];
  }

  // ── WhatsApp ───────────────────────────────────────────────
  static Future<String> sendWhatsAppMessage(String phone, String message) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/whatsapp/message'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'message': message}));
      final data = _decode(res);
      return data['response'] as String? ?? 'No response';
    } catch (e) {
      return '❌ Error: $e';
    }
  }

  // ── Quiz Submit ────────────────────────────────────────────
  static Future<QuizSubmitResult> submitQuiz({
    required String phoneNumber,
    required String learnerName,
    required String courseId,
    required Map<String, String> answers,
  }) async {
    final data = await post('/quizzes/submit', {
      'phone_number': phoneNumber,
      'learner_name': learnerName,
      'course_id':    courseId,
      'answers':      answers,
    });
    return QuizSubmitResult.fromJson(data['data'] ?? data);
  }
}