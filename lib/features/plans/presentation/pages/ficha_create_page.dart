import 'package:flutter/material.dart';
import 'package:gym/core/shared/ui/primary_button.dart';
import 'package:gym/core/shared/ui/secondary_button.dart';
import 'package:provider/provider.dart';

import '../controllers/ficha_controller.dart';
import '../ui/day_card.dart';

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
    final addDisabled = c.days.length >= 7;

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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Form(
                key: c.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SecondaryButton(
                      label:
                          addDisabled
                              ? 'Máximo de 7 dias'
                              : 'Adicionar dia de treino',
                      onPressed: addDisabled ? null : c.addDay,
                      icon: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ...List.generate(c.days.length, (index) {
                              final day = c.days[index];
                              return DayCard(
                                titleController: day.titleEC,
                                collapsed: day.collapsed,
                                exercises: day.exercises,
                                onToggleCollapse: () => c.toggleCollapse(index),
                                onRemove: () => c.removeDay(index),
                                onAddExercise:
                                    () => c.addExercisePlaceholder(index),
                                margin: EdgeInsets.only(
                                  bottom: index == c.days.length - 1 ? 24 : 12,
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
