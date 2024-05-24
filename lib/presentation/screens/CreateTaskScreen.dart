import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_ninja_flutter/domain/entities/tasks.dart';
import 'package:task_ninja_flutter/domain/repositories/tasks_repository.dart';
import 'package:task_ninja_flutter/infraestructure/local/local_database.dart';
import 'package:task_ninja_flutter/infraestructure/services/connection.dart';
import 'package:task_ninja_flutter/presentation/widgets/appbar.dart';
import 'package:uuid/uuid.dart';

class CreateTaskScreen extends ConsumerWidget {
  final TasksRepository tasksRepository;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final stateController = TextEditingController();
  final priorityController = TextEditingController();
  final notificationTimeController = TextEditingController();
  final userUUIDController = TextEditingController();

  CreateTaskScreen({super.key, required this.tasksRepository});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                if (ref.watch(isConnectedProvider)) {
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
                }
                // ignore: use_build_context_synchronously
                var uuid = const Uuid();
                String v4uuid = uuid.v4();

                final dbHelper = DatabaseHelper.instance;
                Map<String, dynamic> row = {
                  DatabaseHelper.columnUuid: v4uuid,
                  DatabaseHelper.columnTitle: titleController.text,
                  DatabaseHelper.columnDescription: descriptionController.text,
                  DatabaseHelper.columnState: stateController.text,
                  DatabaseHelper.columnPriority: priorityController.text,
                  DatabaseHelper.columnNotificationTime:
                      '2024-05-22T22:00:00.000Z',
                  DatabaseHelper.columnUserUUID: '080d6452-4cd6-475d-aac7-3040869da155',
                  DatabaseHelper.columnIsSynced:
                      0, // 0 significa no sincronizado
                };
                await dbHelper.insert(row);
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
