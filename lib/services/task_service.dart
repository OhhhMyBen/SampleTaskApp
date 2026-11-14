import 'package:flutter/foundation.dart';

import '../models/task_item.dart';

class TaskService extends ChangeNotifier {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;

  TaskService._internal() {
    _initSampleTasks();
  }

  final List<TaskItem> _tasks = [];

  List<TaskItem> get tasks => List.unmodifiable(_tasks);

  List<TaskItem> get pendingTasks =>
      _tasks.where((t) => !t.isCompleted).toList();

  List<TaskItem> get completedTasks =>
      _tasks.where((t) => t.isCompleted).toList();

  int get totalCount => _tasks.length;
  int get completedCount => completedTasks.length;
  int get pendingCount => pendingTasks.length;
  double get completionRatio =>
      _tasks.isEmpty ? 0.0 : (completedCount / totalCount);

  void toggleTaskCompletion(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final newStatus = !task.isCompleted;
      _tasks[index] = task.copyWith(
        isCompleted: newStatus,
        completedAt: newStatus ? DateTime.now() : null,
      );
      notifyListeners();
    }
  }

  void addTask(TaskItem task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void clearCompleted() {
    _tasks.removeWhere((t) => t.isCompleted);
    notifyListeners();
  }

  void _initSampleTasks() {
    final now = DateTime.now();

    _tasks.addAll([
      TaskItem(
        id: '1',
        title: 'Finish Flutter UI',
        description: 'Complete dashboard layout and tactile styling.',
        dueDate: DateTime(now.year, now.month, now.day, 16, 30),
        priority: TaskPriority.high,
        category: TaskCategory.work,
        isCompleted: false,
      ),
      TaskItem(
        id: '2',
        title: 'Review Local Database',
        description: 'Verify SQLite persistence on offline sync nodes.',
        dueDate: DateTime(now.year, now.month, now.day, 18, 00),
        priority: TaskPriority.medium,
        category: TaskCategory.work,
        isCompleted: false,
      ),
      TaskItem(
        id: '3',
        title: 'Client Design Handoff',
        description: 'Figma components and motion guidelines delivered.',
        dueDate: DateTime(now.year, now.month, now.day, 14, 15),
        priority: TaskPriority.high,
        category: TaskCategory.work,
        isCompleted: true,
        completedAt: DateTime(now.year, now.month, now.day, 14, 15),
      ),
      TaskItem(
        id: '4',
        title: 'Morning Jog & Hydration',
        description: '30-minute cardio around the lake.',
        dueDate: DateTime(now.year, now.month, now.day, 7, 30),
        priority: TaskPriority.low,
        category: TaskCategory.personal,
        isCompleted: true,
        completedAt: DateTime(now.year, now.month, now.day, 7, 30),
      ),
      TaskItem(
        id: '5',
        title: 'Weekly Grocery Run',
        description: 'Organic vegetables, almond butter, greek yogurt.',
        dueDate: DateTime(now.year, now.month, now.day - 1, 17, 00),
        priority: TaskPriority.low,
        category: TaskCategory.personal,
        isCompleted: true,
        completedAt: DateTime(now.year, now.month, now.day - 1, 17, 00),
      ),
      TaskItem(
        id: '6',
        title: 'Grocery shopping & supplements',
        description: 'Organic blueberries, whey isolate, and oat milk.',
        dueDate: DateTime(now.year, now.month, now.day + 1, 10, 00),
        priority: TaskPriority.low,
        category: TaskCategory.personal,
        isCompleted: false,
      ),
      TaskItem(
        id: '7',
        title: 'Prepare Sprint Retrospective',
        description: 'Gather feedback notes and roadmap progress.',
        dueDate: DateTime(now.year, now.month, now.day + 2, 11, 00),
        priority: TaskPriority.medium,
        category: TaskCategory.work,
        isCompleted: false,
      ),
      TaskItem(
        id: '8',
        title: 'Read System Architecture Docs',
        description: 'Study offline sync mechanisms and caching patterns.',
        dueDate: DateTime(now.year, now.month, now.day + 3, 15, 00),
        priority: TaskPriority.low,
        category: TaskCategory.study,
        isCompleted: false,
      ),
    ]);
  }
}
