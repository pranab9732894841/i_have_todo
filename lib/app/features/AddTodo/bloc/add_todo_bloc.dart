import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:i_have_todo/app/repository/todo_repo.dart';
import 'package:i_have_todo/app/services/notification_service.dart';
import 'package:meta/meta.dart';

part 'add_todo_event.dart';
part 'add_todo_state.dart';

class AddTodoBloc extends Bloc<AddTodoEvent, AddTodoState> {
  AddTodoBloc() : super(AddTodoInitial()) {
    on<AddTodoEvent>((event, emit) async {
      emit(AddTodoLoading());
      final status = await TodoRepository.addTodo(
        title: event.title,
        description: event.description,
        dueDate: event.dueDate.millisecondsSinceEpoch,
        isSetReminder: event.isReminder,
        files: event.files,
      );
      if (status) {
        if (event.isReminder) {
          //schedule notification
          NotificationService().scheduleNotification(
            event.dueDate.millisecondsSinceEpoch,
            event.title,
            event.description,
            event.dueDate,
          );
        }
        emit(AddTodoSuccess());
      } else {
        emit(AddTodoFailure());
      }
    });
  }
}
