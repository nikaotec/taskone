import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:taskone/models/task.dart';
import 'package:taskone/providers/task_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleManageTask extends StatefulWidget {
  const ScheduleManageTask({Key? key}) : super(key: key);

  @override
  _ScheduleManageTaskState createState() => _ScheduleManageTaskState();
}

class _ScheduleManageTaskState extends State<ScheduleManageTask> {
  String _selectedCategory = 'Todos'; // Categoria selecionada
  List<String> _categories = ['Todos', 'Design', 'Desenvolvimento', 'Marketing']; // Lista de categorias
  final TextEditingController _categoryController = TextEditingController(); // Controlador para o diálogo de nova categoria

  @override
  void initState() {
    super.initState();
    _loadCategories(); // Carrega as categorias salvas localmente
  }

  // Carrega as categorias salvas localmente
  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _categories = prefs.getStringList('categories') ?? ['Todos', 'Design', 'Desenvolvimento', 'Marketing'];
    });
  }

  // Salva as categorias localmente
  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('categories', _categories);
  }

  // Adiciona uma nova categoria
  void _addCategory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nova Categoria'),
        content: TextField(
          controller: _categoryController,
          decoration: InputDecoration(
            hintText: 'Nome da categoria',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (_categoryController.text.isNotEmpty) {
                setState(() {
                  _categories.add(_categoryController.text); // Adiciona a nova categoria
                  _saveCategories(); // Salva as categorias
                });
                _categoryController.clear(); // Limpa o campo de texto
                Navigator.pop(context); // Fecha o diálogo
              }
            },
            child: Text('Salvar'),
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
        color: Theme.of(context).colorScheme.background, // Usa a cor de fundo do tema
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant, // Usa a cor do texto secundário
                            fontSize: 16,
                          ),
                        ).animate().fadeIn().slideX(),
                        Text(
                          'Fazil Laghari',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground, // Usa a cor do texto
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn().slideX(delay: 200.ms),
                      ],
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
                      ),
                    ).animate().scale(delay: 400.ms),
                  ],
                ),
              ),

              // Barra de pesquisa
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search tasks',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest, // Usa a cor de superfície mais alta
                  ),
                ),
              ).animate().fadeIn().slideY(delay: 600.ms),

              // Seção de categorias
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categorias',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 100, // Altura da lista de categorias
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // Botão para adicionar nova categoria
                          GestureDetector(
                            onTap: _addCategory,
                            child: Container(
                              width: 100,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          // Lista de categorias
                          ..._categories.map((category) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category; // Atualiza a categoria selecionada
                                });
                              },
                              child: Container(
                                width: 100,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(category),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Seção de projetos em andamento
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ongoing Projects',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See all',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Lista de projetos em andamento (filtrada por categoria)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface, // Usa a cor de superfície
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: StreamBuilder<List<Task>>(
                    stream: taskProvider.getTasksStream(context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Erro: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_alt,
                                size: 64,
                                color: Theme.of(context).colorScheme.onSurfaceVariant, // Usa a cor do texto secundário
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Nenhuma tarefa disponível',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant, // Usa a cor do texto secundário
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final tasks = snapshot.data!;
                      final filteredTasks = _selectedCategory == 'Todos'
                          ? tasks
                          : tasks.where((task) => task.category == _selectedCategory).toList();

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return _buildOngoingTaskCard(
                            context,
                            task,
                            taskProvider
                          ).animate().fadeIn().slideX(
                            delay: Duration(milliseconds: 100 * index),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  

  // Retorna uma cor para cada categoria
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Design':
        return Colors.purple;
      case 'Desenvolvimento':
        return Colors.blue;
      case 'Marketing':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  

  // Widget para cartão de projeto em andamento
  Widget _buildOngoingTaskCard(BuildContext context, Task task, TaskProvider taskProvider) {

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