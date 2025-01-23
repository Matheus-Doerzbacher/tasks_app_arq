// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String?,
      userId: json['userId'] as String,
      description: json['description'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      isFinish: json['isFinish'] as bool? ?? false,
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'description': instance.description,
      'createdDate': instance.createdDate.toIso8601String(),
      'isFinish': instance.isFinish,
    };
