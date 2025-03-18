import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskone/models/task.dart';
import 'package:taskone/providers/task_provider.dart';
import 'package:taskone/screens/tasks/global_functions.dart';
import 'package:taskone/screens/tasks/task_form_screen.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String taskId;

  TaskDetailsScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(
          'Task Details',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurface),
            onPressed: () {
              // Ações adicionais
            },
          ),
        ],
      ),
      body: FutureBuilder<Task>(
        future: Provider.of<TaskProvider>(
          context,
          listen: false,
        ).getTaskById(taskId, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                'Erro ao carregar tarefa',
                style: TextStyle(color: theme.colorScheme.onError),
              ),
            );
          }

          final task = snapshot.data!;
          final double progress = _calculateProgress(task);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título da tarefa
                Text(
                  task.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Informações da tarefa (data, equipe e progresso)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Data da tarefa
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${task.dueDate?.day}/${task.dueDate?.month}/${task.dueDate?.year}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (task.dueTime != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                '${task.dueTime!.hour}:${task.dueTime!.minute}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Project Progress",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    // Equipe da tarefa e progresso
                    Column(
                      children: [
                        // Equipe da tarefa
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            ...task.subtasks
                                .expand((subtask) => subtask.contributors)
                                .map((contributor) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        contributor['avatarUrl'] ?? '',
                                      ),
                                      radius: 12,
                                    ),
                                  );
                                })
                                .toList(),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Progresso da tarefa
                        _progressIndicator(progress, theme),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Detalhes do projeto
                Text(
                  "Project Details",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Prioridade da tarefa
                Text(
                  "Priority",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task.priority,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Categoria da tarefa
                DropdownButtonFormField<String>(
                  value: task.category,
                  items:
                      ['Todos', 'Design', 'Desenvolvimento', 'Marketing'].map((
                        String category,
                      ) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                  onChanged: (value) {
                    task.category = value;
                    Provider.of<TaskProvider>(
                      context,
                      listen: false,
                    ).updateTask(task, context);
                  },
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Lista de subtasks
                Text(
                  "Subtasks",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...task.subtasks.map((subtask) {
                  return _taskItem(subtask, task, context, theme);
                }).toList(),
                const SizedBox(height: 16),

                // Botão para editar a tarefa
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      showTaskFormBottomSheet(context, task: task);
                      // Navegar para a TaskFormScreen no modo de edição
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => TaskFormScreen(task: task),
                      //   ),
                      // );
                    },
                    child: Text(
                      "Edit Task",
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Função para calcular o progresso com base nas subtasks
  double _calculateProgress(Task task) {
    if (task.subtasks.isEmpty) {
      return task.isCompleted ? 1.0 : 0.0;
    } else {
      final completedSubtasks =
          task.subtasks.where((subtask) => subtask.isCompleted).length;
      return completedSubtasks / task.subtasks.length;
    }
  }

  // Widget para o indicador de progresso
  Widget _progressIndicator(double progress, ThemeData theme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
            strokeWidth: 6,
          ),
        ),
        Text(
          "${(progress * 100).toInt()}%",
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Widget para cada item da subtask
  Widget _taskItem(
    Subtask subtask,
    Task task,
    BuildContext context,
    ThemeData theme,
  ) {
    return Card(
      color: theme.colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        leading: Checkbox(
          value: subtask.isCompleted,
          onChanged: (value) {
            subtask.isCompleted = value ?? false;
            _updateTaskCompletion(task, context);
          },
        ),
        title: Text(
          subtask.title,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...subtask.contributors.map((contributor) {
              return Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(contributor['avatarUrl'] ?? ''),
                  radius: 12,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // Função para atualizar o status da tarefa principal
  void _updateTaskCompletion(Task task, BuildContext context) {
    if (task.subtasks.isNotEmpty) {
      task.isCompleted = task.subtasks.every((subtask) => subtask.isCompleted);
    }
    Provider.of<TaskProvider>(context, listen: false).updateTask(task, context);
  }
}
