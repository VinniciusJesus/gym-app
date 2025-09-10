class ExerciseModel {
  final String id;
  final String name;
  final List<String> targetMuscles;
  final List<String> bodyParts;
  final List<String> equipments;
  final List<String> secondaryMuscles;
  final List<String> instructions;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.targetMuscles,
    required this.bodyParts,
    required this.equipments,
    required this.secondaryMuscles,
    required this.instructions,
  });

  factory ExerciseModel.fromMap(Map<String, dynamic> m) {
    return ExerciseModel(
      id: m['exerciseId'],
      name: m['name'],
      targetMuscles: List<String>.from(m['targetMuscles'] ?? const []),
      bodyParts: List<String>.from(m['bodyParts'] ?? const []),
      equipments: List<String>.from(m['equipments'] ?? const []),
      secondaryMuscles: List<String>.from(m['secondaryMuscles'] ?? const []),
      instructions: List<String>.from(m['instructions'] ?? const []),
    );
  }

  String get gifUrl => 'https://static.exercisedb.dev/media/$id.gif';
}
