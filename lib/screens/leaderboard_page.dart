import 'package:flutter/material.dart';
import 'leaderboard_data.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  List<LeaderboardEntry> get leaderboard => [
    LeaderboardEntry(userId: '1', name: 'Student 1', credits: 100),
    LeaderboardEntry(userId: '2', name: 'Student 2', credits: 80),
    LeaderboardEntry(userId: '3', name: 'Student 3', credits: 60),
  ];

  @override
  Widget build(BuildContext context) {
    final sortedLeaderboard = List<LeaderboardEntry>.from(leaderboard)
      ..sort((a, b) => b.credits.compareTo(a.credits));

    return Scaffold(
      appBar: AppBar(title: const Text("Leaderboard 🏆")),
      body: ListView.builder(
        itemCount: sortedLeaderboard.length,
        itemBuilder: (context, index) {
          final student = sortedLeaderboard[index];
          return ListTile(
            leading: Text("#${index + 1}"),
            title: Text(student.name),
            subtitle: Text("${student.credits} credits"),
          );
        },
      ),
    );
  }
}