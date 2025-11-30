

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_kanban/models/drag_task.dart';
import 'package:task_kanban/models/task_model.dart';
import 'package:task_kanban/view/kanban_controller.dart';

class TaskTileWidget extends StatelessWidget {
  final int boardIndex;
  final int taskIndex;
  final Task task;

  const TaskTileWidget({
    super.key,
    required this.boardIndex,
    required this.taskIndex,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final KanbanController controller = Get.find<KanbanController>();

    return Obx(() {
      final currentDrag = controller.currentDragData.value;
      final isBeingDragged = currentDrag != null &&
          currentDrag.task.id == task.id &&
          controller.isDragging.value;

      if (isBeingDragged) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.drag_indicator,
              color: Colors.grey.shade400,
              size: 40,
            ),
          ),
        );
      }

      return Draggable<DraggedTask>(
        key: ValueKey('$boardIndex-$taskIndex-${task.id}'),
        data: DraggedTask(task, boardIndex, taskIndex),
        feedback: Material(
          color: Colors.transparent,
          child: SizedBox(
            width: 340,
            child: _buildTaskCard(task, false, true),
          ),
        ),
        childWhenDragging: Container(),
        onDragStarted: () {
          controller.onDragStarted(DraggedTask(task, boardIndex, taskIndex));
        },
        onDragEnd: (_) => controller.onDragEnd(),
        onDraggableCanceled: (_, __) => controller.onDragCanceled(),
        child: DragTarget<DraggedTask>(
          onWillAcceptWithDetails:
              (DragTargetDetails<DraggedTask> details) {
            return true;
          },
          onMove: (DragTargetDetails<DraggedTask> details) {
            controller.onHoverPosition(boardIndex, taskIndex);
          },
          onLeave: (_) {},
          onAcceptWithDetails:
              (DragTargetDetails<DraggedTask> details) {
            controller.onTaskAcceptedToPosition(
              details.data,
              boardIndex,
              taskIndex,
            );
          },
          builder: (context, candidateData, rejected) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(
                bottom: 12,
                left: 12,
                right: 12,
              ),
              child: _buildTaskCard(task, false, false),
            );
          },
        ),
      );
    });
  }

  Widget _buildTaskCard(Task task, bool isHovering, bool isDragging) {
    final daysUntilDue = task.dueDate.difference(DateTime.now()).inDays;
    final isOverdue = daysUntilDue < 0;
    final isDueSoon = daysUntilDue >= 0 && daysUntilDue <= 2;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: isDragging
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: isDragging ? 12 : 4,
            offset: Offset(0, isDragging ? 6 : 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: task.getPriorityColor().withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: task.getPriorityColor().withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.flag,
                        size: 14,
                        color: task.getPriorityColor(),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.getPriorityLabel(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: task.getPriorityColor(),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.drag_indicator,
                  color: Colors.grey.shade400,
                  size: 20,
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              task.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          const SizedBox(height: 12),

          if (task.tags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: task.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          const SizedBox(height: 12),

          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.blue.shade600,
                  child: Text(
                    task.assigneeAvatar,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOverdue
                          ? Colors.red.shade50
                          : isDueSoon
                          ? Colors.orange.shade50
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: isOverdue
                              ? Colors.red.shade700
                              : isDueSoon
                              ? Colors.orange.shade700
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('MMM dd').format(task.dueDate),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isOverdue
                                ? Colors.red.shade700
                                : isDueSoon
                                ? Colors.orange.shade700
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                if (task.commentsCount > 0) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${task.commentsCount}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                ],

                if (task.attachmentsCount > 0)
                  Row(
                    children: [
                      Icon(
                        Icons.attach_file,
                        size: 14,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${task.attachmentsCount}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
