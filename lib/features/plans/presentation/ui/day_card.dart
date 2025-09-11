import 'package:flutter/material.dart';
import 'package:gym/core/shared/ui/card_widget.dart';
import 'package:gym/features/plans/data/models/exercise_model.dart';

import '../../../../core/shared/theme/app_colors.dart';

class DayCard extends StatelessWidget {
  final TextEditingController titleController;
  final bool collapsed;
  final List<ExerciseModel> exercises;
  final VoidCallback onToggleCollapse;
  final VoidCallback onRemove;
  final VoidCallback onAddExercise;
  final EdgeInsetsGeometry? margin;
  const DayCard({
    super.key,
    required this.titleController,
    required this.collapsed,
    required this.exercises,
    required this.onToggleCollapse,
    required this.onRemove,
    required this.onAddExercise,
    this.margin,
  });
  @override
  Widget build(BuildContext context) {
    final exercisesCount = exercises.length;
    return Padding(
      padding: margin ?? const EdgeInsets.only(bottom: 12),
      child: CardWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: titleController,
                    validator:
                        (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Informe um título'
                                : null,
                    decoration: const InputDecoration(
                      hintText: 'Título do dia',
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      suffixIcon: Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: Color(0xFFB0B5C0),
                      ),
                      suffixIconConstraints: BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: collapsed ? 'Expandir' : 'Minimizar',
                  onPressed: onToggleCollapse,
                  icon: Icon(
                    collapsed
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    size: 22,
                  ),
                  color: const Color(0xFF8A94A6),
                  padding: const EdgeInsets.all(4),
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                ),
                IconButton(
                  tooltip: 'Remover dia',
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                  color: const Color(0xFF8A94A6),
                  padding: const EdgeInsets.all(4),
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                ),
              ],
            ),
            if (collapsed) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.fitness_center,
                    size: 14,
                    color: Color(0xFF8A94A6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    exercisesCount == 0
                        ? 'Sem exercícios'
                        : '$exercisesCount exercício${exercisesCount > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: Color(0xFF8A94A6),
                      fontSize: 12.5,
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Exercícios',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    if (exercises.isEmpty)
                      const Text(
                        'Nenhum exercício adicionado',
                        style: TextStyle(color: Color(0xFF8A94A6)),
                      )
                    else
                      Column(
                        children:
                            exercises
                                .map(
                                  (e) => ListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(e.name),
                                    leading: const Icon(Icons.fitness_center),
                                  ),
                                )
                                .toList(),
                      ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: onAddExercise,
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar exercício'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primaryDark,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
