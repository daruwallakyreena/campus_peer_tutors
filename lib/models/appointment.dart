class Appointment {
  final String id;
  final String studentId;
  final String tutorId;
  final String slotId;
  final String status;

  Appointment({
    required this.id,
    required this.studentId,
    required this.tutorId,
    required this.slotId,
    required this.status,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) => Appointment(
    id: map['id'],
    studentId: map['student_id'],
    tutorId: map['tutor_id'],
    slotId: map['slot_id'],
    status: map['status'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'student_id': studentId,
    'tutor_id': tutorId,
    'slot_id': slotId,
    'status': status,
  };
}





