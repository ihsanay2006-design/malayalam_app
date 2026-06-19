import 'package:flutter/material.dart';

class StudentTestPage extends StatefulWidget {
  const StudentTestPage({super.key});

  @override
  State<StudentTestPage> createState() => _StudentTestPageState();
}

class _StudentTestPageState extends State<StudentTestPage> {
  int selectedOption = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Question 1 of 25",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "What is Flutter?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            _option(0, "A UI toolkit by Google"),
            _option(1, "A programming language"),
            _option(2, "A database"),
            _option(3, "An operating system"),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff3b0150),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: const Text(
                "Submit Answer",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _option(int index, String text) {
    return RadioListTile<int>(
      value: index,
      groupValue: selectedOption,
      onChanged: (value) {
        setState(() {
          selectedOption = value!;
        });
      },
      title: Text(text),
    );
  }
}
