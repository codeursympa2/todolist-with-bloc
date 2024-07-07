import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:todolist_with_bloc/constants/colors.dart';
import 'package:todolist_with_bloc/constants/numbers.dart';
import 'package:todolist_with_bloc/utils/common_widgets.dart';


class CtaPage extends StatefulWidget {
  const CtaPage({super.key});

  @override
  State<StatefulWidget> createState() => _CtaState();
}

class _CtaState extends State<CtaPage> with TickerProviderStateMixin{

  late final GifController controller;

  @override
  void initState() {
    controller= GifController(vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Si on est en mode normal
                MediaQuery.of(context).orientation == Orientation.portrait ?
                Column(
                  children: [
                    getGif(controller, gifSizeCta, "Mobile_Note"),
                    const SizedBox(height: 36,),
                    SizedBox(
                      width: ctaButtonnWidth,
                      child: getContentCta(context: context, screenMode: "p"),)
                  ]
                )
                : //Quand on est rotation
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getGif(controller, gifSizeCta, "Mobile_Note"),
                    getContentCta(context: context, screenMode: "l")
                ],)
              ],
            ),
          )
        ),
      ),
    );
  }
}