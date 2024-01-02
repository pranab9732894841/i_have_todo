part of 'todo_home_bloc.dart';

@immutable
class TodoHomeState {}

class TodoHomeInitial extends TodoHomeState {}

class TodoHomeActionState extends TodoHomeState {}

class TodoHomeLoading extends TodoHomeState {}

class TodoHomeSuccess extends TodoHomeState {
  final DateTime? filterDate;
  final List<Map<String, dynamic>> todos;
  TodoHomeSuccess({required this.todos, required this.filterDate});
  int get totalTodo => todos.length;
  int get totalDone => todos.where((element) => element['isDone']).length;
}

class TodoHomeFailure extends TodoHomeState {}

class TodoHomeUpdateSuccess extends TodoHomeState {}

class TodoHomeUpdateFailure extends TodoHomeState {}
