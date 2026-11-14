import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme/clay_theme.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: ClayColors.background,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ClayTasksApp());
}

class ClayTasksApp extends StatefulWidget {
  const ClayTasksApp({super.key});

  @override
  State<ClayTasksApp> createState() => _ClayTasksAppState();
}

class _ClayTasksAppState extends State<ClayTasksApp> {
  bool _isLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clay Tasks',
      debugShowCheckedModeBanner: false,
      theme: ClayTheme.themeData,
      home: _isLoggedIn
          ? MainShell(onLogout: () => setState(() => _isLoggedIn = false))
          : LoginScreen(
              onLoginSuccess: () => setState(() => _isLoggedIn = true),
            ),
    );
  }
}
