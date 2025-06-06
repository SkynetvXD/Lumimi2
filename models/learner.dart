import 'dart:convert';

class Learner {
  final String id;
  final String name;
  final DateTime birthDate;
  final String? diagnosis;
  final DateTime createdAt;
  final DateTime? lastAccess;

  Learner({
    required this.id,
    required this.name,
    required this.birthDate,
    this.diagnosis,
    required this.createdAt,
    this.lastAccess,
  });

  // Idade do aprendiz em anos
  int get age {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month || 
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  // Converter para um mapa (para armazenamento)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'diagnosis': diagnosis,
      'createdAt': createdAt.toIso8601String(),
      'lastAccess': lastAccess?.toIso8601String(),
    };
  }

  // Criar a partir de um mapa (para recuperação)
  factory Learner.fromMap(Map<String, dynamic> map) {
    return Learner(
      id: map['id'],
      name: map['name'],
      birthDate: DateTime.parse(map['birthDate']),
      diagnosis: map['diagnosis'],
      createdAt: DateTime.parse(map['createdAt']),
      lastAccess: map['lastAccess'] != null ? DateTime.parse(map['lastAccess']) : null,
    );
  }

  // Atualizar o momento do último acesso
  Learner updateLastAccess() {
    return Learner(
      id: id,
      name: name,
      birthDate: birthDate,
      diagnosis: diagnosis,
      createdAt: createdAt,
      lastAccess: DateTime.now(),
    );
  }

  // Converter para JSON
  String toJson() => jsonEncode(toMap());

  // Criar a partir de JSON
  factory Learner.fromJson(String source) => Learner.fromMap(jsonDecode(source));
}