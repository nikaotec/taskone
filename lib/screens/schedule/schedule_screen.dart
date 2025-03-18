import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:taskone/models/task.dart';
import 'package:taskone/providers/task_provider.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final theme = Theme.of(context);

    // Configura o CalendarController
    final calendarController =
        CalendarControllerProvider.of(context).controller;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Agenda Semanal',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exibe a visualização semanal
          Expanded(
            child: WeekView(
              controller: calendarController,
              eventTileBuilder: (date, events, boundary, start, end) {
                // Filtra as tarefas para a data e horário atuais
                final tasksForDate =
                    taskProvider.tasks
                        .where((task) {
                          if (task.dueDate == null || task.dueTime == null)
                            return false;

                          // Combina a data e o horário para comparar com o horário do evento
                          final taskDateTime = DateTime(
                            task.dueDate!.year,
                            task.dueDate!.month,
                            task.dueDate!.day,
                            task.dueTime!.hour,
                            task.dueTime!.minute,
                          );

                          // Verifica se a tarefa corresponde ao horário do evento
                          return taskDateTime.isAtSameMomentAs(date);
                        })
                        .toList();
              
                return _buildEventTile(date, tasksForDate, theme);
              },
              onEventTap: (date, events) {
                // Ao clicar em um evento, exibe as tarefas do dia
                _showTasksForDate(context, date, taskProvider, theme);
              },
              // Aplica o tema ao WeekView
              weekDayBuilder: (day) {
                return Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat(
                        'E',
                      ).format(day), // Exibe o dia da semana (ex: "Mon")
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
              timeLineBuilder: (time) {
                return Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat(
                        'HH:mm',
                      ).format(time), // Exibe a hora (ex: "14:00")
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],

      ),
    );
  }

  // Constrói um tile de evento para o WeekView
  Widget _buildEventTile(DateTime date, List<Task> tasks, ThemeData theme) {
    return Container(
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('HH:mm').format(date), // Exibe a hora do evento
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (tasks.isNotEmpty)
            ...tasks.map((task) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  task.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  task.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  // Exibe as tarefas de uma data específica
  void _showTasksForDate(
    BuildContext context,
    DateTime date,
    List<CalendarEventData<Object?>> events,
    TaskProvider taskProvider,
    ThemeData theme,
  ) {
    final tasksForDate = events
        .map((event) => event.event as Task)
        .toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('dd/MM/yyyy').format(date),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              if (tasksForDate.isEmpty)
                Text(
                  'Nenhuma tarefa para este dia',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ...tasksForDate.map((task) {
                return ListTile(
                  title: Text(
                    task.title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (task.dueTime != null)
                        Text(
                          '${task.dueTime!.hour}:${task.dueTime!.minute.toString().padLeft(2, '0')}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      if (task.description.isNotEmpty)
                        Text(
                          task.description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      task.isCompleted = value ?? false;
                      taskProvider.updateTask(task, context);
                    },
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
