// // ── Course Model ──────────────────────────────────────────────
// class Course {
//   final String id;
//   final String title;
//   final String description;
//   final String facilitatorName;
//   final DateTime createdAt;
//   final String category;
//   final List<String> tags;
//   final int thumbnailColorIndex;

//   Course({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.facilitatorName,
//     required this.createdAt,
//     this.category = 'General',
//     this.tags = const [],
//     this.thumbnailColorIndex = 0,
//   });

//   factory Course.fromJson(Map<String, dynamic> json) {
//     return Course(
//       id: json['_id'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       facilitatorName: json['facilitator']?['name'] ?? 'Unknown',
//       createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
//       category: json['category'] ?? 'General',
//       tags: (json['tags'] as List<dynamic>?)?.map((t) => t.toString()).toList() ?? [],
//       thumbnailColorIndex: json['thumbnail_color_index'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'title': title, 'description': description,
//         'category': category, 'tags': tags,
//         'thumbnail_color_index': thumbnailColorIndex,
//       };

//   Course copyWith({String? title, String? description, String? category,
//       List<String>? tags, int? thumbnailColorIndex}) {
//     return Course(
//       id: id, facilitatorName: facilitatorName, createdAt: createdAt,
//       title: title ?? this.title, description: description ?? this.description,
//       category: category ?? this.category, tags: tags ?? this.tags,
//       thumbnailColorIndex: thumbnailColorIndex ?? this.thumbnailColorIndex,
//     );
//   }
// }

// // ── Module Model ──────────────────────────────────────────────
// class CourseModule {
//   final String id;
//   final String courseId;
//   final String title;
//   final String description;
//   final String pdfLink;
//   final String videoLink;
//   final int order;

//   CourseModule({
//     required this.id, required this.courseId, required this.title,
//     required this.description, required this.pdfLink,
//     required this.videoLink, required this.order,
//   });

//   factory CourseModule.fromJson(Map<String, dynamic> json) {
//     return CourseModule(
//       id: json['_id'] ?? '', courseId: json['course_id'] ?? '',
//       title: json['title'] ?? '', description: json['description'] ?? '',
//       pdfLink: json['pdf_link'] ?? '', videoLink: json['video_link'] ?? '',
//       order: json['order'] ?? 1,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'title': title, 'description': description,
//         'pdf_link': pdfLink, 'video_link': videoLink, 'order': order,
//       };

//   CourseModule copyWith({String? title, String? description,
//       String? pdfLink, String? videoLink, int? order}) {
//     return CourseModule(
//       id: id, courseId: courseId,
//       title: title ?? this.title, description: description ?? this.description,
//       pdfLink: pdfLink ?? this.pdfLink, videoLink: videoLink ?? this.videoLink,
//       order: order ?? this.order,
//     );
//   }
// }

// // ── Quiz Question Model ───────────────────────────────────────
// class QuizQuestion {
//   final String id;
//   final String courseId;
//   final String question;
//   final Map<String, String> options;
//   final String correctAnswer;

//   QuizQuestion({
//     required this.id, required this.courseId, required this.question,
//     required this.options, required this.correctAnswer,
//   });

//   factory QuizQuestion.fromJson(Map<String, dynamic> json) {
//     return QuizQuestion(
//       id: json['_id'] ?? '', courseId: json['course_id'] ?? '',
//       question: json['question'] ?? '',
//       options: {
//         'A': json['options']?['A'] ?? '', 'B': json['options']?['B'] ?? '',
//         'C': json['options']?['C'] ?? '', 'D': json['options']?['D'] ?? '',
//       },
//       correctAnswer: json['correct_answer'] ?? 'A',
//     );
//   }
// }

// // ── Learner Progress Model ────────────────────────────────────
// class LearnerProgress {
//   final String name;
//   final String phoneNumber;
//   final int coursesTaken;
//   final int quizzesTaken;
//   final int averageScore;
//   final int modulesCompleted;

//   LearnerProgress({
//     required this.name, required this.phoneNumber, required this.coursesTaken,
//     required this.quizzesTaken, required this.averageScore, required this.modulesCompleted,
//   });

//   factory LearnerProgress.fromJson(Map<String, dynamic> json) {
//     return LearnerProgress(
//       name: json['name'] ?? 'Learner',
//       phoneNumber: json['phone_number'] ?? '',
//       coursesTaken: json['courses_taken'] ?? 0,
//       quizzesTaken: json['quizzes_taken'] ?? 0,
//       averageScore: json['average_score'] ?? 0,
//       modulesCompleted: json['modules_completed'] ?? 0,
//     );
//   }
// }

// // ── Dashboard Stats Model ─────────────────────────────────────
// class DashboardStats {
//   final int totalLearners;
//   final int totalCourses;
//   final int totalQuizzesTaken;
//   final int averageScore;

//   DashboardStats({
//     required this.totalLearners, required this.totalCourses,
//     required this.totalQuizzesTaken, required this.averageScore,
//   });
// }

// // ── Quiz Answer Review ────────────────────────────────────────
// class QuizAnswerReview {
//   final String question;
//   final Map<String, String> options;
//   final String correctAnswer;
//   final String? learnerAnswer;
//   final bool isCorrect;

//   QuizAnswerReview({
//     required this.question, required this.options, required this.correctAnswer,
//     this.learnerAnswer, required this.isCorrect,
//   });

//   factory QuizAnswerReview.fromJson(Map<String, dynamic> json) {
//     return QuizAnswerReview(
//       question: json['question'] ?? '',
//       options: {
//         'A': json['options']?['A'] ?? '', 'B': json['options']?['B'] ?? '',
//         'C': json['options']?['C'] ?? '', 'D': json['options']?['D'] ?? '',
//       },
//       correctAnswer: json['correct_answer'] ?? 'A',
//       learnerAnswer: json['learner_answer'],
//       isCorrect: json['is_correct'] == true,
//     );
//   }
// }

// // ── Quiz Submit Result ────────────────────────────────────────
// class QuizSubmitResult {
//   final int score;
//   final int correctAnswers;
//   final int totalQuestions;
//   final int attemptNumber;
//   final List<QuizAnswerReview> review;

//   QuizSubmitResult({
//     required this.score, required this.correctAnswers,
//     required this.totalQuestions, required this.attemptNumber,
//     required this.review,
//   });

//   factory QuizSubmitResult.fromJson(Map<String, dynamic> json) {
//     return QuizSubmitResult(
//       score: json['score'] ?? 0,
//       correctAnswers: json['correct_answers'] ?? 0,
//       totalQuestions: json['total_questions'] ?? 0,
//       attemptNumber: json['attempt_number'] ?? 1,
//       review: (json['review'] as List<dynamic>? ?? [])
//           .map((r) => QuizAnswerReview.fromJson(r))
//           .toList(),
//     );
//   }
// }

// // ── Leaderboard Entry ─────────────────────────────────────────
// class LeaderboardEntry {
//   final String learnerName;
//   final String phoneNumber;
//   final int bestScore;
//   final int totalAttempts;

//   LeaderboardEntry({
//     required this.learnerName, required this.phoneNumber,
//     required this.bestScore, required this.totalAttempts,
//   });

//   factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
//     return LeaderboardEntry(
//       learnerName: json['learner_name'] ?? 'Learner',
//       phoneNumber: json['phone_number'] ?? '',
//       bestScore: json['best_score'] ?? 0,
//       totalAttempts: json['total_attempts'] ?? 1,
//     );
//   }
// }













// // ── Course Model ──────────────────────────────────────────────
// class Course {
//   final String id;
//   final String title;
//   final String description;
//   final String facilitatorName;
//   final DateTime createdAt;
//   final String category;
//   final List<String> tags;
//   final int thumbnailColorIndex;

//   Course({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.facilitatorName,
//     required this.createdAt,
//     this.category = 'General',
//     this.tags = const [],
//     this.thumbnailColorIndex = 0,
//   });

//   factory Course.fromJson(Map<String, dynamic> json) {
//     return Course(
//       id: json['_id'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       facilitatorName: json['facilitator']?['name'] ?? 'Unknown',
//       createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
//       category: json['category'] ?? 'General',
//       tags: (json['tags'] as List<dynamic>?)
//               ?.map((t) => t.toString())
//               .toList() ?? [],
//       thumbnailColorIndex: json['thumbnail_color_index'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'title': title,
//         'description': description,
//         'category': category,
//         'tags': tags,
//         'thumbnail_color_index': thumbnailColorIndex,
//       };

//   Course copyWith({
//     String? title, String? description, String? category,
//     List<String>? tags, int? thumbnailColorIndex,
//   }) {
//     return Course(
//       id: id, facilitatorName: facilitatorName, createdAt: createdAt,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       category: category ?? this.category,
//       tags: tags ?? this.tags,
//       thumbnailColorIndex: thumbnailColorIndex ?? this.thumbnailColorIndex,
//     );
//   }
// }

// // ── Module Model ──────────────────────────────────────────────
// class CourseModule {
//   final String id;
//   final String courseId;
//   final String title;
//   final String description;
//   final String pdfLink;
//   final String videoLink;
//   final int order;

//   CourseModule({
//     required this.id, required this.courseId, required this.title,
//     required this.description, required this.pdfLink,
//     required this.videoLink, required this.order,
//   });

//   factory CourseModule.fromJson(Map<String, dynamic> json) {
//     return CourseModule(
//       id: json['_id'] ?? '',
//       courseId: json['course_id'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       pdfLink: json['pdf_link'] ?? '',
//       videoLink: json['video_link'] ?? '',
//       order: json['order'] ?? 1,
//     );
//   }

//   CourseModule copyWith({
//     String? title, String? description, String? pdfLink,
//     String? videoLink, int? order,
//   }) {
//     return CourseModule(
//       id: id, courseId: courseId,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       pdfLink: pdfLink ?? this.pdfLink,
//       videoLink: videoLink ?? this.videoLink,
//       order: order ?? this.order,
//     );
//   }
// }

// // ── Quiz Question Model ───────────────────────────────────────
// class QuizQuestion {
//   final String id;
//   final String courseId;
//   final String question;
//   final Map<String, String> options;
//   final String correctAnswer;

//   QuizQuestion({
//     required this.id, required this.courseId, required this.question,
//     required this.options, required this.correctAnswer,
//   });

//   factory QuizQuestion.fromJson(Map<String, dynamic> json) {
//     return QuizQuestion(
//       id: json['_id'] ?? '',
//       courseId: json['course_id'] ?? '',
//       question: json['question'] ?? '',
//       options: {
//         'A': json['options']?['A'] ?? '',
//         'B': json['options']?['B'] ?? '',
//         'C': json['options']?['C'] ?? '',
//         'D': json['options']?['D'] ?? '',
//       },
//       correctAnswer: json['correct_answer'] ?? 'A',
//     );
//   }
// }

// // ── Course Detail (nested inside LearnerProgress) ─────────────
// class CourseDetail {
//   final String courseTitle;
//   final int modulesCompleted;
//   final int totalModules;
//   final int completionPct;
//   final int? quizScore;
//   final String? currentModule;
//   final DateTime? lastActive;
//   final DateTime? enrolledAt;

//   CourseDetail({
//     required this.courseTitle,
//     required this.modulesCompleted,
//     required this.totalModules,
//     required this.completionPct,
//     this.quizScore,
//     this.currentModule,
//     this.lastActive,
//     this.enrolledAt,
//   });

//   factory CourseDetail.fromJson(Map<String, dynamic> json) {
//     return CourseDetail(
//       courseTitle:      json['course_title'] ?? '',
//       modulesCompleted: json['modules_completed'] ?? 0,
//       totalModules:     json['total_modules'] ?? 0,
//       completionPct:    json['completion_pct'] ?? 0,
//       quizScore:        json['quiz_score'],
//       currentModule:    json['current_module'],
//       lastActive: json['last_active'] != null
//           ? DateTime.tryParse(json['last_active']) : null,
//       enrolledAt: json['enrolled_at'] != null
//           ? DateTime.tryParse(json['enrolled_at']) : null,
//     );
//   }
// }

// // ── Learner Progress Model ────────────────────────────────────
// class LearnerProgress {
//   final String name;
//   final String phoneNumber;
//   final String employeeId;
//   final String department;
//   final String jobRole;
//   final int coursesTaken;
//   final int quizzesTaken;
//   final int averageScore;
//   final int modulesCompleted;
//   final List<CourseDetail> coursesDetail;
//   final DateTime? joinedAt;

//   LearnerProgress({
//     required this.name,
//     required this.phoneNumber,
//     this.employeeId = '',
//     this.department = '',
//     this.jobRole = '',
//     required this.coursesTaken,
//     required this.quizzesTaken,
//     required this.averageScore,
//     required this.modulesCompleted,
//     this.coursesDetail = const [],
//     this.joinedAt,
//   });

//   factory LearnerProgress.fromJson(Map<String, dynamic> json) {
//     return LearnerProgress(
//       name:             json['name'] ?? 'Learner',
//       phoneNumber:      json['phone_number'] ?? '',
//       employeeId:       json['employee_id'] ?? '',
//       department:       json['department'] ?? '',
//       jobRole:          json['job_role'] ?? '',
//       coursesTaken:     json['courses_taken'] ?? 0,
//       quizzesTaken:     json['quizzes_taken'] ?? 0,
//       averageScore:     json['average_score'] ?? 0,
//       modulesCompleted: json['modules_completed'] ?? 0,
//       coursesDetail:    (json['courses_detail'] as List<dynamic>? ?? [])
//           .map((c) => CourseDetail.fromJson(c)).toList(),
//       joinedAt: json['joined_at'] != null
//           ? DateTime.tryParse(json['joined_at']) : null,
//     );
//   }
// }

// // ── Dashboard Stats Model ─────────────────────────────────────
// class DashboardStats {
//   final int totalLearners;
//   final int totalCourses;
//   final int totalQuizzesTaken;
//   final int averageScore;

//   DashboardStats({
//     required this.totalLearners,
//     required this.totalCourses,
//     required this.totalQuizzesTaken,
//     required this.averageScore,
//   });
// }













// // ── Course Model ──────────────────────────────────────────────
// class Course {
//   final String id;
//   final String title;
//   final String description;
//   final String facilitatorName;
//   final DateTime createdAt;
//   final String category;
//   final List<String> tags;
//   final int thumbnailColorIndex;

//   Course({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.facilitatorName,
//     required this.createdAt,
//     this.category = 'General',
//     this.tags = const [],
//     this.thumbnailColorIndex = 0,
//   });

//   factory Course.fromJson(Map<String, dynamic> json) {
//     return Course(
//       id: json['_id'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       facilitatorName: json['facilitator']?['name'] ?? 'Unknown',
//       createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
//       category: json['category'] ?? 'General',
//       tags: (json['tags'] as List<dynamic>?)
//               ?.map((t) => t.toString())
//               .toList() ?? [],
//       thumbnailColorIndex: json['thumbnail_color_index'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'title': title,
//         'description': description,
//         'category': category,
//         'tags': tags,
//         'thumbnail_color_index': thumbnailColorIndex,
//       };

//   Course copyWith({
//     String? title, String? description, String? category,
//     List<String>? tags, int? thumbnailColorIndex,
//   }) {
//     return Course(
//       id: id, facilitatorName: facilitatorName, createdAt: createdAt,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       category: category ?? this.category,
//       tags: tags ?? this.tags,
//       thumbnailColorIndex: thumbnailColorIndex ?? this.thumbnailColorIndex,
//     );
//   }
// }

// // ── Module Model ──────────────────────────────────────────────
// class CourseModule {
//   final String id;
//   final String courseId;
//   final String title;
//   final String description;
//   final String pdfLink;
//   final String videoLink;
//   final int order;

//   CourseModule({
//     required this.id, required this.courseId, required this.title,
//     required this.description, required this.pdfLink,
//     required this.videoLink, required this.order,
//   });

//   factory CourseModule.fromJson(Map<String, dynamic> json) {
//     return CourseModule(
//       id: json['_id'] ?? '',
//       courseId: json['course_id'] ?? '',
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       pdfLink: json['pdf_link'] ?? '',
//       videoLink: json['video_link'] ?? '',
//       order: json['order'] ?? 1,
//     );
//   }

//   CourseModule copyWith({
//     String? title, String? description, String? pdfLink,
//     String? videoLink, int? order,
//   }) {
//     return CourseModule(
//       id: id, courseId: courseId,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       pdfLink: pdfLink ?? this.pdfLink,
//       videoLink: videoLink ?? this.videoLink,
//       order: order ?? this.order,
//     );
//   }
// }

// // ── Quiz Question Model ───────────────────────────────────────
// class QuizQuestion {
//   final String id;
//   final String courseId;
//   final String question;
//   final Map<String, String> options;
//   final String correctAnswer;

//   QuizQuestion({
//     required this.id, required this.courseId, required this.question,
//     required this.options, required this.correctAnswer,
//   });

//   factory QuizQuestion.fromJson(Map<String, dynamic> json) {
//     return QuizQuestion(
//       id: json['_id'] ?? '',
//       courseId: json['course_id'] ?? '',
//       question: json['question'] ?? '',
//       options: {
//         'A': json['options']?['A'] ?? '',
//         'B': json['options']?['B'] ?? '',
//         'C': json['options']?['C'] ?? '',
//         'D': json['options']?['D'] ?? '',
//       },
//       correctAnswer: json['correct_answer'] ?? 'A',
//     );
//   }
// }

// // ── Course Detail (nested inside LearnerProgress) ─────────────
// class CourseDetail {
//   final String courseTitle;
//   final int modulesCompleted;
//   final int totalModules;
//   final int completionPct;
//   final int? quizScore;
//   final String? currentModule;
//   final DateTime? lastActive;
//   final DateTime? enrolledAt;

//   CourseDetail({
//     required this.courseTitle,
//     required this.modulesCompleted,
//     required this.totalModules,
//     required this.completionPct,
//     this.quizScore,
//     this.currentModule,
//     this.lastActive,
//     this.enrolledAt,
//   });

//   factory CourseDetail.fromJson(Map<String, dynamic> json) {
//     return CourseDetail(
//       courseTitle:      json['course_title'] ?? '',
//       modulesCompleted: json['modules_completed'] ?? 0,
//       totalModules:     json['total_modules'] ?? 0,
//       completionPct:    json['completion_pct'] ?? 0,
//       quizScore:        json['quiz_score'],
//       currentModule:    json['current_module'],
//       lastActive: json['last_active'] != null
//           ? DateTime.tryParse(json['last_active']) : null,
//       enrolledAt: json['enrolled_at'] != null
//           ? DateTime.tryParse(json['enrolled_at']) : null,
//     );
//   }
// }

// // ── Learner Progress Model ────────────────────────────────────
// class LearnerProgress {
//   final String name;
//   final String phoneNumber;
//   final String employeeId;
//   final String department;
//   final String jobRole;
//   final int coursesTaken;
//   final int quizzesTaken;
//   final int averageScore;
//   final int modulesCompleted;
//   final List<CourseDetail> coursesDetail;
//   final DateTime? joinedAt;

//   LearnerProgress({
//     required this.name,
//     required this.phoneNumber,
//     this.employeeId = '',
//     this.department = '',
//     this.jobRole = '',
//     required this.coursesTaken,
//     required this.quizzesTaken,
//     required this.averageScore,
//     required this.modulesCompleted,
//     this.coursesDetail = const [],
//     this.joinedAt,
//   });

//   factory LearnerProgress.fromJson(Map<String, dynamic> json) {
//     return LearnerProgress(
//       name:             json['name'] ?? 'Learner',
//       phoneNumber:      json['phone_number'] ?? '',
//       employeeId:       json['employee_id'] ?? '',
//       department:       json['department'] ?? '',
//       jobRole:          json['job_role'] ?? '',
//       coursesTaken:     json['courses_taken'] ?? 0,
//       quizzesTaken:     json['quizzes_taken'] ?? 0,
//       averageScore:     json['average_score'] ?? 0,
//       modulesCompleted: json['modules_completed'] ?? 0,
//       coursesDetail:    (json['courses_detail'] as List<dynamic>? ?? [])
//           .map((c) => CourseDetail.fromJson(c)).toList(),
//       joinedAt: json['joined_at'] != null
//           ? DateTime.tryParse(json['joined_at']) : null,
//     );
//   }
// }

// // ── Dashboard Stats Model ─────────────────────────────────────
// class DashboardStats {
//   final int totalLearners;
//   final int totalCourses;
//   final int totalQuizzesTaken;
//   final int averageScore;

//   DashboardStats({
//     required this.totalLearners,
//     required this.totalCourses,
//     required this.totalQuizzesTaken,
//     required this.averageScore,
//   });
// }

// // ── Quiz Submit Result Model ──────────────────────────────────
// class QuizSubmitResult {
//   final String courseId;
//   final int score;
//   final int totalQuestions;
//   final int correctAnswers;
//   final String feedback;

//   QuizSubmitResult({
//     required this.courseId,
//     required this.score,
//     required this.totalQuestions,
//     required this.correctAnswers,
//     required this.feedback,
//   });

//   factory QuizSubmitResult.fromJson(Map<String, dynamic> json) {
//     return QuizSubmitResult(
//       courseId:       json['course_id'] ?? '',
//       score:          json['score'] ?? 0,
//       totalQuestions: json['total_questions'] ?? 0,
//       correctAnswers: json['correct_answers'] ?? 0,
//       feedback:       json['feedback'] ?? '',
//     );
//   }
// }

// // ── Leaderboard Entry Model ───────────────────────────────────
// class LeaderboardEntry {
//   final String learnerName;
//   final String phoneNumber;
//   final int score;
//   final int rank;

//   LeaderboardEntry({
//     required this.learnerName,
//     required this.phoneNumber,
//     required this.score,
//     required this.rank,
//   });

//   factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
//     return LeaderboardEntry(
//       learnerName: json['learner_name'] ?? json['name'] ?? 'Learner',
//       phoneNumber: json['phone_number'] ?? '',
//       score:       json['score'] ?? 0,
//       rank:        json['rank'] ?? 0,
//     );
//   }
// }





























// // ── Course ────────────────────────────────────────────────────
// class Course {
//   final String id;
//   final String title;
//   final String description;
//   final String facilitatorName;
//   final String category;
//   final List<String> tags;
//   final int thumbnailColorIndex;

//   Course({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.facilitatorName,
//     this.category = 'General',
//     this.tags = const [],
//     this.thumbnailColorIndex = 0,
//   });

//   factory Course.fromJson(Map<String, dynamic> json) {
//     return Course(
//       id:                  (json['_id'] ?? '') as String,
//       title:               (json['title'] ?? '') as String,
//       description:         (json['description'] ?? '') as String,
//       facilitatorName:     json['facilitator'] != null
//           ? (json['facilitator']['name'] ?? 'Unknown') as String
//           : (json['facilitator_name'] ?? 'Unknown') as String,
//       category:            (json['category'] ?? 'General') as String,
//       tags:                (json['tags'] as List<dynamic>? ?? [])
//           .map((t) => t.toString()).toList(),
//       thumbnailColorIndex: (json['thumbnail_color_index'] ?? 0) as int,
//     );
//   }
// }

// // ── Module ────────────────────────────────────────────────────
// class CourseModule {
//   final String id;
//   final String courseId;
//   final String title;
//   final String description;
//   final String pdfLink;
//   final String videoLink;
//   final int    order;

//   CourseModule({
//     required this.id,
//     required this.courseId,
//     required this.title,
//     required this.description,
//     required this.pdfLink,
//     required this.videoLink,
//     required this.order,
//   });

//   factory CourseModule.fromJson(Map<String, dynamic> json) {
//     return CourseModule(
//       id:          (json['_id'] ?? '') as String,
//       courseId:    (json['course_id'] ?? '') as String,
//       title:       (json['title'] ?? '') as String,
//       description: (json['description'] ?? '') as String,
//       pdfLink:     (json['pdf_link'] ?? '') as String,
//       videoLink:   (json['video_link'] ?? '') as String,
//       order:       (json['order'] ?? 1) as int,
//     );
//   }
// }

// // ── Quiz Question ─────────────────────────────────────────────
// class QuizQuestion {
//   final String id;
//   final String courseId;
//   final String question;
//   final Map<String, String> options;
//   final String correctAnswer;

//   QuizQuestion({
//     required this.id,
//     required this.courseId,
//     required this.question,
//     required this.options,
//     required this.correctAnswer,
//   });

//   factory QuizQuestion.fromJson(Map<String, dynamic> json) {
//     final opts = json['options'] as Map<String, dynamic>? ?? {};
//     return QuizQuestion(
//       id:            (json['_id'] ?? '') as String,
//       courseId:      (json['course_id'] ?? '') as String,
//       question:      (json['question'] ?? '') as String,
//       options: {
//         'A': (opts['A'] ?? '') as String,
//         'B': (opts['B'] ?? '') as String,
//         'C': (opts['C'] ?? '') as String,
//         'D': (opts['D'] ?? '') as String,
//       },
//       correctAnswer: (json['correct_answer'] ?? 'A') as String,
//     );
//   }
// }

// // ── Learner Progress ──────────────────────────────────────────
// class LearnerProgress {
//   final String  name;
//   final String  phoneNumber;
//   final int     coursesTaken;
//   final int     quizzesTaken;
//   final int     averageScore;
//   final int     modulesCompleted;
//   final String? department;
//   final String? jobRole;
//   final String? employeeId;
//   final String? location;
//   final String? managerId;
//   final int     experienceYears;
//   final String? educationLevel;

//   LearnerProgress({
//     required this.name,
//     required this.phoneNumber,
//     required this.coursesTaken,
//     required this.quizzesTaken,
//     required this.averageScore,
//     required this.modulesCompleted,
//     this.department,
//     this.jobRole,
//     this.employeeId,
//     this.location,
//     this.managerId,
//     this.experienceYears = 0,
//     this.educationLevel,
//   });

//   factory LearnerProgress.fromJson(Map<String, dynamic> json) {
//     return LearnerProgress(
//       name:             (json['name'] ?? 'Learner') as String,
//       phoneNumber:      (json['phone_number'] ?? '') as String,
//       coursesTaken:     (json['courses_taken'] ?? 0) as int,
//       quizzesTaken:     (json['quizzes_taken'] ?? 0) as int,
//       averageScore:     (json['average_score'] ?? 0) as int,
//       modulesCompleted: (json['modules_completed'] ?? 0) as int,
//       department:       json['department'] as String?,
//       jobRole:          json['job_role'] as String?,
//       employeeId:       json['employee_id'] as String?,
//       location:         json['location'] as String?,
//       managerId:        json['manager_id'] as String?,
//       experienceYears:  (json['experience_years'] ?? 0) as int,
//       educationLevel:   json['education_level'] as String?,
//     );
//   }
// }

// // ── Dashboard Stats ───────────────────────────────────────────
// class DashboardStats {
//   final int totalLearners;
//   final int totalCourses;
//   final int totalQuizzesTaken;
//   final int averageScore;

//   DashboardStats({
//     required this.totalLearners,
//     required this.totalCourses,
//     required this.totalQuizzesTaken,
//     required this.averageScore,
//   });
// }

// // ── Leaderboard Entry ─────────────────────────────────────────
// class LeaderboardEntry {
//   final String name;
//   final String phoneNumber;
//   final int    score;
//   final String courseTitle;

//   LeaderboardEntry({
//     required this.name,
//     required this.phoneNumber,
//     required this.score,
//     required this.courseTitle,
//   });

//   factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
//     return LeaderboardEntry(
//       name:        (json['name'] ?? '') as String,
//       phoneNumber: (json['phone_number'] ?? '') as String,
//       score:       (json['score'] ?? 0) as int,
//       courseTitle: (json['course_title'] ?? '') as String,
//     );
//   }
// }

// // ── Quiz Submit Result ────────────────────────────────────────
// class QuizSubmitResult {
//   final int    score;
//   final bool   passed;
//   final String message;

//   QuizSubmitResult({
//     required this.score,
//     required this.passed,
//     required this.message,
//   });

//   factory QuizSubmitResult.fromJson(Map<String, dynamic> json) {
//     return QuizSubmitResult(
//       score:   (json['score'] ?? 0) as int,
//       passed:  (json['passed'] ?? false) as bool,
//       message: (json['message'] ?? '') as String,
//     );
//   }
// }


























// // ── Course ────────────────────────────────────────────────────
// class Course {
//   final String id;
//   final String title;
//   final String description;
//   final String facilitatorName;
//   final String category;
//   final List<String> tags;
//   final int thumbnailColorIndex;

//   Course({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.facilitatorName,
//     this.category = 'General',
//     this.tags = const [],
//     this.thumbnailColorIndex = 0,
//   });

//   factory Course.fromJson(Map<String, dynamic> json) {
//     // facilitator can be a populated Map or just an ID string
//     String facilitatorName = 'Facilitator';
//     final f = json['facilitator'];
//     if (f is Map) {
//       facilitatorName = (f['name'] ?? 'Facilitator') as String;
//     } else if (json['facilitator_name'] != null) {
//       facilitatorName = json['facilitator_name'] as String;
//     }
//     return Course(
//       id:                  (json['_id'] ?? json['id'] ?? '') as String,
//       title:               (json['title'] ?? '') as String,
//       description:         (json['description'] ?? '') as String,
//       facilitatorName:     facilitatorName,
//       category:            (json['category'] ?? 'General') as String,
//       tags:                (json['tags'] as List<dynamic>? ?? [])
//           .map((t) => t.toString()).toList(),
//       thumbnailColorIndex: (json['thumbnail_color_index'] ?? 0) as int,
//     );
//   }
// }

// // ── Module ────────────────────────────────────────────────────
// class CourseModule {
//   final String id;
//   final String courseId;
//   final String title;
//   final String description;
//   final String pdfLink;
//   final String videoLink;
//   final int    order;

//   CourseModule({
//     required this.id,
//     required this.courseId,
//     required this.title,
//     required this.description,
//     required this.pdfLink,
//     required this.videoLink,
//     required this.order,
//   });

//   factory CourseModule.fromJson(Map<String, dynamic> json) {
//     return CourseModule(
//       id:          (json['_id'] ?? '') as String,
//       courseId:    (json['course_id'] ?? '') as String,
//       title:       (json['title'] ?? '') as String,
//       description: (json['description'] ?? '') as String,
//       pdfLink:     (json['pdf_link'] ?? '') as String,
//       videoLink:   (json['video_link'] ?? '') as String,
//       order:       (json['order'] ?? 1) as int,
//     );
//   }
// }

// // ── Quiz Question ─────────────────────────────────────────────
// class QuizQuestion {
//   final String id;
//   final String courseId;
//   final String question;
//   final Map<String, String> options;
//   final String correctAnswer;

//   QuizQuestion({
//     required this.id,
//     required this.courseId,
//     required this.question,
//     required this.options,
//     required this.correctAnswer,
//   });

//   factory QuizQuestion.fromJson(Map<String, dynamic> json) {
//     final opts = json['options'] as Map<String, dynamic>? ?? {};
//     return QuizQuestion(
//       id:            (json['_id'] ?? '') as String,
//       courseId:      (json['course_id'] ?? '') as String,
//       question:      (json['question'] ?? '') as String,
//       options: {
//         'A': (opts['A'] ?? '') as String,
//         'B': (opts['B'] ?? '') as String,
//         'C': (opts['C'] ?? '') as String,
//         'D': (opts['D'] ?? '') as String,
//       },
//       correctAnswer: (json['correct_answer'] ?? 'A') as String,
//     );
//   }
// }

// // ── Learner Progress ──────────────────────────────────────────
// class LearnerProgress {
//   final String  name;
//   final String  phoneNumber;
//   final int     coursesTaken;
//   final int     quizzesTaken;
//   final int     averageScore;
//   final int     modulesCompleted;
//   final String? department;
//   final String? jobRole;
//   final String? employeeId;
//   final String? location;
//   final String? managerId;
//   final int     experienceYears;
//   final String? educationLevel;

//   LearnerProgress({
//     required this.name,
//     required this.phoneNumber,
//     required this.coursesTaken,
//     required this.quizzesTaken,
//     required this.averageScore,
//     required this.modulesCompleted,
//     this.department,
//     this.jobRole,
//     this.employeeId,
//     this.location,
//     this.managerId,
//     this.experienceYears = 0,
//     this.educationLevel,
//   });

//   factory LearnerProgress.fromJson(Map<String, dynamic> json) {
//     return LearnerProgress(
//       name:             (json['name'] ?? 'Learner') as String,
//       phoneNumber:      (json['phone_number'] ?? '') as String,
//       coursesTaken:     (json['courses_taken'] ?? 0) as int,
//       quizzesTaken:     (json['quizzes_taken'] ?? 0) as int,
//       averageScore:     (json['average_score'] ?? 0) as int,
//       modulesCompleted: (json['modules_completed'] ?? 0) as int,
//       department:       json['department'] as String?,
//       jobRole:          json['job_role'] as String?,
//       employeeId:       json['employee_id'] as String?,
//       location:         json['location'] as String?,
//       managerId:        json['manager_id'] as String?,
//       experienceYears:  (json['experience_years'] ?? 0) as int,
//       educationLevel:   json['education_level'] as String?,
//     );
//   }
// }

// // ── Dashboard Stats ───────────────────────────────────────────
// class DashboardStats {
//   final int totalLearners;
//   final int totalCourses;
//   final int totalQuizzesTaken;
//   final int averageScore;

//   DashboardStats({
//     required this.totalLearners,
//     required this.totalCourses,
//     required this.totalQuizzesTaken,
//     required this.averageScore,
//   });
// }

// // ── Leaderboard Entry ─────────────────────────────────────────
// class LeaderboardEntry {
//   final String name;
//   final String phoneNumber;
//   final int    score;
//   final String courseTitle;

//   LeaderboardEntry({
//     required this.name,
//     required this.phoneNumber,
//     required this.score,
//     required this.courseTitle,
//   });

//   factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
//     return LeaderboardEntry(
//       name:        (json['name'] ?? '') as String,
//       phoneNumber: (json['phone_number'] ?? '') as String,
//       score:       (json['score'] ?? 0) as int,
//       courseTitle: (json['course_title'] ?? '') as String,
//     );
//   }
// }

// // ── Quiz Submit Result ────────────────────────────────────────
// class QuizSubmitResult {
//   final int    score;
//   final bool   passed;
//   final String message;

//   QuizSubmitResult({
//     required this.score,
//     required this.passed,
//     required this.message,
//   });

//   factory QuizSubmitResult.fromJson(Map<String, dynamic> json) {
//     return QuizSubmitResult(
//       score:   (json['score'] ?? 0) as int,
//       passed:  (json['passed'] ?? false) as bool,
//       message: (json['message'] ?? '') as String,
//     );
//   }
// }




















// // ── Course ────────────────────────────────────────────────────
// class Course {
//   final String id;
//   final String title;
//   final String description;
//   final String facilitatorName;
//   final String category;
//   final List<String> tags;
//   final int thumbnailColorIndex;

//   Course({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.facilitatorName,
//     this.category = 'General',
//     this.tags = const [],
//     this.thumbnailColorIndex = 0,
//   });

//   factory Course.fromJson(Map<String, dynamic> json) {
//     // facilitator can be a populated Map or just an ID string
//     String facilitatorName = 'Facilitator';
//     final f = json['facilitator'];
//     if (f is Map) {
//       facilitatorName = (f['name'] ?? 'Facilitator') as String;
//     } else if (json['facilitator_name'] != null) {
//       facilitatorName = json['facilitator_name'] as String;
//     }
//     return Course(
//       id:                  (json['_id'] ?? json['id'] ?? '') as String,
//       title:               (json['title'] ?? '') as String,
//       description:         (json['description'] ?? '') as String,
//       facilitatorName:     facilitatorName,
//       category:            (json['category'] ?? 'General') as String,
//       tags:                (json['tags'] as List<dynamic>? ?? [])
//           .map((t) => t.toString()).toList(),
//       thumbnailColorIndex: (json['thumbnail_color_index'] ?? 0) as int,
//     );
//   }
// }

// // ── Module ────────────────────────────────────────────────────
// class CourseModule {
//   final String id;
//   final String courseId;
//   final String title;
//   final String description;
//   final String pdfLink;
//   final String videoLink;
//   final int    order;

//   CourseModule({
//     required this.id,
//     required this.courseId,
//     required this.title,
//     required this.description,
//     required this.pdfLink,
//     required this.videoLink,
//     required this.order,
//   });

//   factory CourseModule.fromJson(Map<String, dynamic> json) {
//     return CourseModule(
//       id:          (json['_id'] ?? '') as String,
//       courseId:    (json['course_id'] ?? '') as String,
//       title:       (json['title'] ?? '') as String,
//       description: (json['description'] ?? '') as String,
//       pdfLink:     (json['pdf_link'] ?? '') as String,
//       videoLink:   (json['video_link'] ?? '') as String,
//       order:       (json['order'] ?? 1) as int,
//     );
//   }
// }

// // ── Quiz Question ─────────────────────────────────────────────
// class QuizQuestion {
//   final String id;
//   final String courseId;
//   final String question;
//   final Map<String, String> options;
//   final String correctAnswer;

//   QuizQuestion({
//     required this.id,
//     required this.courseId,
//     required this.question,
//     required this.options,
//     required this.correctAnswer,
//   });

//   factory QuizQuestion.fromJson(Map<String, dynamic> json) {
//     final opts = json['options'] as Map<String, dynamic>? ?? {};
//     return QuizQuestion(
//       id:            (json['_id'] ?? '') as String,
//       courseId:      (json['course_id'] ?? '') as String,
//       question:      (json['question'] ?? '') as String,
//       options: {
//         'A': (opts['A'] ?? '') as String,
//         'B': (opts['B'] ?? '') as String,
//         'C': (opts['C'] ?? '') as String,
//         'D': (opts['D'] ?? '') as String,
//       },
//       correctAnswer: (json['correct_answer'] ?? 'A') as String,
//     );
//   }
// }

// // ── Learner Progress ──────────────────────────────────────────
// class LearnerProgress {
//   final String  name;
//   final String  phoneNumber;
//   final int     coursesTaken;
//   final int     quizzesTaken;
//   final int     averageScore;
//   final int     modulesCompleted;
//   final String? department;
//   final String? jobRole;
//   final String? employeeId;
//   final String? location;
//   final String? managerId;
//   final int     experienceYears;
//   final String? educationLevel;

//   LearnerProgress({
//     required this.name,
//     required this.phoneNumber,
//     required this.coursesTaken,
//     required this.quizzesTaken,
//     required this.averageScore,
//     required this.modulesCompleted,
//     this.department,
//     this.jobRole,
//     this.employeeId,
//     this.location,
//     this.managerId,
//     this.experienceYears = 0,
//     this.educationLevel,
//   });

//   factory LearnerProgress.fromJson(Map<String, dynamic> json) {
//     return LearnerProgress(
//       name:             (json['name'] ?? 'Learner') as String,
//       phoneNumber:      (json['phone_number'] ?? '') as String,
//       coursesTaken:     (json['courses_taken'] ?? 0) as int,
//       quizzesTaken:     (json['quizzes_taken'] ?? 0) as int,
//       averageScore:     (json['average_score'] ?? 0) as int,
//       modulesCompleted: (json['modules_completed'] ?? 0) as int,
//       department:       json['department'] as String?,
//       jobRole:          json['job_role'] as String?,
//       employeeId:       json['employee_id'] as String?,
//       location:         json['location'] as String?,
//       managerId:        json['manager_id'] as String?,
//       experienceYears:  (json['experience_years'] ?? 0) as int,
//       educationLevel:   json['education_level'] as String?,
//     );
//   }
// }

// // ── Dashboard Stats ───────────────────────────────────────────
// class DashboardStats {
//   final int totalLearners;
//   final int totalCourses;
//   final int totalQuizzesTaken;
//   final int averageScore;

//   DashboardStats({
//     required this.totalLearners,
//     required this.totalCourses,
//     required this.totalQuizzesTaken,
//     required this.averageScore,
//   });
// }

// // ── Leaderboard Entry ─────────────────────────────────────────
// class LeaderboardEntry {
//   final String name;
//   final String phoneNumber;
//   final int    score;
//   final String courseTitle;

//   LeaderboardEntry({
//     required this.name,
//     required this.phoneNumber,
//     required this.score,
//     required this.courseTitle,
//   });

//   factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
//     return LeaderboardEntry(
//       name:        (json['name'] ?? '') as String,
//       phoneNumber: (json['phone_number'] ?? '') as String,
//       score:       (json['score'] ?? 0) as int,
//       courseTitle: (json['course_title'] ?? '') as String,
//     );
//   }
// }

// // ── Quiz Submit Result ────────────────────────────────────────
// class QuizSubmitResult {
//   final int    score;
//   final bool   passed;
//   final String message;

//   QuizSubmitResult({
//     required this.score,
//     required this.passed,
//     required this.message,
//   });

//   factory QuizSubmitResult.fromJson(Map<String, dynamic> json) {
//     return QuizSubmitResult(
//       score:   (json['score'] ?? 0) as int,
//       passed:  (json['passed'] ?? false) as bool,
//       message: (json['message'] ?? '') as String,
//     );
//   }
// }



















// // ── Course ────────────────────────────────────────────────────
// class Course {
//   final String id;
//   final String title;
//   final String description;
//   final String facilitatorName;
//   final String category;
//   final List<String> tags;
//   final int thumbnailColorIndex;

//   Course({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.facilitatorName,
//     this.category = 'General',
//     this.tags = const [],
//     this.thumbnailColorIndex = 0,
//   });

//   factory Course.fromJson(Map<String, dynamic> json) {
//     String facilitatorName = 'Facilitator';
//     final f = json['facilitator'];
//     if (f is Map) {
//       facilitatorName = (f['name'] ?? 'Facilitator') as String;
//     } else if (json['facilitator_name'] != null) {
//       facilitatorName = json['facilitator_name'] as String;
//     }
//     return Course(
//       id:                  (json['_id'] ?? json['id'] ?? '') as String,
//       title:               (json['title'] ?? '') as String,
//       description:         (json['description'] ?? '') as String,
//       facilitatorName:     facilitatorName,
//       category:            (json['category'] ?? 'General') as String,
//       tags:                (json['tags'] as List<dynamic>? ?? [])
//           .map((t) => t.toString()).toList(),
//       thumbnailColorIndex: (json['thumbnail_color_index'] ?? 0) as int,
//     );
//   }
// }

// // ── Module ────────────────────────────────────────────────────
// class CourseModule {
//   final String id;
//   final String courseId;
//   final String title;
//   final String description;
//   final String pdfLink;
//   final String videoLink;
//   final int    order;

//   CourseModule({
//     required this.id,
//     required this.courseId,
//     required this.title,
//     required this.description,
//     required this.pdfLink,
//     required this.videoLink,
//     required this.order,
//   });

//   factory CourseModule.fromJson(Map<String, dynamic> json) {
//     return CourseModule(
//       id:          (json['_id'] ?? '') as String,
//       courseId:    (json['course_id'] ?? '') as String,
//       title:       (json['title'] ?? '') as String,
//       description: (json['description'] ?? '') as String,
//       pdfLink:     (json['pdf_link'] ?? '') as String,
//       videoLink:   (json['video_link'] ?? '') as String,
//       order:       (json['order'] ?? 1) as int,
//     );
//   }
// }

// // ── Quiz Question ─────────────────────────────────────────────
// class QuizQuestion {
//   final String id;
//   final String courseId;
//   final String question;
//   final Map<String, String> options;
//   final String correctAnswer;

//   QuizQuestion({
//     required this.id,
//     required this.courseId,
//     required this.question,
//     required this.options,
//     required this.correctAnswer,
//   });

//   factory QuizQuestion.fromJson(Map<String, dynamic> json) {
//     final opts = json['options'] as Map<String, dynamic>? ?? {};
//     return QuizQuestion(
//       id:            (json['_id'] ?? '') as String,
//       courseId:      (json['course_id'] ?? '') as String,
//       question:      (json['question'] ?? '') as String,
//       options: {
//         'A': (opts['A'] ?? '') as String,
//         'B': (opts['B'] ?? '') as String,
//         'C': (opts['C'] ?? '') as String,
//         'D': (opts['D'] ?? '') as String,
//       },
//       correctAnswer: (json['correct_answer'] ?? 'A') as String,
//     );
//   }
// }

// // ── Learner Progress ──────────────────────────────────────────
// class LearnerProgress {
//   final String    name;
//   final String    phoneNumber;
//   final int       coursesTaken;
//   final int       quizzesTaken;
//   final int       averageScore;
//   final int       modulesCompleted;
//   final String?   department;
//   final String?   jobRole;
//   final String?   employeeId;
//   final String?   location;
//   final String?   managerId;
//   final int       experienceYears;
//   final String?   educationLevel;
//   final DateTime? joinedAt;          // ← NEW

//   LearnerProgress({
//     required this.name,
//     required this.phoneNumber,
//     required this.coursesTaken,
//     required this.quizzesTaken,
//     required this.averageScore,
//     required this.modulesCompleted,
//     this.department,
//     this.jobRole,
//     this.employeeId,
//     this.location,
//     this.managerId,
//     this.experienceYears = 0,
//     this.educationLevel,
//     this.joinedAt,
//   });

//   factory LearnerProgress.fromJson(Map<String, dynamic> json) {
//     return LearnerProgress(
//       name:             (json['name'] ?? 'Learner') as String,
//       phoneNumber:      (json['phone_number'] ?? '') as String,
//       coursesTaken:     (json['courses_taken'] ?? 0) as int,
//       quizzesTaken:     (json['quizzes_taken'] ?? 0) as int,
//       averageScore:     (json['average_score'] ?? 0) as int,
//       modulesCompleted: (json['modules_completed'] ?? 0) as int,
//       department:       json['department'] as String?,
//       jobRole:          json['job_role'] as String?,
//       employeeId:       json['employee_id'] as String?,
//       location:         json['location'] as String?,
//       managerId:        json['manager_id'] as String?,
//       experienceYears:  (json['experience_years'] ?? 0) as int,
//       educationLevel:   json['education_level'] as String?,
//       joinedAt:         json['joined_at'] != null
//           ? DateTime.tryParse(json['joined_at'] as String)
//           : null,
//     );
//   }
// }

// // ── Course Stats ──────────────────────────────────────────────
// class CourseStats {
//   final String courseId;
//   final String courseTitle;
//   final int    enrolled;
//   final int    completed;
//   final double completionRate;

//   CourseStats({
//     required this.courseId,
//     required this.courseTitle,
//     required this.enrolled,
//     required this.completed,
//     required this.completionRate,
//   });

//   factory CourseStats.fromJson(Map<String, dynamic> json) {
//     return CourseStats(
//       courseId:       (json['course_id'] ?? '') as String,
//       courseTitle:    (json['course_title'] ?? '') as String,
//       enrolled:       (json['enrolled'] ?? 0) as int,
//       completed:      (json['completed'] ?? 0) as int,
//       completionRate: (json['completion_rate'] ?? 0.0).toDouble(),
//     );
//   }
// }

// // ── Dashboard Stats ───────────────────────────────────────────
// class DashboardStats {
//   final int totalLearners;
//   final int totalCourses;
//   final int totalQuizzesTaken;
//   final int averageScore;

//   DashboardStats({
//     required this.totalLearners,
//     required this.totalCourses,
//     required this.totalQuizzesTaken,
//     required this.averageScore,
//   });
// }

// // ── Leaderboard Entry ─────────────────────────────────────────
// class LeaderboardEntry {
//   final String name;
//   final String phoneNumber;
//   final int    score;
//   final String courseTitle;

//   LeaderboardEntry({
//     required this.name,
//     required this.phoneNumber,
//     required this.score,
//     required this.courseTitle,
//   });

//   factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
//     return LeaderboardEntry(
//       name:        (json['name'] ?? '') as String,
//       phoneNumber: (json['phone_number'] ?? '') as String,
//       score:       (json['score'] ?? 0) as int,
//       courseTitle: (json['course_title'] ?? '') as String,
//     );
//   }
// }

// // ── Quiz Submit Result ────────────────────────────────────────
// class QuizSubmitResult {
//   final int    score;
//   final bool   passed;
//   final String message;

//   QuizSubmitResult({
//     required this.score,
//     required this.passed,
//     required this.message,
//   });

//   factory QuizSubmitResult.fromJson(Map<String, dynamic> json) {
//     return QuizSubmitResult(
//       score:   (json['score'] ?? 0) as int,
//       passed:  (json['passed'] ?? false) as bool,
//       message: (json['message'] ?? '') as String,
//     );
//   }
// }


















// ── Course ────────────────────────────────────────────────────
class Course {
  final String id;
  final String title;
  final String description;
  final String facilitatorName;
  final String category;
  final List<String> tags;
  final int thumbnailColorIndex;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.facilitatorName,
    this.category = 'General',
    this.tags = const [],
    this.thumbnailColorIndex = 0,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    String facilitatorName = 'Facilitator';
    final f = json['facilitator'];
    if (f is Map) {
      facilitatorName = (f['name'] ?? 'Facilitator') as String;
    } else if (json['facilitator_name'] != null) {
      facilitatorName = json['facilitator_name'] as String;
    }
    return Course(
      id:                  (json['_id'] ?? json['id'] ?? '') as String,
      title:               (json['title'] ?? '') as String,
      description:         (json['description'] ?? '') as String,
      facilitatorName:     facilitatorName,
      category:            (json['category'] ?? 'General') as String,
      tags:                (json['tags'] as List<dynamic>? ?? [])
          .map((t) => t.toString()).toList(),
      thumbnailColorIndex: (json['thumbnail_color_index'] ?? 0) as int,
    );
  }
}

// ── Module ────────────────────────────────────────────────────
class CourseModule {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final String pdfLink;
  final String videoLink;
  final int    order;

  CourseModule({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.pdfLink,
    required this.videoLink,
    required this.order,
  });

  factory CourseModule.fromJson(Map<String, dynamic> json) {
    return CourseModule(
      id:          (json['_id'] ?? '') as String,
      courseId:    (json['course_id'] ?? '') as String,
      title:       (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      pdfLink:     (json['pdf_link'] ?? '') as String,
      videoLink:   (json['video_link'] ?? '') as String,
      order:       (json['order'] ?? 1) as int,
    );
  }
}

// ── Quiz Question ─────────────────────────────────────────────
class QuizQuestion {
  final String id;
  final String courseId;
  final String question;
  final Map<String, String> options;
  final String correctAnswer;

  QuizQuestion({
    required this.id,
    required this.courseId,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final opts = json['options'] as Map<String, dynamic>? ?? {};
    return QuizQuestion(
      id:            (json['_id'] ?? '') as String,
      courseId:      (json['course_id'] ?? '') as String,
      question:      (json['question'] ?? '') as String,
      options: {
        'A': (opts['A'] ?? '') as String,
        'B': (opts['B'] ?? '') as String,
        'C': (opts['C'] ?? '') as String,
        'D': (opts['D'] ?? '') as String,
      },
      correctAnswer: (json['correct_answer'] ?? 'A') as String,
    );
  }
}

// ── Learner Progress ──────────────────────────────────────────
class LearnerProgress {
  final String    name;
  final String    phoneNumber;
  final int       coursesTaken;
  final int       quizzesTaken;
  final int       averageScore;
  final int       modulesCompleted;
  final String?   department;
  final String?   jobRole;
  final String?   employeeId;
  final String?   location;
  final String?   managerId;
  final int       experienceYears;
  final String?   educationLevel;
  final DateTime? joinedAt;
  final List<Map<String, dynamic>> enrolledCourses;
  final List<Map<String, dynamic>> quizResults;

  LearnerProgress({
    required this.name,
    required this.phoneNumber,
    required this.coursesTaken,
    required this.quizzesTaken,
    required this.averageScore,
    required this.modulesCompleted,
    this.department,
    this.jobRole,
    this.employeeId,
    this.location,
    this.managerId,
    this.experienceYears = 0,
    this.educationLevel,
    this.joinedAt,
    this.enrolledCourses = const [],
    this.quizResults = const [],
  });

  factory LearnerProgress.fromJson(Map<String, dynamic> json) {
    return LearnerProgress(
      name:             (json['name'] ?? 'Learner') as String,
      phoneNumber:      (json['phone_number'] ?? '') as String,
      coursesTaken:     (json['courses_taken'] ?? 0) as int,
      quizzesTaken:     (json['quizzes_taken'] ?? 0) as int,
      averageScore:     (json['average_score'] ?? 0) as int,
      modulesCompleted: (json['modules_completed'] ?? 0) as int,
      department:       json['department'] as String?,
      jobRole:          json['job_role'] as String?,
      employeeId:       json['employee_id'] as String?,
      location:         json['location'] as String?,
      managerId:        json['manager_id'] as String?,
      experienceYears:  (json['experience_years'] ?? 0) as int,
      educationLevel:   json['education_level'] as String?,
      joinedAt:         json['joined_at'] != null
          ? DateTime.tryParse(json['joined_at'] as String)
          : null,
      enrolledCourses: (json['enrolled_courses'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      quizResults: (json['quiz_results'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }
}

// ── Course Stats ──────────────────────────────────────────────
class CourseStats {
  final String courseId;
  final String courseTitle;
  final int    enrolled;
  final int    completed;
  final double completionRate;

  CourseStats({
    required this.courseId,
    required this.courseTitle,
    required this.enrolled,
    required this.completed,
    required this.completionRate,
  });

  factory CourseStats.fromJson(Map<String, dynamic> json) {
    return CourseStats(
      courseId:       (json['course_id'] ?? '') as String,
      courseTitle:    (json['course_title'] ?? '') as String,
      enrolled:       (json['enrolled'] ?? 0) as int,
      completed:      (json['completed'] ?? 0) as int,
      completionRate: (json['completion_rate'] ?? 0.0).toDouble(),
    );
  }
}

// ── Dashboard Stats ───────────────────────────────────────────
class DashboardStats {
  final int totalLearners;
  final int totalCourses;
  final int totalQuizzesTaken;
  final int averageScore;

  DashboardStats({
    required this.totalLearners,
    required this.totalCourses,
    required this.totalQuizzesTaken,
    required this.averageScore,
  });
}

// ── Leaderboard Entry ─────────────────────────────────────────
class LeaderboardEntry {
  final String name;
  final String phoneNumber;
  final int    score;
  final String courseTitle;

  LeaderboardEntry({
    required this.name,
    required this.phoneNumber,
    required this.score,
    required this.courseTitle,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      name:        (json['name'] ?? '') as String,
      phoneNumber: (json['phone_number'] ?? '') as String,
      score:       (json['score'] ?? 0) as int,
      courseTitle: (json['course_title'] ?? '') as String,
    );
  }
}

// ── Quiz Submit Result ────────────────────────────────────────
class QuizSubmitResult {
  final int    score;
  final bool   passed;
  final String message;

  QuizSubmitResult({
    required this.score,
    required this.passed,
    required this.message,
  });

  factory QuizSubmitResult.fromJson(Map<String, dynamic> json) {
    return QuizSubmitResult(
      score:   (json['score'] ?? 0) as int,
      passed:  (json['passed'] ?? false) as bool,
      message: (json['message'] ?? '') as String,
    );
  }
}