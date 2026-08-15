import 'package:flutter/foundation.dart';
import 'package:signals/signals_flutter.dart';
import 'package:tasks/main.dart';
import 'package:tasks/model/task.dart';
import 'package:tasks/model/task_item.dart';
import 'package:tasks/service/db_service.dart';

class TaskService {
  final dynamic dbService;
  TaskService(this.dbService);
  final loading = signal(false);
  // DbService get dbService => getIt<DbService>();
  FlutterSignal<List<Task>?> upcomingTasks = signal<List<Task>?>([]);
  FlutterSignal<List<Task>?> tasks = signal<List<Task>?>([]);
  FlutterSignal<List<Task>?> recentTasks = signal<List<Task>?>([]);
  FlutterSignal<List<TaskItem>?> taskItems = signal<List<TaskItem>?>([]);
  final task = signal<Task?>(null);

  Future<void> addTask(Task task) async {
    loading.value = true;
    try {
      await dbService.addTask(task);
      await getUpcomingTasks();
      await getRecentTasks();
    } finally {
      loading.value = false;
    }
  }

  Future<void> addTaskItem(TaskItem taskItem) async {
    loading.value = true;
    try {
      final taskItemId = await dbService.addTaskItem(taskItem);
      if (kDebugMode) {
        print("taskItem id is $taskItemId");
      }
    } catch (e) {
      if (kDebugMode) {
        print("error $e");
      }
    } finally {
      loading.value = false;
    }
  }

  Future<List<Task>> getTasks() async {
    final allTasks = await dbService.getTasks();
    tasks.value = allTasks;
    return allTasks;
  }

  Future<void> deleteTask(Task task) async {
    await dbService.deleteTask(task);
  }

  Future<void> updateTask(Task task) async {
    await dbService.updateTask(task);
  }

  Future<Task?> getTaskById(int id) async {
    try {
      task.value = await dbService.getTask(id);
      if (task.value != null) {
        getTaskItems(task.value!.id!);
      }
      return task.value;
    } catch (e) {
      return null;
    }
  }

  Future<List<Task>> getUpcomingTasks() async {
    loading.value = true;
    try {
      final tasks = await dbService.getUpcomingTasks();
      upcomingTasks.value = tasks;
      return tasks ?? [];
    } finally {
      loading.value = false;
    }
  }

  Future<List<Task>> getCompletedTasks() async {
    loading.value = true;
    try {
      final tasks = await dbService.getCompletedTasks();
      return tasks ?? [];
    } finally {
      loading.value = false;
    }
  }

  Future<void> getRecentTasks() async {
    loading.value = true;
    try {
      final tasks = await dbService.getRecentTasks();
      recentTasks.value = tasks;
    } finally {
      loading.value = false;
    }
  }

  Future<List<TaskItem>> getTaskItems(int taskId) async {
    loading.value = true;
    try {
      final taskItems = await dbService.getTaskItems(taskId);
      this.taskItems.value = taskItems;
      return taskItems;
    } finally {
      loading.value = false;
    }
  }

  Future<void> deleteTaskItem(TaskItem taskItem) async {
    await dbService.deleteTaskItem(taskItem);
  }

  Future<void> updateTaskItem(TaskItem taskItem) async {
    await dbService.updateTaskItem(taskItem);
  }
}
