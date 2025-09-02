import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/slot.dart';
import '../models/tutor.dart';

class TutorDashboardScreen extends StatefulWidget {
  final Tutor tutor;
  const TutorDashboardScreen({super.key, required this.tutor});

  @override
  State<TutorDashboardScreen> createState() => _TutorDashboardScreenState();
}

class _TutorDashboardScreenState extends State<TutorDashboardScreen> {
  List<Slot> availableSlots = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool loading = false;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchSlots();
  }

  Future<void> _fetchSlots() async {
    setState(() { loading = true; });
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;
      final tutorId = widget.tutor.id;
      final slotsRes = await Supabase.instance.client.from('slots').select().eq('tutor_id', tutorId);
      setState(() {
        availableSlots = List<Slot>.from(slotsRes.map((s) => Slot.fromMap(s)));
        loading = false;
      });
    } catch (e) {
      setState(() { errorMsg = e.toString(); loading = false; });
    }
  }

  Future<void> _addSlot() async {
    if (selectedDate != null && selectedTime != null) {
      setState(() { loading = true; errorMsg = null; });
      try {
        final user = Supabase.instance.client.auth.currentUser;
        if (user == null) return;
        final tutorId = widget.tutor.id;
        final dateStr = selectedDate!.toIso8601String().split('T')[0];
        final timeStr = selectedTime!.format(context);
        final slotRes = await Supabase.instance.client.from('slots').insert({
          'tutor_id': tutorId,
          'date': dateStr,
          'time': timeStr,
        }).select().single();
        setState(() {
          availableSlots.add(Slot.fromMap(slotRes));
          selectedDate = null;
          selectedTime = null;
          loading = false;
        });
      } catch (e) {
        setState(() { errorMsg = e.toString(); loading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tutor Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
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
              color: Colors.green[50],
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(Icons.account_circle, size: 40),
                title: Text(widget.tutor.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text("Your profile summary here"),
              ),
            ),
            const Text("Set Available Slots", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 60)),
                      );
                      if (date != null) setState(() => selectedDate = date);
                    },
                    child: Text(selectedDate == null ? "Select Date" : "${selectedDate!.toLocal()}".split(' ')[0]),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) setState(() => selectedTime = time);
                    },
                    child: Text(selectedTime == null ? "Select Time" : selectedTime!.format(context)),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: loading ? null : _addSlot,
                  child: loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text("Add Slot"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (errorMsg != null)
              Text(errorMsg!, style: const TextStyle(color: Colors.red)),
            const Text("Your Available Slots:", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: availableSlots.length,
                      itemBuilder: (context, idx) {
                        final slot = availableSlots[idx];
                        return ListTile(
                          leading: const Icon(Icons.event_available),
                          title: Text("${slot.date}"),
                          subtitle: Text(slot.time),
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
