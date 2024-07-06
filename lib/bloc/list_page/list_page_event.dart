part of 'list_page_bloc.dart';

sealed class ListPageEvent extends Equatable {
  const ListPageEvent();
  @override
  List<Object?> get props => [];
}

final class ListPageInitialEvent extends ListPageEvent{
  const ListPageInitialEvent();
}

final class ListPageLoadTasksEvent extends ListPageEvent{
  const ListPageLoadTasksEvent();
}

class ListPageDeleteTaskEvent extends ListPageEvent{
  final Task task;
  const ListPageDeleteTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

class ListPageCheckTaskEvent extends ListPageEvent{

  final Task task;
  const ListPageCheckTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

final class ListPageLoadWithoutProgressBarEvent extends ListPageEvent{
  const ListPageLoadWithoutProgressBarEvent();
}
