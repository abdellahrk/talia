// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskItem _$TaskItemFromJson(Map<String, dynamic> json) => _TaskItem(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  isCompleted: (json['isCompleted'] as num?)?.toInt() ?? 0,
  taskId: (json['taskId'] as num).toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TaskItemToJson(_TaskItem instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'isCompleted': instance.isCompleted,
  'taskId': instance.taskId,
  'createdAt': instance.createdAt?.toIso8601String(),
};
