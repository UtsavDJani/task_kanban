
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_kanban/view/kanban_controller.dart';
import 'package:task_kanban/widgets/board_widget.dart';

class KanbanBoardScreen extends StatelessWidget {
  const KanbanBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final KanbanController controller = Get.put(KanbanController());

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Kanban Board',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          Obx(() => Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chevron_left,
                    color: controller.currentBoardIndex.value > 0
                        ? Colors.black87
                        : Colors.grey.shade400,
                  ),
                  onPressed: controller.currentBoardIndex.value > 0
                      ? controller.goToPreviousPage
                      : null,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '${controller.currentBoardIndex.value + 1} / ${controller.boards.length}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.chevron_right,
                    color: controller.currentBoardIndex.value < controller.boards.length - 1
                        ? Colors.black87
                        : Colors.grey.shade400,
                  ),
                  onPressed: controller.currentBoardIndex.value < controller.boards.length - 1
                      ? controller.goToNextPage
                      : null,
                ),
              ],
            ),
          )),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() => PageView.builder(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        itemCount: controller.boards.length,
        itemBuilder: (context, pageIndex) {
          return BoardWidget(boardIndex: pageIndex);
        },
      )),

    );
  }
}