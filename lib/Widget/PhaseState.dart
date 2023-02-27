import 'package:flutter/material.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Screens/PhaseDetails.dart';

import '../Screens/MainScreen.dart';
import '../main.dart';

class PhaseState extends StatefulWidget {
  final Project project;

  PhaseState({required this.project});

  @override
  _PhaseStateState createState() => _PhaseStateState();
}

class _PhaseStateState extends State<PhaseState> {
  @override
  Widget build(BuildContext context) {
    return widget.project.allPhases.length==0?
    Text(
      'This project does not have any phases',
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500
      ),
    ):
    ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.project.allPhases.length,
      itemBuilder: (c, index) {
        int x=index+1;
        return GestureDetector(
          onTap: () {
            if (MainScreenState.intersIsReady&&user!.showAd)
              MainScreenState.showInterstitialAd();
            else
              Navigator.push(context, MaterialPageRoute(builder: (builder)=>PhaseDetail(widget.project.allPhases[index], widget.project)));
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // color: Color(0x27839DF3),
              border: Border.all(color: Color(0xA6839DF3), width: 3),
              borderRadius: BorderRadius.circular(15)
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 27,
                      height: 27,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: widget.project.allPhases[index].isDone
                            ? Color(0xFF59E57E)
                            : Color(0xFFE96A6A),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '#$x\r'+widget.project.allPhases[index].phaseName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                widget.project.allPhases[index].allTasks.isEmpty
                    ? Center(
                        child: Text(
                          'There are no tasks',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      )
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            widget.project.allPhases[index].allTasks.length,
                        itemBuilder: (c, x) {
                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              bottom: 6,
                              right: 8,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xFF424950)),
                              child: ListTile(
                                title: Text(
                                  widget.project.allPhases[index].allTasks[x]
                                      .taskName,
                                  style: TextStyle(
                                      decoration: widget
                                              .project
                                              .allPhases[index]
                                              .allTasks[x]
                                              .isDone
                                          ? TextDecoration.lineThrough
                                          : null),
                                ),
                                trailing: Container(
                                  width: 65,
                                  child: Row(
                                    children: [
                                      VerticalDivider(
                                        indent: 10,
                                        thickness: 2,
                                        endIndent: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 9),
                                        child: Icon(stateIcon(widget.project.allPhases[index].allTasks[x].isDone),
                                          color: widget.project.allPhases[index].allTasks[x].isDone
                                              ? Color(0xFF00FF3C)
                                              : Color(0xFFE96A6A),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
              ],
            ),
          ),
        );
      },
    );
  }

  IconData stateIcon(bool done) {
    return done ? Icons.done : Icons.check_box_outline_blank_outlined;
  }
}