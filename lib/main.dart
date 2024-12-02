import 'package:flutter/material.dart';
import 'package:task_management_with_provider/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:task_management_with_provider/providers/category_provider.dart';
import 'package:task_management_with_provider/providers/task_provider.dart';
import 'package:task_management_with_provider/themes/light_theme.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TaskProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        home: const Home());
  }
}
