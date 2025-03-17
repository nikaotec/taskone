import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Stream<List<Task>> getTasksStream(BuildContext context) async* {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = await authProvider.getUserIdLocally();

    if (userId == null) {
      throw Exception('Usuário não autenticado');
    }

    yield* _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((querySnapshot) {
          return querySnapshot.docs.map((doc) {
            final data = doc.data();
            data['docId'] = doc.id; // Include the document ID
            return Task.fromMap(data);
          }).toList();
        });
  }

  Future<Task> getTaskById(String taskId, BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = await authProvider.getUserIdLocally();

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final docSnapshot =
          await _firestore
              .collection('tasks')
              .where('id', isEqualTo: taskId)
              .get();

      if (docSnapshot.docs.isEmpty) {
        throw Exception('Tarefa não encontrada');
      }

      final doc = docSnapshot.docs.first;
      final data = doc.data();
      data['docId'] = doc.id; // Include the document ID
      return Task.fromMap(data);
    } catch (e) {
      print('Erro ao buscar tarefa: $e');
      throw Exception('Erro ao buscar tarefa: $e');
    }
  }

  Future<List<Task>> loadTasks(BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = await authProvider.getUserIdLocally();

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final querySnapshot =
          await _firestore
              .collection('tasks')
              .where('userId', isEqualTo: userId)
              .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['docId'] = doc.id;
        return Task.fromMap(data);
      }).toList();
    } catch (e) {
      print('Erro ao carregar tarefas: $e');
      throw Exception('Erro ao carregar tarefas: $e');
    }
  }

  Future<void> addTask(Task task, BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = await authProvider.getUserIdLocally();

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      final docRef = await _firestore.collection('tasks').add({
        'id': task.id,
        'title': task.title,
        'isCompleted': task.isCompleted,
        'priority': task.priority,
        'createdAt': Timestamp.fromDate(task.createdAt),
        'editedAt':
            task.editedAt
                .map(
                  (edit) => {
                    'timestamp': Timestamp.fromDate(edit['timestamp']),
                    'userId': edit['userId'],
                  },
                )
                .toList(),
        'description': task.description,
        'dueDate':
            task.dueDate != null ? Timestamp.fromDate(task.dueDate!) : null,
        'dueTime':
            task.dueTime != null
                ? '${task.dueTime!.hour}:${task.dueTime!.minute}'
                : null,
        'shared': task.shared,
        'subtasks': task.subtasks.map((subtask) => subtask.toMap()).toList(),
        'userId': userId,
      });

      // Update the document with its ID
      await docRef.update({'docId': docRef.id});

      print('Tarefa adicionada com sucesso!');
    } catch (e) {
      print('Erro ao adicionar tarefa: $e');
      throw Exception('Erro ao adicionar tarefa: $e');
    }
  }

  Future<void> updateTask(Task task, BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = await authProvider.getUserIdLocally();

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      // Get the document reference using the task ID
      final querySnapshot =
          await _firestore
              .collection('tasks')
              .where('id', isEqualTo: task.id)
              .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Tarefa não encontrada');
      }

      final docRef = querySnapshot.docs.first.reference;
      final updatedEditedAt = List<Map<String, dynamic>>.from(task.editedAt);
      updatedEditedAt.add({'timestamp': DateTime.now(), 'userId': userId});

      await docRef.update({
        'title': task.title,
        'isCompleted': task.isCompleted,
        'priority': task.priority,
        'editedAt':
            updatedEditedAt
                .map(
                  (edit) => {
                    'timestamp': Timestamp.fromDate(edit['timestamp']),
                    'userId': edit['userId'],
                  },
                )
                .toList(),
        'description': task.description,
        'dueDate':
            task.dueDate != null ? Timestamp.fromDate(task.dueDate!) : null,
        'dueTime':
            task.dueTime != null
                ? '${task.dueTime!.hour}:${task.dueTime!.minute}'
                : null,
        'shared': task.shared,
        'subtasks': task.subtasks.map((subtask) => subtask.toMap()).toList(),
      });

      print('Tarefa atualizada com sucesso!');
    } catch (e) {
      print('Erro ao atualizar tarefa: $e');
      throw Exception('Erro ao atualizar tarefa: $e');
    }
  }

  Future<void> deleteTask(String docId, BuildContext context) async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = await authProvider.getUserIdLocally();

      if (userId == null) {
        throw Exception('Usuário não autenticado');
      }

      await _firestore.collection('tasks').doc(docId).delete();
      print('Tarefa excluída com sucesso!');
    } catch (e) {
      print('Erro ao excluir tarefa: $e');
      throw Exception('Erro ao excluir tarefa: $e');
    }
  }
}
