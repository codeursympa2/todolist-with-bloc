part of 'task_form_bloc.dart';

sealed class TaskFormState extends Equatable {
  const TaskFormState();

  @override
  List<Object?> get props => [];
}

final class TaskFormInitialState extends TaskFormState {
  const TaskFormInitialState();
}

class TaskFormValidating extends TaskFormState{
  final TaskFieldsFormError? formFieldsErrors;

  const TaskFormValidating({
    required this.formFieldsErrors,
  });

  @override
  List<Object?> get props => [formFieldsErrors];
}

final class TaskFormValidated extends TaskFormState{
    const TaskFormValidated();
}
