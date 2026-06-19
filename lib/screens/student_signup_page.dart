import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_dashboard_page.dart';

class StudentSignupPage extends StatefulWidget {
  const StudentSignupPage({super.key});

  @override
  State<StudentSignupPage> createState() => _StudentSignupPageState();
}

class _StudentSignupPageState extends State<StudentSignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController dobController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController regController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2010),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      dobController.text = "${picked.day}/${picked.month}/${picked.year}";
    }
  }

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

      // 🔥 SAVE ROLE
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'role': 'student',
      });

      // 🔥 SAVE STUDENT DETAILS
      await FirebaseFirestore.instance
          .collection("students")
          .doc(user.uid)
          .set({
        "name": nameController.text.trim(),
        "registerNumber": regController.text.trim(),
        "email": emailController.text.trim(),
        "dob": dobController.text.trim(),
        "mobile": mobileController.text.trim(),
      });

      // ✅ NAVIGATE CLEANLY
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const StudentDashboardPage(),
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
        title: const Text("Student Sign Up"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(label: "Name", controller: nameController),
              _field(label: "Register Number", controller: regController),
              _field(
                label: "Email",
                controller: emailController,
                hint: "example: name@gmail.com",
              ),

              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: _field(
                    label: "Date of Birth",
                    controller: dobController,
                    icon: Icons.calendar_month,
                  ),
                ),
              ),

              _field(
                label: "Mobile Number",
                controller: mobileController,
                keyboardType: TextInputType.number,
              ),

              _field(
                label: "Password",
                controller: passwordController,
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
    required String label,
    String? hint,
    bool obscure = false,
    IconData? icon,
    required TextEditingController controller,
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
          if (label == "Mobile Number" && v.length != 10) {
            return "Enter valid 10-digit number";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}