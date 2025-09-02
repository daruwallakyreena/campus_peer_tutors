import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tutor.dart';
import '../models/slot.dart';

class TutorDetailScreen extends StatefulWidget {
  final Tutor tutor;
  const TutorDetailScreen({super.key, required this.tutor});

  @override
  State<TutorDetailScreen> createState() => _TutorDetailScreenState();
}

class _TutorDetailScreenState extends State<TutorDetailScreen> {
  List<Slot> availableSlots = [];
  String? bookingMessage;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _fetchSlots();
  }

  Future<void> _fetchSlots() async {
    setState(() { loading = true; });
    try {
      final slotsRes = await Supabase.instance.client
          .from('slots')
          .select()
          .eq('tutor_id', widget.tutor.id);
      setState(() {
        availableSlots = List<Slot>.from(slotsRes.map((s) => Slot.fromMap(s)));
        loading = false;
      });
    } catch (e) {
      setState(() { bookingMessage = 'Failed to fetch slots: $e'; loading = false; });
    }
  }

  Future<void> _bookSlot(Slot slot) async {
    setState(() { loading = true; bookingMessage = null; });
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        setState(() { bookingMessage = 'You must be logged in as a student.'; loading = false; });
        return;
      }
      // Fetch student id from students table using user.email!
      final studentRes = await Supabase.instance.client.from('students').select().eq('email', user.email!).single();
      final studentId = studentRes['id'];
      await Supabase.instance.client.from('appointments').insert({
        'student_id': studentId,
        'tutor_id': widget.tutor.id,
        'slot_id': slot.id,
        'status': 'pending',
      });
      setState(() {
        bookingMessage = 'Appointment requested for ${slot.date} at ${slot.time}!';
        loading = false;
      });
    } catch (e) {
      setState(() { bookingMessage = 'Booking failed: $e'; loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tutor = widget.tutor;

    return Scaffold(
      appBar: AppBar(title: Text(tutor.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${tutor.subject} • ${tutor.qualification}"),
            Text("Charges: ₹${tutor.chargesPerHour}/hr"),
            const SizedBox(height: 20),
            const Text("Available Slots:", style: TextStyle(fontWeight: FontWeight.bold)),
            if (loading)
              const Center(child: CircularProgressIndicator()),
            ...availableSlots.map((slot) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.event_available),
                    title: Text("${slot.date} at ${slot.time}"),
                    trailing: ElevatedButton(
                      child: const Text("Request"),
                      onPressed: loading ? null : () => _bookSlot(slot),
                    ),
                  ),
                )),
            if (bookingMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(bookingMessage!, style: const TextStyle(color: Colors.green)),
              ),
          ],
        ),
      ),
    );
  }
}
