import 'package:flutter/material.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:signals/signals_flutter.dart';
import 'package:tasks/main.dart';
import 'package:tasks/model/task.dart';
import 'package:tasks/model/task_item.dart';
import 'package:tasks/service/task_service.dart';

class RecentTaskCard extends StatefulWidget {
  final Task task;
  const RecentTaskCard(this.task, {super.key});

  @override
  State<RecentTaskCard> createState() => _RecentTaskCardState();
}

class _RecentTaskCardState extends State<RecentTaskCard> {
  final taskItems = signal<List<TaskItem>?>([]);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getTaskItems();
    });
    super.initState();
  }

  Future<void> getTaskItems() async {
    final items = await getIt<TaskService>().getTaskItems(widget.task.id!);
    taskItems.value = items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);

    return M3ECard(
      child: Container(
        width: .infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: .center,
          mainAxisSize: .min,
          children: [
            Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: .start,
                      mainAxisAlignment: .center,
                      mainAxisSize: .min,
                      children: [
                        Text(
                          widget.task.title,
                          style: theme.typeScale.bodyMedium.copyWith(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          widget.task.dueDate
                              .toIso8601String()
                              .toString()
                              .split("T")[0],
                          style: theme.typeScale.bodySmall.copyWith(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            SizedBox(width: 5),
                            Text(
                              widget.task.dueTime.format(context),
                              style: theme.typeScale.bodySmall.copyWith(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        // Icon(
                        //   Icons.circle_outlined,
                        //   color: theme.colorScheme.primary,
                        // ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            Icon(
                              Icons.task_alt_outlined,
                              color: theme.colorScheme.primary,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "${taskItems.value!.length}",
                              style: theme.typeScale.bodySmall.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
