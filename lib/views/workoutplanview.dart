import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:szakdoga/models/workout.dart';
import 'package:szakdoga/views/home_view.dart';
import 'package:szakdoga/views/workout_details_view.dart';


class WorkoutPlanner extends StatefulWidget {
  @override
  _WorkoutPlannerState createState() => _WorkoutPlannerState();
}

class _WorkoutPlannerState extends State<WorkoutPlanner> {
  List<Workout> workouts = [];
  List<Exercise> availableExercises = [
    Exercise(
        ename: 'Gyakorlat 1',
        category: 'Kar',
        sets: 3,
        repetitions: 10,
        weight: 0.0),
    Exercise(
        ename: 'Gyakorlat 2',
        category: 'Has',
        sets: 4,
        repetitions: 12,
        weight: 0.0),
    Exercise(
        ename: 'Gyakorlat 3',
        category: 'Hát',
        sets: 3,
        repetitions: 8,
        weight: 0.0),
    Exercise(
        ename: 'Gyakorlat 4',
        category: 'Láb',
        sets: 3,
        repetitions: 8,
        weight: 0.0),
    Exercise(
        ename: 'Gyakorlat 5',
        category: 'Mell',
        sets: 3,
        repetitions: 8,
        weight: 0.0),
    Exercise(
        ename: 'Gyakorlat 6',
        category: 'Váll',
        sets: 3,
        repetitions: 8,
        weight: 0.0),
    Exercise(
        ename: 'Gyakorlat 7',
        category: 'Teljes test',
        sets: 3,
        repetitions: 8,
        weight: 0.0),
    Exercise(
        ename: 'Bicep Curls',
        category: 'Kar',
        sets: 3,
        repetitions: 10,
        weight: 0.0),
    // további gyakorlatok
  ];

  Exercise? selectedExercise;

  TextEditingController workoutNameController = TextEditingController();
  TextEditingController exerciseNameController = TextEditingController();
  TextEditingController setsController = TextEditingController();
  TextEditingController repetitionsController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController categorySearchController =
      TextEditingController(); // Új mező: kategória kereső
  List<Exercise> filteredExercises = []; // Új változó

  String? selectedCategory; // Új változó
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(HomeView());
          },
        ),
        backgroundColor: Colors.black54,
        title: Center(child: Text('Edzésterv Tervező')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Edzésterv neve:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            TextField(
              controller: workoutNameController,
              decoration: InputDecoration(labelText: 'Pl.: Push-Pull'),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Gyakorlat hozzáadása:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: exerciseNameController,
                    decoration: InputDecoration(labelText: 'Gyakorlat neve'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.playlist_add),
                  onPressed: () {
                    showExerciseDialog();
                  },
                ),
              ],
            ),
            TextField(
              controller: setsController,
              decoration: InputDecoration(labelText: 'Szettek száma'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: repetitionsController,
              decoration: InputDecoration(labelText: 'Ismétlések száma'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Súly (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  addExercise();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.black54, // Itt állíthatod be a háttérszínt
                ),
                child: Text('Hozzáadás'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Edzéstervek:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
  itemCount: workouts.length,
  itemBuilder: (context, index) {
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    startWorkout(workouts[index].exercises);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54,
                  ),
                  child: Text('Kezdés'),
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(workouts[index].wname),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteWorkout(index);
                  },
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var exercise in workouts[index].exercises)
                  ListTile(
                    title: Text(
                      '${exercise.ename}: ${exercise.sets} szett, ${exercise.repetitions} ismétlés, Súly: ${exercise.weight} kg',
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        deleteExercise(index, exercise);
                      },
                      child: Text('Törlés'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  },
),
            ),
          ],
        ),
      ),
    );
  }
  void startWorkout(List<Exercise> exercises) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => WorkoutDetailsView(exercises: exercises),
    ),
  );
}

  void showExerciseDialog() {
    showDialog(
      context: context,
      builder: (context) {
        List<String> availableCategories = availableExercises
            .map((exercise) => exercise.category)
            .toSet()
            .toList();

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Válassz egy gyakorlatot'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Keresés',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredExercises = availableExercises
                              .where((exercise) =>
                                  exercise.ename
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) &&
                                  exercise.category.toLowerCase().contains(
                                      selectedCategory?.toLowerCase() ?? ''))
                              .toList();
                        });
                      },
                    ),
                    DropdownButton(
                      value: selectedCategory,
                      hint: Text('Válassz kategóriát'),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                          filteredExercises = availableExercises
                              .where((exercise) => exercise.category
                                  .toLowerCase()
                                  .contains(
                                      selectedCategory?.toLowerCase() ?? ''))
                              .toList();
                        });
                      },
                      items: availableCategories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    for (var exercise in filteredExercises)
                      ListTile(
                        title: Text(exercise.ename),
                        subtitle: Text('Kategória: ${exercise.category}'),
                        onTap: () {
                          setState(() {
                            selectedExercise = exercise;
                            exerciseNameController.text = exercise.ename;
                            weightController.text = exercise.weight.toString();
                          });
                          Navigator.pop(context);
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Mégse'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void addExercise() {
    String exerciseName = exerciseNameController.text;
    String exerciseCategory = selectedExercise?.category ??
        ""; // Kategóriát csak akkor veszi figyelembe, ha egy meglévő gyakorlatot választunk
    int sets = int.tryParse(setsController.text) ?? 0;
    int repetitions = int.tryParse(repetitionsController.text) ?? 0;
    double weight = double.tryParse(weightController.text) ?? 0.0;

    if (exerciseName.isNotEmpty && sets > 0 && repetitions > 0) {
      Exercise exercise = Exercise(
        ename: exerciseName,
        category: exerciseCategory,
        sets: sets,
        repetitions: repetitions,
        weight: weight,
      );

      if (workoutNameController.text.isEmpty) {
        workoutNameController.text = 'Edzésterv ${workouts.length + 1}';
      }

      Workout workout = workouts.firstWhere(
        (w) => w.wname == workoutNameController.text,
        orElse: () {
          Workout newWorkout = Workout(
            wname: workoutNameController.text,
            exercises: [],
          );
          workouts.add(newWorkout);
          return newWorkout;
        },
      );

      setState(() {
        workout.exercises.add(exercise);
        workoutNameController.clear();
        exerciseNameController.clear();
        setsController.clear();
        repetitionsController.clear();
        weightController.clear();
      });
    } else {
      // Hibakezelés, pl. ha a beviteli mezők nincsenek kitöltve megfelelően
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Hiba'),
          content: Text('Kérlek töltsd ki megfelelően az összes mezőt.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void deleteWorkout(int index) {
    setState(() {
      workouts.removeAt(index);
    });
  }

  void deleteExercise(int workoutIndex, Exercise exercise) {
    setState(() {
      workouts[workoutIndex].exercises.remove(exercise);
    });
  }
}
