class Student {
  final String id;
  final String name;
  final String uid;
  final String rollno;
  final String dept;
  final String studentClass;
  final String email;

  Student({
    required this.id,
    required this.name,
    required this.uid,
    required this.rollno,
    required this.dept,
    required this.studentClass,
    required this.email,
  });

  factory Student.fromMap(Map<String, dynamic> map) => Student(
    id: map['id'],
    name: map['name'],
    uid: map['uid'],
    rollno: map['rollno'],
    dept: map['dept'],
    studentClass: map['class'],
    email: map['email'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'uid': uid,
    'rollno': rollno,
    'dept': dept,
    'class': studentClass,
    'email': email,
  };
}

