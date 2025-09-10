import 'package:flutter/material.dart';
import 'package:gym/core/shared/ui/primary_button.dart';
import 'package:provider/provider.dart';

import '../../../../core/shared/theme/app_colors.dart';
import '../../../../core/shared/ui/auth_input.dart';
import '../../../../core/shared/ui/card_widget.dart';

class TrainingDay {
  final TextEditingController titleEC;
  final List<String> exercises;
  TrainingDay({String title = ''})
    : titleEC = TextEditingController(text: title),
      exercises = [];
  void dispose() => titleEC.dispose();
}

class FichaController extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final List<TrainingDay> days = [];
  bool saving = false;

  void init() {
    if (days.isEmpty) addDay();
  }

  void addDay() {
    final index = days.length + 1;
    days.add(TrainingDay(title: 'Dia $index'));
    notifyListeners();
  }

  void removeDay(int index) {
    days[index].dispose();
    days.removeAt(index);
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

class FichaCreatePage extends StatefulWidget {
  const FichaCreatePage({super.key});
  @override
  State<FichaCreatePage> createState() => _FichaCreatePageState();
}

class _FichaCreatePageState extends State<FichaCreatePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FichaController>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<FichaController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        centerTitle: true,
        title: const Text(
          'Criar Ficha',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Form(
                key: c.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AddDayButton(onTap: c.addDay),
                    const SizedBox(height: 12),
                    ...List.generate(c.days.length, (index) {
                      final day = c.days[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == c.days.length - 1 ? 24 : 12,
                        ),
                        child: CardWidget(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Dia ${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => c.removeDay(index),
                                    icon: const Icon(Icons.delete_outline),
                                    color: const Color(0xFF8A94A6),
                                    tooltip: 'Remover dia',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              AuthInput(
                                controller: day.titleEC,
                                label: 'Título do dia',
                                hint: 'Ex: Peito e Tríceps',
                                validator:
                                    (v) =>
                                        (v == null || v.trim().isEmpty)
                                            ? 'Informe um título'
                                            : null,
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F4F7),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Text(
                                      'Exercícios',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    if (day.exercises.isEmpty)
                                      const Text(
                                        'Nenhum exercício adicionado',
                                        style: TextStyle(
                                          color: Color(0xFF8A94A6),
                                        ),
                                      ),
                                    if (day.exercises.isNotEmpty)
                                      Column(
                                        children:
                                            day.exercises
                                                .map(
                                                  (e) => ListTile(
                                                    dense: true,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    title: Text(e),
                                                    leading: const Icon(
                                                      Icons.fitness_center,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                      ),
                                    const SizedBox(height: 8),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton.icon(
                                        onPressed:
                                            () =>
                                                c.addExercisePlaceholder(index),
                                        icon: const Icon(Icons.add),
                                        label: const Text(
                                          'Adicionar exercício',
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor:
                                              AppColors.primaryDark,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    PrimaryButton(
                      label: 'Salvar ficha',
                      loading: c.saving,
                      onPressed: c.saving ? null : c.onSave,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: _FabAddDay(onTap: c.addDay),
    );
  }
}

class _AddDayButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddDayButton({required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add),
      label: const Text('Adicionar dia de treino'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        side: BorderSide(color: AppColors.primaryDark.withOpacity(0.35)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

class _FabAddDay extends StatelessWidget {
  final VoidCallback onTap;
  const _FabAddDay({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      icon: const Icon(Icons.add),
      label: const Text('Novo dia'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
