import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_ninja_flutter/domain/entities/tasks.dart';
import 'package:task_ninja_flutter/domain/repositories/tasks_repository.dart';
import 'package:task_ninja_flutter/infraestructure/local/local_database.dart';
import 'package:task_ninja_flutter/presentation/widgets/appbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_ninja_flutter/infraestructure/services/connection.dart';

class HomeScreen extends ConsumerWidget {
  final TasksRepository tasksRepository;
  final dbHelper = DatabaseHelper.instance;
  HomeScreen({super.key, required this.tasksRepository});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),
      body: ref.watch(isConnectedProvider) 
        ? FutureBuilder<List<Task>>(
            future: tasksRepository.getAllTask(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child:
                        Text('Ha ocurrido un error: ${snapshot.error.toString()}'));
              } else {
                final tasks = snapshot.data!;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      child: InkWell(
                        onTap: () async {
                          context.push('/tasks/${task.uuid}');
                        },
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          )
        : FutureBuilder<List<Map<String, dynamic>>> ( 
          future: dbHelper.queryAllRows(),
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child:
                        Text('Ha ocurrido un error: ${snapshot.error.toString()}'));
              } else {
                final tasks = snapshot.data!;
                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Card(
                      child: InkWell(
                        onTap: () async {
                          context.push('/tasks/${task['uuid']}');
                        },
                        child: ListTile(
                          title: Text(task['title']),
                          subtitle: Text(task['description']),
                        ),
                      ),
                    );
                  },
                );
              }
          },
         ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/create-tasks');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
