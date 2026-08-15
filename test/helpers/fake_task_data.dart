import 'package:material_ui/material_ui.dart';
import 'package:tasks/model/task.dart';

import 'db_service_helper.dart';

List<Task> upcomingTasks = <Task>[
  Task(
    title: 'Finish project proposal',
    description: 'Complete the proposal and send it to the team.',
    dueDate: DateTime(2026, 8, 15),
    dueTime: const TimeOfDay(hour: 11, minute: 0),
    createdAt: DateTime(2026, 8, 13),
  ),
  Task(
    title: 'Team meeting',
    description: 'Weekly product and engineering sync.',
    dueDate: DateTime(2026, 8, 16),
    dueTime: const TimeOfDay(hour: 10, minute: 0),
    createdAt: DateTime(2026, 8, 14),
  ),
  Task(
    title: 'Buy groceries',
    description: 'Milk, bread, eggs, fruits and vegetables.',
    dueDate: DateTime(2026, 8, 17),
    dueTime: const TimeOfDay(hour: 17, minute: 30),
    createdAt: DateTime(2026, 8, 15),
  ),
  Task(
    title: 'Read Flutter documentation',
    description: 'Review the latest Flutter and Dart documentation.',
    dueDate: DateTime(2026, 8, 18),
    dueTime: const TimeOfDay(hour: 20, minute: 0),
    createdAt: DateTime(2026, 8, 12),
  ),
  Task(
    title: 'Submit expense report',
    description: 'Submit this month\'s expense report.',
    dueDate: DateTime(2026, 8, 14),
    dueTime: const TimeOfDay(hour: 16, minute: 0),
    isCompleted: 1,
    createdAt: DateTime(2026, 8, 8),
  ),
  Task(
    title: 'Backup important files',
    description: 'Back up important documents and project files.',
    dueDate: DateTime(2026, 8, 13),
    dueTime: const TimeOfDay(hour: 12, minute: 0),
    isCompleted: 1,
    createdAt: DateTime(2026, 8, 5),
  ),
];

Future<void> populateFakeTasks(DbServiceHelper db) async {
  // final now = DateTime(2026, 8, 15, 9, 0);

  final tasks = <Task>[
    Task(
      title: 'Finish project proposal',
      description: 'Complete the proposal and send it to the team.',
      dueDate: DateTime(2026, 8, 15),
      dueTime: const TimeOfDay(hour: 11, minute: 0),
      createdAt: DateTime(2026, 8, 13),
    ),
    Task(
      title: 'Team meeting',
      description: 'Weekly product and engineering sync.',
      dueDate: DateTime(2026, 8, 16),
      dueTime: const TimeOfDay(hour: 10, minute: 0),
      createdAt: DateTime(2026, 8, 14),
    ),
    Task(
      title: 'Buy groceries',
      description: 'Milk, bread, eggs, fruits and vegetables.',
      dueDate: DateTime(2026, 8, 17),
      dueTime: const TimeOfDay(hour: 17, minute: 30),
      createdAt: DateTime(2026, 8, 15),
    ),
    Task(
      title: 'Read Flutter documentation',
      description: 'Review the latest Flutter and Dart documentation.',
      dueDate: DateTime(2026, 8, 18),
      dueTime: const TimeOfDay(hour: 20, minute: 0),
      createdAt: DateTime(2026, 8, 12),
    ),
    Task(
      title: 'Submit expense report',
      description: 'Submit this month\'s expense report.',
      dueDate: DateTime(2026, 8, 14),
      dueTime: const TimeOfDay(hour: 16, minute: 0),
      isCompleted: 1,
      createdAt: DateTime(2026, 8, 8),
    ),
    Task(
      title: 'Backup important files',
      description: 'Back up important documents and project files.',
      dueDate: DateTime(2026, 8, 13),
      dueTime: const TimeOfDay(hour: 12, minute: 0),
      isCompleted: 1,
      createdAt: DateTime(2026, 8, 5),
    ),
  ];

  for (final task in tasks) {
    await db.addTask(task);
  }
}
