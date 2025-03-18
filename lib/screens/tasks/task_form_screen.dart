import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
      // Abre um diálogo para selecionar usuários
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
                  // Lista de usuários fictícia (substitua por uma lista real de usuários)
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
          context.go('/home');
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
    return WillPopScope(
      onWillPop: () async {
        if (_title.isNotEmpty ||
            _description.isNotEmpty ||
            _subtasks.isNotEmpty) {
          final result = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: Text('Descartar alterações?'),
                  content: Text(
                    'Você tem alterações não salvas. Deseja descartá-las?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text('Descartar'),
                    ),
                  ],
                ),
          );
          return result ?? false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title:
              Text(
                widget.task == null ? 'Create New Task' : 'Edit Task',
              ).animate().fadeIn().slideX(),
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              final canPop = await Navigator.of(context).maybePop();
              if (!canPop && mounted) {
                context.go('/home');
              }
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Task Title
                  Text(
                    'Task Title',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    initialValue: _title,
                    decoration: InputDecoration(
                      hintText: 'Enter task title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Task title is required';
                      }
                      return null;
                    },
                    onChanged: (value) => _title = value,
                  ).animate().fadeIn().slideX(),
                  SizedBox(height: 16),

                  // Time & Date (lado a lado)
                  Text(
                    'Time & Date',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      // Select Date
                      Expanded(
                        child: ListTile(
                          title: Text(
                            _dueDate == null
                                ? 'Select date'
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
                      // Select Time
                      Expanded(
                        child: ListTile(
                          title: Text(
                            _dueTime == null
                                ? 'Select time'
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
                  Text(
                    'Task Details',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    initialValue: _description,
                    decoration: InputDecoration(
                      hintText: 'Enter task details',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surface,
                    ),
                    maxLines: 5,
                    onChanged: (value) => _description = value,
                  ).animate().fadeIn().slideX(delay: 100.ms),
                  SizedBox(height: 16),

                  // Priority and Category (lado a lado)
                  Row(
                    children: [
                      // Priority
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Priority',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _priority,
                              items:
                                  ['low', 'medium', 'high'].map((
                                    String priority,
                                  ) {
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      // Category
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Category',
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            DropdownButtonFormField<String>(
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Subtasks
                  Text(
                    'Subtasks',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _subtaskController,
                          decoration: InputDecoration(
                            hintText: 'Enter subtask title',
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
                  ..._subtasks.map((subtask) {
                    return ListTile(
                      title: Text(subtask.title),
                      subtitle: Row(
                        children: [
                          ...subtask.contributors.map((user) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 4.0),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  user['avatarUrl'] ?? '',
                                ),
                                radius: 12,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _subtasks.remove(subtask);
                          });
                        },
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 16),

                  // Create Button
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
                            : Text('Create', style: TextStyle(fontSize: 16)),
                  ).animate().fadeIn(delay: 500.ms).slideY(),
                ],
              ),
            ),
          ),
        ),
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
