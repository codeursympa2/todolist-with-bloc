import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todolist_with_bloc/constants/strings.dart';
import 'package:todolist_with_bloc/data/domain/task.dart';
import 'package:todolist_with_bloc/data/local/services/database_service.dart';

part 'list_page_event.dart';
part 'list_page_state.dart';

class ListPageBloc extends Bloc<ListPageEvent, ListPageState> {
  final DatabaseService dbService=DatabaseService.instance;
  final queryDuration= const Duration(seconds: 1);


  ListPageBloc() : super(const ListPageInitialState()) {
    on<ListPageInitialEvent>((event,emit)async{
      emit(const ListPageInitialState());
    });
    on<ListPageLoadTasksEvent>((event,emit)async{
      await _onLoadTasksEvent(event,emit);
    });
    on<ListPageLoadWithoutProgressBarEvent>((event,emit)async{
      await _onLoadWithoutProgressBarEvent(event,emit);
    });
    on<ListPageDeleteTaskEvent>((event,emit)async{
      await _onDeleteEvent(event,emit);
    });
    on<ListPageCheckTaskEvent>((event,emit)async{
      await _onCheckTaskEvent(event,emit);
    });
  }

  Future<void> _onInitialEvent(ListPageInitialEvent event,Emitter<ListPageState> emit)async{
    emit(const ListPageInitialState());
  }

  Future<void> _onLoadTasksEvent(ListPageLoadTasksEvent event,Emitter<ListPageState> emit)async{
    emit(const ListPageLoadingState());
    List<Task> todos=[];
    todos=await dbService.getAllTasks();
    try{
      if(todos.isEmpty){
        await Future.delayed(queryDuration,(){
          emit(const ListPageEmptyState(message: noData));
        });
      }else{
        await Future.delayed(queryDuration,(){
          emit(ListPageLoadedState(todos: todos));
        });
      }
    }catch(e){
      _emitFailureState(emit);
    }

  }

   Future<void> _onDeleteEvent(ListPageDeleteTaskEvent event, Emitter<ListPageState> emit) async {
    //Récuperation de la tache via l'evenement
    final Task task= event.task;
    try{
      await dbService.deleteTask(task);
      emit(const ListPageSuccessState(message: "Tâche supprimée."));
      await _listWithoutLoading(emit);
    }catch(e){
      _emitFailureState(emit);
    }
  }

  Future<void> _onCheckTaskEvent(ListPageCheckTaskEvent event, Emitter<ListPageState> emit) async {
    Task task=event.task;
    try{
      //Mise à jour
      await dbService.updateTask(task.id!, task.toJsonUpdateIsCompleted());
      //Rechargement
      await _listWithoutLoading(emit);
    }catch(e){
      _emitFailureState(emit);
    }
  }
  Future<void> _onLoadWithoutProgressBarEvent(ListPageLoadWithoutProgressBarEvent event, Emitter<ListPageState> emit) async {
    try{
      await _listWithoutLoading(emit);
    }catch(e){
      _emitFailureState(emit);
    }
  }


  Future<void> _listWithoutLoading(Emitter<ListPageState> emit) async{
    List<Task> todos=[];
    todos=await dbService.getAllTasks();

    if(todos.isEmpty){
      emit(const ListPageEmptyState(message: noData));
    }else{
      emit(ListPageLoadedState(todos: todos));
    }
  }

  void _emitFailureState(Emitter<ListPageState> emit){
    emit(const ListPageFailureState(message: errorMessage));
  }
}
