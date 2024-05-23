import 'package:task_ninja_flutter/domain/entities/tasks.dart';

abstract class TasksDatasources {

  Future<List<Task>> getAllTask();
  Future<Task> getTask(String uuid);
  Future<Task> createTask(Task task);
  Future<Task> updateTask(String uuid, Task task);
  Future<bool> deleteTask(String uuid);

}