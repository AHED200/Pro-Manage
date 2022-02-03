import 'package:flutter/material.dart';

class TaskField extends StatelessWidget{
  TextEditingController taskController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: taskController,
      decoration: InputDecoration(
        hintText: 'Label'
      ),
    );
  }

  String getTask(){
    return taskController.text;
  }
}