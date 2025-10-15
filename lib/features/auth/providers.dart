import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState { final bool isLoggedIn; AuthState(this.isLoggedIn); }

final _authController = StateProvider<AuthState>((ref) => AuthState(false));
final authStateProvider = Provider<AuthState>((ref) => ref.watch(_authController));
final authChangesProvider = StreamProvider<AuthState>((ref) async* {
  // Simple stream bridge dari state; produksi: hubungkan ke supabase.auth.onAuthStateChange()
  final controller = StreamController<AuthState>();
  ref.onDispose(controller.close);
  controller.add(ref.read(_authController));
  yield* controller.stream;
});

final loginActionProvider = Provider((ref) => () => ref.read(_authController.notifier).state = AuthState(true));
final logoutActionProvider = Provider((ref) => () => ref.read(_authController.notifier).state = AuthState(true));