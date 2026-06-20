import 'package:flutter/material.dart';

// ─── Alert model ──────────────────────────────────────────────────────────────
class AppAlert {
  final String id;
  final String emoji;
  final String title;
  final String message;
  final DateTime createdAt;

  AppAlert({
    required this.id,
    required this.emoji,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}

// ─── Singleton store — shared between Dashboard and AlertsScreen ──────────────
class AlertStore extends ChangeNotifier {
  // Private constructor
  AlertStore._();
  static final AlertStore instance = AlertStore._();

  final List<AppAlert> _alerts = [
    AppAlert(
      id: '1',
      emoji: '⏰',
      title: 'Quiz Deadline Approaching',
      message: 'SEO Basics Quiz is due in 5 days',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AppAlert(
      id: '2',
      emoji: '📗',
      title: 'New Content Available',
      message: 'Week 4 materials uploaded for Digital Marketing',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AppAlert(
      id: '3',
      emoji: '🏆',
      title: 'Learner Achievement',
      message: '5 learners completed Leadership Assessment with 90%+',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  List<AppAlert> get alerts => List.unmodifiable(_alerts);

  void addAlert(AppAlert alert) {
    _alerts.insert(0, alert);
    notifyListeners();
  }

  void deleteAlert(String id) {
    _alerts.removeWhere((a) => a.id == id);
    notifyListeners();
  }
}