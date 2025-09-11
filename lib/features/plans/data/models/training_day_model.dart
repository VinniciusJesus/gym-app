import 'package:flutter/material.dart';

import 'exercise_model.dart';

class TrainingDay {
  final TextEditingController titleEC;
  List<ExerciseModel> exercises = [];
  bool collapsed;
  TrainingDay({String title = '', this.collapsed = false})
    : titleEC = TextEditingController(text: title),
      exercises = [];
  void dispose() => titleEC.dispose();
}
