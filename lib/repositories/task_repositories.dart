import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

// Interface para o repositório de tarefas
abstract class TaskRepository {
  Future<void> addTask(Task task);
  Future<void> updateTask(Task task);
  Future<void> deleteTask(String taskId);
  Stream<List<Task>> getTasks();
}

// Implementação do repositório usando Firestore
class FirebaseTaskRepository implements TaskRepository {
  final CollectionReference _tasksCollection = FirebaseFirestore.instance
      .collection('tasks');

  @override
  Future<void> addTask(Task task) async {
    try {
      await _tasksCollection.doc(task.id).set(task.toMap());
    } catch (e) {
      print('Erro ao adicionar tarefa: $e');
    }
    
  }

  @override
  Future<void> updateTask(Task task) async {
    await _tasksCollection.doc(task.id).update(task.toMap());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  @override
  Stream<List<Task>> getTasks() {
    return _tasksCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
