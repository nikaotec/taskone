import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:taskone/models/task.dart';
import 'package:taskone/providers/auth_provider.dart';
import 'package:taskone/providers/task_provider.dart';
import 'package:taskone/widgets/skeleton_loading.dart';
import '../themes/color_scheme.dart'; // Importe o esquema de cores

class TaskList extends StatelessWidget {
  const TaskList({Key? key}) : super(key: key);

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Deseja realmente sair?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  final authProvider = Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  );
                  await authProvider.signOut();
                  if (context.mounted) context.go('/login');
                },
                child: const Text('Sair'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      body: Container(
        color:
            Theme.of(
              context,
            ).colorScheme.background, // Usa a cor de fundo do tema
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Minhas Tarefas',
                          style: TextStyle(
                            color:
                                Theme.of(context)
                                    .colorScheme
                                    .onBackground, // Usa a cor do texto do tema
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn().slideX(),
                        Text(
                          'Gerencie suas atividades',
                          style: TextStyle(
                            color:
                                Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant, // Usa a cor do texto secundário
                            fontSize: 16,
                          ),
                        ).animate().fadeIn().slideX(delay: 200.ms),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Theme.of(context).colorScheme.onBackground,
                      ), // Usa a cor do texto do tema
                      onPressed: () => _showLogoutDialog(context),
                    ).animate().scale(delay: 400.ms),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(
                          context,
                        ).colorScheme.surface, // Usa a cor de superfície
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Buscar tarefas',
                            prefixIcon: Icon(
                              Icons.search,
                              color:
                                  Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant, // Usa a cor do texto secundário
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor:
                                Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest, // Usa a cor de superfície mais alta
                          ),
                        ),
                      ).animate().fadeIn().slideY(delay: 600.ms),
                      Expanded(
                        child: StreamBuilder<List<Task>>(
                          stream: taskProvider.getTasksStream(context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SkeletonLoading();
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Erro: ${snapshot.error}'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.task_alt,
                                      size: 64,
                                      color:
                                          Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant, // Usa a cor do texto secundário
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Nenhuma tarefa disponível',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant, // Usa a cor do texto secundário
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final tasks = snapshot.data!;
                            return ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                final task = tasks[index];
                                return _buildTaskCard(
                                  context,
                                  task,
                                  taskProvider,
                                ).animate().fadeIn().slideX(
                                  delay: Duration(milliseconds: 100 * index),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/add-task'),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor:
            Theme.of(
              context,
            ).colorScheme.secondary, // Usa a cor secundária do tema
        elevation: 6, // Sombra mais pronunciada
      ).animate().scale(delay: 800.ms),
    );
  }

  Widget _buildTaskCard(
    BuildContext context,
    Task task,
    TaskProvider taskProvider,
  ) {
    Color priorityColor;
    switch (task.priority) {
      case 'high':
        priorityColor = Colors.red[400]!;
        break;
      case 'medium':
        priorityColor = Colors.orange[400]!;
        break;
      default:
        priorityColor = Colors.green[400]!;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2, // Sombra suave
      color: Theme.of(context).colorScheme.surface, // Usa a cor de superfície
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: priorityColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: priorityColor,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color:
                Theme.of(
                  context,
                ).colorScheme.onSurface, // Usa a cor do texto do tema
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) ...[
              SizedBox(height: 5),
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                      Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant, // Usa a cor do texto secundário
                ),
              ),
            ],
            if (task.dueDate != null) ...[
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ), // Usa a cor do texto secundário
                  SizedBox(width: 5),
                  Text(
                    '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}',
                    style: TextStyle(
                      color:
                          Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant, // Usa a cor do texto secundário
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color:
                Theme.of(
                  context,
                ).colorScheme.onSurfaceVariant, // Usa a cor do texto secundário
          ),
          onPressed: () => context.push('/task-detail', extra: task),
        ),
        onTap: () {
          task.isCompleted = !task.isCompleted;
          taskProvider.updateTask(task, context);
        },
      ),
    );
  }
}
