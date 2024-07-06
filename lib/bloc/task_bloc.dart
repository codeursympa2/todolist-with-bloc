import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todolist_with_bloc/constants/strings.dart';
import 'package:todolist_with_bloc/data/domain/task.dart';
import 'package:todolist_with_bloc/data/services/database_service.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {

  final DatabaseService dbService= DatabaseService.instance;
  late StreamSubscription streamSubscription;


  final queryDuration= const Duration(seconds: 1);

  TaskBloc() : super(const TaskInitialState()) {
    //init
    on<TaskInitialEvent>(_onInitialEvent);
    //Mise à jour et enregistrement
    on<TaskSaveEvent>(_onSaveEvent);
    //Listing
    on<TaskListEvent>( (event,emit) async{
      await _onListEvent(event, emit);
    });
    //Suppression
    on<TaskDeleteEvent>(_onDeleteEvent);
    //Recupération d'une liste en background sans la progression
    on<TaskListWithoutLoadingEvent>((event,emit)async{
      await _onListWithoutLoadingEvent(event,emit);
    });
    //Recupération d'une tâche
    on<TaskFindByIdEvent>(_onFindByIdEvent);
    //Nombre total des tâches
    on<TaskTotalListEvent>(_onListTotalEvent);
  }

  Future<void> _onInitialEvent(TaskInitialEvent event, Emitter<TaskState> emit) async {
    emit(const TaskInitialState());
  }

  Future<void> _onSaveEvent(TaskSaveEvent event, Emitter<TaskState> emit) async{
    late final String typeOperation;
    emit(const TaskLoadingState());

    try{
      final Task task=event.task;
      if(task.id != null){
        //On fait la mise à jour
        await dbService.updateTask(task.id!, task.toJsonUpdate());
        typeOperation="modifiée";
      }else{
        //On sauvegarde
        await dbService.addTask(task);
        typeOperation="ajoutée";
      }
      //On patiente 1 seconde pour pouvoir afficher la barre de progression
      await Future.delayed(
          queryDuration,
              () => emit(TaskSuccessState("Tâche $typeOperation."))
      );
    }catch(e){
      _emitFailureState(emit);
    }
  }

  Future<void> _onListEvent(TaskListEvent event, Emitter<TaskState> emit) async{
    //On écoute
    monitorSaveTodo(emit);
    emit(const TaskLoadingState());
    try{
       await _listTaskWithoutLoading(emit);
    }catch(e){
      _emitFailureState(emit);
    }
  }

  Future<void> _onDeleteEvent(TaskDeleteEvent event, Emitter<TaskState> emit) async{
    //Récuperation de la tache via l'evenement
    final Task task= event.task;
    try{
      dbService.deleteTask(task);
      emit(const TaskSuccessState("Tâche supprimée."));
    }catch(e){
      emit(const TaskFailureState(errorMessage));
    }
  }

  Future<void> _onListWithoutLoadingEvent(TaskListWithoutLoadingEvent event, Emitter<TaskState> emit) async{
    try{
     await _listTaskWithoutLoading(emit);
    }catch(e){
      _emitFailureState(emit);
    }
  }

  Future<void> _onFindByIdEvent(TaskFindByIdEvent event, Emitter<TaskState> emit) async{
    try{
      int id=event.id;

      Task? task=await dbService.getTask(id);

      if(task != null){
        emit(TaskEditingState(task: task));
      }else{
        emit(const TaskFailureState(errorGetTask));
      }
    }catch(e){
      _emitFailureState(emit);
    }
  }

  Future<void> _onListTotalEvent(TaskTotalListEvent event, Emitter<TaskState> emit)async {
    try{
      int total= await dbService.getTotalTasks();
      emit(TaskTotalList(total: total));
    }catch(e){
      _emitFailureState(emit);
    }
  }

  Future<void> _listTaskWithoutLoading(Emitter<TaskState> emit) async{
    List<Task> todos=[];
    todos=await dbService.getAllTasks();

    if(todos.isEmpty){
      await Future.delayed(queryDuration,(){
        emit(const TasksEmptyState(error: noData));
      });
    }else{
      await Future.delayed(queryDuration,(){
        emit(TaskLoadedState(todos: todos));
      });
    }
  }

  void _emitFailureState(Emitter<TaskState> emit){
    emit(const TaskFailureState(errorMessage));
  }

  //On surveille si on fait ajout suppression ou modification et recharge la liste
  void monitorSaveTodo(Emitter<TaskState> emit){
    streamSubscription= stream.listen((TaskState state) async{
      if(state is TaskSuccessState){
        _listTaskWithoutLoading(emit);
      }
    });
  }
}