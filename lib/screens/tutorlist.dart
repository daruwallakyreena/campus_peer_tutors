import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tutor_provider.dart';
import '../widgets/tutorcard.dart';
import 'tutordetail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/student.dart';

class TutorListScreen extends StatefulWidget {
  final Student? student;
  const TutorListScreen({super.key, this.student});

  @override
  State<TutorListScreen> createState() => _TutorListScreenState();
}

class _TutorListScreenState extends State<TutorListScreen> {
  Student? student;
  String? selectedSubject;
  RangeValues priceRange = const RangeValues(100, 1000);

  final _formKey = GlobalKey<FormState>();
  String name = '', uid = '', rollno = '', dept = 'IT', studentClass = 'FY';
  String email = '';
  String password = '';
  String? errorMsg;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      student = widget.student;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (student == null) {
      // Registration form
      return Scaffold(
        appBar: AppBar(title: const Text("Student Registration")),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const Text("Register to find a tutor", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Name"),
                  onSaved: (val) => name = val ?? '',
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "UID"),
                  onSaved: (val) => uid = val ?? '',
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Roll No"),
                  onSaved: (val) => rollno = val ?? '',
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                DropdownButtonFormField<String>(
                  value: dept,
                  decoration: const InputDecoration(labelText: "Department"),
                  items: ['IT', 'SD'].map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (val) => setState(() => dept = val ?? 'IT'),
                ),
                DropdownButtonFormField<String>(
                  value: studentClass,
                  decoration: const InputDecoration(labelText: "Class"),
                  items: ['FY', 'SY', 'TY'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (val) => setState(() => studentClass = val ?? 'FY'),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Email"),
                  onSaved: (val) => email = val ?? '',
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                  onSaved: (val) => password = val ?? '',
                  validator: (val) => val == null || val.length < 6 ? 'Min 6 chars' : null,
                ),
                const SizedBox(height: 32),
                if (errorMsg != null)
                  Text(errorMsg!, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  child: loading ? const CircularProgressIndicator() : const Text("Register & Continue", style: TextStyle(fontSize: 18)),
                  onPressed: loading ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      setState(() { loading = true; errorMsg = null; });
                      try {
                        final authRes = await Supabase.instance.client.auth.signUp(
                          email: email,
                          password: password,
                        );
                        final user = authRes.user;
                        if (user == null) {
                          setState(() { errorMsg = 'Auth registration failed.'; loading = false; });
                          return;
                        }
                        await Supabase.instance.client.from('students').insert({
                          'name': name,
                          'uid': uid,
                          'rollno': rollno,
                          'dept': dept,
                          'class': studentClass,
                          'email': email,
                        });
                        setState(() {
                          student = Student(
                            id: user.id,
                            name: name,
                            uid: uid,
                            rollno: rollno,
                            dept: dept,
                            studentClass: studentClass,
                            email: email,
                          );
                          loading = false;
                        });
                      } catch (e) {
                        setState(() { errorMsg = e.toString(); loading = false; });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Dummy tutors for now
    final tutors = Provider.of<TutorProvider>(context).tutors.where((t) {
      return t.chargesPerHour >= priceRange.start && t.chargesPerHour <= priceRange.end;
    }).toList();
    final subjects = tutors.map((t) => t.subject).toSet().toList();

    final filteredTutors = selectedSubject == null
        ? tutors
        : tutors.where((t) => t.subject == selectedSubject).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => setState(() => student = null),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.blue[50],
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(Icons.account_circle, size: 40),
                title: Text(student!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("UID: ${student!.uid} | Roll: ${student!.rollno}\nDept: ${student!.dept} | Class: ${student!.studentClass}"),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    hint: const Text("Filter by Domain"),
                    value: selectedSubject,
                    items: [null, ...subjects].map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(s ?? "All Domains"),
                    )).toList(),
                    onChanged: (val) => setState(() => selectedSubject = val),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Price Range (₹)", style: TextStyle(fontSize: 12)),
                      RangeSlider(
                        values: priceRange,
                        min: 100,
                        max: 1000,
                        divisions: 9,
                        labels: RangeLabels(
                          priceRange.start.round().toString(),
                          priceRange.end.round().toString(),
                        ),
                        onChanged: (range) => setState(() => priceRange = range),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredTutors.isEmpty
                  ? const Center(child: Text("No tutors found for selected filters."))
                  : ListView.builder(
                      itemCount: filteredTutors.length,
                      itemBuilder: (context, idx) {
                        final tutor = filteredTutors[idx];
                        return TutorCard(
                          tutor: tutor,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => TutorDetailScreen(tutor: tutor)),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
