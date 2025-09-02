import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student.dart';
import 'tutorlist.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';
  String? errorMsg;
  bool loading = false;

  Future<void> _login() async {
    setState(() { loading = true; errorMsg = null; });
    try {
      final res = await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);
      if (res.user != null) {
        // Fetch student profile
        final profileRes = await Supabase.instance.client.from('students').select().eq('email', email).single();
        if (profileRes == null || profileRes.isEmpty) {
          setState(() { errorMsg = 'No student profile found for this account.'; loading = false; });
          return;
        }
        final student = Student.fromMap(profileRes);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => TutorListScreen(student: student)),
        );
      } else {
        setState(() { errorMsg = 'Login failed. Check credentials.'; });
      }
    } catch (e) {
      setState(() { errorMsg = e.toString(); });
    } finally {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (val) => email = val ?? '',
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (val) => password = val ?? '',
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 24),
              if (errorMsg != null)
                Text(errorMsg!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: loading ? null : () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _login();
                  }
                },
                child: loading ? const CircularProgressIndicator() : const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
