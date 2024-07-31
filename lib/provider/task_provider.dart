import 'package:flutter/material.dart';
import '../service/back4app_service.dart';

class TaskProvider with ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];
  List<String> _selectedTasks = [];
  bool _isLoading = false;
  bool _isEditing = false;
  final Back4AppService _back4AppService = Back4AppService();

  List<Map<String, dynamic>> get tasks => _tasks;
  List<String> get selectedTasks => _selectedTasks;
  bool get isLoading => _isLoading;
  bool get isEditing => _isEditing;

  TaskProvider() {
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    _isLoading = true;
    notifyListeners();

    final tasks = await _back4AppService.fetchTasks();
    _tasks = List<Map<String, dynamic>>.from(tasks);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(String title, String description, bool completed) async {
    if (title.isNotEmpty && description.isNotEmpty) {
      final newTask = await _back4AppService.addTask(title, description, completed);
      if (newTask != null) {
        _tasks.add(newTask);
        notifyListeners();
      }
    }
  }

  Future<void> updateTaskStatus(String objectId, bool completed) async {
    await _back4AppService.updateTaskStatus(objectId, completed);
    final index = _tasks.indexWhere((task) => task['objectId'] == objectId);
    if (index != -1) {
      _tasks[index]['completed'] = completed;
      notifyListeners();
    }
  }

  Future<void> updateSelectedTasksStatus(bool completed) async {
    for (String taskId in _selectedTasks) {
      await updateTaskStatus(taskId, completed);
    }
    _selectedTasks.clear();
    _isEditing = false;
    notifyListeners();
  }

  void toggleTaskSelection(String objectId) {
    if (_selectedTasks.contains(objectId)) {
      _selectedTasks.remove(objectId);
    } else {
      _selectedTasks.add(objectId);
    }
    notifyListeners();
  }

  void toggleEditingMode() {
    _isEditing = !_isEditing;
    if (!_isEditing) {
      _selectedTasks.clear();
    }
    notifyListeners();
  }

  void selectAllTasks() {
    _selectedTasks = _tasks.map((task) => task['objectId'] as String).toList();
    notifyListeners();
  }
}