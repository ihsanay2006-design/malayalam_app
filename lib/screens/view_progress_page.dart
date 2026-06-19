import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewProgressPage extends StatelessWidget {
  const ViewProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Student Progress")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('results').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("No data yet"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];

              return ListTile(
                title: Text("Score: ${data['score']}"),
                subtitle: Text("User: ${data['userId']}"),
              );
            },
          );
        },
      ),
    );
  }
}