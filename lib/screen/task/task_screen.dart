import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:signals/signals_flutter.dart';
import 'package:tasks/main.dart';
import 'package:tasks/model/task_item.dart';
import 'package:tasks/service/task_service.dart';
import 'package:tasks/utils/feedback.dart';

class TaskScreen extends StatefulWidget {
  final int id;
  const TaskScreen(this.id, {super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final taskListTitle = TextEditingController();
  final taskListDescription = TextEditingController();

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
      appBar: AppBar(
        title: Text(getIt<TaskService>().task.value?.title ?? "Task"),
        backgroundColor: M3ETheme.of(context).colorScheme.surfaceDim,
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
      ),
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
                    task.title,
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
                  SizedBox(height: 10),

                  InkWell(
                    onTap: () {
                      _addTaskItemDialog();
                    },
                    child: Row(
                      children: [Icon(Icons.add), Text("Add task item")],
                    ),
                  ),
                  SizedBox(height: 10),
                  SignalBuilder(
                    builder: (BuildContext context) {
                      final taskItems = getIt<TaskService>().taskItems.value;
                      if (taskItems!.isEmpty) {
                        return SizedBox.shrink();
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          final taskItem = taskItems[index];
                          return Dismissible(
                            key: Key(taskItem.id.toString()),
                            onDismissed: (direction) async {
                              await getIt<TaskService>().deleteTaskItem(
                                taskItem,
                              );
                            },
                            child: InkWell(
                              onDoubleTap: () {
                                // TODO: Edit task item
                              },
                              child: ListTile(
                                leading: Icon(Icons.light),
                                title: Text(taskItem.title),
                                subtitle: Text(
                                  taskItem.createdAt!.toLocal().toString(),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    if (taskItem.isCompleted == 0) {
                                      getIt<TaskService>().updateTaskItem(
                                        taskItem.copyWith(isCompleted: 1),
                                      );
                                      showSnackbar(context, "Task completed");
                                    } else {
                                      getIt<TaskService>().updateTaskItem(
                                        taskItem.copyWith(isCompleted: 0),
                                      );
                                      showSnackbar(context, "Task uncompleted");
                                    }
                                    getIt<TaskService>().getTaskItems(
                                      getIt<TaskService>().task.value!.id!,
                                    );
                                  },
                                  icon: taskItem.isCompleted == 1
                                      ? Icon(Icons.check_box_outlined)
                                      : Icon(Icons.check_box_outline_blank),
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 2);
                        },
                        itemCount: taskItems.length,
                      );
                    },
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

  void _addTaskItemDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: .min,
              children: [
                TextField(
                  controller: taskListTitle,
                  decoration: InputDecoration(
                    hintText: "Title",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: taskListDescription,
                  decoration: InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _addTaskItem();
                      },
                      child: Card(
                        semanticContainer: false,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Save"),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addTaskItem() async {
    if (taskListTitle.text.isEmpty) {
      return;
    }
    final taskItem = TaskItem(
      title: taskListTitle.text,
      description: taskListDescription.text,
      taskId: getIt<TaskService>().task.value!.id!,
      createdAt: DateTime.now(),
    );
    await getIt<TaskService>().addTaskItem(taskItem);
    taskListTitle.clear();
    taskListDescription.clear();
    await getIt<TaskService>().getTaskItems(
      getIt<TaskService>().task.value!.id!,
    );
    showSnackbar(context, "Task added successfully");

    try {
      Navigator.pop(context);
    } catch (e) {
      if (kDebugMode) {
        print("error $e");
      }
    }
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
