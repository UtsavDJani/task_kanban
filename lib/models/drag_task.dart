
import 'package:task_kanban/models/task_model.dart';

class DraggedTask {
  Task task;
  int fromBoard;
  int fromIndex;

  DraggedTask(this.task, this.fromBoard, this.fromIndex);
}