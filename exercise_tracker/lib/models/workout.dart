class Workout {
  int? id;
  String name;
  int sets;
  int repetitions;
  DateTime date;

  Workout({
    this.id,
    required this.name,
    required this.sets,
    required this.repetitions,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sets': sets,
      'repetitions': repetitions,
      'date': date.toIso8601String(),
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      name: map['name'],
      sets: map['sets'],
      repetitions: map['repetitions'],
      date: DateTime.parse(map['date']),
    );
  }
}
