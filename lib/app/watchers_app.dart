import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/theme/theme_controller.dart';
import '../shared/navigation/app_router.dart';

class WatchersApp extends StatelessWidget {
  const WatchersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'WATCHERS',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeController.instance.isDark
              ? ThemeMode.dark
              : ThemeMode.light,
          routerConfig: AppRouter.instance,
        );
      },
    );
  }
}
