import 'package:flutter/material.dart';
import 'package:matrix_project/core/services/matrix_service.dart';
import 'package:matrix_project/core/services/navigation_service.dart';
import 'package:matrix_project/views/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MatrixService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme:
            const AppBarTheme(backgroundColor: Colors.white, elevation: 0),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.orangeAccent,
        useMaterial3: false,
      ),
      navigatorKey: navigator.key,
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
