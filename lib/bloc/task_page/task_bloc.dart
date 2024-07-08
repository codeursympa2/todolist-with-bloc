import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todolist_with_bloc/constants/strings.dart';
import 'package:todolist_with_bloc/data/domain/task.dart';
import 'package:todolist_with_bloc/data/local/services/database_service.dart';

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
    on<TaskSaveEvent>((event,emit) async{
      await _onSaveEvent(event,emit);
    });
    //Recupération d'une tâche
    on<TaskFindByIdEvent>((event,emit)async{
      await _onFindByIdEvent(event,emit);
    });
    //Nombre total des tâches
    on<TaskTotalListEvent>((event,emit)async{
      await _onListTotalEvent(event, emit);
    });
  }

  Future<void> _onInitialEvent(TaskInitialEvent event, Emitter<TaskState> emit) async {
    emit(const TaskInitialState());
  }

  Future<void> _onSaveEvent(TaskSaveEvent event, Emitter<TaskState> emit) async{
    late final String typeOperation;
    try{
      emit(const TaskLoadingState());
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
      emit(TaskSuccessState("Tâche $typeOperation."));
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


  void _emitFailureState(Emitter<TaskState> emit){
    emit(const TaskFailureState(errorMessage));
  }

  //On surveille si on fait ajout suppression ou modification et recharge la liste
  void monitorSaveTodo(Emitter<TaskState> emit){
    streamSubscription= stream.listen((TaskState state) async{
      if(state is TaskSuccessState){
        //_listTaskWithoutLoading(emit);
      }
    });
  }
}