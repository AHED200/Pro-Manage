import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskField extends StatelessWidget{
  late String task;
  TextEditingController taskController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    task=taskController.text;
    return TextField(
      decoration: InputDecoration(
        hintText: 'Label'
      ),
    );
  }
}