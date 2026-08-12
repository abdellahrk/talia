// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  dueDate: DateTime.parse(json['dueDate'] as String),
  dueTime: const TimeOfDayConverter().fromJson(json['dueTime'] as String),
  isCompleted: (json['isCompleted'] as num?)?.toInt() ?? 0,
  isDue: (json['isDue'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'dueDate': instance.dueDate.toIso8601String(),
  'dueTime': const TimeOfDayConverter().toJson(instance.dueTime),
  'isCompleted': instance.isCompleted,
  'isDue': instance.isDue,
};
