import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/GlobalMethod.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Helper/constant.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Model/Task.dart';
import 'package:project_management/Model/Worker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PhaseDetail extends StatefulWidget {
  final Phase phase;
  final Project project;

  PhaseDetail(this.phase, this.project);

  @override
  _PhaseDetailState createState() => _PhaseDetailState();
}

class _PhaseDetailState extends State<PhaseDetail> {
  late Phase phase = widget.phase;
  bool _thereTask = false;
  bool _thereWorkers = false;

  //Material for edit
  late MaterialProvider provider =
      Provider.of<MaterialProvider>(context, listen: false);
  final fireStore = FirebaseFirestore.instance;
  bool isEdit = false;
  bool phaseEdit = false;
  late final phaseNameController = TextEditingController(text: phase.phaseName);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.phase.allTasks.isNotEmpty) _thereTask = true;
    if (widget.phase.allWorkers.isNotEmpty) _thereTask = true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Divider divider = Divider(
      thickness: 2,
      height: 30,
    );

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
        actions: [
          IconButton(
              onPressed: () => setState(() {
                    isEdit = true;
                  }),
              icon: Icon(Icons.edit))
        ],
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
                      phase.description != '' ? phase.description : 'None',
                      softWrap: true,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    contentPadding: EdgeInsets.only(bottom: 9, top: 15),
                  ),
                  _thereTask ? divider : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tasks',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        onTap: () {
                          //New Task
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    // title: Row(
                                    //   children: [
                                    //     Text(
                                    //       'New task',
                                    //       style: TextStyle(
                                    //           fontSize: 18,
                                    //           fontWeight: FontWeight.w700),
                                    //     ),
                                    //     IconButton(
                                    //       onPressed: () {
                                    //         taskField..add(TaskFiled());
                                    //       },
                                    //       icon: Icon(
                                    //         Icons.add,
                                    //         size: 20,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // content: SingleChildScrollView(
                                    //     child: Column(children: taskFields)),
                                    content: NewTask(),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17),
                                          )),
                                      TextButton(
                                          onPressed: () async {
                                            //Insert Task
                                            for (int x = 0;
                                                x <
                                                    _NewTaskState
                                                        .taskFields.length;
                                                x++) {
                                              String task=_NewTaskState.taskFields[x].taskController.text;
                                              if(task.isNotEmpty)
                                                widget.phase.allTasks.add(Task(task, false));
                                            }
                                            provider
                                                .updatePhase(widget.project);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Ok',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17),
                                          ))
                                    ],
                                  ));
                        },
                        child: Container(
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF9BC1F3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: EdgeInsets.only(left: 8),
                          padding:
                              EdgeInsets.symmetric(vertical: 9, horizontal: 9),
                        ),
                      )
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
                                  isEdit = true;
                                  phase.changeTaskState(phase.allTasks[x]);
                                });
                              },
                            )),
                      );
                    },
                  ),
                  _thereWorkers ? divider : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Workers',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                        onTap: () {
                          //New Workers
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog());
                        },
                        child: Container(
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF9BC1F3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: EdgeInsets.only(left: 8),
                          padding:
                              EdgeInsets.symmetric(vertical: 9, horizontal: 9),
                        ),
                      )
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
            isEdit
                ? GestureDetector(
                    onTap: () {
                      provider.updatePhase(widget.project);
                      setState(() {
                        isEdit = false;
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
                  )
                : Container()
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

class TaskFiled extends StatelessWidget {
  final taskController = TextEditingController();
  final String index;

  TaskFiled(this.index);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: taskController,
      decoration: InputDecoration(label: Text('Task #$index')),
    );
  }
}

class NewTask extends StatefulWidget {
  const NewTask({Key? key}) : super(key: key);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  static List<TaskFiled> taskFields = [TaskFiled('1')];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 205,
      height: 250,
      child: ListView(
        children: [
          Row(
            children: [
              Text(
                'New task',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
              IconButton(
                  onPressed: () => setState(() {
                        taskFields
                            .add(TaskFiled((taskFields.length + 1).toString()));
                      }),
                  icon: Icon(
                    Icons.add,
                    size: 25,
                  ))
            ],
          ),
          ListView.separated(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: taskFields.length,
            itemBuilder: (context, x) {
              return taskFields[x];
            },
            separatorBuilder: (x, s) {
              return Divider(
                endIndent: 15,
                indent: 15,
              );
            },
          ),
        ],
      ),
    );
  }
}

//Finish phase

// GestureDetector(
// onTap: () {
// setState(() {
// phase.finishPhase();
// });
// },
// child: Container(
// margin: EdgeInsets.all(15),
// width: size.width,
// padding: EdgeInsets.all(8),
// decoration: BoxDecoration(
// color: Color(0xFF1CCC57),
// borderRadius: BorderRadius.circular(10)),
// child: Text(
// 'Finish phase',
// textAlign: TextAlign.center,
// style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
// ),
// ),GestureDetector(
// onTap: () {
// setState(() {
// phase.finishPhase();
// });
// },
// child: Container(
// margin: EdgeInsets.all(15),
// width: size.width,
// padding: EdgeInsets.all(8),
// decoration: BoxDecoration(
// color: Color(0xFF1CCC57),
// borderRadius: BorderRadius.circular(10)),
// child: Text(
// 'Finish phase',
// textAlign: TextAlign.center,
// style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
// ),
// ),

//Cancel changes button

// GestureDetector(
// onTap: () {
// //Cancel changes
// setState(() {
// isEdit = false;
// });
// },
// child: Container(
// width: double.infinity,
// padding:
// EdgeInsets.symmetric(vertical: 8, horizontal: 12),
// margin: EdgeInsets.only(
// left: 30, right: 30, top: 12, bottom: 3),
// decoration: BoxDecoration(
// border:
// Border.all(color: Color(0x96633BE5), width: 3),
// borderRadius: BorderRadius.circular(9),
// ),
// child: Text(
// 'Cancel',
// textAlign: TextAlign.center,
// style: TextStyle(
// fontSize: 20,
// fontWeight: FontWeight.w700,
// ),
// ),
// ),
// ),
