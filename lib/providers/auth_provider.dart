import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/db_helper.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userId')) return;
    final id = prefs.getInt('userId')!;
    final u = await DBHelper.getUserById(id);
    if (u != null) {
      _user = u;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    final u = await DBHelper.getUserByEmail(email);
    if (u == null) return false;
    if (u.password != password) return false;
    _user = u;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', u.id!);
    notifyListeners();
    return true;
  }

  Future<bool> signup(User user) async {
    final id = await DBHelper.insertUser(user);
    user.id = id;
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', id);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    notifyListeners();
  }

  Future<void> updateProfile(User updated) async {
    await DBHelper.updateUser(updated);
    _user = updated;
    notifyListeners();
  }
}
