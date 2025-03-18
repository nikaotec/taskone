import 'package:flutter/material.dart';
import 'package:taskone/models/task.dart';
import 'package:taskone/screens/tasks/task_form_screen.dart';

void showTaskFormBottomSheet(BuildContext context, {Task? task}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Permite que o BottomSheet ocupe a maior parte da tela
    backgroundColor: Colors.transparent, // Remove o fundo padrão do BottomSheet
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Ajusta o padding para o teclado
        ),
        child: TaskFormScreen(task: task),
      );
    },
  );
}