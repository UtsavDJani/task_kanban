

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_kanban/models/board_model.dart';
import 'package:task_kanban/models/drag_task.dart';
import 'package:task_kanban/models/task_model.dart';

class KanbanController extends GetxController {
  final boards = <Board>[].obs;
  final currentBoardIndex = 0.obs;
  final hoveringIndex = Rxn<int>();
  final dragPosition = Rxn<Offset>();
  final isChangingPage = false.obs;
  final currentDragData = Rxn<DraggedTask>();
  final isDragging = false.obs;

  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    _initializeBoards();
    pageController = PageController(initialPage: currentBoardIndex.value);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void _initializeBoards() {
    boards.value = [
      Board(
        title: "To Do",
        color: Colors.blue,
        icon: Icons.pending_actions,
        tasks: [
          Task(
            id: '1',
            title: 'Design new landing page',
            description: 'Create mockups and wireframes for the new product landing page',
            priority: Priority.high,
            status: TaskStatus.todo,
            dueDate: DateTime.now().add(const Duration(days: 3)),
            tags: ['Design', 'UI/UX'],
            assignee: 'Sarah Johnson',
            assigneeAvatar: 'SJ',
            commentsCount: 5,
            attachmentsCount: 3,
          ),
          Task(
            id: '2',
            title: 'Update API documentation',
            description: 'Document new endpoints and authentication flow',
            priority: Priority.medium,
            status: TaskStatus.todo,
            dueDate: DateTime.now().add(const Duration(days: 5)),
            tags: ['Documentation', 'Backend'],
            assignee: 'Mike Chen',
            assigneeAvatar: 'MC',
            commentsCount: 2,
            attachmentsCount: 1,
          ),
          Task(
            id: '3',
            title: 'Fix navigation bug',
            description: 'Users reporting issues with mobile navigation menu',
            priority: Priority.urgent,
            status: TaskStatus.todo,
            dueDate: DateTime.now().add(const Duration(days: 1)),
            tags: ['Bug', 'Mobile'],
            assignee: 'Alex Kumar',
            assigneeAvatar: 'AK',
            commentsCount: 8,
            attachmentsCount: 2,
          ),
        ],
      ),
      Board(
        title: "In Progress",
        color: Colors.orange,
        icon: Icons.work,
        tasks: [
          Task(
            id: '4',
            title: 'Implement payment gateway',
            description: 'Integrate Stripe payment system with checkout flow',
            priority: Priority.high,
            status: TaskStatus.inProgress,
            dueDate: DateTime.now().add(const Duration(days: 7)),
            tags: ['Backend', 'Payment'],
            assignee: 'Emma Wilson',
            assigneeAvatar: 'EW',
            commentsCount: 12,
            attachmentsCount: 4,
          ),
          Task(
            id: '5',
            title: 'Database optimization',
            description: 'Optimize slow queries and add proper indexing',
            priority: Priority.medium,
            status: TaskStatus.inProgress,
            dueDate: DateTime.now().add(const Duration(days: 4)),
            tags: ['Backend', 'Performance'],
            assignee: 'David Lee',
            assigneeAvatar: 'DL',
            commentsCount: 6,
            attachmentsCount: 0,
          ),
        ],
      ),
      Board(
        title: "In Review",
        color: Colors.purple,
        icon: Icons.rate_review,
        tasks: [
          Task(
            id: '6',
            title: 'User authentication system',
            description: 'New OAuth 2.0 implementation with social login',
            priority: Priority.high,
            status: TaskStatus.review,
            dueDate: DateTime.now().add(const Duration(days: 2)),
            tags: ['Backend', 'Security'],
            assignee: 'Lisa Anderson',
            assigneeAvatar: 'LA',
            commentsCount: 15,
            attachmentsCount: 5,
          ),
          Task(
            id: '7',
            title: 'Dark mode implementation',
            description: 'Add dark theme support across all screens',
            priority: Priority.low,
            status: TaskStatus.review,
            dueDate: DateTime.now().add(const Duration(days: 6)),
            tags: ['Frontend', 'UI'],
            assignee: 'Tom Brown',
            assigneeAvatar: 'TB',
            commentsCount: 4,
            attachmentsCount: 2,
          ),
        ],
      ),
      Board(
        title: "Completed",
        color: Colors.green,
        icon: Icons.check_circle,
        tasks: [
          Task(
            id: '8',
            title: 'Email notification system',
            description: 'Automated email notifications for user actions',
            priority: Priority.medium,
            status: TaskStatus.completed,
            dueDate: DateTime.now().subtract(const Duration(days: 2)),
            tags: ['Backend', 'Notifications'],
            assignee: 'Rachel Green',
            assigneeAvatar: 'RG',
            commentsCount: 9,
            attachmentsCount: 1,
          ),
        ],
      ),
    ];
  }

  void onPageChanged(int index) {
    currentBoardIndex.value = index;
    isChangingPage.value = false;
  }

  void goToPreviousPage() {
    if (currentBoardIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void goToNextPage() {
    if (currentBoardIndex.value < boards.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPointerMove(PointerMoveEvent details, double screenWidth) {
    dragPosition.value = details.position;

    if (dragPosition.value != null && !isChangingPage.value) {
      if (dragPosition.value!.dx < 80 && currentBoardIndex.value > 0) {
        isChangingPage.value = true;
        goToPreviousPage();
      } else if (dragPosition.value!.dx > screenWidth - 80 &&
          currentBoardIndex.value < boards.length - 1) {
        isChangingPage.value = true;
        goToNextPage();
      }
    }
  }

  void onPointerUp(PointerUpEvent details) {
    dragPosition.value = null;
    isChangingPage.value = false;
  }

  void onDragStarted(DraggedTask dragData) {
    currentDragData.value = dragData;
    isDragging.value = true;
  }

  void onHoverPosition(int boardIndex, int hoverIndex) {
    if (currentDragData.value == null) return;

    final dragData = currentDragData.value!;

    if (boardIndex == dragData.fromBoard) {
      if (hoverIndex != dragData.fromIndex) {
        final task = boards[dragData.fromBoard].tasks.removeAt(dragData.fromIndex);

        boards[boardIndex].tasks.insert(hoverIndex, task);

        currentDragData.value = DraggedTask(task, boardIndex, hoverIndex);

        boards.refresh();
      }
    } else {
      final task = boards[dragData.fromBoard].tasks.removeAt(dragData.fromIndex);
      boards[boardIndex].tasks.insert(hoverIndex, task);

      currentDragData.value = DraggedTask(task, boardIndex, hoverIndex);

      boards.refresh();
    }
  }

  void onTaskAcceptedToBoard(DraggedTask dragData, int boardIndex) {
    currentDragData.value = null;
    isDragging.value = false;
    hoveringIndex.value = null;
    boards.refresh();
  }

  void onTaskAcceptedToPosition(DraggedTask dragData, int boardIndex, int taskIndex) {
    currentDragData.value = null;
    isDragging.value = false;
    hoveringIndex.value = null;
    boards.refresh();
  }

  void setHoveringIndex(int? index) {
    hoveringIndex.value = index;
  }

  void clearHoveringIndex() {
    hoveringIndex.value = null;
  }

  void onDragEnd() {
    currentDragData.value = null;
    isDragging.value = false;
    hoveringIndex.value = null;
    dragPosition.value = null;
  }

  void onDragCanceled() {
    if (currentDragData.value != null) {
      boards.refresh();
    }
    currentDragData.value = null;
    isDragging.value = false;
    hoveringIndex.value = null;
  }
}