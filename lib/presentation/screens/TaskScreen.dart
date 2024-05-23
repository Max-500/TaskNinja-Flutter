import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_ninja_flutter/domain/entities/tasks.dart';
import 'package:task_ninja_flutter/infraestructure/local/local_database.dart';
import 'package:task_ninja_flutter/infraestructure/repositories/task_repository_impl.dart';
import 'package:task_ninja_flutter/infraestructure/services/connection.dart';
import 'package:task_ninja_flutter/presentation/widgets/appbar.dart';

class TaskScreen extends ConsumerWidget {
  final dbHelper = DatabaseHelper.instance;
  final TaskRepositoryImpl tasksRepository;
  final String uuid;

  // Define los controladores de texto aquí
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final stateController = TextEditingController();
  final priorityController = TextEditingController();
  final notificationTimeController = TextEditingController();

  TaskScreen({super.key, required this.uuid, required this.tasksRepository});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(kToolbarHeight), child: MyAppBar(),),
      body: ref.watch(isConnectedProvider) ? FutureBuilder<Task>(
        future: tasksRepository.getTask(uuid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text('Ha ocurrido un error: ${snapshot.error.toString()}'));
          } else {
            final task = snapshot.data!;
            // Asigna los valores iniciales a los controladores de texto
            titleController.text = task.title;
            descriptionController.text = task.description;
            stateController.text = task.state;
            priorityController.text = task.priority;
            notificationTimeController.text = task.notificationTime;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Título'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: stateController,
                    decoration: const InputDecoration(labelText: 'Estado'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: priorityController,
                    decoration: const InputDecoration(labelText: 'Prioridad'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: notificationTimeController,
                    decoration:
                        const InputDecoration(labelText: 'Hora de notificación'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          final Task task = Task(uuid: uuid, title: titleController.text, description: descriptionController.text, 
                            state: stateController.text, priority: priorityController.text, notificationTime: '', userUUID: 'userUUID');
                            await tasksRepository.updateTask(uuid, task);
                            context.go('/');
                        },
                        child: const Text('Actualizar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await tasksRepository.deleteTask(uuid);
                          if(result){
                            // ignore: use_build_context_synchronously
                            context.go('/');
                          }
                          // Aca ira el mostrar un cuadro de dialogo
                        },
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ) : FutureBuilder<Map<String, dynamic>>(
        future: dbHelper.getRow(uuid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Ha ocurrido un error: ${snapshot.error.toString()}'));
          } else if (snapshot.data!.isEmpty) {
            return Center(
                child: Text('No hay datos disponibles'));
          } else {
            final taskData = snapshot.data!;
            // Asigna los valores iniciales a los controladores de texto
            titleController.text = taskData['title'];
            descriptionController.text = taskData['description'];
            stateController.text = taskData['state'];
            priorityController.text = taskData['priority'];
            notificationTimeController.text = taskData['notificationTime'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Título'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Descripción'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: stateController,
                    decoration: const InputDecoration(labelText: 'Estado'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: priorityController,
                    decoration: const InputDecoration(labelText: 'Prioridad'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: notificationTimeController,
                    decoration:
                        const InputDecoration(labelText: 'Hora de notificación'),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          final Task task = Task(uuid: uuid, title: titleController.text, description: descriptionController.text, 
                            state: stateController.text, priority: priorityController.text, notificationTime: '', userUUID: 'userUUID');
                            await tasksRepository.updateTask(uuid, task);
                            context.go('/');
                        },
                        child: const Text('Actualizar'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await dbHelper.delete(uuid);
                          if(result == 1){
                            // ignore: use_build_context_synchronously
                            context.go('/');
                          }
                          // Aca ira el mostrar un cuadro de dialogo
                        },
                        child: const Text('Eliminar'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      )
    );
  }
}
