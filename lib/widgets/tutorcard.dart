import 'package:flutter/material.dart';
import '../models/tutor.dart';

class TutorCard extends StatelessWidget {
  final Tutor tutor;
  final VoidCallback onTap;

  const TutorCard({super.key, required this.tutor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(tutor.name),
        subtitle: Text("${tutor.subject} • ₹${tutor.chargesPerHour}/hr"),
        onTap: onTap,
      ),
    );
  }
}
