import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/models/exercise_model.dart';
import '../../data/models/training_day_model.dart';

class FichaController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final List<TrainingDay> days = [];
  bool saving = false;

  void init() {
    if (days.isEmpty) addDay();
  }

  void addExercisesToDay(int dayIndex, List<ExerciseModel> items) {
    final day = days[dayIndex];
    day.exercises.addAll(items);
    notifyListeners();
  }

  void addDay() {
    if (days.length >= 7) return; // máximo de 7 dias
    final index = days.length + 1;
    days.add(TrainingDay(title: 'Dia $index'));
    notifyListeners();
  }

  void removeDay(int index) {
    days[index].dispose();
    days.removeAt(index);
    notifyListeners();
  }

  void toggleCollapse(int index) {
    days[index].collapsed = !days[index].collapsed;
    notifyListeners();
  }

  void addExercisePlaceholder(int index) {
    notifyListeners();
  }

  List<ExerciseModel> allExercises = [];
  bool _exercisesLoaded = false;

  Future<void> onSave() async {
    if (saving) return;
    if (!(formKey.currentState?.validate() ?? false)) return;
    saving = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    saving = false;
    notifyListeners();
  }

  Future<void> loadExercises() async {
    if (_exercisesLoaded) return;
    final raw = await rootBundle.loadString('assets/exercises.json');
    final List data = json.decode(raw);
    allExercises = data.map((e) => ExerciseModel.fromMap(e)).toList();
    _exercisesLoaded = true;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final d in days) {
      d.dispose();
    }
    super.dispose();
  }
}
