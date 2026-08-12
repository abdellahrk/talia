import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tasks/utils/time_of_day_converter.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    int? id,
    required String title,
    required String description,
    required DateTime dueDate,
    @TimeOfDayConverter() required TimeOfDay dueTime,
    @Default(0) int isCompleted,
    @Default(0) int isDue,
    @Default(0) int isAllDay,
    DateTime? createdAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
