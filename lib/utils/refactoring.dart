import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_bloc/bloc/list_page_bloc/list_page_bloc.dart';
import 'package:todolist_with_bloc/bloc/task_page_bloc/form/task_form_bloc.dart';
import 'package:todolist_with_bloc/constants/colors.dart';
import 'package:todolist_with_bloc/data/domain/task.dart';

Future<void> toastMessage({required BuildContext context, required String message, required Color color}) async{

  await Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(5),
    backgroundColor: color,
    borderRadius: BorderRadius.circular(8),
    mainButton: IconButton(
      onPressed: () {
        context.pop();
      },
      icon: const Icon(Icons.close,color: secondary,),
    ),
    message: message,
  ).show(context);
}

//Couper une chaine
String truncateString(String text, int length) {
  if (text.length <= length) {
    return text;
  } else {
    return '${text.substring(0, length)}...';
  }
}

void back(BuildContext context) {
  context.replace("/home");
  //rechargement
  BlocProvider.of<ListPageBloc>(context).add(const ListPageLoadWithoutProgressBarEvent());
}

void validateTaskForm(BuildContext context,Task task){
  BlocProvider.of<TaskFormBloc>(context).add(TaskFormValidateEvent(task: task));
}
