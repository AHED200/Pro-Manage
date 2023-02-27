import 'package:expandable/expandable.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../Model/Task.dart';

class PhaseField extends StatefulWidget {

  int? phaseIndex;
  PhaseField(this.phaseIndex);

  DateFormat format = DateFormat('yyyy-MM-dd');
  DateTime now = DateTime.now();
  String? phaseName;
  late String startDate = format.format(now).toString();
  late String dueDate = format.format(now.add(Duration(days: 1))).toString();
  String? phaseDescription;
  final List<Task> tasks=[];


  @override
  State<PhaseField> createState() => _PhaseFieldState(phaseIndex!);
}

class _PhaseFieldState extends State<PhaseField> {
  final toastKey = GlobalKey();
  int? phaseIndex;

  final TextEditingController phaseNameController = TextEditingController();
  final DateRangePickerController dateController = DateRangePickerController();
  final TextEditingController phaseDescription=TextEditingController();
  late ExpandableController expandController;

  _PhaseFieldState(this.phaseIndex);

  @override
  Widget build(BuildContext context) {
    expandController=ExpandableController(initialExpanded: phaseIndex==1||this.widget.tasks.length>0?false:true);
    return ExpandablePanel(
      header: Text("Phase #$phaseIndex", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
      collapsed: phaseBody(),
      expanded: Container(),
      controller: expandController,
      theme: ExpandableThemeData(
        iconColor: Colors.white,
      ),
    );
  }


  Column phaseBody(){
      return Column(
        children: [

          //Phase name & Date picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Phase field
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 40),
                    child: TextField(
                      controller: phaseNameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(label: Text('Phase name*')),
                      onChanged: (xx){
                        this.widget.phaseName = phaseNameController.text;
                      },
                    ),
                  ),
                ),
              ),

              //Date picker
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Date',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),

                  TextButton(
                    child: Text(
                      'Start: ' + widget.startDate + '\n' + 'End: ' + widget.dueDate,
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return AlertDialog(
                              backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                              content: SizedBox(
                                height: 250,
                                width: 250,
                                child: SfDateRangePicker(
                                  enablePastDates: false,
                                  controller: dateController,
                                  confirmText: 'Ok',
                                  showActionButtons: true,
                                  selectionMode:
                                  DateRangePickerSelectionMode.range,
                                  onCancel: () {
                                    Navigator.pop(context);
                                  },
                                  onSubmit: (date) {
                                    if (dateController.selectedRange!.endDate !=
                                        null &&
                                        dateController.selectedRange!.startDate !=
                                            null) {
                                      setState(() {
                                        widget.dueDate = widget.format.format(
                                            DateTime.parse(dateController
                                                .selectedRange!.endDate
                                                .toString()));
                                        widget.startDate = widget.format.format(
                                            DateTime.parse(dateController
                                                .selectedRange!.startDate
                                                .toString()));
                                      });
                                      Navigator.pop(context);
                                    } else {
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
                ],
              ),
            ],
          ),

          //Description & Tasks
          //Description
          Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                child: TextField(
                  controller: phaseDescription,
                  textInputAction: TextInputAction.newline,
                  maxLength: 150,
                  maxLines: 5,
                  minLines: 1,
                  decoration: InputDecoration(label: Text('Description')),
                  onChanged: (xx){
                    this.widget.phaseDescription = phaseDescription.text;
                  },
                ),
              ),
            ],
          ),

          //Divider line
          Padding(
            padding: const EdgeInsets.only(top: 1, bottom: 10),
            child: Divider(thickness: 2),
          ),

          //Tasks
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tasks", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
              GestureDetector(
                onTap: (){
                  //New Task
                  setState(() {
                    this.widget.tasks.add(Task('', false));
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xff4b556d),
                      borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: Icon(
                      Icons.add
                  )
                ),
              ),
            ],
          ),

          //Show all tasks
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: this.widget.tasks.length,
              itemBuilder: (b, x){
                final taskController=TextEditingController(text: this.widget.tasks[x].taskName);
                return Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: TextField(
                    controller: taskController,
                    maxLength: 50,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(label: Text('#$x')),
                    onChanged: (txt){
                      this.widget.tasks[x].taskName=txt;
                    },
                  ),
                );
              })
        ],
      );
  }

}
