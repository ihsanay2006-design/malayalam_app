import 'package:flutter/material.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({Key? key}) : super(key: key);

  static const Color primaryViolet = Color(0xFF3A0B5E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Select Your Role',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryViolet,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 90,
              color: primaryViolet,
            ),
            const SizedBox(height: 20),
            const Text(
              'Who are you?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryViolet,
              ),
            ),
            const SizedBox(height: 40),

            // STUDENT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/authChoice',
                    arguments: 'student',
                  );
                },
                child: const Text(
                  'I am a Student',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // FACULTY BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/authChoice',
                    arguments: 'faculty',
                  );
                },
                child: const Text(
                  'I am a Faculty',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
