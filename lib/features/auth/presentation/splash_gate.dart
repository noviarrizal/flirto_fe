
import 'package:flutter/material.dart';

class SplashGate extends StatelessWidget {
  const SplashGate({ super.key });
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}