part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object?> get props => [];
}

final class TaskInitialState extends TaskState {
  const TaskInitialState();
}

// En chargement récupération des tasks
final class TaskLoadingState extends TaskState {
  const TaskLoadingState();
}



// Etat de succès après une opération
class TaskSuccessState extends TaskState {
  final String message;
  const TaskSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

// Etat d'échec avec un message d'erreur
class TaskFailureState extends TaskState {
  final String error;

  const TaskFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

//Etat edition task
class TaskEditingState extends TaskState{
  final Task task;
  const TaskEditingState({required this.task});

  @override
  List<Object?> get props => [task];
}

class TaskTotalList extends TaskState{
  final int total;
  const TaskTotalList({required this.total});

  @override
  List<Object?> get props =>[total];
}