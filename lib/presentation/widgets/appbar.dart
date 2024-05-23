// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_ninja_flutter/infraestructure/services/connection.dart';

class MyAppBar extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(isConnectedProvider);
    return AppBar(
      title: Text(
        isConnected ? 'Conectado' : 'Desconectado',
        style: TextStyle(
          color: isConnected ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
