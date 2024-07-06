part of 'task_bloc.dart';

sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

final class TaskInitialEvent extends TaskEvent{
  const TaskInitialEvent();
}

class TaskSaveEvent extends TaskEvent{
  final Task task;

  const TaskSaveEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class TaskFindByIdEvent extends TaskEvent{
  final int id;

  const TaskFindByIdEvent({required this.id});

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

final class TaskTotalListEvent extends TaskEvent{
    const TaskTotalListEvent();
}

