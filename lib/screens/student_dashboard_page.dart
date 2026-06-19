import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'letter_detail_page.dart';
import 'leaderboard_page.dart';
import 'student_test_page.dart'; // ✅ IMPORTANT

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({super.key});

  @override
  State<StudentDashboardPage> createState() =>
      _StudentDashboardPageState();
}

class _StudentDashboardPageState
    extends State<StudentDashboardPage> {
  String search = "";

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              // 🔝 TOP BAR
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Learn Malayalam",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout,
                          color: Colors.white),
                      onPressed: logout,
                    )
                  ],
                ),
              ),

              // 🔍 SEARCH
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (value) =>
                      setState(() => search = value),
                  decoration: InputDecoration(
                    hintText: "Search letter...",
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🎮 BUTTONS
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _actionButton(
                      "Learn",
                      Icons.menu_book,
                      Colors.orange,
                      () {},
                    ),
                    const SizedBox(width: 10),

                    // ✅ FIXED TEST BUTTON
                    _actionButton(
                      "Test",
                      Icons.quiz,
                      Colors.green,
                      () {
                        final page = StudentTestPage();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => page,
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 10),

                    _actionButton(
                      "Rank",
                      Icons.emoji_events,
                      Colors.purple,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const LeaderboardPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 📘 CONTENT GRID
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('learning_items')
                        .snapshots(),
                    builder: (context, snapshot) {

                      if (!snapshot.hasData) {
                        return const Center(
                            child:
                                CircularProgressIndicator());
                      }

                      final docs = snapshot.data!.docs;

                      Map<String, List<Map<String, dynamic>>> grouped = {};

                      for (var doc in docs) {
                        final data =
                            doc.data() as Map<String, dynamic>;

                        String letter =
                            data['letter'] ?? 'അ';

                        if (search.isNotEmpty &&
                            !letter.contains(search) &&
                            !(data['english_letter'] ?? "")
                                .toLowerCase()
                                .contains(
                                    search.toLowerCase())) {
                          continue;
                        }

                        grouped.putIfAbsent(letter, () => []);
                        grouped[letter]!.add(data);
                      }

                      final letters = grouped.keys.toList();

                      return GridView.builder(
                        itemCount: letters.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.2,
                        ),
                        itemBuilder: (context, index) {
                          String letter = letters[index];
                          final firstItem =
                              grouped[letter]!.first;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      LetterDetailPage(
                                    letter: letter,
                                    items:
                                        grouped[letter]!,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 6,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        20),
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                children: [
                                  Text(
                                    letter,
                                    style:
                                        const TextStyle(
                                      fontSize: 40,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    firstItem[
                                            'english_letter'] ??
                                        "",
                                    style:
                                        const TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🎮 BUTTON
  Widget _actionButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 70,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.8), color],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 5),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}