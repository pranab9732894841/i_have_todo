part of 'add_todo_bloc.dart';

@immutable
class AddTodoState {}

class AddTodoInitial extends AddTodoState {}

class AddTodoAction extends AddTodoState {}

class AddTodoLoading extends AddTodoAction {}

class AddTodoSuccess extends AddTodoAction {}

class AddTodoFailure extends AddTodoAction {}
