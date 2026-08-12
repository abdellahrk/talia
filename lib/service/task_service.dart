import 'package:signals/signals_core.dart';
import 'package:tasks/main.dart';
import 'package:tasks/model/task.dart';
import 'package:tasks/service/db_service.dart';

class TaskService {
  final loading = signal(false);
  DbService get dbService => getIt<DbService>();
  Signal<List<Task>?> upcomingTasks = signal<List<Task>?>([]);
  Signal<List<Task>?> recentTasks = signal<List<Task>?>([]);
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

  Future<List<Task>> getTasks() async {
    return await dbService.getTasks();
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
      return task.value;
    } catch (e) {
      return null;
    }
  }

  Future<List<Task>> getUpcomingTasks() async {
    final tasks = await dbService.getUpcomingTasks();
    upcomingTasks.value = tasks;
    return tasks ?? [];
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
}
