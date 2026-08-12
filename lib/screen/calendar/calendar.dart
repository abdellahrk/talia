import 'package:flutter/material.dart';
import 'package:infinite_calendar_view/infinite_calendar_view.dart';
import 'package:material_3_expressive/foundations/m3e_theme.dart';
import 'package:tasks/main.dart';
import 'package:tasks/model/task.dart';
import 'package:tasks/service/task_service.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  EventsController controller = EventsController();

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() async {
    final taskService = getIt<TaskService>();
    await taskService.getUpcomingTasks();
    List<Event> tasks = [];
    print("upcoming tasks are: ${taskService.upcomingTasks.value}");

    for (var task in taskService.upcomingTasks.value!) {
      final event = Event(
        startTime: DateTime.now(),
        endTime: task.dueDate,
        title: task.title,
        isFullDay: false,
        columnIndex: 3,
      );
      tasks.add(event);
    }

    controller.updateCalendarData((calendarData) {
      print("calendar tasks are : $tasks");
      if (tasks.isNotEmpty) {
        calendarData.addEvents(tasks);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: M3ETheme.of(context).colorScheme.surfaceDim,
      appBar: AppBar(
        title: Text("Calendar"),
        backgroundColor: M3ETheme.of(context).colorScheme.surfaceDim,
      ),
      body: EventsMonths(controller: controller),
    );
  }
}
