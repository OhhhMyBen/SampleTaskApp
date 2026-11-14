import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task_item.dart';
import '../services/task_service.dart';
import '../theme/clay_theme.dart';
import '../widgets/clay_container.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 4));
  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskCategory _selectedCategory = TaskCategory.work;
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ClayColors.primaryContainer,
              onPrimary: Colors.white,
              surface: ClayColors.background,
              onSurface: ClayColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDate),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: ClayColors.primaryContainer,
                onPrimary: Colors.white,
                surface: ClayColors.background,
                onSurface: ClayColors.textPrimary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _saveTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task title'),
          backgroundColor: ClayColors.onErrorContainer,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    Future.delayed(const Duration(milliseconds: 600), () {
      final newTask = TaskItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: _descController.text.trim(),
        dueDate: _selectedDate,
        priority: _selectedPriority,
        category: _selectedCategory,
        isCompleted: false,
      );

      TaskService().addTask(newTask);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task created successfully! 🎉'),
            backgroundColor: ClayColors.mintText,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('EEE, MMM d · h:mm a').format(_selectedDate);

    return Scaffold(
      backgroundColor: ClayColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            _buildAppBar(context),

            // Scrollable Form
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                children: [
                  // Banner Header
                  _buildIntroBanner(),

                  const SizedBox(height: 16),

                  // Main Clay Form Card
                  Container(
                    decoration: BoxDecoration(
                      color: ClayColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: ClayShadows.extruded(offset: 8, blur: 18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.85),
                        width: 1.2,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Field 1: Task Title
                        _buildFieldLabel('Task Title', isRequired: true),
                        const SizedBox(height: 6),
                        ClayTextField(
                          controller: _titleController,
                          hintText: 'What needs to be done?',
                          prefixIcon: Icons.edit_note_rounded,
                        ),

                        const SizedBox(height: 18),

                        // Field 2: Description
                        _buildFieldLabel('Description'),
                        const SizedBox(height: 6),
                        ClayTextField(
                          controller: _descController,
                          hintText: 'Add details, notes, or subtasks...',
                          maxLines: 3,
                        ),

                        const SizedBox(height: 18),

                        // Field 3: Due Date & Time
                        _buildFieldLabel('Due Date & Time'),
                        const SizedBox(height: 6),
                        GestureDetector(
                          onTap: _pickDateTime,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ClayColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: ClayShadows.recessed,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.8),
                                width: 1.0,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_rounded,
                                  color: ClayColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    formattedDate,
                                    style: const TextStyle(
                                      color: ClayColors.textPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.expand_more_rounded,
                                  color: ClayColors.outline,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Field 4: Priority Selector
                        _buildFieldLabel('Priority'),
                        const SizedBox(height: 8),
                        _buildPrioritySelector(),

                        const SizedBox(height: 18),

                        // Field 5: Category Selector
                        _buildFieldLabel('Category'),
                        const SizedBox(height: 8),
                        _buildCategorySelector(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Mindful Momentum Snippet
                  _buildMomentumPill(),

                  const SizedBox(height: 24),

                  // Buttons
                  ClayButton(
                    label: _isSaving ? 'Saving...' : 'Save Task',
                    icon: Icons.add_task_rounded,
                    isPrimary: true,
                    isLoading: _isSaving,
                    onPressed: _isSaving ? null : _saveTask,
                  ),

                  const SizedBox(height: 10),

                  ClayButton(
                    label: 'Cancel',
                    isPrimary: false,
                    onPressed: () => Navigator.of(context).pop(),
                  ),

                  const SizedBox(height: 30),
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
              ClayIconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: ClayColors.textPrimary,
                  size: 22,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 14),
              const Text(
                'Create Task',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ClayColors.textPrimary,
                ),
              ),
            ],
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ClayColors.surfaceContainerLow,
              boxShadow: ClayShadows.subtle(offset: 3, blur: 6),
            ),
            child: const Icon(
              Icons.layers_rounded,
              color: ClayColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroBanner() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan your next goal',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: ClayColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'Sculpt tasks with satisfying ease.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ClayColors.textSecondary,
                  ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ClayColors.blueSurface,
            boxShadow: ClayShadows.subtle(offset: 3, blur: 8),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.draw_rounded,
            color: ClayColors.primary,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ClayColors.textSecondary,
          ),
        ),
        if (isRequired) ...[
          const SizedBox(width: 4),
          const Text(
            '*',
            style: TextStyle(
              color: ClayColors.onErrorContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: [
        Expanded(
          child: _buildPriorityButton(
            TaskPriority.low,
            'Low',
            ClayColors.mintSurface,
            ClayColors.mintText,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPriorityButton(
            TaskPriority.medium,
            'Medium',
            ClayColors.primaryContainer,
            Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildPriorityButton(
            TaskPriority.high,
            'High',
            ClayColors.peachSurface,
            ClayColors.peachText,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityButton(
    TaskPriority priority,
    String label,
    Color activeBg,
    Color activeText,
  ) {
    final isSelected = _selectedPriority == priority;

    return GestureDetector(
      onTap: () => setState(() => _selectedPriority = priority),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : ClayColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: ClayColors.shadowPrimaryDark.withValues(alpha: 0.85),
                    offset: const Offset(4, 4),
                    blurRadius: 10,
                  ),
                  const BoxShadow(
                    color: Colors.white,
                    offset: Offset(-4, -4),
                    blurRadius: 10,
                  ),
                ]
              : ClayShadows.subtle(offset: 2.5, blur: 6),
          border: Border.all(
            color: Colors.white.withValues(alpha: isSelected ? 0.7 : 0.8),
            width: 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? (priority == TaskPriority.medium ? Colors.white : activeText)
                    : ClayColors.outline,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? activeText : ClayColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    final categories = [
      TaskCategory.personal,
      TaskCategory.work,
      TaskCategory.study,
      TaskCategory.other,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          final name = cat.name[0].toUpperCase() + cat.name.substring(1);

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: isSelected
                      ? ClayColors.blueSurface
                      : ClayColors.surfaceContainerLow,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: ClayColors.blueShadow.withValues(alpha: 0.9),
                            offset: const Offset(3, 3),
                            blurRadius: 8,
                          ),
                          const BoxShadow(
                            color: Colors.white,
                            offset: Offset(-3, -3),
                            blurRadius: 8,
                          ),
                        ]
                      : ClayShadows.subtle(offset: 2.5, blur: 6),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.8),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      const Icon(
                        Icons.check_rounded,
                        size: 15,
                        color: ClayColors.textPrimary,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? ClayColors.textPrimary
                            : ClayColors.textSecondary,
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

  Widget _buildMomentumPill() {
    return Container(
      decoration: BoxDecoration(
        color: ClayColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: ClayShadows.recessed,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ClayColors.mintSurface,
              boxShadow: [
                BoxShadow(
                  color: ClayColors.mintShadow.withValues(alpha: 0.8),
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
              Icons.spa_rounded,
              color: ClayColors.mintText,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'MINDFUL MOMENTUM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: ClayColors.mintText,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Breaking it down makes everything achievable!',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: ClayColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
