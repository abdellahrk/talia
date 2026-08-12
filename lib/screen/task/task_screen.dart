import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:signals/signals_flutter.dart';
import 'package:tasks/main.dart';
import 'package:tasks/service/task_service.dart';

class TaskScreen extends StatefulWidget {
  final int id;
  const TaskScreen(this.id, {super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    getTask();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getTask() async {
    await getIt<TaskService>().getTaskById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text("Task")),
      body: SingleChildScrollView(
        child: SignalBuilder(
          builder: (context) {
            final task = getIt<TaskService>().task.value;
            return Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: .start,
                crossAxisAlignment: .start,
                children: [
                  Text(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    task!.title,
                    style: theme.typeScale.headlineMedium.copyWith(
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    task.description,
                    style: theme.typeScale.bodyMedium.copyWith(
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
