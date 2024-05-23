import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:task_ninja_flutter/domain/entities/tasks.dart';
import 'package:task_ninja_flutter/domain/repositories/tasks_repository.dart';
import 'package:task_ninja_flutter/presentation/widgets/appbar.dart';

class CreateTaskScreen extends StatelessWidget {
  final TasksRepository tasksRepository;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final stateController = TextEditingController();
  final priorityController = TextEditingController();
  final notificationTimeController = TextEditingController();
  final userUUIDController = TextEditingController();

  CreateTaskScreen({super.key, required this.tasksRepository});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: MyAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: stateController,
              decoration: const InputDecoration(labelText: 'Estado'),
            ),
            TextField(
              controller: priorityController,
              decoration: const InputDecoration(labelText: 'Prioridad'),
            ),
            TextField(
              controller: notificationTimeController,
              decoration:
                  const InputDecoration(labelText: 'Hora de notificación'),
            ),
            TextField(
              controller: userUUIDController,
              decoration: const InputDecoration(labelText: 'UUID del usuario'),
            ),
            ElevatedButton(
              onPressed: () async {
                final Task newTask = Task(
                  uuid: '',
                  title: titleController.text,
                  description: descriptionController.text,
                  state: stateController.text,
                  priority: priorityController.text,
                  notificationTime: notificationTimeController.text,
                  userUUID: userUUIDController.text,
                );
                // Aquí puedes manejar la creación de la

                await tasksRepository.createTask(newTask);
                // ignore: use_build_context_synchronously
                context.go('/');
              },
              child: const Text('Crear tarea'),
            ),
          ],
        ),
      ),
    );
  }
}
