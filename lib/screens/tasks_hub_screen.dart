import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_item.dart';
import '../services/task_service.dart';
import '../theme/clay_theme.dart';
import '../widgets/clay_container.dart';
import 'add_task_screen.dart';

class TasksHubScreen extends StatefulWidget {
  final VoidCallback onOpenProfile;

  const TasksHubScreen({super.key, required this.onOpenProfile});

  @override
  State<TasksHubScreen> createState() => _TasksHubScreenState();
}

class _TasksHubScreenState extends State<TasksHubScreen> {
  final TaskService _taskService = TaskService();
  String _selectedFilter = 'All';

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

  List<TaskItem> _getFilteredTasks() {
    final now = DateTime.now();
    switch (_selectedFilter) {
      case 'Today':
        return _taskService.tasks.where((t) {
          return t.dueDate.year == now.year &&
              t.dueDate.month == now.month &&
              t.dueDate.day == now.day;
        }).toList();
      case 'Upcoming':
        return _taskService.tasks.where((t) {
          final taskDate = DateTime(t.dueDate.year, t.dueDate.month, t.dueDate.day);
          final today = DateTime(now.year, now.month, now.day);
          return taskDate.isAfter(today) && !t.isCompleted;
        }).toList();
      case 'Completed':
        return _taskService.completedTasks;
      case 'All':
      default:
        return _taskService.tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _getFilteredTasks();
    final total = _taskService.totalCount;
    final completed = _taskService.completedCount;
    final pending = _taskService.pendingCount;
    final percent = total == 0 ? 0 : ((completed / total) * 100).round();
    final todayStr = DateFormat('EEEE, MMM d').format(DateTime.now());

    return Scaffold(
      backgroundColor: ClayColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildTopAppBar(context),

            // Scrollable Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  // Greeting & Focus button
                  _buildGreeting(),

                  const SizedBox(height: 16),

                  // Daily Productivity Overview Card (Lavender)
                  _buildProductivityCard(todayStr, percent, completed, total),

                  const SizedBox(height: 16),

                  // Mini Summary Cards (3 Columns)
                  _buildSummaryCards(total, completed, pending),

                  const SizedBox(height: 22),

                  // Section Title & Tune button
                  _buildSectionHeader(),

                  const SizedBox(height: 12),

                  // Category Filter Pills
                  _buildFilterPills(total, completed),

                  const SizedBox(height: 16),

                  // Task List
                  if (tasks.isEmpty)
                    _buildEmptyState()
                  else
                    ...tasks.map((task) => _buildTaskCard(task)),

                  // Bottom padding to avoid FAB overlap
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: _buildFab(context),
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Title
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
                          letterSpacing: -0.3,
                        ),
                  ),
                  Text(
                    'Tasks Hub',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: ClayColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ],
          ),

          // Actions: Notification & Profile
          Row(
            children: [
              ClayIconButton(
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: ClayColors.textSecondary,
                  size: 22,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No new notifications'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              ClayIconButton(
                icon: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF8C9EFF), Color(0xFFDCE3FF)],
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: widget.onOpenProfile,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Good morning, Alex',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: ClayColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(width: 6),
                const Text('👋', style: TextStyle(fontSize: 22)),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              "Let's make today productive.",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ClayColors.textSecondary,
                  ),
            ),
          ],
        ),
        ClayIconButton(
          icon: const Icon(
            Icons.bolt_rounded,
            color: ClayColors.primary,
            size: 22,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Quick Focus Mode activated! 🎯'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductivityCard(
      String todayStr, int percent, int completed, int total) {
    return Container(
      decoration: BoxDecoration(
        color: ClayColors.lavenderSurface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: ClayShadows.extruded(offset: 8, blur: 18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                todayStr.toUpperCase(),
                style: const TextStyle(
                  color: ClayColors.lavenderText,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC8C2E5).withValues(alpha: 0.8),
                      offset: const Offset(2, 2),
                      blurRadius: 5,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-2, -2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: ClayColors.lavenderText,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Your productivity',
            style: TextStyle(
              color: ClayColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$percent%',
                    style: const TextStyle(
                      color: ClayColors.textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$completed of $total tasks completed',
                    style: const TextStyle(
                      color: Color(0xFF615796),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              // Tactile Ring Badge
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE0D7FC),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFC8C2E5).withValues(alpha: 0.9),
                      offset: const Offset(3, 3),
                      blurRadius: 6,
                    ),
                    const BoxShadow(
                      color: Colors.white,
                      offset: Offset(-3, -3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ClayColors.mintSurface,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC5D9CE).withValues(alpha: 0.8),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                      const BoxShadow(
                        color: Colors.white,
                        offset: Offset(-2, -2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.trending_up_rounded,
                    color: ClayColors.mintText,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Rounded progress track
          Container(
            height: 14,
            decoration: BoxDecoration(
              color: const Color(0xFFD5CAFC),
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFBDB0E8).withValues(alpha: 0.8),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-2, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            padding: const EdgeInsets.all(2.5),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: (percent / 100).clamp(0.02, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF65BFA0), Color(0xFF88DFC2)],
                  ),
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(int total, int completed, int pending) {
    return Row(
      children: [
        Expanded(
          child: _buildMiniCard(
            title: 'Total Tasks',
            value: '$total',
            icon: Icons.assignment_outlined,
            color: ClayColors.lavenderSurface,
            iconColor: const Color(0xFF554699),
            textColor: ClayColors.textPrimary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMiniCard(
            title: 'Completed',
            value: '$completed',
            icon: Icons.check_circle_rounded,
            color: ClayColors.mintSurface,
            iconColor: ClayColors.mintText,
            textColor: ClayColors.mintText,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMiniCard(
            title: 'Pending',
            value: '$pending',
            icon: Icons.schedule_rounded,
            color: ClayColors.peachSurface,
            iconColor: ClayColors.peachText,
            textColor: ClayColors.peachText,
          ),
        ),
      ],
    );
  }

  Widget _buildMiniCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: ClayShadows.subtle(offset: 4, blur: 10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.85),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.7),
              boxShadow: [
                BoxShadow(
                  color: ClayColors.shadowDark.withValues(alpha: 0.4),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
                const BoxShadow(
                  color: Colors.white,
                  offset: Offset(-2, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: ClayColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Tasks',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ClayColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'Keep moving forward.',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: ClayColors.textSecondary,
                  ),
            ),
          ],
        ),
        ClayIconButton(
          size: 38,
          borderRadius: 14,
          icon: const Icon(
            Icons.tune_rounded,
            color: ClayColors.outline,
            size: 18,
          ),
          onPressed: () {
            // Cycle filter quickly
            final options = ['All', 'Today', 'Upcoming', 'Completed'];
            final nextIdx = (options.indexOf(_selectedFilter) + 1) % options.length;
            setState(() => _selectedFilter = options[nextIdx]);
          },
        ),
      ],
    );
  }

  Widget _buildFilterPills(int total, int completed) {
    final filters = [
      {'name': 'All', 'count': total},
      {'name': 'Today', 'count': 4},
      {'name': 'Upcoming', 'count': 3},
      {'name': 'Completed', 'count': completed},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: filters.map((item) {
          final name = item['name'] as String;
          final count = item['count'] as int;
          final isSelected = _selectedFilter == name;

          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
                child: Text(
                  '$name ($count)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : ClayColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskCard(TaskItem task) {
    final isDone = task.isCompleted;

    String categoryText;
    Color catBg;
    Color catText;

    if (isDone) {
      categoryText = 'Done';
      catBg = ClayColors.mintSurface;
      catText = ClayColors.mintText;
    } else {
      switch (task.priority) {
        case TaskPriority.high:
          categoryText = 'Important';
          catBg = ClayColors.peachSurface;
          catText = ClayColors.peachText;
          break;
        case TaskPriority.medium:
          categoryText = task.category.name[0].toUpperCase() +
              task.category.name.substring(1);
          catBg = ClayColors.blueSurface;
          catText = ClayColors.blueText;
          break;
        case TaskPriority.low:
          categoryText = task.category.name[0].toUpperCase() +
              task.category.name.substring(1);
          catBg = ClayColors.lavenderSurface;
          catText = ClayColors.lavenderText;
          break;
      }
    }

    final timeStr = DateFormat('h:mm a').format(task.dueDate);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDone ? ClayColors.mintSurface : ClayColors.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
        boxShadow: ClayShadows.extruded(offset: 6, blur: 14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tactile Checkbox
              ClayCheckbox(
                value: isDone,
                onChanged: (_) => _taskService.toggleTaskCompletion(task.id),
              ),
              const SizedBox(width: 12),
              // Task Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDone
                            ? ClayColors.textSecondary
                            : ClayColors.textPrimary,
                        decoration:
                            isDone ? TextDecoration.lineThrough : null,
                        decorationColor: ClayColors.outline,
                        decorationThickness: 2,
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDone
                              ? const Color(0xFF8EA297)
                              : ClayColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Category / Status Tag
              ClayPill(
                label: categoryText,
                backgroundColor: catBg,
                textColor: catText,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Metadata bottom row
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: [
                Icon(
                  isDone ? Icons.task_alt_rounded : Icons.event_rounded,
                  size: 15,
                  color: isDone
                      ? const Color(0xFF5E8373)
                      : ClayColors.outline,
                ),
                const SizedBox(width: 4),
                Text(
                  isDone ? 'Completed' : 'Today · $timeStr',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDone
                        ? const Color(0xFF5E8373)
                        : ClayColors.outline,
                  ),
                ),
                if (!isDone) ...[
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.flag_rounded,
                    size: 15,
                    color: ClayColors.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.priority.name[0].toUpperCase() +
                        task.priority.name.substring(1),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ClayColors.outline,
                    ),
                  ),
                ],
              ],
            ),
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
              'No tasks found for this filter',
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

  Widget _buildFab(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AddTaskScreen()),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [ClayColors.primaryContainer, ClayColors.primaryGradientEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: ClayShadows.fab,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.7),
            width: 1.5,
          ),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
