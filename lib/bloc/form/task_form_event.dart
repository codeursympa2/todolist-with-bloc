part of 'task_form_bloc.dart';

sealed class TaskFormEvent extends Equatable {
  const TaskFormEvent();
  @override
  List<Object?> get props => [];
}

final class TaskFormInitialEvent extends TaskFormEvent{
  const TaskFormInitialEvent();
}

class TaskFormValidateEvent extends TaskFormEvent{
  final Task task;
  const TaskFormValidateEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

