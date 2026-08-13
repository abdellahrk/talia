import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
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
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    getTask();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
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
            if (task == null) {
              return Center(child: Text("No task found"));
            }
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
      bottomNavigationBar: BottomAppBar(
        child: InkWell(
          onTap: () {
            _showBottomSheet();
          },
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            width: .maxFinite,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(50),
              // border: Border.all(color: theme.colorScheme.danger, width: 0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                // Icon(icon, size: 14, color: filled ? white : colorPrimary),
                Text(
                  "Edit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showBottomSheet() {
    final task = getIt<TaskService>().task.value;
    final theme = M3ETheme.of(context);

    if (null != task) {
      titleController.text = task.title;
      descriptionController.text = task.description;
    }

    return M3EBottomSheet.show<void>(
      context,
      builder: (context) => Padding(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(
                  task?.title ?? "",
                  style: theme.typeScale.headlineSmall.copyWith(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    M3ETextField(controller: titleController, label: "Title"),
                    SizedBox(height: 18),
                    M3ETextField(
                      controller: descriptionController,
                      maxLines: 4,
                      // label: "Details",
                    ),
                    SizedBox(height: 18),
                    FilledButton(
                      onPressed: () {
                        M3EDatePicker.show(
                          context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                      },
                      child: Text("Date"),
                    ),
                    Text("hi"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
