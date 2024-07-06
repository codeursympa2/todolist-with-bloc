import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_bloc/bloc/list_page/list_page_bloc.dart';
import 'package:todolist_with_bloc/constants/colors.dart';
import 'package:todolist_with_bloc/constants/numbers.dart';
import 'package:todolist_with_bloc/constants/strings.dart';
import 'package:todolist_with_bloc/utils/refactoring.dart';
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
    super.initState();
    BlocProvider.of<ListPageBloc>(context).add(const ListPageLoadTasksEvent());
    _listener=AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
  }

  @override
  Widget build(BuildContext context) {

    //On écoute en cas de succés d'une requete
    return  Scaffold(
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
      body: BlocListener<ListPageBloc,ListPageState>(listener: (context,state){
          if(state is ListPageSuccessState){
            toastMessage(context: context, message: state.message, color: primary);
          }
          if(state is ListPageFailureState){
            toastMessage(context: context, message: state.message, color: danger);
          }
    },child:SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Center(child: Text(appNameComplete,style: Theme.of(context).textTheme.headlineLarge,)),
              //Chip options
              const SizedBox(height: 10,),
              Expanded(
                child: BlocBuilder<ListPageBloc,ListPageState>(
                  builder: (context,state){
                    return contentHomePage(state);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }


  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  void _onStateChanged(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      BlocProvider.of<ListPageBloc>(context).add(const ListPageLoadWithoutProgressBarEvent());
    }
  }

}







