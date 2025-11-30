
import 'package:flutter/material.dart';

enum Priority { low, medium, high, urgent }
enum TaskStatus { todo, inProgress, review, completed }

class Task {
  final String id;
  final String title;
  final String description;
  final Priority priority;
  final TaskStatus status;
  final DateTime dueDate;
  final List<String> tags;
  final String assignee;
  final String assigneeAvatar;
  final int commentsCount;
  final int attachmentsCount;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.dueDate,
    required this.tags,
    required this.assignee,
    required this.assigneeAvatar,
    this.commentsCount = 0,
    this.attachmentsCount = 0,
  });

  Color getPriorityColor() {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.deepOrange;
      case Priority.urgent:
        return Colors.red;
    }
  }

  String getPriorityLabel() {
    switch (priority) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
      case Priority.urgent:
        return 'Urgent';
    }
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    Priority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    List<String>? tags,
    String? assignee,
    String? assigneeAvatar,
    int? commentsCount,
    int? attachmentsCount,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      tags: tags ?? this.tags,
      assignee: assignee ?? this.assignee,
      assigneeAvatar: assigneeAvatar ?? this.assigneeAvatar,
      commentsCount: commentsCount ?? this.commentsCount,
      attachmentsCount: attachmentsCount ?? this.attachmentsCount,
    );
  }
}