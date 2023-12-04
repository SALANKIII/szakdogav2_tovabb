class Workout {
  String wname;
  List<Exercise> exercises;

  Workout({required this.wname, required this.exercises});

  factory Workout.fromJson(Map<String, dynamic> json){
    return Workout(wname: json['wname'] as String, exercises: json['exercise'] as List<Exercise>);
  }
}
class Exercise {
  String ename;
  String category; // Új mező: kategória
  int sets;
  int repetitions;
  double weight;

  Exercise({
    required this.ename,
    required this.category,
    required this.sets,
    required this.repetitions,
    required this.weight,
  });
  factory Exercise.fromJson(Map<String, dynamic> json){
    return Exercise(ename: json['ename'] as String,
     category: json['category'] as String,
      sets: json['category'] as int,
      repetitions: json['repetitions'] as int,
      weight: json['weight'] as double
      );
  }
}