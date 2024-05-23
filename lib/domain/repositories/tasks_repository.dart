import 'package:task_ninja_flutter/domain/entities/tasks.dart';

abstract class TasksRepository {
  Future<List<Task>> getAllTask();
  Future<Task> getTask(String uuid);
  Future<Task> createTask(Task task);
  Future<Task> updateTask(String uuid, Task task);
  Future<void> deleteTask(String uuid);
}