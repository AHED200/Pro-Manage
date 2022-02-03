import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/GlobalMethod.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/Note.dart';
import 'package:project_management/Model/Project.dart';
import 'package:provider/provider.dart';

class NewNote extends StatefulWidget {
  final Project project;
  NewNote(this.project);
  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  int selectedColor = 0;
  List<Color> colors = [
    Colors.blueGrey,
    Colors.blue,
    Colors.red.shade400,
    Colors.yellow.shade700,
    Colors.lightGreenAccent,
  ];
  final space = SizedBox(width: 4);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          'Create note',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          child: TextField(
            controller: titleController,
            decoration: InputDecoration(
                labelText: 'Title', hintText: 'Enter title note.'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          child: TextField(
            controller: contentController,
            maxLines: 7,
            minLines: 7,
            decoration: InputDecoration(
                labelText: 'The content', hintText: 'Enter note content'),
          ),
        ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Color(0xFF3D3A3A),
              borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(
              'Colors',
              style: TextStyle(fontSize: 20),
            ),
            leading: Icon(Icons.palette_outlined),
            dense: true,
            trailing: Wrap(
              children: [
                ColorIndicator(
                  width: 25,
                  height: 25,
                  borderRadius: 22,
                  color: colors[0],
                  isSelected: selectedColor == 0,
                  onSelect: () => setState(() => selectedColor = 0),
                ),
                space,
                ColorIndicator(
                  width: 25,
                  height: 25,
                  borderRadius: 22,
                  color: colors[1],
                  isSelected: selectedColor == 1,
                  onSelect: () => setState(() => selectedColor = 1),
                ),
                space,
                ColorIndicator(
                  width: 25,
                  height: 25,
                  borderRadius: 22,
                  color: colors[2],
                  onSelect: () => setState(() => selectedColor = 2),
                  isSelected: selectedColor == 2,
                ),
                space,
                ColorIndicator(
                  width: 25,
                  height: 25,
                  borderRadius: 22,
                  color: colors[3],
                  isSelected: selectedColor == 3,
                  onSelect: () => setState(() => selectedColor = 3),
                ),
                space,
                ColorIndicator(
                  width: 25,
                  height: 25,
                  borderRadius: 22,
                  color: colors[4],
                  isSelected: selectedColor == 4,
                  onSelect: () => setState(() => selectedColor = 4),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            GestureDetector(
              onTap: (){
                MaterialProvider provider = Provider.of<MaterialProvider>(context, listen: false);
                Note newNote=Note(titleController.text, contentController.text.replaceAll(new RegExp(r'(?:[\t ]*(?:\r?\n|\r))+'), '\n'), getDate(DateTime.now()), getColorString().toString());
                widget.project.notes.add(newNote);
                // provider.newNote(newNote, widget.project.uid);
                provider.updateProject(widget.project);
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple, width: 4),
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10)
      ],
    );
  }

  String? getColorString() {
    switch (selectedColor) {
      case 0:
        return 'blueGrey';
      case 1:
        return 'blue';
      case 2:
        return 'red';
      case 3:
        return 'yellowAccent';
      case 4:
        return 'lightGreenAccent';
    }
  }
}
