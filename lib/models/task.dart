import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Subtask {
  String id;
  String title;
  bool isCompleted;
  List<Map<String, String>>
  contributors; // Lista de contribuidores (userId e avatarUrl)

  Subtask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    List<Map<String, String>>? contributors,
  }) : contributors = contributors ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'contributors':
          contributors, // Adiciona a lista de contribuidores ao mapa
    };
  }

  factory Subtask.fromMap(Map<String, dynamic> map) {
    return Subtask(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      contributors:
          (map['contributors'] as List?)?.map<Map<String, String>>((
            contributor,
          ) {
            return {
              'userId': contributor['userId'] ?? '',
              'avatarUrl': contributor['avatarUrl'] ?? '',
            };
          }).toList() ??
          [],
    );
  }
}

class Task {
  final String id;
  final String docId;
  final String title;
  bool isCompleted;
  String priority;
  final DateTime createdAt;
  final List<Map<String, dynamic>> editedAt;
  String description;
  DateTime? dueDate;
  TimeOfDay? dueTime;
  List<String> shared;
  List<Subtask> subtasks;
  String? category; // Campo de categoria (opcional, padrão: 'Todos')
  int progress; // Novo campo: progresso da tarefa (0 a 100)

  Task({
    required this.id,
    required this.docId,
    required this.title,
    this.isCompleted = false,
    this.priority = 'low',
    required this.createdAt,
    required this.editedAt,
    this.description = '',
    this.dueDate,
    this.dueTime,
    List<String>? shared,
    List<Subtask>? subtasks,
    this.category = 'Todos', // Valor padrão para a categoria
    this.progress = 0, // Valor padrão para o progresso
  }) : shared = shared ?? [],
       subtasks = subtasks ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'docId': docId,
      'title': title,
      'isCompleted': isCompleted,
      'priority': priority,
      'createdAt': createdAt,
      'editedAt': editedAt,
      'description': description,
      'dueDate': dueDate,
      'dueTime': dueTime != null ? '${dueTime!.hour}:${dueTime!.minute}' : null,
      'shared': shared,
      'subtasks': subtasks.map((subtask) => subtask.toMap()).toList(),
      'category':
          category ??
          'Todos', // Garante que a categoria seja 'Todos' se for nula
      'progress': progress, // Adiciona o campo progress ao mapa
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    // Handle createdAt conversion
    DateTime createdAtDateTime;
    if (map['createdAt'] is Timestamp) {
      createdAtDateTime = (map['createdAt'] as Timestamp).toDate();
    } else {
      createdAtDateTime = DateTime.now();
    }

    // Handle editedAt conversion
    List<Map<String, dynamic>> editedAtList = [];
    if (map['editedAt'] != null) {
      editedAtList =
          (map['editedAt'] as List).map((edit) {
            if (edit['timestamp'] is Timestamp) {
              return {
                'timestamp': (edit['timestamp'] as Timestamp).toDate(),
                'userId': edit['userId'],
              };
            }
            return edit as Map<String, dynamic>;
          }).toList();
    }

    // Handle dueDate conversion
    DateTime? dueDateDateTime;
    if (map['dueDate'] is Timestamp) {
      dueDateDateTime = (map['dueDate'] as Timestamp).toDate();
    } else if (map['dueDate'] != null) {
      dueDateDateTime = DateTime.parse(map['dueDate'].toString());
    }

    // Handle dueTime conversion
    TimeOfDay? dueTimeOfDay;
    if (map['dueTime'] != null) {
      final timeParts = map['dueTime'].toString().split(':');
      if (timeParts.length == 2) {
        dueTimeOfDay = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    }

    // Handle subtasks conversion
    List<Subtask> subtasksList = [];
    if (map['subtasks'] != null) {
      subtasksList =
          (map['subtasks'] as List)
              .map(
                (subtask) => Subtask.fromMap(subtask as Map<String, dynamic>),
              )
              .toList();
    }

    return Task(
      id: map['id'] ?? '',
      docId: map['docId'] ?? '',
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      priority: map['priority'] ?? 'low',
      createdAt: createdAtDateTime,
      editedAt: editedAtList,
      description: map['description'] ?? '',
      dueDate: dueDateDateTime,
      dueTime: dueTimeOfDay,
      shared: List<String>.from(map['shared'] ?? []),
      subtasks: subtasksList,
      category:
          map['category'] ??
          'Todos', // Garante que a categoria seja 'Todos' se for nula
      progress: map['progress'] ?? 0, // Adiciona o campo progress ao factory
    );
  }

  Task copyWith({
    String? id,
    String? docId,
    String? title,
    bool? isCompleted,
    String? priority,
    DateTime? createdAt,
    List<Map<String, dynamic>>? editedAt,
    String? description,
    DateTime? dueDate,
    TimeOfDay? dueTime,
    List<String>? shared,
    List<Subtask>? subtasks,
    String? category,
    int? progress, // Adiciona o campo progress ao copyWith
  }) {
    return Task(
      id: id ?? this.id,
      docId: docId ?? this.docId,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      editedAt: editedAt ?? this.editedAt,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      shared: shared ?? this.shared,
      subtasks: subtasks ?? this.subtasks,
      category: category ?? this.category,
      progress:
          progress ?? this.progress, // Adiciona o campo progress ao copyWith
    );
  }
}
