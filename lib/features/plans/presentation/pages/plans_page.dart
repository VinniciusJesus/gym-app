import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/shared/theme/app_colors.dart';
import '../../../../core/shared/ui/card_widget.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlansController>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<PlansController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        centerTitle: true,
        title: const Text(
          'Planos',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: c.onCreateFicha,
        icon: const Icon(Icons.add, color: AppColors.primary),
        label: const Text('Nova Ficha'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CardWidget(
                    title: 'Minhas fichas',
                    child:
                        c.loading
                            ? const _SectionLoading()
                            : c.userPlans.isEmpty
                            ? const _EmptyState(
                              text: 'Você ainda não possui fichas',
                            )
                            : ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: c.userPlans.length,
                              separatorBuilder:
                                  (_, __) => const Divider(
                                    height: 1,
                                    color: Color(0xFFE9EEF3),
                                  ),
                              itemBuilder: (_, i) {
                                final p = c.userPlans[i];
                                return _PlanTile(
                                  title: p.title,
                                  subtitle: p.subtitle,
                                  locked: p.locked,
                                  onTap: () => c.onOpenPlan(p),
                                  onMore: () => c.onPlanMore(p),
                                );
                              },
                            ),
                  ),
                  const SizedBox(height: 16),
                  CardWidget(
                    title: 'Treinos liberados',
                    child:
                        c.loading
                            ? const _SectionLoading()
                            : _WorkoutsList(
                              items: c.readyWorkoutsUnlocked,
                              locked: false,
                              onTap: c.onTapUnlocked,
                            ),
                  ),
                  const SizedBox(height: 16),
                  CardWidget(
                    title: 'Treinos bloqueados',
                    child:
                        c.loading
                            ? const _SectionLoading()
                            : _WorkoutsList(
                              items: c.readyWorkoutsLocked,
                              locked: true,
                              onTap: c.onTapLocked,
                            ),
                  ),
                  const SizedBox(height: 16),
                  CardWidget(
                    title: 'Treinos únicos',
                    child:
                        c.loading
                            ? const _SectionLoading()
                            : _WorkoutsList(
                              items: c.singleWorkouts,
                              locked: false,
                              onTap: c.onTapSingle,
                            ),
                  ),
                  const SizedBox(height: 16),
                  CardWidget(
                    title: 'Treinos individualizados',
                    child:
                        c.loading
                            ? const _SectionLoading()
                            : c.personalized.isEmpty
                            ? const _EmptyState(
                              text: 'Nenhum treino individualizado',
                            )
                            : ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: c.personalized.length,
                              separatorBuilder:
                                  (_, __) => const Divider(
                                    height: 1,
                                    color: Color(0xFFE9EEF3),
                                  ),
                              itemBuilder: (_, i) {
                                final p = c.personalized[i];
                                return _PlanTile(
                                  title: p.title,
                                  subtitle:
                                      p.coach == null
                                          ? 'Personal'
                                          : 'Personal • ${p.coach}',
                                  locked: p.locked,
                                  onTap: () => c.onOpenPersonalized(p),
                                  onMore: () => c.onPersonalizedMore(p),
                                );
                              },
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkoutsList extends StatelessWidget {
  final List<WorkoutTemplate> items;
  final bool locked;
  final void Function(WorkoutTemplate) onTap;

  const _WorkoutsList({
    required this.items,
    required this.locked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptyState(text: 'Nada por aqui');
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: items.length,
      separatorBuilder:
          (_, __) => const Divider(height: 1, color: Color(0xFFE9EEF3)),
      itemBuilder: (_, i) {
        final t = items[i];
        return _WorkoutListItem(
          title: t.name,
          imageUrl: t.imageUrl,
          locked: locked,
          onTap: () => onTap(t),
        );
      },
    );
  }
}

class _WorkoutListItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool locked;
  final VoidCallback onTap;

  const _WorkoutListItem({
    required this.title,
    required this.imageUrl,
    required this.onTap,
    this.locked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 48,
                width: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (locked)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Icon(
                  Icons.lock_outline,
                  size: 18,
                  color: Color(0xFF8A94A6),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PlanTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool locked;
  final VoidCallback onTap;
  final VoidCallback onMore;

  const _PlanTile({
    required this.title,
    required this.subtitle,
    required this.locked,
    required this.onTap,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEDEFF2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                locked ? Icons.lock_outline : Icons.fitness_center,
                size: 22,
                color: const Color(0xFF5A6473),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.textSub),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onMore,
              icon: const Icon(Icons.more_horiz),
              color: const Color(0xFF5A6473),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLoading extends StatelessWidget {
  const _SectionLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFEDEFF2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.inbox_outlined,
              size: 22,
              color: Color(0xFF5A6473),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(color: AppColors.textSub)),
          ),
        ],
      ),
    );
  }
}

class PlansController extends ChangeNotifier {
  bool loading = true;

  final List<PlanSummary> userPlans = [];
  final List<WorkoutTemplate> readyWorkoutsUnlocked = [];
  final List<WorkoutTemplate> readyWorkoutsLocked = [];
  final List<WorkoutTemplate> singleWorkouts = [];
  final List<PersonalizedPlan> personalized = [];

  Future<void> init() async {
    loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 300));

    userPlans
      ..clear()
      ..addAll([
        PlanSummary(
          id: '1',
          title: 'Hipertrofia A/B',
          subtitle: 'Atualizado em 02/09',
          locked: false,
        ),
        PlanSummary(
          id: '2',
          title: 'Full Body 3x',
          subtitle: 'Criado em 25/08',
          locked: false,
        ),
      ]);

    readyWorkoutsUnlocked
      ..clear()
      ..addAll([
        WorkoutTemplate(
          id: 'u1',
          name: 'Full Body Iniciante',
          imageUrl:
              'https://images.unsplash.com/photo-1517836357463-d25dfeac3438',
        ),
        WorkoutTemplate(
          id: 'u2',
          name: 'Push/Pull/Legs',
          imageUrl:
              'https://images.unsplash.com/photo-1517963879433-6ad2b056d712',
        ),
        WorkoutTemplate(
          id: 'u3',
          name: 'Upper/Lower',
          imageUrl:
              'https://images.unsplash.com/photo-1518611012118-696072aa579a',
        ),
      ]);

    readyWorkoutsLocked
      ..clear()
      ..addAll([
        WorkoutTemplate(
          id: 'l1',
          name: 'ABC Avançado',
          imageUrl:
              'https://images.unsplash.com/photo-1518611012118-696072aa579a',
        ),
        WorkoutTemplate(
          id: 'l2',
          name: 'Periodização 12 semanas',
          imageUrl:
              'https://images.unsplash.com/photo-1518611012118-696072aa579a',
        ),
      ]);

    singleWorkouts
      ..clear()
      ..addAll([
        WorkoutTemplate(
          id: 's1',
          name: 'Treino de 15 minutos para abdômen',
          imageUrl:
              'https://images.unsplash.com/photo-1518611012118-696072aa579a',
        ),
        WorkoutTemplate(
          id: 's2',
          name: 'Treino para tríceps',
          imageUrl:
              'https://images.unsplash.com/photo-1518611012118-696072aa579a',
        ),
        WorkoutTemplate(
          id: 's3',
          name: 'Treino para bíceps',
          imageUrl:
              'https://images.unsplash.com/photo-1593079831268-3381b0db4a77',
        ),
        WorkoutTemplate(
          id: 's4',
          name: 'Treino para pernas',
          imageUrl:
              'https://images.unsplash.com/photo-1540497077202-7c8a3999166f',
        ),
      ]);

    personalized
      ..clear()
      ..addAll([
        PersonalizedPlan(
          id: 'p1',
          title: 'Periodização 8 semanas',
          coach: 'Coach Ana',
          locked: false,
        ),
        PersonalizedPlan(
          id: 'p2',
          title: 'Reabilitação Ombro',
          coach: 'Coach Leo',
          locked: true,
        ),
      ]);

    loading = false;
    notifyListeners();
  }

  void onCreateFicha() {}
  void onOpenPlan(PlanSummary plan) {}
  void onPlanMore(PlanSummary plan) {}
  void onTapUnlocked(WorkoutTemplate t) {}
  void onTapLocked(WorkoutTemplate t) {}
  void onTapSingle(WorkoutTemplate t) {}
  void onOpenPersonalized(PersonalizedPlan plan) {}
  void onPersonalizedMore(PersonalizedPlan plan) {}
}

class PlanSummary {
  final String id;
  final String title;
  final String subtitle;
  final bool locked;
  PlanSummary({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.locked,
  });
}

class WorkoutTemplate {
  final String id;
  final String name;
  final String imageUrl;
  WorkoutTemplate({
    required this.id,
    required this.name,
    required this.imageUrl,
  });
}

class PersonalizedPlan {
  final String id;
  final String title;
  final String? coach;
  final bool locked;
  PersonalizedPlan({
    required this.id,
    required this.title,
    this.coach,
    this.locked = false,
  });
}
