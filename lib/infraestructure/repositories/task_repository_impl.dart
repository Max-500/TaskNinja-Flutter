import 'package:task_ninja_flutter/infraestructure/datasources/tasks_datasources.dart';
import 'package:task_ninja_flutter/domain/entities/tasks.dart';
import 'package:task_ninja_flutter/domain/repositories/tasks_repository.dart';

class TaskRepositoryImpl extends TasksRepository {
  final TaskDatasource dataSource;

  TaskRepositoryImpl({ required this.dataSource });

  @override
  Future<Task> createTask(Task task) {
    return dataSource.createTask(task);
  }

  @override
  Future<bool> deleteTask(String uuid) {
    return dataSource.deleteTask(uuid);
  }

  @override
  Future<List<Task>> getAllTask() {
    return dataSource.getAllTask();
  }

  @override
  Future<Task> getTask(String uuid) {
    return dataSource.getTask(uuid);
  }

  @override
  Future<Task> updateTask(String uuid, Task task) {
    return dataSource.updateTask(uuid, task);
  }
}
