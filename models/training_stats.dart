class TrainingStats {
  final int successes;
  final int errors;
  final int totalAttempts;
  final DateTime? date;

  TrainingStats({
    required this.successes,
    required this.errors,
    required this.totalAttempts,
    this.date,
  });

  double get successPercentage => (successes / totalAttempts) * 100;
  double get errorPercentage => (errors / totalAttempts) * 100;
  
  // Função para converter em Map para armazenamento
  Map<String, dynamic> toMap() {
    return {
      'successes': successes,
      'errors': errors,
      'totalAttempts': totalAttempts,
      'date': date?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }
  
  // Função para criar objeto a partir de Map
  factory TrainingStats.fromMap(Map<String, dynamic> map) {
    return TrainingStats(
      successes: map['successes'],
      errors: map['errors'],
      totalAttempts: map['totalAttempts'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
    );
  }
}