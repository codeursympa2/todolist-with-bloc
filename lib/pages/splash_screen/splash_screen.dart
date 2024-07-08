import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_bloc/bloc/task_page_bloc/task_bloc.dart';
import 'package:todolist_with_bloc/constants/colors.dart';
import 'package:todolist_with_bloc/utils/common_widgets.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    // Configuration de la couleur de la barre d'état
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: secondary, //
        statusBarIconBrightness: Brightness.dark, // Couleur des icônes de la barre d'état
      ),
    );  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initTasks();
  }

  void _initTasks()  {
    BlocProvider.of<TaskBloc>(context).add(const TaskTotalListEvent());
  }
  @override
  Widget build(BuildContext context) {
    const redirectDuration= Duration(seconds: 3);
    return  Scaffold(
      body: BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        //On redirige selon la liste des taches
        if(state is TaskTotalList){
          if(state.total < 1){
            Future.delayed(redirectDuration,(){
              context.replace('/cta');
            });
          }else{
            Future.delayed(redirectDuration,(){
              context.replace('/home');
            });
          }
        }
      },
      child: Center(
            child: logo(),
          ),
      ),
      backgroundColor: secondary,
    );
  }



  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
    super.dispose();
  }

}
