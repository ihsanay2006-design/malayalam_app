import 'package:flutter/material.dart';

class StudentLearningPage extends StatelessWidget {
  final String level;
  
  const StudentLearningPage({required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Learning Zone")),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.pink],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            _card(
              title: "🎧 Listen & Learn",
              subtitle: "Hear pronunciation",
              icon: Icons.headphones,
              color: Colors.deepOrange,
            ),

            _card(
              title: "🎥 Watch Practice",
              subtitle: "Visual learning",
              icon: Icons.play_circle,
              color: Colors.blue,
            ),

          ],
        ),
      ),
    );
  }

  Widget _card({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, size: 40, color: color),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}