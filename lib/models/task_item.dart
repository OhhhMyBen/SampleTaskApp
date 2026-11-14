enum TaskPriority { low, medium, high }

enum TaskCategory { personal, work, study, other }

class TaskItem {
  final String id;
  String title;
  String description;
  DateTime dueDate;
  TaskPriority priority;
  TaskCategory category;
  bool isCompleted;
  DateTime? completedAt;

  TaskItem({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.work,
    this.isCompleted = false,
    this.completedAt,
  });

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskCategory? category,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
