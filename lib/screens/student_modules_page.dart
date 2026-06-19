import 'package:flutter/material.dart';
import 'student_learning_page.dart';

class StudentModulesPage extends StatelessWidget {
  const StudentModulesPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Learning Modules"),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            moduleCard(context, "Alphabet", Icons.text_fields, Colors.orange),

            const SizedBox(height: 20),

            moduleCard(context, "Word", Icons.menu_book, Colors.green),

            const SizedBox(height: 20),

            moduleCard(context, "Sentence", Icons.subject, Colors.purple),

          ],
        ),
      ),
    );
  }

  Widget moduleCard(
      BuildContext context,
      String level,
      IconData icon,
      Color color,
      ) {

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),

        title: Text(
          level,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        trailing: const Icon(Icons.arrow_forward_ios),

        onTap: () {

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StudentLearningPage(level: level),
            ),
          );

        },
      ),
    );
  }
}