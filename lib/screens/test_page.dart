import 'package:flutter/material.dart';
import 'question_data.dart';
import 'result_page.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int currentIndex = 0;
  int score = 0;

  List<Question> get questions => [
    Question(
      question: "What is the Malayalam word for 'Hello'?",
      options: ["Namaste", "Vanakkam", "Namaskaram", "Hello"],
      correctIndex: 2,
    ),
    Question(
      question: "How do you say 'Thank you' in Malayalam?",
      options: ["Dhanyavaad", "Nanni", "Nandri", "Sukriya"],
      correctIndex: 1,
    ),
  ];

  void answer(int selectedOption) {
    if (selectedOption == questions[currentIndex].correctIndex) {
      score++;
    }

    if (currentIndex < questions.length - 1) {
      setState(() => currentIndex++);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            score: score,
            total: questions.length,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Question ${currentIndex + 1}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              question.question,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...question.options.asMap().entries.map(
                  (entry) => ElevatedButton(
                    onPressed: () => answer(entry.key),
                    child: Text(entry.value),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}