import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todolist_with_bloc/data/domain/task_fields_form_error.dart';

part 'task_form_event.dart';
part 'task_form_state.dart';

class TaskFormBloc extends Bloc<TaskFormEvent, TaskFormState> {
  TaskFormBloc() : super(const TaskFormInitialState()) {
    on<TaskFormInitialEvent>((event, emit) {

    });
  }
}
