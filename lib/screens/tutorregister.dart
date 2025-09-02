import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tutor.dart';
import 'tutordashboard.dart';

class TutorRegisterScreen extends StatefulWidget {
  const TutorRegisterScreen({super.key});

  @override
  State<TutorRegisterScreen> createState() => _TutorRegisterScreenState();
}

class _TutorRegisterScreenState extends State<TutorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String subject = '';
  String email = '';
  String phone = '';
  String qualification = '';
  double chargesPerHour = 0.0;
  String password = '';
  String? errorMsg;
  bool loading = false;

  Future<void> _registerTutor() async {
    setState(() { loading = true; errorMsg = null; });
    try {
      final authRes = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      final user = authRes.user;
      if (user == null) {
        setState(() { errorMsg = 'Auth registration failed.'; });
        return;
      }
      final insertRes = await Supabase.instance.client.from('tutors').insert({
        'name': name,
        'subject': subject,
        'email': email,
        'phone': phone,
        'qualification': qualification,
        'charges_per_hour': chargesPerHour,
        'user_id': user.id,
      });
      // Fetch the tutor profile from Supabase
      final profileRes = await Supabase.instance.client.from('tutors').select().eq('email', email).single();
      final tutor = Tutor.fromMap(profileRes);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TutorDashboardScreen(tutor: tutor)),
      );
    } catch (e) {
      setState(() { errorMsg = e.toString(); });
    } finally {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Register as Tutor")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text("Tutor Registration", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Name"),
                  onSaved: (val) => name = val ?? '',
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Subject"),
                  onSaved: (val) => subject = val ?? '',
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email"),
                  onSaved: (val) => email = val ?? '',
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Phone"),
                  onSaved: (val) => phone = val ?? '',
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Qualification"),
                  onSaved: (val) => qualification = val ?? '',
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Charges per Hour"),
                  keyboardType: TextInputType.number,
                  onSaved: (val) => chargesPerHour = double.tryParse(val ?? '0') ?? 0,
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  onSaved: (val) => password = val ?? '',
                  validator: (val) => val == null || val.length < 6 ? 'Min 6 chars' : null,
                ),
                const SizedBox(height: 28),
                if (errorMsg != null)
                  Text(errorMsg!, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: loading ? const CircularProgressIndicator() : const Text("Register & Continue", style: TextStyle(fontSize: 18)),
                  onPressed: loading ? null : () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _registerTutor();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
