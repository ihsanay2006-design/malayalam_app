import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'upload_learning_item_page.dart';
import 'test_page.dart';
import 'view_progress_page.dart';

class FacultyDashboardPage extends StatefulWidget {
  const FacultyDashboardPage({super.key});

  @override
  State<FacultyDashboardPage> createState() => _FacultyDashboardPageState();
}

class _FacultyDashboardPageState extends State<FacultyDashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    /// 🤖 FLOATING ANIMATION
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: -10,
      upperBound: 10,
    )..repeat(reverse: true);
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// 🎨 BACKGROUND
      body: Stack(
        children: [
          /// 🌈 GRADIENT BG
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// 🔝 HEADER
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Hello Faculty 👋",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: logout,
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// 🎯 CARDS
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        _card(
                          title: "📚 Upload Modules",
                          color: Colors.blue,
                          icon: Icons.upload_file,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const UploadLearningItemPage(),
                              ),
                            );
                          },
                        ),
                        _card(
                          title: "📝 Upload Test",
                          color: Colors.orange,
                          icon: Icons.quiz,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TestPage(),
                              ),
                            );
                          },
                        ),
                        _card(
                          title: "📊 View Student Results",
                          color: Colors.green,
                          icon: Icons.bar_chart,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ViewProgressPage(),
                              ),
                            );
                          },
                        ),
                        _card(
                          title: "🏆 Manage Leaderboard",
                          color: Colors.purple,
                          icon: Icons.emoji_events,
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Leaderboard feature coming soon"),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// 🤖 FLOATING CHATBOT
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Positioned(
                bottom: 40 + _controller.value,
                right: 20,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Hi! Let's teach 📖",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const CircleAvatar(
                      radius: 25,
                      child: Text("🤖"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _card({
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
