import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
sealed class Task with _$Task {
  const factory Task({
    String? id,
    required String userId,
    required String description,
    required DateTime createdDate,
    @Default(false) bool isFinish,
  }) = _Task;

  factory Task.fromJson(Map<String, Object?> json) => _$TaskFromJson(json);
}
