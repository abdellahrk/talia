import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_item.freezed.dart';
part 'task_item.g.dart';

@freezed
abstract class TaskItem with _$TaskItem {
  const factory TaskItem({
    int? id,
    required String title,
    required String description,
    @Default(0) int isCompleted,
    required int taskId,
    DateTime? createdAt,
  }) = _TaskItem;

  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);
}
