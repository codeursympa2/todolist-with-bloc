import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif/gif.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_bloc/bloc/form/task_form_bloc.dart';
import 'package:todolist_with_bloc/bloc/task_bloc.dart';
import 'package:todolist_with_bloc/constants/colors.dart';
import 'package:todolist_with_bloc/constants/numbers.dart';
import 'package:todolist_with_bloc/data/domain/task.dart';
import 'package:todolist_with_bloc/utils/refactoring.dart';

import '../../utils/common_widgets.dart';

class TaskPage extends StatefulWidget {
  final String? id;
  const TaskPage({this.id, super.key});

  @override
  State<StatefulWidget> createState() => _TaskState();
}

class _TaskState extends State<TaskPage> with TickerProviderStateMixin {
  late String? id;
  late GifController controller1;

  _TaskState();

  @override
  void initState() {
    super.initState();
    id=widget.id;
    controller1 = GifController(vsync: this);
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //On écoute les changements
    return Scaffold(
      appBar: AppBar(
        title: Text(id != null ? "Mise à jour d'une tâche" : "Ajout d'une tâche", style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => back(context),
          icon: const Icon(Icons.arrow_back),
        ),
        backgroundColor: secondary,
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) async {
          if (state is TaskLoadingState) {
             _showLoadingDialog(context);
          } else if (state is TaskSuccessState) {
            await _handleSuccessState(context, state);
          } else if (state is TaskFailureState) {
            toastMessage(context: context, message: state.error, color: danger);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              getGif(controller1, gifSizeAddTask, "ToDoList"),
              const SizedBox(height: 10),
              _FormContent(id: id)
            ],
        ),
      )),
      backgroundColor: secondary,
    );
  }

  //Affichage circular progress bar
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child:  CircularProgressIndicator(backgroundColor: primary, color: secondary),
      ),
    );
  }
  //etat de success
  Future<void> _handleSuccessState(BuildContext context, TaskSuccessState state)  async {
    toastMessage(context: context, message: state.message, color: primary);

    await Future.delayed(const Duration(seconds: 2),(){
      context.go("/home");
    });

  }
}


class _FormContent extends StatefulWidget{
  final String? id;
  const _FormContent({this.id});

  @override
 State<StatefulWidget> createState() => _FormState();
}

class _FormState extends State<_FormContent>{
  late String? id;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descFocusNode = FocusNode();

  late bool _nameFocusable;

  _FormState();

  @override
  void initState() {
    id=widget.id;
    _initForm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    const double sizeBoxValue=16;
    return
    //On écoute les changements d'etats de TaskState pour la mise à jour
    BlocListener<TaskBloc,TaskState>(listener: (context,state){
      if(state is TaskEditingState){
        //Validation du formulaire
        validateTaskForm(context, state.task);
        _fillForm(state.task);
      }
      if(state is TaskFailureState){
        toastMessage(context: context, message: state.error, color: danger);
      }
    },
    child: Padding(padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: BlocBuilder<TaskFormBloc, TaskFormState>(
          builder: (context, state) {
            return Column(
                  children: [
                    _builderNameField(state),
                    const SizedBox(height: sizeBoxValue),
                    _buildDescField(state),
                    const SizedBox(height: sizeBoxValue),
                    _buttonFormButtons(state)
                  ],);
          },
        ),
      ),
    ));
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    _loadTask();
  }

  @override
  void dispose() {
    _disposeTextEditing();
    super.dispose();
  }

  //REFACTORING
  void _logicToSave() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        FocusScope.of(context).unfocus(); //Suppression du focus sur le champs fermeture du clavier
        late Task taskSave;
        if(id == null){
          taskSave=Task.withoutId(_nameController.text, _descController.text);
        }else{
          taskSave=Task.updateTask(int.tryParse(id!)!,_nameController.text, _descController.text);
        }
        //On sauvegarde
        BlocProvider.of<TaskBloc>(context).add(TaskSaveEvent(task: taskSave));
    }
  }

  //Form

  void _initEditingTextController(){
    _nameController.text="";
    _descController.text="";
  }

  void _checkFocusableName(){
    id == null ? _nameFocusable=true: _nameFocusable=false;
  }

  void _initForm(){
    _checkFocusableName();
    _initEditingTextController();
  }

  void _loadTask() {
    if (id != null) {
      final taskId = int.tryParse(id!);
      BlocProvider.of<TaskBloc>(context).add(TaskFindByIdEvent(id: taskId!));
    }
  }

  void _disposeTextEditing(){
    _nameController.dispose();
    _descController.dispose();
  }

  Widget _builderNameField(TaskFormState state){
    return texEditingField(
        context: context,
        label: 'Titre',
        focused: _nameFocusable,
        textInputAction: TextInputAction.next,
        focusNode: _nameFocusNode,
        ctrl:_nameController,
        maxLines: 1,
        validator: (value) => _validateField(state, value, 'name'),
        onChanged:(value) => _onChangedTextEditingField(),
        onFieldSubmitted: (value){}
    );
  }

  Widget _buildDescField(TaskFormState state){
    return  texEditingField(
        context: context,
        label: 'Description',
        focused: false,
        textInputAction: TextInputAction.done,
        focusNode: _descFocusNode,
        ctrl:_descController,
        maxLines: 5,
        validator: (value)=> _validateField(state, value, 'desc'),
        onChanged:(value)=> _onChangedTextEditingField(),
        onFieldSubmitted: (value) => _logicToSave()
    );

  }

  Widget _buttonFormButtons(TaskFormState state){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        elevatedButton(
        label: "Valider",
        icon: Icons.check,
        iconColor: secondary,
        background: primary,
        colorText: secondary,
        action: state is TaskFormValidated ? (){
          if (_formKey.currentState != null && _formKey.currentState!.validate()) {
            _logicToSave();
          }
          }:
          (){
          toastMessage(context: context, message: "Formulaire invalide", color: danger);
        }),
        const SizedBox(width: 16),
        elevatedButton(
            action: () {
              back(context);
            },
            label: 'Annuler',
            colorText: primary,
            background: secondary,
            borderColor: primary,
            icon: Icons.cancel,
            iconColor: primary
        ),
      ],
    );
  }

  void _onChangedTextEditingField(){
    //Au changement on notifie et on envoie les data
    validateTaskForm(context, Task.withoutId(_nameController.text, _descController.text));
  }


  String? _validateField(TaskFormState state, String? value, String field) {
    if (state is TaskFormValidating) {
      if (field == 'name' && state.formFieldsErrors?.nameFieldErrorMessage != "") {
        return state.formFieldsErrors?.nameFieldErrorMessage;
      }
      if (field == 'desc' && state.formFieldsErrors?.descFieldErrorMessage != "") {
        return state.formFieldsErrors?.descFieldErrorMessage;
      }
    }
    return null;
  }

  //
  void _fillForm(Task task) {
    setState(() {
      _nameController.text = task.name ?? "";
      _descController.text = task.desc ?? "";
    });
  }
}