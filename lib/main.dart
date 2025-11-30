import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_kanban/view/kanban_board_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Kanban Board',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const KanbanBoardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}