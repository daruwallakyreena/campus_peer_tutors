import 'package:flutter/material.dart';
import '../models/tutor.dart';

class TutorProvider with ChangeNotifier {
  final List<Tutor> _tutors = [];

  List<Tutor> get tutors => _tutors;

  void addTutor(Tutor tutor) {
    _tutors.add(tutor);
    notifyListeners();
  }

  List<Tutor> filterBySubject(String subject) {
    return _tutors.where((t) => t.subject == subject).toList();
  }
}
