import 'package:flutter/material.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  static const Color primaryViolet = Color(0xFF3A0B5E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🎓 Graduation Cap
              const Text(
                '🎓',
                style: TextStyle(fontSize: 80),
              ),

              const SizedBox(height: 20),

              // App Quote
              const Text(
                'Learn • Test • Grow',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryViolet,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'A smart learning platform for students',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 50),

              // ENGLISH BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryViolet,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/role');
                },
                child: const Text(
                  'English',
                  style: TextStyle(fontSize: 18),
                ),
              ),

              const SizedBox(height: 20),

              // MALAYALAM BUTTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryViolet,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/role');
                },
                child: const Text(
                  'മലയാളം',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
