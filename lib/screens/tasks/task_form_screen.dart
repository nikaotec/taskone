/**
 * Tela de formulário de tarefas
 * 
 */
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:taskone/models/task.dart';
import 'package:taskone/providers/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({Key? key, this.task}) : super(key: key);

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late bool _isCompleted;
  late String _priority;
  late String _description;
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  List<String> _shared = [];
  List<Subtask> _subtasks = [];
  String? _category;
  int _progress = 0;
  final TextEditingController _subtaskController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.task != null) {
      _title = widget.task!.title;
      _isCompleted = widget.task!.isCompleted;
      _priority = widget.task!.priority;
      _description = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _dueTime = widget.task!.dueTime;
      _shared = widget.task!.shared;
      _subtasks = List.from(widget.task!.subtasks);
      _category = widget.task!.category;
      _progress = widget.task!.progress;
    } else {
      _title = '';
      _isCompleted = false;
      _priority = 'low';
      _description = '';
      _dueDate = null;
      _dueTime = null;
      _shared = [];
      _subtasks = [];
      _category = 'Todos';
      _progress = 0;
    }
  }

  @override
  void dispose() {
    _subtaskController.dispose();
    super.dispose();
  }

  void _addSubtask() async {
    if (_subtaskController.text.isNotEmpty) {
      final List<Map<String, String>> selectedUsers =
          await _showUserSelectionDialog();

      setState(() {
        _subtasks.add(
          Subtask(
            id: DateTime.now().toString(),
            title: _subtaskController.text,
            contributors: selectedUsers,
          ),
        );
        _subtaskController.clear();
      });
    }
  }

  Future<List<Map<String, String>>> _showUserSelectionDialog() async {
    final List<Map<String, String>> selectedUsers = [];

    await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Selecionar Usuários'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ..._dummyUsers.map((user) {
                    return CheckboxListTile(
                      title: Text(user['name'] ?? ''),
                      value: selectedUsers.contains(user),
                      onChanged: (value) {
                        if (value == true) {
                          selectedUsers.add(user);
                        } else {
                          selectedUsers.remove(user);
                        }
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, selectedUsers),
                child: Text('Confirmar'),
              ),
            ],
          ),
    );

    return selectedUsers;
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final task = Task(
          id: widget.task?.id ?? DateTime.now().toString(),
          docId: widget.task?.docId ?? '',
          title: _title,
          isCompleted: _isCompleted,
          priority: _priority,
          createdAt: widget.task?.createdAt ?? DateTime.now(),
          editedAt: widget.task?.editedAt ?? [],
          description: _description,
          dueDate: _dueDate,
          dueTime: _dueTime,
          shared: _shared,
          subtasks: _subtasks,
          category: _category,
          progress: _progress,
        );

        final taskProvider = Provider.of<TaskProvider>(context, listen: false);

        if (widget.task == null) {
          await taskProvider.addTask(task, context);
        } else {
          await taskProvider.updateTask(task, context);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tarefa salva com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        await Future.delayed(Duration(milliseconds: 500));

        if (mounted) {
          Navigator.pop(context); // Fecha o Bottom Sheet após salvar
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao salvar tarefa: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).viewInsets.bottom, // Ajusta para o teclado
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.task == null ? 'Criar Tarefa' : 'Editar Tarefa',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Task Title
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  hintText: 'Título da tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O título é obrigatório';
                  }
                  return null;
                },
                onChanged: (value) => _title = value,
              ),
              SizedBox(height: 16),
              // Time & Date
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _dueDate == null
                            ? 'Selecionar data'
                            : DateFormat('dd/MM/yyyy').format(_dueDate!),
                      ),
                      leading: Icon(Icons.calendar_today),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _dueDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() => _dueDate = date);
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ListTile(
                      title: Text(
                        _dueTime == null
                            ? 'Selecionar hora'
                            : '${_dueTime!.hour.toString().padLeft(2, '0')}:${_dueTime!.minute.toString().padLeft(2, '0')}',
                      ),
                      leading: Icon(Icons.access_time),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _dueTime ?? TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() => _dueTime = time);
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Task Details
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  hintText: 'Descrição da tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                ),
                maxLines: 3,
                onChanged: (value) => _description = value,
              ),
              SizedBox(height: 16),
              // Priority and Category
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _priority,
                      items:
                          ['low', 'medium', 'high'].map((String priority) {
                            return DropdownMenuItem<String>(
                              value: priority,
                              child: Text(priority),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _priority = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Prioridade',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _category,
                      items:
                          [
                            'Todos',
                            'Design',
                            'Desenvolvimento',
                            'Marketing',
                          ].map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _category = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Categoria',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Subtasks
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _subtaskController,
                      decoration: InputDecoration(
                        hintText: 'Adicionar subtarefa',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(icon: Icon(Icons.add), onPressed: _addSubtask),
                ],
              ),
              SizedBox(height: 8),
              // Lista de subtarefas rolável
              Container(
                height: 150, // Altura fixa para a lista de subtarefas
                child: ListView.builder(
                  itemCount: _subtasks.length,
                  itemBuilder: (context, index) {
                    final subtask = _subtasks[index];
                    return ListTile(
                      title: Text(subtask.title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Exibe os avatares dos contribuidores
                          ...subtask.contributors.map((contributor) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  contributor['avatarUrl'] ?? '',
                                ),
                                radius: 12,
                              ),
                            );
                          }).toList(),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                _subtasks.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveTask,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child:
                    _isLoading
                        ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                        : Text('Salvar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
