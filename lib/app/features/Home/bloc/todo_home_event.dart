part of 'todo_home_bloc.dart';

@immutable
class TodoHomeEvent {}

class GetTodoEvent extends TodoHomeEvent {
  final DateTime? filterDate;
  GetTodoEvent({this.filterDate});
}

class TodoHomeUpdateEvent extends TodoHomeEvent {
  final String id;
  final bool isDone;

  TodoHomeUpdateEvent({
    required this.id,
    required this.isDone,
  });
}
