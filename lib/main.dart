import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_bloc/bloc/form/task_form_bloc.dart';
import 'package:todolist_with_bloc/bloc/list_page/list_page_bloc.dart';
import 'package:todolist_with_bloc/bloc/task_bloc.dart';
import 'package:todolist_with_bloc/constants/colors.dart';
import 'package:todolist_with_bloc/constants/strings.dart';
import 'package:todolist_with_bloc/pages/home_page/home_page.dart';
import 'package:todolist_with_bloc/pages/task_page/task_page.dart';
import 'package:todolist_with_bloc/pages/test_page.dart';


final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          name: 'update',
          path: 'task/:id',
          builder: (context, state) {
            final idString = state.pathParameters['id'];
            return TaskPage(id: idString);
          },),
        GoRoute(
          name: "create",
          path: 'task',
          builder: (context, state) {
          return const TaskPage();
          },
        ),
        GoRoute(
          name: "home",
          path: 'home',
          builder: (context, state) {
           return const HomePage();
          },
        ),GoRoute(
          name: "test",
          path: 'test',
          builder: (context, state) {
           return const TestPage();
          },
        ),
    ]
    ),
  ],
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const gothicA1 = 'GothicA1';
    const ptSerif = 'PTSerif';

    return MultiBlocProvider(
        providers: [
          BlocProvider<TaskBloc>(create: (context) => TaskBloc()),
          BlocProvider<ListPageBloc>(create: (context) => ListPageBloc()),
          BlocProvider<TaskFormBloc>(create: (context) => TaskFormBloc()),
        ],
        child: MaterialApp.router(
      title: appNameComplete,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //Configuration des polices à partir de figma
        textTheme: const TextTheme(
          // Century Gothic Bold 20
          headlineLarge: TextStyle(
            fontFamily: gothicA1,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          // PT Serif Regular 15
          bodyLarge: TextStyle(
            fontFamily: ptSerif,
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
          // Century Gothic Bold 14
          headlineMedium: TextStyle(
            fontFamily: gothicA1,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          // PT Serif Regular 12
          bodyMedium: TextStyle(
            fontFamily: ptSerif,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          // PT Serif Bold 15
          headlineSmall: TextStyle(
            fontFamily: ptSerif,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          //Exeption
          labelLarge: TextStyle(
              fontFamily: ptSerif,
              fontWeight: FontWeight.normal,
              fontSize: 15,
              color: secondary
          ),
        ),

        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        useMaterial3: true,
      ),
      routerConfig: _router,
    )
    );
  }
}


