import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;

  

  // Verifica se o usuário já está logado
  Future<bool> checkIfUserIsLoggedIn() async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = currentUser;
      notifyListeners();
      return true; // Usuário está logado
    }
    return false; // Usuário não está logado
  }

  // Método para fazer login com email e senha
  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;

      // Salva os dados do usuário localmente
      if (_user != null) {
        await _saveUserDataLocally(_user!.uid);
      }

      notifyListeners();
      return _user;
    } catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  // Método para registrar um novo usuário
  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;

      // Salva os dados do usuário no Firestore
      if (_user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .set({
              'uid': _user!.uid,
              'email': _user!.email,
              'createdAt': FieldValue.serverTimestamp(),
            });

        // Salva os dados do usuário localmente
        await _saveUserDataLocally(_user!.uid);
      }

      notifyListeners();
      return _user;
    } catch (e) {
      throw Exception('Erro ao registrar: $e');
    }
  }

  // Método para fazer logout
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;

    // Remove os dados do usuário localmente
    await _clearUserDataLocally();

    notifyListeners();
  }

  // Salva os dados do usuário localmente
  Future<void> _saveUserDataLocally(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', uid); // Salva o UID do usuário
  }

  // Limpa os dados do usuário localmente
  Future<void> _clearUserDataLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId'); // Remove o UID do usuário
  }

  // Recupera o UID do usuário salvo localmente
  Future<String?> getUserIdLocally() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }
}
