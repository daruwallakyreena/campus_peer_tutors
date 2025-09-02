class Slot {
  final String id;
  final String tutorId;
  final String date;
  final String time;

  Slot({
    required this.id,
    required this.tutorId,
    required this.date,
    required this.time,
  });

  factory Slot.fromMap(Map<String, dynamic> map) => Slot(
    id: map['id'],
    tutorId: map['tutor_id'],
    date: map['date'],
    time: map['time'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'tutor_id': tutorId,
    'date': date,
    'time': time,
  };
}





