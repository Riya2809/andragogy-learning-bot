// import 'package:flutter/material.dart';

// // ─── Models ───────────────────────────────────────────────────────────────────
// class PollOption {
//   final String label;
//   int votes;
//   PollOption({required this.label, required this.votes});
// }

// class Poll {
//   final String question;
//   final List<PollOption> options;
//   int? votedIndex;

//   Poll({required this.question, required this.options, this.votedIndex});

//   int get totalVotes => options.fold(0, (s, o) => s + o.votes);

//   double percent(int index) {
//     final total = totalVotes;
//     if (total == 0) return 0;
//     return options[index].votes / total;
//   }

//   int get leadingIndex {
//     int maxVotes = 0, idx = 0;
//     for (int i = 0; i < options.length; i++) {
//       if (options[i].votes > maxVotes) {
//         maxVotes = options[i].votes;
//         idx = i;
//       }
//     }
//     return idx;
//   }
// }

// // ─── Shared provider (singleton) ─────────────────────────────────────────────
// class PollsProvider extends ChangeNotifier {
//   // Single instance shared across the app
//   static final PollsProvider instance = PollsProvider._();
//   PollsProvider._();

//   final List<Poll> polls = [
//     Poll(
//       question: 'What time works best for live sessions?',
//       options: [
//         PollOption(label: 'Morning (9–11 AM)', votes: 12),
//         PollOption(label: 'Afternoon (2–4 PM)', votes: 28),
//         PollOption(label: 'Evening (7–9 PM)', votes: 35),
//       ],
//     ),
//     Poll(
//       question: 'Which learning format do you prefer?',
//       options: [
//         PollOption(label: 'Video lessons', votes: 40),
//         PollOption(label: 'Text + exercises', votes: 18),
//         PollOption(label: 'Live workshops', votes: 22),
//       ],
//     ),
//     Poll(
//       question: 'How often should we send course updates?',
//       options: [
//         PollOption(label: 'Daily', votes: 10),
//         PollOption(label: 'Every 2–3 days', votes: 33),
//         PollOption(label: 'Weekly', votes: 20),
//       ],
//     ),
//   ];

//   /// Vote on a poll — notifies all listeners (both screens update live)
//   void vote(Poll poll, int optionIndex) {
//     if (poll.votedIndex != null) return;
//     poll.options[optionIndex].votes++;
//     poll.votedIndex = optionIndex;
//     notifyListeners(); // ← this makes both screens rebuild
//   }
// }


import 'package:flutter/material.dart';

// ─── Models ───────────────────────────────────────────────────────────────────
class PollOption {
  final String label;
  int votes;
  PollOption({required this.label, required this.votes});
}

class Poll {
  final String id;
  final String question;
  final List<PollOption> options;
  int? votedIndex;

  Poll({
    required this.id,
    required this.question,
    required this.options,
    this.votedIndex,
  });

  int get totalVotes => options.fold(0, (s, o) => s + o.votes);

  double percent(int index) {
    final total = totalVotes;
    if (total == 0) return 0;
    return options[index].votes / total;
  }

  int get leadingIndex {
    int maxVotes = 0, idx = 0;
    for (int i = 0; i < options.length; i++) {
      if (options[i].votes > maxVotes) {
        maxVotes = options[i].votes;
        idx = i;
      }
    }
    return idx;
  }
}

// ─── Shared provider (singleton) ─────────────────────────────────────────────
class PollsProvider extends ChangeNotifier {
  static final PollsProvider instance = PollsProvider._();
  PollsProvider._();

  final List<Poll> polls = [
    Poll(
      id: '1',
      question: 'What time works best for live sessions?',
      options: [
        PollOption(label: 'Morning (9–11 AM)', votes: 12),
        PollOption(label: 'Afternoon (2–4 PM)', votes: 28),
        PollOption(label: 'Evening (7–9 PM)', votes: 35),
      ],
    ),
    Poll(
      id: '2',
      question: 'Which learning format do you prefer?',
      options: [
        PollOption(label: 'Video lessons', votes: 40),
        PollOption(label: 'Text + exercises', votes: 18),
        PollOption(label: 'Live workshops', votes: 22),
      ],
    ),
    Poll(
      id: '3',
      question: 'How often should we send course updates?',
      options: [
        PollOption(label: 'Daily', votes: 10),
        PollOption(label: 'Every 2–3 days', votes: 33),
        PollOption(label: 'Weekly', votes: 20),
      ],
    ),
  ];

  /// Vote on a poll
  void vote(Poll poll, int optionIndex) {
    if (poll.votedIndex != null) return;
    poll.options[optionIndex].votes++;
    poll.votedIndex = optionIndex;
    notifyListeners();
  }

  /// Add a new poll
  void addPoll(String question, List<String> optionLabels) {
    polls.insert(
      0,
      Poll(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        question: question,
        options: optionLabels
            .map((l) => PollOption(label: l, votes: 0))
            .toList(),
      ),
    );
    notifyListeners();
  }

  /// Delete a poll by id
  void deletePoll(String id) {
    polls.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}