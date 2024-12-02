import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_management_with_provider/models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Complete Flutter project',
      description:
          'Work on the notes app using Flutter and implement essential features.',
      priority: 'High',
      categoryId: 'Home',
      dueAt: '2024-12-01',
      status: false,
    ),
    Task(
      id: '2',
      title: 'Grocery Shopping',
      description: 'Buy vegetables, fruits, and other essentials for the week.',
      priority: 'Medium',
      categoryId: 'Fitness',
      dueAt: '2024-11-30',
      status: false,
    ),
    Task(
      id: '3',
      title: 'Team Meeting',
      description:
          'Discuss the project timeline and deliverables with the team.',
      priority: 'High',
      categoryId: 'Work',
      dueAt: '2024-11-29',
      status: false,
    ),
    Task(
      id: '4',
      title: 'Doctor Appointment',
      description: 'Visit Dr. Sharma for a routine checkup at 4 PM.',
      priority: 'Low',
      categoryId: 'Home',
      dueAt: '2024-12-02',
      status: false,
    ),
    Task(
      id: '5',
      title: 'Read Book',
      description: 'Finish reading the last two chapters of "Atomic Habits."',
      priority: 'Low',
      categoryId: 'Work',
      dueAt: '2024-12-03',
      status: false,
    ),
  ];
  List<Task> get tasks => _tasks;

  final List<Task> _completedTasks = [];
  List<Task> get completedTasks => _completedTasks;

  // create task
  void createTask(String title, description, priority, categoryId, dueAt) {
    String id = DateTime.now().microsecondsSinceEpoch.toString();
    Task task = Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      categoryId: categoryId,
      dueAt: dueAt,
    );
    _tasks.add(task);
    log(task.toString());
    notifyListeners();
  }

  // update task
  void updateTask(Task updatedTask) {
    int index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    _tasks[index] = updatedTask;
    notifyListeners();
  }

  // delete task
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  // mark completed
  void toggleStatus(String id) {
    int index = _tasks.indexWhere((task) => task.id == id);
    _tasks[index].status = !_tasks[index].status;
    if (_tasks[index].status == true) {
      _completedTasks.add(_tasks[index]);
      _tasks.removeAt(index);
    }
    notifyListeners();
  }

  // get tasks by category
  List<Task> getTaskbyCategory(String categoryId) {
    return _tasks.where((task) => task.categoryId == categoryId).toList();
  }
}
