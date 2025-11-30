import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_kanban/models/drag_task.dart';
import 'package:task_kanban/view/kanban_controller.dart';
import 'package:task_kanban/widgets/task_tile_widget.dart';

class BoardWidget extends StatelessWidget {
  final int boardIndex;

  const BoardWidget({
    super.key,
    required this.boardIndex,
  });

  @override
  Widget build(BuildContext context) {
    final KanbanController controller = Get.find<KanbanController>();
    final screenWidth = MediaQuery.of(context).size.width;

    return Listener(
      onPointerMove: (details) {
        if (context.mounted) {
          controller.onPointerMove(details, screenWidth);
        }
      },
      onPointerUp: controller.onPointerUp,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade50,
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(() {
                final board = controller.boards[boardIndex];
                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: board.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        board.icon,
                        color: board.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            board.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${board.tasks.length} ${board.tasks.length == 1 ? 'task' : 'tasks'}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: board.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: board.color.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${board.tasks.length}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: board.color,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),

            Expanded(
              child: DragTarget<DraggedTask>(
                onWillAcceptWithDetails: (_) => true,
                onAcceptWithDetails: (details) {
                  controller.onTaskAcceptedToBoard(details.data, boardIndex);
                },
                onLeave: (_) => controller.clearHoveringIndex(),
                builder: (context, candidateData, rejected) {
                  return Obx(() {
                    final tasks = controller.boards[boardIndex].tasks;

                    if (tasks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 64,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No tasks yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Drag tasks here to get started',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 16, bottom: 20),
                      itemCount: tasks.length,
                      itemBuilder: (context, taskIndex) {
                        return TaskTileWidget(
                          key: ValueKey('task-${tasks[taskIndex].id}'),
                          boardIndex: boardIndex,
                          taskIndex: taskIndex,
                          task: tasks[taskIndex],
                        );
                      },
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}