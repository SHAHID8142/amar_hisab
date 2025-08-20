import 'package:flutter/material.dart';
import 'package:amar_hisab/models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  set tasks(List<Task> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = Task(
        id: _tasks[index].id,
        title: _tasks[index].title,
        description: _tasks[index].description,
        isCompleted: !_tasks[index].isCompleted,
      );
      notifyListeners();
    }
  }
}