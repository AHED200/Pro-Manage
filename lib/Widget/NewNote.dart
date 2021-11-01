import 'package:flutter/material.dart';


class NewNote extends StatelessWidget {

  final TextEditingController titleController=TextEditingController();
  final TextEditingController contentController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Text(
          'Create note',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600
          ),
        ),
        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'Enter title note.'
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: TextField(
            controller: contentController,
            maxLines: 7,
            decoration: InputDecoration(
                labelText: 'Content',
                hintText: 'Enter note content.'
            ),
          ),
        ),
      ],
    );
  }
}
