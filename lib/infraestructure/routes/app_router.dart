import 'package:go_router/go_router.dart';
import 'package:task_ninja_flutter/infraestructure/datasources/tasks_datasources.dart';
import 'package:task_ninja_flutter/infraestructure/repositories/task_repository_impl.dart';
import 'package:task_ninja_flutter/presentation/screens/CreateTaskScreen.dart';
import 'package:task_ninja_flutter/presentation/screens/HomeScreen.dart';
import 'package:task_ninja_flutter/presentation/screens/TaskScreen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', name: 's', builder: (context, state) =>  HomeScreen(tasksRepository: TaskRepositoryImpl(dataSource: TaskDatasource()))),
    GoRoute(path: '/tasks/:uuid',  builder: (context, state) {
          final String uuid = state.pathParameters['uuid']!;
          return TaskScreen(uuid: uuid, tasksRepository: TaskRepositoryImpl(dataSource: TaskDatasource()));
    },),
    GoRoute(path: '/create-tasks', builder: (context, state) => CreateTaskScreen(tasksRepository: TaskRepositoryImpl(dataSource: TaskDatasource())),)
  ],
);