part of 'list_page_bloc.dart';

sealed class ListPageState extends Equatable {
  const ListPageState();

  @override
  List<Object> get props => [];
}

final class ListPageInitialState extends ListPageState {
    const ListPageInitialState();
}

final class ListPageLoadingState extends ListPageState {
  const ListPageLoadingState();
}

class ListPageLoadedState extends ListPageState {
  final List<Task> todos;
  const ListPageLoadedState({required this.todos});

  @override
  List<Object> get props => [todos];
}



class ListPageEmptyState extends ListPageState{
  final String message;
  const ListPageEmptyState({required this.message});
  @override
  List<Object> get props => [message];
}

class ListPageFailureState extends ListPageState{
  final String message;
  const ListPageFailureState({required this.message});
  @override
  List<Object> get props => [message];
}

class ListPageSuccessState extends ListPageState{
  final String message;
  const ListPageSuccessState({required this.message});
  @override
  List<Object> get props => [message];
}

class ListPageCheckTask extends ListPageState{
  const ListPageCheckTask();
}