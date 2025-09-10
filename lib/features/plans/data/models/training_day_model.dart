import 'package:flutter/material.dart';

class TrainingDay {
  final TextEditingController titleEC;
  final List<String> exercises;
  bool collapsed;
  TrainingDay({String title = '', this.collapsed = false})
    : titleEC = TextEditingController(text: title),
      exercises = [];
  void dispose() => titleEC.dispose();
}
