import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_bloc/bloc/list_page/list_page_bloc.dart';
import 'package:todolist_with_bloc/bloc/task_bloc.dart';
import 'package:todolist_with_bloc/constants/colors.dart';
import 'package:todolist_with_bloc/constants/numbers.dart';
import 'package:todolist_with_bloc/data/domain/task.dart';
import 'package:todolist_with_bloc/utils/refactoring.dart';

Widget contentHomePage(ListPageState state){
  if (state is ListPageInitialState) {
    return Container();
  } else if (state is ListPageLoadingState) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  } else if (state is ListPageEmptyState) {
    return Center(child: Text(state.message));
  } else if (state is ListPageLoadedState) {
    return ListView.builder(
      itemCount: state.todos.length,
      itemBuilder: (context, index) {
        // Utilisez l'état chargé pour afficher les tâches
        var task=state.todos[index];
        return Dismissible(
            key: Key(task.id.toString()),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) async {
              //suppression
              BlocProvider.of<ListPageBloc>(context).add(ListPageDeleteTaskEvent(task: task));
            },
            background: Container(
              color: danger,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            child: _taskItem(context, task,(){
              //Mise à jour état de la tâche
              task.isCompleted= task.isCompleted == 1 ? 0 :1 ;
              //ref.read(taskProvider.notifier).updateTaskIsCompleted(task);
              BlocProvider.of<ListPageBloc>(context).add(ListPageCheckTaskEvent(task: task));
            }));
      },
    );

  } else{
    return const Center(
      child: Text("Rechargement..."),
    );
  }
}

Widget _taskItem(BuildContext context,Task task,VoidCallback actionIconButton){
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(roundedCardTask),
    ),
    color: secondary,
    elevation: 5,
    child: ListTile(
      onTap: (){
        context.goNamed('update', pathParameters: {'id': task.id.toString()});
      },
      contentPadding: const EdgeInsets.symmetric(vertical: 9,horizontal: 9),
      subtitle: Text(truncateString(task.desc, 60),
        overflow: TextOverflow.visible,
        maxLines: 2
        ,style: Theme.of(context).textTheme.bodyMedium,),
      leading: _leftVerticalBarTask(task),
      title:Text(truncateString(task.name, 25),style: Theme.of(context).textTheme.headlineMedium,),
      trailing: _iconTaskCardTransition(task,actionIconButton ),
    ),
  );
}

Widget _iconTaskCardTransition(Task task,VoidCallback action){
  if(task.isCompleted == 1){
    return _iconButton(action, primary);
  }else{
    return _iconButton(action, shadow);
  }
}

Widget _iconButton(VoidCallback action,Color color){
  return IconButton(
    onPressed: action,
    icon: Icon(Icons.check_circle,color: color,size: iconTaskItem,),
  );
}

Widget _leftVerticalBarTask(Task task){
  return Container(
    width: 5,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(roundedCardTask)
        ),
        color: task.isCompleted == 1 ? primary : shadow
    ),
  );
}