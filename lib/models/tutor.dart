class Tutor {
  final String id;
  final String name;
  final String subject;
  final String email;
  final String phone;
  final String qualification;
  final double chargesPerHour;

  Tutor({
    required this.id,
    required this.name,
    required this.subject,
    required this.email,
    required this.phone,
    required this.qualification,
    required this.chargesPerHour,
  });

  factory Tutor.fromMap(Map<String, dynamic> map) => Tutor(
    id: map['id'],
    name: map['name'],
    subject: map['subject'],
    email: map['email'],
    phone: map['phone'] ?? '',
    qualification: map['qualification'] ?? '',
    chargesPerHour: (map['charges_per_hour'] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'subject': subject,
    'email': email,
    'phone': phone,
    'qualification': qualification,
    'charges_per_hour': chargesPerHour,
  };
}
