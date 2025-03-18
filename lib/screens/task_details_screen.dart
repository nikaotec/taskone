import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class TaskDetailsScreen extends StatelessWidget {
  final String taskId;

   TaskDetailsScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtendo o tema atual

    return Scaffold(
      backgroundColor:
          theme.colorScheme.background, // Usando o tema para o fundo
      appBar: AppBar(
        backgroundColor:
            theme.colorScheme.surface, // Usando o tema para o AppBar
        elevation: 0, // Remove a sombra do AppBar
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
          final double progress = _calculateProgress(
            task,
          ); // Calcula o progresso com base nas subtasks

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
                            // Exibindo os avatares dos contribuidores
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
                    // Atualizar a categoria da tarefa
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

                // Botão para adicionar subtask
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
                    onPressed: () => _addSubtask(context, task),
                    child: Text(
                      "Add Subtask",
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
      return task.isCompleted
          ? 1.0
          : 0.0; // Progresso baseado na tarefa principal
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
            _updateTaskCompletion(
              task,
              context,
            ); // Atualiza o status da tarefa principal
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
            // Exibindo os avatares dos contribuidores
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
      // Marca a tarefa como concluída se todas as subtasks estiverem concluídas
      task.isCompleted = task.subtasks.every((subtask) => subtask.isCompleted);
    }
    Provider.of<TaskProvider>(context, listen: false).updateTask(task, context);
  }

  // Função para adicionar uma nova subtask
  void _addSubtask(BuildContext context, Task task) {
    final theme = Theme.of(context); // Obtendo o tema atual
    final TextEditingController _subtaskController = TextEditingController();
    final List<Map<String, String>> _selectedUsers = [];

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Add Subtask',
              style: TextStyle(color: theme.colorScheme.onSurface),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _subtaskController,
                  decoration: InputDecoration(
                    hintText: 'Subtask title',
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Aqui você pode adicionar um seletor de usuários (pode ser um dropdown ou uma lista de checkboxes)
                // Exemplo simplificado:
                Text(
                  'Select users:',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                ..._dummyUsers.map((user) {
                  return CheckboxListTile(
                    title: Text(user['name'] ?? ''),
                    value: _selectedUsers.contains(user),
                    onChanged: (value) {
                      if (value == true) {
                        _selectedUsers.add(user);
                      } else {
                        _selectedUsers.remove(user);
                      }
                    },
                  );
                }).toList(),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_subtaskController.text.isNotEmpty) {
                    final newSubtask = Subtask(
                      id: DateTime.now().toString(),
                      title: _subtaskController.text,
                      contributors: _selectedUsers,
                    );
                    task.subtasks.add(newSubtask);
                    _updateTaskCompletion(
                      task,
                      context,
                    ); // Atualiza o status da tarefa principal
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Add',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // Lista de usuários fictícia (substitua por uma lista real de usuários)
  final List<Map<String, String>> _dummyUsers = [
    {
      'userId': '1',
      'name': 'User 1',
      'avatarUrl': 'https://via.placeholder.com/150',
    },
    {
      'userId': '2',
      'name': 'User 2',
      'avatarUrl': 'https://via.placeholder.com/150',
    },
    {
      'userId': '3',
      'name': 'User 3',
      'avatarUrl': 'https://via.placeholder.com/150',
    },
  ];
}
