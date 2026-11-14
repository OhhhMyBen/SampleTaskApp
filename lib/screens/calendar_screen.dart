import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_item.dart';
import '../services/task_service.dart';
import '../theme/clay_theme.dart';
import '../widgets/clay_container.dart';
import 'add_task_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final TaskService _taskService = TaskService();
  DateTime _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime _selectedDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day);

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

  void _prevMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _selectToday() {
    setState(() {
      final now = DateTime.now();
      _currentMonth = DateTime(now.year, now.month, 1);
      _selectedDate = DateTime(now.year, now.month, now.day);
    });
  }

  List<TaskItem> _getTasksForSelectedDate() {
    return _taskService.tasks.where((t) {
      return t.dueDate.year == _selectedDate.year &&
          t.dueDate.month == _selectedDate.month &&
          t.dueDate.day == _selectedDate.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tasksForDate = _getTasksForSelectedDate();
    final monthYearStr = DateFormat('MMMM yyyy').format(_currentMonth);
    final selectedDayStr = DateFormat('MMMM d').format(_selectedDate);

    return Scaffold(
      backgroundColor: ClayColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(context),

            // Scrollable Calendar & Agenda
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                children: [
                  // Title and navigation controls
                  _buildHeaderControls(),

                  const SizedBox(height: 16),

                  // Calendar Card
                  _buildCalendarCard(monthYearStr),

                  const SizedBox(height: 22),

                  // Agenda Header
                  _buildAgendaHeader(selectedDayStr, tasksForDate.length),

                  const SizedBox(height: 12),

                  // Tasks for selected day
                  if (tasksForDate.isEmpty)
                    _buildEmptyAgenda()
                  else
                    ...tasksForDate.map((task) => _buildAgendaTaskCard(task)),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: GestureDetector(
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
                    'Calendar Schedule',
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

  Widget _buildHeaderControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendar',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ClayColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'Plan your days.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ClayColors.textSecondary,
                  ),
            ),
          ],
        ),
        Row(
          children: [
            ClayIconButton(
              size: 40,
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: ClayColors.textSecondary,
                size: 22,
              ),
              onPressed: _prevMonth,
            ),
            const SizedBox(width: 8),
            ClayIconButton(
              size: 40,
              icon: const Icon(
                Icons.chevron_right_rounded,
                color: ClayColors.textSecondary,
                size: 22,
              ),
              onPressed: _nextMonth,
            ),
            const SizedBox(width: 8),
            ClayIconButton(
              size: 40,
              backgroundColor: ClayColors.blueSurface,
              icon: const Icon(
                Icons.calendar_view_week_rounded,
                color: ClayColors.primary,
                size: 20,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarCard(String monthYearStr) {
    return Container(
      decoration: BoxDecoration(
        color: ClayColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(26),
        boxShadow: ClayShadows.extruded(offset: 8, blur: 18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.9),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          // Month Name & Today Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    monthYearStr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: ClayColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ClayColors.primaryContainer,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _selectToday,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: ClayColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: ClayShadows.subtle(offset: 2.5, blur: 6),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.8),
                      width: 1,
                    ),
                  ),
                  child: const Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: ClayColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Day of week header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _DayHeader('Sun'),
              _DayHeader('Mon'),
              _DayHeader('Tue'),
              _DayHeader('Wed'),
              _DayHeader('Thu'),
              _DayHeader('Fri'),
              _DayHeader('Sat'),
            ],
          ),

          const SizedBox(height: 8),

          // Calendar Grid
          _buildMonthGrid(),
        ],
      ),
    );
  }

  Widget _buildMonthGrid() {
    final firstDayOfMonth = _currentMonth;
    final startingWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final prevMonthDays =
        DateTime(_currentMonth.year, _currentMonth.month, 0).day;

    final totalSlots = ((startingWeekday + daysInMonth) / 7).ceil() * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.95,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: totalSlots,
      itemBuilder: (context, index) {
        if (index < startingWeekday) {
          final prevDay = prevMonthDays - (startingWeekday - index - 1);
          return Center(
            child: Text(
              '$prevDay',
              style: const TextStyle(
                color: ClayColors.outlineVariant,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        final dayNumber = index - startingWeekday + 1;
        if (dayNumber > daysInMonth) {
          final nextDay = dayNumber - daysInMonth;
          return Center(
            child: Text(
              '$nextDay',
              style: const TextStyle(
                color: ClayColors.outlineVariant,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        final cellDate =
            DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
        final isSelected = _selectedDate.year == cellDate.year &&
            _selectedDate.month == cellDate.month &&
            _selectedDate.day == cellDate.day;

        // Check if there are tasks on this day
        final dayTasks = _taskService.tasks.where((t) {
          return t.dueDate.year == cellDate.year &&
              t.dueDate.month == cellDate.month &&
              t.dueDate.day == cellDate.day;
        }).toList();

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = cellDate),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected
                  ? ClayColors.primaryContainer
                  : (dayTasks.isNotEmpty
                      ? ClayColors.surfaceContainerLow
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(16),
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
                  : (dayTasks.isNotEmpty
                      ? ClayShadows.subtle(offset: 2, blur: 5)
                      : null),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 1.5)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : ClayColors.textPrimary,
                  ),
                ),
                if (dayTasks.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: dayTasks.take(3).map((task) {
                      Color dotColor = task.isCompleted
                          ? ClayColors.mintText
                          : (task.priority == TaskPriority.high
                              ? ClayColors.peachText
                              : (isSelected ? Colors.white : ClayColors.primary));
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: dotColor,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAgendaHeader(String selectedDayStr, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Tasks for $selectedDayStr',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ClayColors.textPrimary,
                  ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: ClayColors.blueSurface,
                borderRadius: BorderRadius.circular(999),
                boxShadow: ClayShadows.subtle(offset: 2, blur: 4),
              ),
              child: Text(
                '$count tasks',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: ClayColors.blueText,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgendaTaskCard(TaskItem task) {
    final isDone = task.isCompleted;
    final timeStr = DateFormat('h:mm a').format(task.dueDate);

    Color badgeBg;
    Color badgeText;
    String badgeLabel;

    if (isDone) {
      badgeBg = ClayColors.mintSurface;
      badgeText = ClayColors.mintText;
      badgeLabel = 'Done';
    } else {
      switch (task.priority) {
        case TaskPriority.high:
          badgeBg = ClayColors.peachSurface;
          badgeText = ClayColors.peachText;
          badgeLabel = 'High';
          break;
        case TaskPriority.medium:
          badgeBg = ClayColors.blueSurface;
          badgeText = ClayColors.blueText;
          badgeLabel = 'Medium';
          break;
        case TaskPriority.low:
          badgeBg = ClayColors.lavenderSurface;
          badgeText = ClayColors.lavenderText;
          badgeLabel = 'Low';
          break;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDone ? ClayColors.mintSurface : ClayColors.surfaceElevated,
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
          ClayCheckbox(
            value: isDone,
            onChanged: (_) => _taskService.toggleTaskCompletion(task.id),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDone
                        ? ClayColors.textSecondary
                        : ClayColors.textPrimary,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                  ),
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
                      timeStr,
                      style: const TextStyle(
                        fontSize: 12,
                        color: ClayColors.outline,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(color: ClayColors.outline)),
                    const SizedBox(width: 8),
                    Text(
                      task.category.name[0].toUpperCase() +
                          task.category.name.substring(1),
                      style: const TextStyle(
                        fontSize: 12,
                        color: ClayColors.outline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ClayPill(
            label: badgeLabel,
            backgroundColor: badgeBg,
            textColor: badgeText,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAgenda() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ClayColors.surfaceContainerLow,
                boxShadow: ClayShadows.subtle(),
              ),
              child: const Icon(
                Icons.event_available_rounded,
                color: ClayColors.outline,
                size: 26,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'No tasks scheduled for this day',
              style: TextStyle(
                color: ClayColors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  final String text;
  const _DayHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: ClayColors.outline,
      ),
    );
  }
}
