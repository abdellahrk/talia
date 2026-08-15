import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tasks/model/task.dart';
import 'package:tasks/model/task_item.dart';

class DbServiceHelper {
  late Database database;
  final String taskTable = "tasks";

  Future<void> opendDb() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'task_db_test.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          isCompleted INTEGER,
          dueDate TEXT,
          dueTime TEXT,
          isDue INTEGER,
          isAllDay INTEGER DEFAULT 0,
           createdAt TEXT
        )
      ''');
        db.execute('''
      CREATE TABLE taskItems(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskId INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT DEFAULT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT,
        FOREIGN KEY(taskId) REFERENCES tasks(id)
      )
    ''');
        await db.execute('''
      CREATE INDEX index_taskItems_taskId
      ON taskItems(taskId)
    ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
      CREATE TABLE taskItems(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        taskId INTEGER NOT NULL,
        title TEXT NOT NULL,
        description TEXT DEFAULT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT,
        FOREIGN KEY(taskId) REFERENCES tasks(id)
      )
    ''');

          await db.execute('''
      CREATE INDEX index_taskItems_taskId
      ON taskItems(taskId)
    ''');
        } else if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE tasks ADD COLUMN isAllDay INTEGER NOT NULL DEFAULT 0',
          );
        }
      },
      onConfigure: (Database db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'task_db_test.db');

    await deleteDatabase(path);

    await opendDb();
  }

  void _addCreatedDateAndTaskList(Batch batch) {
    batch.execute('ALTER TABLE tasks ADD COLUMN createdAt TEXT');
    batch.execute('ALTER TABLE tasks ADD COLUMN isAllDay INTEGER DEFAULT 0');
    batch.execute('''
        CREATE TABLE taskItems(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          taskId INTEGER, 
          title TEXT,
          description TEXT DEFAULT NULL,
          isCompleted INTEGER DEFAULT 0, 
          createdAt TEXT, 
          isAllDay INTEGER DEFAULT 0,
          FOREIGN KEY(taskId) REFERENCES tasks(id))''');
    batch.execute('''
      CREATE INDEX index_taskItems_taskId ON taskItems(taskId)
    ''');
  }

  void _addIsAllDay(Batch batch) {
    batch.execute('ALTER TABLE tasks ADD COLUMN isAllDay INTEGER DEFAULT 0');
  }

  Future<int?> addTask(Task task) async {
    return await database.insert('tasks', task.toJson());
  }

  Future<List<Task>> getTasks() async {
    final List<Map<String, dynamic>> maps = await database.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromJson(maps[i]);
    });
  }

  Future<void> deleteTask(Task task) async {
    await database.delete('tasks', where: 'id = ?', whereArgs: [task.id]);
  }

  Future<void> updateTask(Task task) async {
    await database.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<Task?> getTask(int taskId) async {
    List<Map<String, dynamic>> maps = await database.query(
      taskTable,
      where: "id = ?",
      whereArgs: [taskId],
    );

    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    }

    return null;
  }

  Future<void> closeDb() async {
    await database.close();
  }

  Future<List<Task>?> getUpcomingTasks() async {
    final maps = await database.query(
      taskTable,
      where: 'isDue = 0 AND dueDate > ?',
      whereArgs: [DateTime.now().toUtc().toIso8601String()],
    );
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Task.fromJson(maps[i]);
      });
    }
    return [];
  }

  Future<List<Task>?> getRecentTasks() async {
    final maps = await database.query(
      taskTable,
      where: 'isCompleted = 0 AND isDue = 0',
      orderBy: 'dueDate DESC',
      limit: 10,
    );
    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Task.fromJson(maps[i]);
      });
    }
    return [];
  }

  Future<List<Task>?> getCompletedTasks() async {
    final maps = await database.query(
      taskTable,
      where: 'isCompleted = 1',
      limit: 10,
    );

    if (maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Task.fromJson(maps[i]);
      });
    }
    return [];
  }

  Future<List<TaskItem>> getTaskItems(int taskId) async {
    final List<Map<String, dynamic>> maps = await database.query(
      'taskItems',
      where: 'taskId = ?',
      whereArgs: [taskId],
    );
    return List.generate(maps.length, (i) {
      return TaskItem.fromJson(maps[i]);
    });
  }

  Future<int?> addTaskItem(TaskItem taskItem) async {
    return await database.insert('taskItems', taskItem.toJson());
  }

  Future<void> deleteTaskItem(TaskItem taskItem) async {
    await database.delete(
      'taskItems',
      where: 'id = ?',
      whereArgs: [taskItem.id],
    );
  }

  Future<void> updateTaskItem(TaskItem taskItem) async {
    await database.update(
      'taskItems',
      taskItem.toJson(),
      where: 'id = ?',
      whereArgs: [taskItem.id],
    );
  }

  Future<void> resetTestDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'task_db_test.db');

    await deleteDatabase(path);
  }
}
