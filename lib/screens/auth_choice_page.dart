import 'package:flutter/material.dart';

class AuthChoicePage extends StatelessWidget {
  const AuthChoicePage({Key? key}) : super(key: key);

  static const Color primaryPurple = Color(0xFF4A148C); // deep dark violet

  @override
  Widget build(BuildContext context) {
    // role will be passed as 'student' or 'faculty'
    final String role = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryPurple,
        title: const Text(
          'Welcome',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 80,
              color: primaryPurple,
            ),
            const SizedBox(height: 20),
            const Text(
              'Learn • Test • Grow',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryPurple,
              ),
            ),
            const SizedBox(height: 40),

            // SIGN UP BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (role == 'student') {
                    Navigator.pushNamed(context, '/studentSignup');
                  } else {
                    Navigator.pushNamed(context, '/facultySignup');
                  }
                },
                child: const Text(
                  'New User? Sign Up',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // LOGIN BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryPurple),
                  foregroundColor: primaryPurple,
                ),
                onPressed: () {
                  if (role == 'student') {
                    Navigator.pushNamed(context, '/studentLogin');
                  } else {
                    Navigator.pushNamed(context, '/facultyLogin');
                  }
                },
                child: const Text(
                  'Already have an account? Login',
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
