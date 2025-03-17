import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(bool?)? onToggle;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const TaskTile({
    Key? key,
    required this.task,
    this.onToggle,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getPriorityColor(String priority) {
      switch (priority) {
        case 'high':
          return Colors.red; // Vermelho para alta prioridade
        case 'medium':
          return Colors.orange; // Laranja para média prioridade
        default:
          return Colors.green; // Verde para baixa prioridade
      }
    }

    return GestureDetector(
      onTap: onTap, // Navega para a tela de detalhes
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // Bordas arredondadas
          color: Theme.of(context).colorScheme.surface, // Fundo neutro
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment
                    .stretch, // Estica os filhos para ocupar toda a altura
            children: [
              // Barra lateral colorida
              Container(
                width: 4, // Largura fina
                decoration: BoxDecoration(
                  color: getPriorityColor(
                    task.priority,
                  ), // Cor baseada na prioridade
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ), // Espaçamento entre a barra e o checkbox
              // Checkbox redondo
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Checkbox(
                    value: task.isCompleted,
                    onChanged: onToggle,
                    shape: const CircleBorder(), // Torna o checkbox redondo
                    activeColor:
                        Theme.of(
                          context,
                        ).colorScheme.primary, // Cor quando marcado
                    side: BorderSide(
                      color:
                          Theme.of(
                            context,
                          ).colorScheme.onSurface, // Cor da borda
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ), // Espaçamento entre o checkbox e o conteúdo
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Espaçamento interno
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration:
                              task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                          color: task.isCompleted ? Colors.grey : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Prioridade: ${_getPriorityLabel(task.priority)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete, // Chama o método de exclusão
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPriorityLabel(String priority) {
    switch (priority) {
      case 'high':
        return 'Alta';
      case 'medium':
        return 'Média';
      default:
        return 'Baixa';
    }
  }
}
