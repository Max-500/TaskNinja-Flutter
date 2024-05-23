import 'package:dio/dio.dart';
import 'package:task_ninja_flutter/domain/datasources/tasks_datasources.dart';
import 'package:task_ninja_flutter/domain/entities/tasks.dart';

class TaskDatasource extends TasksDatasources {
  final Dio dio = Dio(BaseOptions(
    baseUrl: 'http://52.45.227.131:3000/api/v1/tasks',
  ));

  @override
  Future<Task> createTask(Task task) async {
    final response = await dio.post(
      '/',
      data: {
        'userUUID': '080d6452-4cd6-475d-aac7-3040869da155',
        'data': [
          {
            'title': task.title,
            'description': task.description,
            'priority': task.priority,
            'notificationTime': '2024-05-22T22:00:00Z',
          },
        ],
      },
    );

    if (response.statusCode == 201) {
      return Task(uuid: response.data['createdTasks'][0]['uuid'], title: response.data['createdTasks'][0]['title'], description: response.data['createdTasks'][0]['description'], state: response.data['createdTasks'][0]['state'], priority: response.data['createdTasks'][0]['priority'], notificationTime: response.data['createdTasks'][0]['notificationTime'], userUUID: response.data['createdTasks'][0]['userUUID']);
    } else {
      throw Exception('Failed to create task');
    }
  }

  @override
  Future<bool> deleteTask(String uuid) async {
    final response = await dio.delete('/$uuid');
    if(response.statusCode != 200){
      throw Exception('Failed to delete the task');
    }
    return true;
  }

  @override
  Future<List<Task>> getAllTask() async {
    final response = await dio.get('');
    final List<dynamic> taskList = response.data['data'];
    final List<Task> tasks =
        taskList.map((taskMap) => Task.fromJson(taskMap)).toList();
    return tasks;
  }

  @override
  Future<Task> getTask(String uuid) async {
    final response = await dio.get('/$uuid');
    final dynamic taskList = response.data['data'];
    final Task task = Task.fromJson(taskList);
    return task;
  }

  @override
  Future<Task> updateTask(String uuid, Task task) async {
    final response = await dio.put('/$uuid', data: {
      'title': task.title,
      'description': task.description,
      'priority': task.priority
    });
    final dynamic taskList = response.data['data'];
    final Task taskResponse = Task.fromJson(taskList);
    return taskResponse;

  }
}
