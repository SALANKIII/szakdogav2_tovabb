// workout_details_view.dart
import 'package:flutter/material.dart';
import 'package:szakdoga/models/workout.dart';

class WorkoutDetailsView extends StatefulWidget {
  final List<Exercise> exercises;

  WorkoutDetailsView({required this.exercises});

  @override
  _WorkoutDetailsViewState createState() => _WorkoutDetailsViewState();
}

class _WorkoutDetailsViewState extends State<WorkoutDetailsView> {
  List<double?> weights = [];

  @override
  void initState() {
    super.initState();
    // Initialize weights list with null values for each set
    widget.exercises.forEach((exercise) {
      for (int i = 0; i < exercise.sets; i++) {
        weights.add(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edzés részletei'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < widget.exercises.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.exercises[i].ename} - Szett ${i + 1}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        weights[i] = double.tryParse(value);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Súly (kg)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle the weights, you can print or store them as needed
                  print('Weights: $weights');
                  // Navigate back to the workout planner view
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54,
                ),
                child: Text('Mentés'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
