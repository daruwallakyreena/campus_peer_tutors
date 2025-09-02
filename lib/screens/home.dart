import 'package:flutter/material.dart';
import 'tutorlist.dart';
import 'tutorregister.dart';
import 'studentlogin.dart';
import 'tutorlogin.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Campus Peer Tutors", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome!",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "How would you like to use Campus Peer Tutors?",
                style: TextStyle(fontSize: 18, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon: const Icon(Icons.search, size: 28),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Text("Find a Tutor", style: TextStyle(fontSize: 20)),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TutorListScreen()),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add, size: 28),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  child: Text("Register as Tutor", style: TextStyle(fontSize: 20)),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: Colors.green,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TutorRegisterScreen()),
                ),
              ),
              const SizedBox(height: 40),
              const Divider(height: 1, thickness: 1),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.login, size: 24),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  child: Text("Login as Student", style: TextStyle(fontSize: 18)),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.blueGrey,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentLoginScreen()),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.login, size: 24),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                  child: Text("Login as Tutor", style: TextStyle(fontSize: 18)),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.teal,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TutorLoginScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
