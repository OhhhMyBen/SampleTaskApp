import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_item.dart';
import '../services/task_service.dart';
import '../theme/clay_theme.dart';
import '../widgets/clay_container.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  final TaskService _taskService = TaskService();
  String _selectedFilter = 'All Completed';

  @override
  void initState() {
    super.initState();
    _taskService.addListener(_onTasksChanged);
  }

  @override
  void dispose() {
    _taskService.removeListener(_onTasksChanged);
    super.dispose();
  }

  void _onTasksChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final completedTasks = _taskService.completedTasks;
    final total = _taskService.totalCount;
    final count = completedTasks.length;
    final percent = total == 0 ? 0 : ((count / total) * 100).round();

    return Scaffold(
      backgroundColor: ClayColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(context),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  // Title Section
                  _buildHeader(),

                  const SizedBox(height: 16),

                  // Celebration Card
                  _buildCelebrationCard(count, percent),

                  const SizedBox(height: 16),

                  // Filter Pills
                  _buildFilterPills(count),

                  const SizedBox(height: 18),

                  // Completed Tasks
                  if (completedTasks.isEmpty)
                    _buildEmptyState()
                  else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'COMPLETED ITEMS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: ClayColors.outline,
                          ),
                        ),
                        Text(
                          '$count items',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: ClayColors.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...completedTasks.map((task) => _buildCompletedCard(task)),
                  ],

                  const SizedBox(height: 20),

                  // Bottom Utilities
                  _buildUtilityActions(context),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: ClayColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: ClayShadows.subtle(offset: 4, blur: 8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.85),
                    width: 1.2,
                  ),
                ),
                child: const Icon(
                  Icons.layers_rounded,
                  color: ClayColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Clay Tasks',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ClayColors.textPrimary,
                        ),
                  ),
                  Text(
                    'Completed Archive',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: ClayColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),
          ClayIconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: ClayColors.textSecondary,
              size: 22,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completed Tasks',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ClayColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              "Look how far you've come.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ClayColors.textSecondary,
                  ),
            ),
          ],
        ),
        Row(
          children: [
            ClayIconButton(
              icon: const Icon(
                Icons.search_rounded,
                color: ClayColors.textSecondary,
                size: 20,
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            ClayIconButton(
              icon: const Icon(
                Icons.tune_rounded,
                color: ClayColors.textSecondary,
                size: 20,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCelebrationCard(int count, int percent) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD0E8DB), Color(0xFFDBE2FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: ClayShadows.extruded(offset: 8, blur: 18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 3D Trophy Badge
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: ClayColors.shadowPrimaryDark.withValues(alpha: 0.8),
                  offset: const Offset(3, 3),
                  blurRadius: 8,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-3, -3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: ClayColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '$count Tasks Accomplished',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: ClayColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: ClayColors.shadowDark.withValues(alpha: 0.3),
                            offset: const Offset(1, 1),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Text(
                        '$percent%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: ClayColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Keep up the momentum! You're making excellent progress on your goals.",
                  style: TextStyle(
                    fontSize: 12,
                    color: ClayColors.textSecondary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                // Tactile Progress Bar
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFBAC6D4).withValues(alpha: 0.6),
                        offset: const Offset(1.5, 1.5),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(1.5),
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: (percent / 100).clamp(0.05, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [ClayColors.primary, ClayColors.primaryContainer],
                        ),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPills(int count) {
    final filters = [
      {'name': 'All Completed', 'count': count},
      {'name': 'Today', 'count': 2},
      {'name': 'This Week', 'count': 1},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: filters.map((item) {
          final name = item['name'] as String;
          final isSelected = _selectedFilter == name;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: isSelected
                      ? ClayColors.primaryContainer
                      : ClayColors.surfaceContainerLow,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: ClayColors.shadowPrimaryDark.withValues(alpha: 0.9),
                            offset: const Offset(4, 4),
                            blurRadius: 10,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-4, -4),
                            blurRadius: 10,
                          ),
                        ]
                      : ClayShadows.subtle(offset: 3, blur: 7),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: isSelected ? 0.6 : 0.8),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    if (isSelected) ...[
                      const Icon(
                        Icons.done_all_rounded,
                        size: 15,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      '$name (${item['count']})',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : ClayColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompletedCard(TaskItem task) {
    final timeStr = task.completedAt != null
        ? DateFormat('h:mm a').format(task.completedAt!)
        : DateFormat('h:mm a').format(task.dueDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: ClayColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        boxShadow: ClayShadows.extruded(offset: 6, blur: 14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.85),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Checked Mint Bead Button
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ClayColors.mintButton,
              boxShadow: [
                BoxShadow(
                  color: ClayColors.mintShadow.withValues(alpha: 0.9),
                  offset: const Offset(2.5, 2.5),
                  blurRadius: 6,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-2.5, -2.5),
                  blurRadius: 6,
                ),
              ],
              border: Border.all(color: Colors.white, width: 1.2),
            ),
            child: const Icon(
              Icons.check_rounded,
              color: ClayColors.mintText,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          // Task Title & Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: ClayColors.textSecondary,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: ClayColors.outline,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                    ClayPill(
                      label: task.category.name[0].toUpperCase() +
                          task.category.name.substring(1),
                      backgroundColor: ClayColors.blueSurface,
                      textColor: ClayColors.blueText,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 13,
                      color: ClayColors.outline,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$timeStr · Completed',
                      style: const TextStyle(
                        fontSize: 11,
                        color: ClayColors.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Restore / Replay button
          ClayIconButton(
            size: 34,
            icon: const Icon(
              Icons.replay_rounded,
              size: 17,
              color: ClayColors.textSecondary,
            ),
            tooltip: 'Restore to pending',
            onPressed: () {
              _taskService.toggleTaskCompletion(task.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Restored "${task.title}" to active tasks'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ClayColors.surfaceContainerLow,
                boxShadow: ClayShadows.subtle(),
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: ClayColors.outline,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No completed tasks yet',
              style: TextStyle(
                color: ClayColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUtilityActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ClayButton(
                label: 'Export Summary',
                icon: Icons.ios_share_rounded,
                isPrimary: false,
                height: 48,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Completed summary exported! 📄'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                _taskService.clearCompleted();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cleared completed tasks'),
                  ),
                );
              },
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: ClayColors.peachSurface,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: ClayShadows.subtle(offset: 3, blur: 8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.delete_sweep_rounded,
                      color: ClayColors.peachText,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Clear',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: ClayColors.peachText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Archived tasks stay accessible for 30 days.',
          style: TextStyle(
            fontSize: 11,
            color: ClayColors.outline,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
