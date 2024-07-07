import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todolist_with_bloc/constants/strings.dart';
import 'package:todolist_with_bloc/data/domain/task.dart';
import 'package:todolist_with_bloc/data/domain/task_fields_form_error.dart';

part 'task_form_event.dart';
part 'task_form_state.dart';

class TaskFormBloc extends Bloc<TaskFormEvent, TaskFormState> {
  TaskFormBloc() : super(const TaskFormInitialState()) {
    on<TaskFormInitialEvent>((event, emit) => _onFormInitialEvent(event, emit));
    on<TaskFormValidateEvent>((event, emit) => _onFormValidateEvent(event, emit));
  }

  Future<void> _onFormInitialEvent(TaskFormInitialEvent event,Emitter<TaskFormState> emit)async{
    emit(const TaskFormInitialState());
  }

  Future<void> _onFormValidateEvent(TaskFormValidateEvent event,Emitter<TaskFormState> emit)async{
    Task task=event.task;

    late String stateNameMessage;
    late String stateDescMessage;

    bool formInvalid=false;

    if(task.name==""){
      formInvalid=true;
      stateNameMessage="Veiller saisir un titre.";
    }else{
      stateNameMessage="";
    }

    if(task.desc== ""){
      formInvalid=true;
      stateDescMessage="Veiller saisir la description.";
    }else{
      stateDescMessage="";
    }

    if(formInvalid){
      var errors=TaskFieldsFormError(nameFieldErrorMessage: stateNameMessage, descFieldErrorMessage: stateDescMessage);
      emit(TaskFormValidating(formFieldsErrors: errors));
    }else {
      emit(const TaskFormValidated());
    }
  }
}
