import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/GlobalMethod.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Helper/constant.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Worker.dart';
import 'package:project_management/Widget/ContainerButton.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PhaseDetail extends StatefulWidget {
  final Phase phase;

  PhaseDetail(this.phase);

  @override
  _PhaseDetailState createState() => _PhaseDetailState();
}

class _PhaseDetailState extends State<PhaseDetail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Divider divider = Divider(
      thickness: 2,
      height: 30,
    );
    MaterialProvider provider=Provider.of<MaterialProvider>(context);

    final phase = widget.phase;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          'Phase details',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(CupertinoIcons.left_chevron),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.edit))],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        height: size.height,
        decoration: Constant.purpleDecoration,
        child: Column(
          children: [
            ListTile(
              title: Text(
                phase.phaseName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Due date:  ' + phase.dueDate,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              trailing: getPhaseStateIcon(phase),
              contentPadding: EdgeInsets.only(bottom: 8, top: 15),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  ListTile(
                    title: Text(
                      'Description',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      phase.description,
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    contentPadding: EdgeInsets.only(bottom: 9, top: 15),
                  ),
                  divider,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Workers',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      ContainerButton(icon: Icons.add),
                    ],
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: phase.allTasks.length,
                    itemBuilder: (context, x) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: phase.allTasks[x].isDone
                                ? Color(0xFF80BA8C)
                                : Color(0xFFD9D4FF)),
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.all(5),
                        child: ListTile(
                            title: Text(
                              phase.allTasks[x].taskName,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  decoration: phase.allTasks[x].isDone
                                      ? TextDecoration.lineThrough
                                      : null),
                            ),
                            trailing: IconButton(
                              icon: phase.allTasks[x].isDone
                                  ? Icon(
                                      Icons.check_circle_outlined,
                                      size: 40,
                                      color: Color(0xFF005F29),
                                    )
                                  : Icon(
                                      Icons.circle_outlined,
                                      size: 40,
                                      color: Color(0xFF717171),
                                    ),
                              onPressed: () {
                                setState(() {
                                  phase.changeTaskState(phase.allTasks[x]);
                                });
                              },
                            )),
                      );
                    },
                  ),
                  divider,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tasks',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      ContainerButton(icon: Icons.add),
                    ],
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: phase.allWorkers.length,
                    itemBuilder: (context, index) {
                      Worker person = phase.allWorkers[index];
                      return Container(
                        padding: EdgeInsets.all(4),
                        margin: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Color(0xFFD3E9EC),
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(
                            person.name ?? 'None',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          subtitle: Text(
                            person.job ?? 'None',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              person.email.toString().isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.email,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        launch('mailto:${person.email}');
                                      },
                                    )
                                  : Text(''),

                              person.phoneNumber.toString().isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.call_outlined,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        launch('tel:${person.phoneNumber}');
                                      },
                                    )
                                  : Text(''),
                              //WhatsappIcon
                              // IconButton(
                              //   icon: Icon(
                              //     Icons.whats
                              //   ),
                              //   onPressed: (){},
                              // ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  phase.finishPhase();
                });
              },
              child: Container(
                margin: EdgeInsets.all(15),
                width: size.width,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color(0xFF1CCC57),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Finish phase',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Icon? getPhaseStateIcon(Phase phase) {
    String state = getPhaseState(phase).toString();

    switch (state) {
      case 'begging':
        return Icon(
          Icons.schedule_outlined,
          size: 45,
        );
      case 'notBegging':
        return Icon(
          Icons.not_started_outlined,
          size: 45,
        );
      case 'notFinish':
        return Icon(
          Icons.error_outline_outlined,
          size: 45,
          color: Color(0xC8F54747),
        );
      case 'finish':
        return Icon(
          Icons.task_alt_outlined,
          size: 45,
          color: Color(0xC800D46E),
        );
    }
  }
}
