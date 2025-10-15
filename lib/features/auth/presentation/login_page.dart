import 'package:flirto_fe/features/auth/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({ super.key });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onLogin = ref.read(loginActionProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('Flirto Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text( 'Welcome to Flirto 💘',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onLogin, child: const Text('Login (Mock)'),
            )
          ],
        )
      )
    );
  }
}