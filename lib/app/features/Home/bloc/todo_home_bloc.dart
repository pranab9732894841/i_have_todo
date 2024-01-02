import 'package:bloc/bloc.dart';
import 'package:i_have_todo/app/repository/todo_repo.dart';
import 'package:meta/meta.dart';

part 'todo_home_event.dart';
part 'todo_home_state.dart';

class TodoHomeBloc extends Bloc<TodoHomeEvent, TodoHomeState> {
  TodoHomeBloc() : super(TodoHomeInitial()) {
    on<TodoHomeEvent>((event, emit) async {
      emit(TodoHomeLoading());
      await TodoRepository.getTodo().then((value) {
        // sort data by created date
        value.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
        emit(TodoHomeSuccess(todos: value, filterDate: null));
      }).catchError((error) {
        emit(TodoHomeFailure());
      });
    });

    on<GetTodoEvent>((event, emit) async {
      emit(TodoHomeLoading());
      await TodoRepository.getTodo(
        filterDate: event.filterDate,
      ).then((value) {
        // sort data by created date
        value.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
        emit(TodoHomeSuccess(todos: value, filterDate: event.filterDate));
      }).catchError((error) {
        emit(TodoHomeFailure());
      });
    });

    on<TodoHomeUpdateEvent>((event, emit) async {
      await TodoRepository.updateTodo(
        id: event.id,
        isDone: event.isDone,
      ).then((value) {
        if (value) {
          emit(TodoHomeUpdateSuccess());
        } else {
          emit(TodoHomeUpdateFailure());
        }
      }).catchError((error) {
        emit(TodoHomeUpdateFailure());
      });
    });
  }
}
