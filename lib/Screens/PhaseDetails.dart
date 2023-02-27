import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:intl/intl.dart';
import 'package:project_management/Helper/GlobalMethod.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Helper/Constant.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Model/Task.dart';
import 'package:project_management/Model/Worker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';

class PhaseDetail extends StatefulWidget {
  Phase phase;
  final Project project;

  PhaseDetail(this.phase, this.project);

  @override
  _PhaseDetailState createState() => _PhaseDetailState();
}

class _PhaseDetailState extends State<PhaseDetail> {
  bool _thereTask = false;
  bool _thereWorkers = false;
  final _key=GlobalKey<FormState>();

  //Material for edit
  late MaterialProvider provider = Provider.of<MaterialProvider>(context, listen: false);
  final fireStore = FirebaseFirestore.instance;
  bool isEdit = false;
  bool isChangeState=false;
  bool phaseEdit = false;
  late final phaseNameController = TextEditingController(text: widget.phase.phaseName);
  late final descriptionController = TextEditingController(text: widget.phase.description);
  late String startDate = widget.phase.startAt;
  late String dueDate = widget.phase.dueDate;
  DateFormat format = DateFormat('yyyy-MM-dd');
  DateRangePickerController dateController = DateRangePickerController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.phase.allTasks.isNotEmpty) _thereTask = true;
    if (widget.phase.allWorkers.isNotEmpty) _thereTask = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
        ),
        body: HawkFabMenu(
          body: Container(
            margin: EdgeInsets.only(top: 15),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            height: size.height,
            decoration: Constant.purpleDecoration,
            child: Column(
              children: [
                isEdit
                    ? Column(
                  children: [
                    TextField(
                      controller: phaseNameController,
                      maxLength: 25,
                      decoration: InputDecoration(
                          hintText: "Enter phase name.",
                          fillColor: Colors.black45,
                          label: Text(
                            'Phase',
                          )),
                    ),
                    SizedBox(height: 6,),
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
                                      initialSelectedRange: PickerDateRange(getDateTime(startDate), getDateTime(dueDate)),
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                      onSubmit: (date) {
                                        if (dateController.selectedRange!.endDate != null && dateController.selectedRange!.startDate != null) {
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
                    SizedBox(height: 10,),
                    TextField(
                      controller: descriptionController,
                      maxLines: 3,
                      minLines: 1,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintText: "Enter phase description.",
                          fillColor: Colors.black45,
                          label: Text(
                            'Description',
                          )),
                    ),
                    SizedBox(height: 10,),
                  ],
                )
                    : Column(
                        children: [
                          ListTile(
                            title: SelectableText(
                              widget.phase.phaseName,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                            subtitle: SelectableText(
                              'Due date:  ' + widget.phase.dueDate,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            trailing: getPhaseStateIcon(widget.phase),
                            contentPadding: EdgeInsets.only(bottom: 8, top: 15),
                          ),
                          ListTile(
                            title: Text(
                              'Description',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              widget.phase.description != ''
                                  ? widget.phase.description
                                  : 'None',
                              softWrap: true,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            contentPadding: EdgeInsets.only(bottom: 9, top: 15),
                          ),
                        ],
                      ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: [
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
                                                bool thereIsNewTask=false;
                                                for (int x = 0; x < _NewTaskState.taskFields.length; x++) {
                                                  String task = _NewTaskState.taskFields[x].taskController.text;
                                                  if (task.isNotEmpty){
                                                    widget.phase.allTasks.add(Task(task, false));
                                                    thereIsNewTask=true;
                                                  }
                                                }
                                                if(thereIsNewTask) 
                                                  provider.updateProject(widget.project);

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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF9BC1F3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: EdgeInsets.only(left: 8),
                              padding: EdgeInsets.symmetric(
                                  vertical: 9, horizontal: 9),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      //All tasks builder
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.phase.allTasks.length,
                        itemBuilder: (context, x) {
                          return FocusedMenuHolder(
                            onPressed: (){},
                            menuItems: [
                              //Finish task or unfinished
                              widget.phase.allTasks[x].isDone?
                                  //When task is finished
                              FocusedMenuItem(
                                      title: Text(
                                        "Undone this task",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      trailingIcon: Icon(
                                        Icons.close_outlined,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          isChangeState = true;
                                          widget.phase.changeTaskState(
                                              widget.phase.allTasks[x]);
                                        });
                                      },
                                    ):
                                  //When task is unfinished
                              FocusedMenuItem(
                                title: Text("Finish this task",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.green),),
                                trailingIcon: Icon(Icons.check_outlined, color: Colors.green,),
                                onPressed: (){
                                  setState(() {
                                    isChangeState = true;
                                    widget.phase.changeTaskState(widget.phase.allTasks[x]);
                                  });
                                },
                              ),
                              //Delete task
                              FocusedMenuItem(
                                  title: Text("Delete",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.redAccent),),
                                  trailingIcon: Icon(Icons.delete,color: Colors.redAccent,),
                                  onPressed: (){
                                    setState(() {
                                      widget.phase.allTasks.remove(widget.phase.allTasks[x]);
                                      isChangeState = true;
                                    });
                                  }
                              ),
                            ],
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: widget.phase.allTasks[x].isDone
                                      ? Color(0xFF80BA8C)
                                      : Color(0xFFD9D4FF)),
                              margin: EdgeInsets.only(bottom: 15),
                              padding: EdgeInsets.all(5),
                              child: ListTile(
                                  title: Text(
                                    widget.phase.allTasks[x].taskName,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        decoration:
                                            widget.phase.allTasks[x].isDone
                                                ? TextDecoration.lineThrough
                                                : null),
                                  ),
                                  trailing: IconButton(
                                    icon: widget.phase.allTasks[x].isDone
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
                                        isChangeState = true;
                                        widget.phase.changeTaskState(widget.phase.allTasks[x]);
                                      });
                                    },
                                  )),
                            ),
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
                              final workerNameController=TextEditingController();
                              final workerPhoneNumberController=TextEditingController();
                              final workerEmailController=TextEditingController();
                              final workerJobController=TextEditingController();

                              final sizedBox=SizedBox(height: 15,);
                              //New Workers
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    content: Container(
                                      height: 400,
                                      width: 250,
                                      child: ListView(
                                        physics: NeverScrollableScrollPhysics(),
                                        children: [
                                          Text(
                                            'Assign new worker',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500
                                            ),
                                          ),
                                          SizedBox(height: 25,),
                                          TextField(
                                            controller: workerNameController,
                                            keyboardType: TextInputType.name,
                                            maxLength: 20,
                                            decoration: InputDecoration(
                                              label: Text('Worker name*'),
                                              prefixIcon: Icon(Icons.person)
                                            ),
                                          ),
                                          sizedBox,
                                          TextField(
                                            controller: workerJobController,
                                            keyboardType: TextInputType.text,
                                            maxLength: 20,
                                            decoration: InputDecoration(
                                                label: Text('Worker job'),
                                                prefixIcon: Icon(Icons.person)
                                            ),
                                          ),
                                          sizedBox,
                                          Form(
                                            key: _key,
                                            child: TextFormField(
                                              validator: (x){
                                                if(!EmailValidator.validate(x!))
                                                  return 'Please enter a valid email';
                                              },
                                              controller: workerEmailController,
                                              keyboardType: TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                  label: Text('Email'),
                                                  prefixIcon: Icon(Icons.email)
                                              ),
                                            ),
                                          ),
                                          sizedBox,
                                          TextField(
                                            controller: workerPhoneNumberController,
                                            keyboardType: TextInputType.phone,
                                            decoration: InputDecoration(
                                                label: Text('Phone number'),
                                                prefixIcon: Icon(Icons.call)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                            //Insert new worker
                                            if(workerNameController.text.isNotEmpty){
                                              if(workerEmailController.text.isNotEmpty&&!_key.currentState!.validate())
                                                throw new Exception();
                                              Worker worker=Worker(workerNameController.text, workerPhoneNumberController.text, workerEmailController.text, workerJobController.text);
                                              setState(() {
                                                widget.phase.allWorkers.add(worker);
                                              });
                                              provider.updateProject(widget.project);
                                            }
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
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF9BC1F3),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              margin: EdgeInsets.only(left: 8),
                              padding: EdgeInsets.symmetric(
                                  vertical: 9, horizontal: 9),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15,),
                      //All worker builder
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.only(bottom: 60),
                        itemCount: widget.phase.allWorkers.length,
                        itemBuilder: (context, index) {
                          Worker person = widget.phase.allWorkers[index];
                          return FocusedMenuHolder(
                            onPressed: (){
                              showFlash(
                                  context: context,
                                  builder: (context, controller) {
                                    final bool jobEmpty=person.job!.isNotEmpty;
                                    final bool emailEmpty=person.email!.isNotEmpty;
                                    final bool phoneEmpty=person.phoneNumber!.isNotEmpty;
                                    final emptyTextSpan=TextSpan();
                                    final style=TextStyle(fontSize: 17);
                                    final boldStyle=TextStyle(fontSize: 17, fontWeight: FontWeight.bold);
                                    return Flash.dialog(
                                        controller: controller,
                                        boxShadows: kElevationToShadow[4],
                                        backgroundColor: Color(0xFF9BC1F3),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Padding(
                                          padding: const EdgeInsets.all(17.0),
                                          child: Wrap(
                                            children: [
                                              SelectableText.rich(
                                                  TextSpan(children: [
                                                    TextSpan(
                                                      text: person.name! + '\n\n',
                                                      style: TextStyle(
                                                          fontSize: 20, fontWeight: FontWeight.w700),
                                                    ),
                                                    jobEmpty?TextSpan(
                                                      text: 'Job: ',
                                                      style: style,
                                                    ):emptyTextSpan,
                                                    jobEmpty?TextSpan(
                                                        text: person.job! + '\n',
                                                        style: boldStyle
                                                    ):emptyTextSpan,
                                                    emailEmpty?TextSpan(
                                                      text: 'Email: ',
                                                      style: style,
                                                    ):emptyTextSpan,
                                                    emailEmpty?TextSpan(
                                                        text: person.email! + '\n',
                                                        style: boldStyle
                                                    ):emptyTextSpan,
                                                    phoneEmpty?TextSpan(
                                                      text: 'Phone number: ',
                                                      style:style,
                                                    ):emptyTextSpan,
                                                    phoneEmpty?TextSpan(
                                                        text: person.phoneNumber! + '\n',
                                                        style: boldStyle
                                                    ):emptyTextSpan
                                                  ]))
                                            ],
                                          ),
                                        ));
                                  });
                            },
                            menuItems: [
                              //Delete worker
                              FocusedMenuItem(
                                  title: Text("Delete this worker",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.redAccent),),
                                  trailingIcon: Icon(Icons.delete,color: Colors.redAccent,),
                                  onPressed: (){
                                    setState(() {
                                      widget.phase.allWorkers.remove(widget.phase.allWorkers[index]);
                                      isChangeState = true;
                                    });
                                  }
                              ),
                            ],
                            child: Container(
                              margin: EdgeInsets.only(bottom: 15),
                              padding: EdgeInsets.all(5),
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
                                subtitle: person.name!.isNotEmpty?Text(
                                  person.job ?? 'None',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black),
                                ):Container(),
                                trailing: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    person.email!.isNotEmpty
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
                                    person.phoneNumber!.isNotEmpty
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
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                isEdit || isChangeState
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isEdit = false;
                                isChangeState=false;
                              });
                              CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.info,
                                  title: 'Notification',
                                  text:
                                      'All changes will be removed after restarting the application.',
                                  confirmBtnText: 'Ok',
                                  showCancelBtn: false,
                                  onConfirmBtnTap: () =>
                                      Navigator.pop(context));
                            },
                            child: Container(
                              // width: 100,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 33),
                              margin: EdgeInsets.only(
                                  left: 6, right: 6, top: 12, bottom: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(
                                      color: Color(0x96633BE5), width: 3)),
                              child: Text(
                                'Cancel',
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
                              if (phaseNameController.text.isNotEmpty) {
                                widget.phase.startAt=startDate;
                                widget.phase.dueDate=dueDate;
                                widget.phase.description=descriptionController.text;
                                widget.phase.phaseName=phaseNameController.text;
                                provider.updateProject(widget.project);
                                setState(() {
                                  isEdit = false;
                                  isChangeState=false;
                                });
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
                                              content: Text('You should enter phase name.')));
                                    });
                            },
                            child: Container(
                              // width: 80,
                              padding: EdgeInsets.symmetric(
                                  vertical: 9.5, horizontal: 40),
                              margin: EdgeInsets.only(
                                  left: 6, right: 6, top: 12, bottom: 3),
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
                        ],
                      )
                    : Container()
              ],
            ),
          ),
          icon: AnimatedIcons.menu_close,
          fabColor: Color(0xff6168e7),
          iconColor: Colors.white,
          items: [
            widget.phase.isDone?
                HawkFabMenuItem(
                  label: 'Unfinished phase',
                  ontap: () {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.confirm,
                      text: 'Are you sure for unfinished this phase.',
                      confirmBtnText: 'Yes',
                      onConfirmBtnTap: () {
                        setState(() {
                          widget.phase.isDone=false;
                        });
                        widget.project.checkPhasesState();
                        provider.updateProject(widget.project);
                        Navigator.pop(context);
                      },
                      cancelBtnText: 'No, cancel',
                    );
                  },
                  color: Color(0xFFE027D1),
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                ): HawkFabMenuItem(
                  label: 'Finish phase',
                  ontap: () {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.confirm,
                      text: 'Are you sure for finishing this phase.',
                      confirmBtnText: 'Yes',
                      onConfirmBtnTap: () {
                        setState(() {
                          widget.phase.finishPhase();
                        });
                        widget.project.checkPhasesState();
                        provider.updateProject(widget.project);
                        Navigator.pop(context);
                      },
                      cancelBtnText: 'No, cancel',
                    );
                  },
                  color: Colors.green[400],
                  icon: Icon(
                    Icons.check_outlined,
                    color: Colors.white,
                  ),
                ),

            HawkFabMenuItem(
              label: 'Delete phase',
              ontap: () {
                CoolAlert.show(
                  context: context,
                  type: CoolAlertType.confirm,
                  text: 'Are you sure for deleting this phase.',
                  confirmBtnText: 'Yes',
                  onConfirmBtnTap: () {
                    widget.project.allPhases.remove(widget.phase);
                    provider.updateProject(widget.project);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  cancelBtnText: 'No, cancel',
                );
              },
              color: Colors.red[400],
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            HawkFabMenuItem(
              label: 'Edit',
              ontap: () {
                setState(() {
                  isEdit = true;
                });
              },
              color: Colors.orange[400],
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ],
        ));
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

  DateTime getDateTime(String date){
    return DateTime.parse(date);
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
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  static List<TaskFiled> taskFields = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskFields = [TaskFiled('1')];
  }

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