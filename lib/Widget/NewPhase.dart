import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/Helper/GlobalMethod.dart';
import 'package:project_management/Helper/constant.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Widget/NewTask.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class NewPhase extends StatefulWidget {
  late Project project;

  NewPhase({required this.project});

  @override
  State<NewPhase> createState() => _NewPhaseState();
}

class _NewPhaseState extends State<NewPhase> {
  late Project project = widget.project;
  final phaseName = TextEditingController();
  final phaseDescription = TextEditingController();
  String startDate = getDate(null);
  String dueDate = getDate(DateTime.now().add(Duration(days: 1)));
  DateFormat format = DateFormat('yyyy-MM-dd');
  late int index = project.allPhases.length + 1;
  TextStyle buttonStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w700);
  Divider divider = Divider(
    height: 25,
  );
  List<TaskField> taskFields = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DateRangePickerController dateController = DateRangePickerController();
    dateController.selectedRange = PickerDateRange(
        (DateTime.now()), DateTime.now().add(Duration(days: 1)));

    return ListView(
      padding: EdgeInsets.all(12),
      shrinkWrap: true,
      primary: false,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'New phase',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white12,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF644E70)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        if (index > 1) {
                          setState(() {
                            index--;
                          });
                        }
                      },
                      icon: Icon(Icons.remove)),
                  Text('#$index'),
                  IconButton(
                      onPressed: () {
                        if (index <= project.allPhases.length) {
                          setState(() {
                            index++;
                          });
                        }
                      },
                      icon: Icon(Icons.add)),
                ],
              ),
            )
          ],
        ),
        // divider,
        SizedBox(
          height: 12,
        ),
        TextField(
          controller: phaseName,
          decoration: InputDecoration(labelText: 'Phase name'),
        ),
        divider,
        ListTile(
          leading: Text(
            'Dates',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          title: TextButton(
            child: Text(
              startDate + ' - ' + dueDate,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      title: Text(
                        'Select date range',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      content: SizedBox(
                        height: 250,
                        width: 250,
                        child: SfDateRangePicker(
                          enablePastDates: false,
                          controller: dateController,
                          confirmText: 'Ok',
                          showActionButtons: true,
                          selectionMode: DateRangePickerSelectionMode.range,
                          onCancel: () {
                            Navigator.pop(context);
                          },
                          onSubmit: (date) {
                            if (dateController.selectedRange!.endDate != null &&
                                dateController.selectedRange!.startDate !=
                                    null) {
                              setState(() {
                                dueDate = format.format(DateTime.parse(
                                    dateController.selectedRange!.endDate
                                        .toString()));
                                startDate = format.format(DateTime.parse(
                                    dateController.selectedRange!.startDate
                                        .toString()));
                              });
                              Navigator.pop(context);
                            } else {
                              //This part not working
                              showFlash(
                                  context: context,
                                  duration: Duration(seconds: 4),
                                  builder: (context, controller) {
                                    return Flash.bar(
                                        controller: controller,
                                        backgroundColor: Color(0xBB393939),
                                        borderRadius: BorderRadius.circular(10),
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 40),
                                        forwardAnimationCurve:
                                            Curves.easeOutBack,
                                        child: FlashBar(
                                            content: Text(
                                                'You must choice start date and end date.')));
                                  });
                            }
                          },
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
        divider,
        TextField(
          controller: phaseDescription,
          maxLines: 3,
          minLines: 1,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
              hintText: "Enter phase description.",
              label: Text(
                'Description',
              )),
        ),
        divider,
        Container(
          decoration: BoxDecoration(
            color: Color(0x98012A44),
            borderRadius: BorderRadius.circular(15),
          ),
          width: size.width,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(bottom: 20),
          child: Wrap(
            children: [
              Row(
                children: [
                  Text(
                    'Tasks in the phase',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          taskFields.add(TaskField());
                        });
                      },
                      icon: Icon(Icons.add))
                ],
              ),
              for (int x = 0; x < taskFields.length; x++)
                Wrap(children: [
                  Text(
                    '#${x + 1} Task',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  taskFields[x],
                  if (x >= 0 && x <= taskFields.length - 2) Divider()
                ])
            ],
          ),
        ),

        !isLoading
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text('Cancel', style: buttonStyle),
                    ),
                    onTap: () => insertPhase(false),
                  ),
                  GestureDetector(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 7),
                      decoration: BoxDecoration(
                        color: Color(0xFF763F75),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        'Ok',
                        style: buttonStyle,
                      ),
                    ),
                    onTap: () => insertPhase(true),
                  )
                ],
              )
            : Center(
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Color(0x96633BE5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: CircularProgressIndicator()),
            ),
      ],
    );
  }

  void insertPhase(bool state) async {
    if (state) {
      if (phaseName.text.isNotEmpty) {

        setState(() {
          isLoading = true;
        });

        Phase newPhase=Phase(phaseName.text, phaseDescription.text, startDate, dueDate, false);
        late Project project=widget.project;
        project.allPhases.insert(index-1, newPhase);
        await FirebaseFirestore.instance.collection('project').doc(project.uid).update(project.toMap(project.allPhases));

        setState(() {
          isLoading=false;
        });
        Navigator.pop(context);

      }else
        showFlash(
            context: context,
            duration: Duration(seconds: 4),
            builder: (context, controller) {
              return Flash.bar(
                  controller: controller,
                  backgroundColor: Color(0xBB393939),
                  borderRadius: BorderRadius.circular(10),
                  margin: EdgeInsets.symmetric(
                      horizontal: 15, vertical: 40),
                  forwardAnimationCurve:
                  Curves.easeOutBack,
                  child: FlashBar(
                      content: Text(
                          'You must enter the phase name')));
            });
    } else
      Navigator.pop(context);
  }
}
