import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_management/Helper/GlobalMethod.dart';
import 'package:project_management/Helper/constant.dart';
import 'package:project_management/Model/Note.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Screens/PhaseDetails.dart';
import 'package:project_management/Widget/AppBarContainer.dart';
import 'package:project_management/Widget/ContainerButton.dart';
import 'package:random_color/random_color.dart';

class ProjectDetail extends StatefulWidget {
  final Project project;

  ProjectDetail({required this.project});

  @override
  _ProjectDetailState createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Project project = widget.project;

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
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            AppBarContainer(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      Text(
                        'All phases',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700),
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
                                            project.allPhases[index])));
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
                          ContainerButton(icon: Icons.edit)
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (var note in project.notes) noteWidget(note)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget noteWidget(Note note) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: 170,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: getNoteColor()),
      padding: EdgeInsets.all(5),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(text: note.createdAt + '\n\n'),
        TextSpan(
            text: note.note + '\n',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
        TextSpan(text: note.description, style: TextStyle(fontSize: 15))
      ])),
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

  Color getNoteColor() {
    RandomColor randomColor = RandomColor();
    return randomColor.randomColor(
        colorSaturation: ColorSaturation.lowSaturation);
  }
}
