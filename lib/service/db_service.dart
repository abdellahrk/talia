import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tasks/model/task.dart';

class DbService {
  late Database database;
  final String taskTable = "tasks";

  Future<void> opendDb() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'task_db.db');
    database = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          isCompleted INTEGER,
          dueDate TEXT,
          dueTime TEXT,
          isDue INTEGER
        )
      ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        Batch batch = db.batch();
        if (oldVersion == 1) {
          _addCreatedDateAndTaskList(batch);
        }
        await batch.commit();
      },
    );
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
          FOREIGN KEY(taskId) REFERENCES tasks(id))''');
    batch.execute('''
      CREATE INDEX index_taskItems_taskId ON taskItems(taskId)
    ''');
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
}
