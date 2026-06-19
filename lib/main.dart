import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:malayala_learning_app/screens/splash_page.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// SCREENS
import 'screens/language_selection_page.dart';
import 'screens/role_selection_page.dart';
import 'screens/auth_choice_page.dart';

import 'screens/student_login_page.dart';
import 'screens/student_signup_page.dart';
import 'screens/student_dashboard_page.dart';

import 'screens/faculty_login_page.dart';
import 'screens/faculty_signup_page.dart';
import 'screens/faculty_dashboard_page.dart';
import 'screens/upload_learning_item_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color primaryViolet = Color(0xFF3A0B5E);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color.fromARGB(255, 42, 5, 71),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 34, 4, 57),
          foregroundColor: Colors.white,
        ),
      ),

      home: const SplashPage(),

      routes: {
        '/role': (context) => const RoleSelectionPage(),
        '/authChoice': (context) => const AuthChoicePage(),
        '/authChecker': (context) => const AuthChecker(),

        '/studentLogin': (context) => const StudentLoginPage(),
        '/studentSignup': (context) => const StudentSignupPage(),
        '/studentDashboard': (context) => const StudentDashboardPage(),

        '/facultyLogin': (context) => const FacultyLoginPage(),
        '/facultySignup': (context) => const FacultySignupPage(),
        '/facultyDashboard': (context) => const FacultyDashboardPage(),
        '/uploadLearningItem': (context) =>
            const UploadLearningItemPage(),
      },
    );
  }
}

// ✅ FIXED AUTH + ROLE ROUTING
class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ❌ Not logged in
        if (!snapshot.hasData) {
          return const LanguageSelectionPage();
        }

        final user = snapshot.data!;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, roleSnap) {

            if (roleSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!roleSnap.hasData || !roleSnap.data!.exists) {
              return const RoleSelectionPage();
            }

            final data =
                roleSnap.data!.data() as Map<String, dynamic>;

            final role = data['role'] ?? 'student';

            return role == 'faculty'
                ? const FacultyDashboardPage()
                : const StudentDashboardPage();
          },
        );
      },
    );
  }
}