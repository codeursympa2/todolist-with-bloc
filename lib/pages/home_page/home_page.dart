import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_bloc/bloc/task_bloc.dart';
import 'package:todolist_with_bloc/constants/colors.dart';
import 'package:todolist_with_bloc/constants/numbers.dart';
import 'package:todolist_with_bloc/constants/strings.dart';
import 'package:todolist_with_bloc/utils/task_common_widgets.dart';



class HomePage extends StatefulWidget {

  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    BlocProvider.of<TaskBloc>(context).add(const TaskListEvent());
    _listener=AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(roundedCardTask)),
        icon: const Icon(Icons.add_to_photos, color: secondary),
        onPressed: () {
          return context.go('/task');
        },
        label: Row(
          children: [
            Text("Nouvelle tâche", style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
      backgroundColor: secondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Center(child: Text(appNameComplete,style: Theme.of(context).textTheme.headlineLarge,)),
              //Chip options
              const SizedBox(height: 10,),
              Expanded(
                child: BlocBuilder<TaskBloc,TaskState>(
                  builder: (event,state){
                    return contentHomePage(state);
                  },
                ),
              )
            ],
          ),
        ),
      ),


    );
  }


  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  void _onStateChanged(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      BlocProvider.of<TaskBloc>(context).add(const TaskListWithoutLoadingEvent());
    }
  }

}







