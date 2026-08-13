import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:signals/signals_flutter.dart';
import 'package:tasks/main.dart';
import 'package:tasks/model/task.dart';
import 'package:tasks/screen/widget/recent_task_card.dart';
import 'package:tasks/service/cache_service.dart';
import 'package:tasks/service/notification_service.dart';
import 'package:tasks/service/task_service.dart';
import 'package:tasks/utils/feedback.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  int barIndex = 1;
  final selectedTime = signal<String?>(null);
  DateTime? selectedDateValue;

  @override
  void initState() {
    dateController.text = DateTime.now().toString();
    getData();
    super.initState();
  }

  Future<void> getData() async {
    Future.wait([
      getIt<TaskService>().getUpcomingTasks(),
      getIt<TaskService>().getRecentTasks(),
      getIt<TaskService>().getCompletedTasks(),
    ]);
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return Scaffold(
      backgroundColor: M3ETheme.of(context).colorScheme.surfaceDim,
      appBar: AppBar(
        backgroundColor: M3ETheme.of(context).colorScheme.surfaceDim,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          M3EButton.icon(
            icon: const Icon(M3EIcons.add),
            label: const Text('New'),
            size: M3EButtonSize.xs,
            onPressed: _showDialog,
          ),
        ],
        actionsPadding: EdgeInsets.only(right: 8.2),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(
                  "Good Morning,",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  getIt<CacheService>().getItem("user", "name") ?? "",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    M3ECard(
                      color: theme.colorScheme.tertiary,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: .center,
                        mainAxisSize: .min,
                        children: [
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                "Upcoming ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: .end,
                                children: [
                                  SignalBuilder(
                                    builder: (BuildContext context) {
                                      final taskService = getIt<TaskService>();
                                      final upcomingCount =
                                          taskService
                                              .upcomingTasks
                                              .value
                                              ?.length ??
                                          0;
                                      if (taskService.loading.value) {
                                        return const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: M3ELoadingIndicator(),
                                        );
                                      }

                                      return Text(
                                        upcomingCount.toString(),
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    " Tasks",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                    M3ECard(
                      color: theme.colorScheme.secondary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: .center,
                        mainAxisSize: .min,
                        children: [
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                "Today's tasks",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: .end,
                                children: [
                                  Text(
                                    "2",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    " Tasks",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    M3ECard(
                      color: theme.colorScheme.primary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: .center,
                        mainAxisSize: .min,
                        children: [
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                "Completed",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: .end,
                                children: [
                                  Text(
                                    "2",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    " Tasks",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text(
                      "Recent Tasks",
                      style: theme.typeScale.titleLarge.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      child: Row(
                        children: [
                          Text(
                            "See all",
                            style: theme.typeScale.labelLarge.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 17,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SignalBuilder(
                  builder: (BuildContext context) {
                    final taskService = getIt<TaskService>();
                    final recentTasks = taskService.recentTasks.value;
                    if (recentTasks!.isEmpty) {
                      return Text(
                        "No recent tasks",
                        style: theme.typeScale.bodyLarge,
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: recentTasks.length,

                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              "/task",
                              arguments: recentTasks[index].id,
                            );
                          },
                          child: RecentTaskCard(recentTasks[index]),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    getIt<NotificationService>().showNotification(
      Task(
        id: 3,
        title: "test notif",
        description: "nice notification",
        dueDate: DateTime(2206),
        dueTime: TimeOfDay(hour: 12, minute: 12),
      ),
    );
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: .center,
            mainAxisSize: .min,
            children: [
              Text("New Task", style: TextStyle(fontSize: 24)),
              SizedBox(height: 15),
              M3ETextField(
                controller: titleController,
                label: 'Task title',
                supportingText: 'Enter task title',
                leading: const Icon(M3EIcons.edit),
              ),
              SizedBox(height: 15),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: "Description",
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: dateController,
                      onTap: () async {
                        final DateTime? pickedDate = await M3EDatePicker.show(
                          context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          selectedDateValue = pickedDate;

                          dateController.text =
                              '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';

                          // selectedDate.value = dateController.text;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Date',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: timeController,
                      readOnly: true,
                      onTap: () async {
                        final hour = DateTime.now().hour;
                        final minute = DateTime.now().minute;

                        final pickedTime = await M3ETimePicker.show(
                          context,
                          initialTime: M3ETime(hour: hour, minute: minute),
                        );

                        if (pickedTime != null) {
                          timeController.text =
                              '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                          selectedTime.value = timeController.text;
                        }
                      },
                      decoration: const InputDecoration(
                        hintText: 'Time',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.access_time),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: _addTask,
                    child: Card(
                      semanticContainer: false,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: .min,
                          children: [
                            Text("Save"),
                            SizedBox(width: 5),
                            Icon(Icons.add),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Card(
                      semanticContainer: false,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: .min,
                          children: [
                            Text("Cancel"),
                            SizedBox(width: 5),
                            Icon(Icons.cancel),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addTask() async {
    if (titleController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        selectedDateValue == null ||
        timeController.text.isEmpty) {
      showSnackbar(context, "Please fill all the fields");
      return;
    }
    final timeParts = timeController.text.split(':');

    final task = Task(
      title: titleController.text,
      description: descriptionController.text,
      dueDate: selectedDateValue!,
      dueTime: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      createdAt: DateTime.now(),
    );
    await getIt<TaskService>().addTask(task);
    if (!context.mounted) return;
    showSnackbar(context, "Task added successfully");
    Navigator.pop(context);
  }
}
