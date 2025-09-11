import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../../../core/shared/theme/app_colors.dart';
import '../../../../core/shared/ui/auth_input.dart';
import '../../../../core/shared/ui/primary_button.dart';
import '../../data/models/exercise_model.dart';
import '../ui/gif_thumb.dart';

class ExercisePickerPage extends StatefulWidget {
  final void Function(List<ExerciseModel> selected)? onDone;
  final void Function(List<ExerciseModel> selected)? onCreateSuperset;

  const ExercisePickerPage({super.key, this.onDone, this.onCreateSuperset});

  @override
  State<ExercisePickerPage> createState() => _ExercisePickerPageState();
}

class _ExercisePickerPageState extends State<ExercisePickerPage> {
  final TextEditingController searchEC = TextEditingController();
  final Set<String> selectedIds = {};
  List<ExerciseModel> all = [];
  List<ExerciseModel> filtered = [];
  String? selectedBodyPart;
  String? selectedEquipment;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
    searchEC.addListener(_applyFilters);
  }

  @override
  void dispose() {
    searchEC.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final raw = await rootBundle.loadString('assets/exercises.json');
    final list = List<Map<String, dynamic>>.from(jsonDecode(raw));
    all = list.map(ExerciseModel.fromMap).toList();
    filtered = all;
    loading = false;
    if (mounted) setState(() {});
  }

  void _applyFilters() {
    final q = searchEC.text.trim().toLowerCase();
    final bp = selectedBodyPart;
    final eq = selectedEquipment;
    filtered =
        all.where((e) {
          final matchesQ =
              q.isEmpty ||
              e.name.toLowerCase().contains(q) ||
              e.targetMuscles.any((m) => m.toLowerCase().contains(q));
          final matchesBp =
              bp == null || bp == 'Todos' || e.bodyParts.contains(bp);
          final matchesEq =
              eq == null || eq == 'Todos' || e.equipments.contains(eq);
          return matchesQ && matchesBp && matchesEq;
        }).toList();
    setState(() {});
  }

  List<String> get bodyParts {
    final s = <String>{};
    for (final e in all) {
      s.addAll(e.bodyParts);
    }
    final list = s.toList()..sort();
    return ['Todos', ...list];
  }

  List<String> get equipments {
    final s = <String>{};
    for (final e in all) {
      s.addAll(e.equipments);
    }
    final list = s.toList()..sort();
    return ['Todos', ...list];
  }

  void _toggle(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selCount = selectedIds.length;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FB),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.close),
                ),
                const SizedBox(width: 8),
                Text('Escolher exercícios', style: theme.textTheme.titleMedium),
                const Spacer(),
                if (selCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(.08),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      '$selCount selecionado${selCount == 1 ? '' : 's'}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const SizedBox(width: 12),
              ],
            ),
          ),
        ),
        // no build:
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Busca
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  child: AuthInput(
                    controller: searchEC,
                    label: 'Busca',
                    hint: 'Buscar por nome ou músculo',
                    action: TextInputAction.search,
                    suffix: const Icon(Icons.search, size: 20),
                  ),
                ),
              ),

              // Filtros
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _FilterBar(
                    bodyParts: bodyParts,
                    equipments: equipments,
                    selectedBodyPart: selectedBodyPart ?? 'Todos',
                    selectedEquipment: selectedEquipment ?? 'Todos',
                    onBodyPart: (v) {
                      selectedBodyPart = v;
                      _applyFilters();
                    },
                    onEquipment: (v) {
                      selectedEquipment = v;
                      _applyFilters();
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Cabeçalho do "Card" (título e divisor) – fica leve como sliver
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 14, 16, 8),
                        child: Text(
                          'Todos os exercícios',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Divider(height: 1, color: Color(0xFFE9EEF3)),
                    ],
                  ),
                ),
              ),

              // Conteúdo do "Card": estados (loading/empty) ou lista
              if (loading)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x0F000000),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const _ListLoading(),
                    ),
                  ),
                )
              else if (filtered.isEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const _Empty(text: 'Nenhum exercício encontrado'),
                  ),
                )
              else
                // Lista performática de fato: sliver list (sem height infinita)
                SliverList.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final e = filtered[i];
                    final selected = selectedIds.contains(e.id);
                    return Container(
                      color: Colors.white,
                      child: _ExerciseTile(
                        model: e,
                        selected: selected,
                        onTap: () => _toggle(e.id),
                      ),
                    );
                  },
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 96),
              ), // espaço p/ bottom bar
            ],
          ),
        ),

        bottomNavigationBar: _BottomActions(
          selectedCount: selCount,
          onAdd:
              selCount == 0
                  ? null
                  : () {
                    final list =
                        all.where((e) => selectedIds.contains(e.id)).toList();
                    widget.onDone?.call(list);
                    Navigator.of(context).maybePop(list);
                  },
          onSuperset:
              selCount < 2
                  ? null
                  : () {
                    final list =
                        all.where((e) => selectedIds.contains(e.id)).toList();
                    widget.onCreateSuperset?.call(list);
                    Navigator.of(context).maybePop(list);
                  },
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final List<String> bodyParts;
  final List<String> equipments;
  final String selectedBodyPart;
  final String selectedEquipment;
  final ValueChanged<String> onBodyPart;
  final ValueChanged<String> onEquipment;

  const _FilterBar({
    required this.bodyParts,
    required this.equipments,
    required this.selectedBodyPart,
    required this.selectedEquipment,
    required this.onBodyPart,
    required this.onEquipment,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ChipDropdown(
          label: 'Região',
          items: bodyParts,
          value: selectedBodyPart,
          onChanged: onBodyPart,
        ),
        _ChipDropdown(
          label: 'Equipamento',
          items: equipments,
          value: selectedEquipment,
          onChanged: onEquipment,
        ),
      ],
    );
  }
}

class _ChipDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String value;
  final ValueChanged<String> onChanged;

  const _ChipDropdown({
    required this.label,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          final v = await showModalBottomSheet<String>(
            context: context,
            showDragHandle: true,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (ctx) {
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: items.length,
                separatorBuilder:
                    (_, __) =>
                        const Divider(height: 1, color: Color(0xFFE9EEF3)),
                itemBuilder: (_, i) {
                  final item = items[i];
                  final selected = item == value;
                  return ListTile(
                    title: Text(item),
                    selectedColor: AppColors.primary,
                    trailing: selected ? const Icon(Icons.check) : null,
                    onTap: () => Navigator.of(ctx).pop(item),
                  );
                },
              );
            },
          );
          if (v != null) onChanged(v);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSub,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.textSub,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.keyboard_arrow_down, color: AppColors.textSub),
            ],
          ),
        ),
      ),
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  final ExerciseModel model;
  final VoidCallback onTap;
  final bool selected;

  const _ExerciseTile({
    required this.model,
    required this.onTap,
    required this.selected,
  });

  String _musclesText() {
    final all = <String>[...model.targetMuscles, ...model.secondaryMuscles];
    return all.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          children: [
            GifThumb(url: model.gifUrl, size: 48),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _musclesText(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF6B7785),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : const Color(0xFFCBD6E2),
                  width: 2,
                ),
                color: selected ? AppColors.primary : Colors.transparent,
              ),
              alignment: Alignment.center,
              child:
                  selected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ListLoading extends StatelessWidget {
  const _ListLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      separatorBuilder:
          (_, __) => const Divider(height: 1, color: Color(0xFFE9EEF3)),
      itemBuilder: (_, __) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4F8),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      width: 160,
                      color: const Color(0xFFEFF4F8),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: 220,
                      color: const Color(0xFFEFF4F8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Empty extends StatelessWidget {
  final String text;
  const _Empty({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _BottomActions extends StatelessWidget {
  final int selectedCount;
  final VoidCallback? onAdd;
  final VoidCallback? onSuperset;

  const _BottomActions({
    required this.selectedCount,
    required this.onAdd,
    required this.onSuperset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Supersérie (${selectedCount.clamp(0, 999)})',
                  onPressed: onSuperset,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  label: 'Adicionar (${selectedCount.clamp(0, 999)})',
                  onPressed: onAdd,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
