part of 'add_todo_bloc.dart';

@immutable
class AddTodoEvent {
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isReminder;
  final List<File> files;
  const AddTodoEvent({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.isReminder,
    required this.files,
  });
}
