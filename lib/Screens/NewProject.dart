import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Widget/PhaseField.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';

class NewProject extends StatefulWidget {
  @override
  State<NewProject> createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  List<PhaseField> phaseFields = [PhaseField()];
  DateFormat format = DateFormat('yyyy-MM-dd');
  String? dueDate;
  late String description;

  TextEditingController projectNameController=TextEditingController();
  TextEditingController costController=TextEditingController();

  bool isLoading=false;

  @override
  Widget build(BuildContext context) {

    void createProject()async{
      setState((){
        isLoading=true;
      });

      FirebaseFirestore firestore=FirebaseFirestore.instance;
      List<Phase> phases=[];
      for(PhaseField phaseF in phaseFields){
        Phase phase=Phase(phaseF.phaseName.toString(), '', phaseF.startDate, phaseF.dueDate, false);
        phases.add(phase);
      }

      final String projectUid = Uuid().v4();
      Project project=Project(projectNameController.text, dueDate.toString(), costController.text, false);
      String userId=FirebaseAuth.instance.currentUser!.uid;

      //Add project UID in user projects list
      await firestore.collection('users').doc(userId).update({
        'allProjects': FieldValue.arrayUnion([projectUid])
      });

      //Create new project in Firestore
      await firestore.collection('project').doc(projectUid).set(project.toMap(phases));

      Timer(Duration(seconds: 3), () {
        setState(() {
          isLoading=false;
        });
        // Navigator.of(context).pop();
      });
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New project',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                'Project name',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              TextField(
                textInputAction: TextInputAction.next,
                controller: projectNameController,
                keyboardType: TextInputType.name,
              ),
              SizedBox(height: 10),
              Text(
                'The cost',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              TextField(
                textInputAction: TextInputAction.go,
                controller: costController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.attach_money_outlined)
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Due date',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  TextButton(
                    child: Text(
                      dueDate==null?
                      format.format(DateTime.now()):
                      dueDate.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                                  onSubmit: (data){
                                    setState(() {
                                      dueDate = format.format(DateTime.parse(data.toString()));
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          });
                    },
                  )
                ],
              ),
              Divider(endIndent: 20, indent: 20, height: 20,),
              Container(
                decoration: BoxDecoration(
                  color: Color(0x98012A44),
                  borderRadius: BorderRadius.circular(15),
                ),
                width: size.width,
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(bottom: 70),
                child: Wrap(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Project phases',
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                phaseFields.add(PhaseField());
                              });
                            },
                            icon: Icon(Icons.add))
                      ],
                    ),
                    for (int x = 0; x < phaseFields.length; x++)
                      Wrap(children: [
                        Text(
                          '#${x + 1}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        phaseFields[x],
                        if(x>=0&&x<=phaseFields.length-2)
                          Divider()
                      ])
                  ],
                ),
              ),
            ],
          ),
        )),
        GestureDetector(
          onTap: () {
            createProject();
          },
          child: Align(
            alignment: Alignment.bottomCenter,
            child: !isLoading?Container(
              width: size.width - 11,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0x96633BE5),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                'Create project',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ):
            Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: Color(0x96633BE5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child:CircularProgressIndicator()
            ),
          ),
        ),
      ]),
    );
  }
}
