import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flash/flash.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:project_management/Helper/GlobalMethod.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Helper/constant.dart';
import 'package:project_management/Model/Note.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Screens/MainScreen.dart';
import 'package:project_management/Screens/PhaseDetails.dart';
import 'package:project_management/Widget/AppBarContainer.dart';
import 'package:project_management/Widget/NewNote.dart';
import 'package:project_management/Widget/NewPhase.dart';
import 'package:provider/provider.dart';

import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProjectDetail extends StatefulWidget {
  final Project project;

  ProjectDetail({required this.project});

  @override
  _ProjectDetailState createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  DateFormat format = DateFormat('yyyy-MM-dd');
  String? newDueDate;
  bool edit = false;
  late TextEditingController projectNameController =
      TextEditingController(text: widget.project.projectName);
  late TextEditingController costController =
      TextEditingController(text: widget.project.theCost);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Project project = widget.project;
    MaterialProvider provider = Provider.of<MaterialProvider>(context);

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(CupertinoIcons.back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            !edit
                ? IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      setState(() {
                        edit = !edit;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      CoolAlert.show(
                        context: context,
                        type: CoolAlertType.warning,
                        text: "Are you sure for delete project.",
                        title: 'Warning!',
                        confirmBtnText: 'Delete',
                        confirmBtnColor: Colors.redAccent,
                        onConfirmBtnTap: () async {
                          await provider.deleteProject(project);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        cancelBtnText: 'Cancel',
                        showCancelBtn: true,
                        onCancelBtnTap: () => Navigator.pop(context),
                      );
                    },
                  ),
          ]),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          edit
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Project name'),
                        controller: projectNameController,
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      content: SizedBox(
                                        height: 250,
                                        width: 250,
                                        child: SfDateRangePicker(
                                          enablePastDates: false,
                                          confirmText: 'Ok',
                                          showActionButtons: true,
                                          onCancel: () {
                                            Navigator.pop(context);
                                          },
                                          onSubmit: (data) {
                                            setState(() {
                                              newDueDate = format.format(
                                                  DateTime.parse(
                                                      data.toString()));
                                            });
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                decoration: BoxDecoration(
                                  color: Color(0x25633BE5),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'Due date\n',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: newDueDate == null
                                          ? project.dueDate
                                          : newDueDate,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ]),
                                )),
                          ),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: costController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'The cost',
                              ),
                            ),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          project.projectName = projectNameController.text;
                          project.theCost = costController.text;
                          if (newDueDate != null) project.dueDate = newDueDate!;
                          provider.updateProject(project);
                          setState(() {
                            edit = false;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          margin: EdgeInsets.only(
                              left: 30, right: 30, top: 12, bottom: 3),
                          decoration: BoxDecoration(
                            color: Color(0x96633BE5),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            'Save',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            edit = false;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          margin: EdgeInsets.only(
                              left: 30, right: 30, top: 8, bottom: 12),
                          decoration: BoxDecoration(
                            color: Color(0x96828282),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : AppBarContainer(
                  height: 120,
                  width: size.width,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  text: project.projectName,
                  date: project.dueDate,
                  cost: project.theCost,
                ),
          Expanded(
            child: Container(
              height: 400,
              width: size.width,
              decoration: Constant.purpleDecoration,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All phases',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                          onPressed: () {
                            showSlidingBottomSheet(context,
                                builder: (context) => SlidingSheetDialog(
                                    isDismissable: false,
                                    snapSpec: SnapSpec(snappings: [0.7, 0.7]),
                                    // controller: controller,
                                    cornerRadius: 20,
                                    border: Border.all(color: Colors.white54),
                                    builder: (context, state) {
                                      return Material(
                                          child: NewPhase(
                                        project: project,
                                      ));
                                    }));
                          },
                          icon: Icon(
                            Icons.add,
                          ),
                          iconSize: 35,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: 10),
                        scrollDirection: Axis.horizontal,
                        itemCount: project.allPhases.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PhaseDetail(
                                          project.allPhases[index], project)));
                            },
                            child: Container(
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(8),
                                width: 180,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: getPhaseStateColor(
                                      project.allPhases[index]),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      project.allPhases[index].phaseName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: getStateIcon(
                                          project.allPhases[index]),
                                    )
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Notes',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w700),
                        ),
                        GestureDetector(
                          onTap: () {
                            showSlidingBottomSheet(context,
                                builder: (context) => SlidingSheetDialog(
                                    isDismissable: false,
                                    snapSpec: SnapSpec(snappings: [0.7, 0.7]),
                                    // controller: controller,
                                    cornerRadius: 20,
                                    border: Border.all(color: Colors.white54),
                                    builder: (context, state) {
                                      return Material(child: NewNote(project));
                                    }));
                          },
                          child: Container(
                            child: Icon(
                              Icons.edit,
                              size: 30,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF9BC1F3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: EdgeInsets.only(left: 8),
                            padding: EdgeInsets.symmetric(
                                vertical: 9, horizontal: 9),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    StaggeredGridView.countBuilder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 4,
                      itemCount: widget.project.notes.length,
                      itemBuilder: (BuildContext context, int index) =>
                          noteWidget(widget.project.notes[index]),
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget noteWidget(Note note) {
    return GestureDetector(
      onTap: () {
        showFlash(
            context: context,
            builder: (context, controller) {
              return Flash.dialog(
                  controller: controller,
                  boxShadows: kElevationToShadow[4],
                  backgroundColor: getNoteColor(note.color),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Wrap(
                      children: [
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                            text: note.noteTitle + '\r\r\r\r\r',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          TextSpan(
                            text: note.createdAt + '\n\n',
                            style:
                                TextStyle(fontSize: 17, color: Color(0xc0ffffff)),
                          ),
                          TextSpan(
                            text: note.description+ '\n\n',
                            style:
                                TextStyle(fontSize: 17),
                          ),
                        ]))
                      ],
                    ),
                  ));
            });
      },
      onLongPress: (){
        CoolAlert.show(
            context: context,
            type: CoolAlertType.confirm,
            title: 'Delete note',
            text: 'Are your sure for deleting this note.',
            confirmBtnText: 'Yes',
            showCancelBtn: false,
            onConfirmBtnTap: () async{
                await FirebaseFirestore.instance.collection('project').doc(widget.project.uid).update({
                  'notes':FieldValue.arrayRemove([note.toMap()])
                });
              setState(() {
                widget.project.notes.remove(note);
              });
              Navigator.pop(context);
            }
        );
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: getNoteColor(note.color)),
        padding: EdgeInsets.all(5),
        child: RichText(
            text: TextSpan(children: [
          TextSpan(
              text: note.noteTitle + '\n',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          TextSpan(text: note.description, style: TextStyle(fontSize: 15))
        ])),
      ),
    );
  }

  Color? getPhaseStateColor(Phase phase) {
    String state = getPhaseState(phase).toString();

    switch (state) {
      case 'begging':
        return Color(0xC8BF8B04);
      case 'notBegging':
        return Color(0xC86F6E6E);
      case 'notFinish':
        return Color(0xC8F54747);
      case 'finish':
        return Color(0xC800D46E);
    }
  }

  Widget getStateIcon(Phase phase) {
    String state = getPhaseState(phase).toString();

    switch (state) {
      case 'begging':
        return Column(
          children: [
            Icon(
              Icons.event_available_outlined,
              size: 45,
            ),
            Text(
              'End after: ' + reminderDay(phase.dueDate),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        );
      case 'notBegging':
        return Column(
          children: [
            Icon(
              Icons.flag_outlined,
              size: 45,
            ),
            Text(
              'Start after: ' + reminderDay(phase.dueDate),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        );
      case 'notFinish':
        return Column(
          children: [
            Icon(
              Icons.error_outline_outlined,
              size: 45,
            ),
            Text(
              'Not finish yet',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        );
      case 'finish':
        return Column(children: [
          Icon(
            Icons.check_circle_outline_outlined,
            size: 45,
          ),
          Text(
            'Done',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          )
        ]);
      default:
        return Text('Error!');
    }
  }

  Color? getNoteColor(String color) {
    switch (color) {
      case 'blueGrey':
        return Colors.blueGrey;
      case 'blue':
        return Colors.blue;
      case 'red':
        return Colors.red.shade400;
      case 'yellowAccent':
        return Colors.yellow.shade700;
      case 'lightGreenAccent':
        return Colors.lightGreen;
    }
  }
}
