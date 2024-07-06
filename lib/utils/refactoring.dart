import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_bloc/constants/colors.dart';

Future<void> toastMessage({required BuildContext context, required String message, required Color color}) async{

  await Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    duration: Duration(seconds: 3),
    margin: EdgeInsets.all(5),
    backgroundColor: color,
    borderRadius: BorderRadius.circular(8),
    mainButton: IconButton(
      onPressed: () {
        context.pop();
      },
      icon: Icon(Icons.close,color: secondary,),
    ),
    message: message,
  ).show(context);
}

//Couper une chaine
String truncateString(String text, int length) {
  if (text.length <= length) {
    return text;
  } else {
    return text.substring(0, length) + '...';
  }
}

Future<void> back(BuildContext context) async {
  context.go('/home');
  //rechargement
 // await ref.read(taskProvider.notifier).getDataWithoutLoadingList();
}
