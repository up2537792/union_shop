import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final ValueNotifier<User?> currentUser = ValueNotifier<User?>(null);

  static const _kUsersKey = 'demo_users_v1';
  static const _kCurrentUserKey = 'demo_current_user_v1';

  Future<void> init() async {
    final sp = await SharedPreferences.getInstance();
    final cur = sp.getString(_kCurrentUserKey);
    if (cur != null) {
      try {
        final j = json.decode(cur) as Map<String, dynamic>;
        currentUser.value = User.fromJson(j);
      } catch (_) {}
    }
  }

  Future<bool> signUp(String email, String password, String displayName) async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getStringList(_kUsersKey) ?? [];
    final users = raw.map((e) => json.decode(e) as Map<String, dynamic>).toList();
    final exists = users.any((u) => (u['email'] as String).toLowerCase() == email.toLowerCase());
    if (exists) return false;
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final entry = {
      'id': id,
      'email': email,
      'displayName': displayName,
      'password': password,
    };
    users.add(entry);
    await sp.setStringList(_kUsersKey, users.map((u) => json.encode(u)).toList());
    // auto sign-in
    final user = User(id: id, email: email, displayName: displayName);
    await _setCurrentUser(user);
    return true;
  }

  Future<bool> signIn(String email, String password) async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getStringList(_kUsersKey) ?? [];
    for (final s in raw) {
      final u = json.decode(s) as Map<String, dynamic>;
      if ((u['email'] as String).toLowerCase() == email.toLowerCase() && (u['password'] as String) == password) {
        final user = User(id: u['id'] ?? '', email: u['email'] ?? '', displayName: u['displayName'] ?? '');
        await _setCurrentUser(user);
        return true;
      }
    }
    return false;
  }

  Future<void> signOut() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kCurrentUserKey);
    currentUser.value = null;
  }

  Future<void> _setCurrentUser(User u) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kCurrentUserKey, json.encode(u.toJson()));
    currentUser.value = u;
  }

  Future<void> updateDisplayName(String id, String newDisplayName) async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getStringList(_kUsersKey) ?? [];
    final users = raw.map((e) => json.decode(e) as Map<String, dynamic>).toList();
    for (var u in users) {
      if (u['id'] == id) {
        u['displayName'] = newDisplayName;
      }
    }
    await sp.setStringList(_kUsersKey, users.map((u) => json.encode(u)).toList());
    final cur = currentUser.value;
    if (cur != null && cur.id == id) {
      final updated = User(id: cur.id, email: cur.email, displayName: newDisplayName);
      await _setCurrentUser(updated);
    }
  }
}
