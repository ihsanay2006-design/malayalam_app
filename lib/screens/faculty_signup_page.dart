import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'faculty_dashboard_page.dart';

class FacultySignupPage extends StatefulWidget {
  const FacultySignupPage({super.key});

  @override
  State<FacultySignupPage> createState() => _FacultySignupPageState();
}

class _FacultySignupPageState extends State<FacultySignupPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final deptController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final courseController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // 🔥 CREATE USER
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user!;

      // 🔥 SAVE ROLE FOR AUTH CHECKER
      await FirebaseFirestore.instance
          .collection('faculty')
          .doc(user.uid)
          .set({
        'role': 'faculty',
      });

      // 🔥 SAVE FACULTY PROFILE
      await FirebaseFirestore.instance
          .collection('faculty')
          .doc(user.uid)
          .set({
        'name': nameController.text.trim(),
        'department': deptController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'course': courseController.text.trim(),
        'created_at': Timestamp.now(),
      });

      // ✅ GO TO DASHBOARD
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const FacultyDashboardPage(),
        ),
        (route) => false,
      );

    } on FirebaseAuthException catch (e) {
      String msg = "Signup failed";

      if (e.code == 'email-already-in-use') {
        msg = "Email already exists";
      } else if (e.code == 'weak-password') {
        msg = "Password too weak";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faculty Sign Up"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(controller: nameController, label: "Name"),
              _field(controller: deptController, label: "Department"),
              _field(
                controller: emailController,
                label: "Email",
                hint: "example: faculty@gmail.com",
              ),
              _field(
                controller: phoneController,
                label: "Mobile Number",
                keyboardType: TextInputType.number,
              ),
              _field(controller: courseController, label: "Course Name"),
              _field(
                controller: passwordController,
                label: "Password",
                obscure: true,
              ),

              const SizedBox(height: 24),

              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: signup,
                      child: const Text(
                        "Create Account",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool obscure = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: (v) {
          if (v == null || v.isEmpty) return "$label is required";
          if (label == "Password" && v.length < 6) {
            return "Password must be at least 6 characters";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}