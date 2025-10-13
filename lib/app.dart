
import 'package:flutter/material.dart';

class FlirtoApp extends ConsumerWidget {
  const FlirtoApp({ super.key });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Flirto',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}