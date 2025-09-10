import 'package:flutter/material.dart';

import '../../data/models/training_day_model.dart';

class FichaController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final List<TrainingDay> days = [];
  bool saving = false;

  void init() {
    if (days.isEmpty) addDay();
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

  Future<void> onSave() async {
    if (saving) return;
    if (!(formKey.currentState?.validate() ?? false)) return;
    saving = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    saving = false;
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
