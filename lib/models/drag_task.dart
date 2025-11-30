/*
class DraggedTask {
  String task;
  int fromBoard;
  int fromIndex;

  DraggedTask(this.task, this.fromBoard, this.fromIndex);
}*/


import 'package:task_kanban/models/task_model.dart';

class DraggedTask {
  Task task;
  int fromBoard;
  int fromIndex;

  DraggedTask(this.task, this.fromBoard, this.fromIndex);
}