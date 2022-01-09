import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Widget/PhaseField.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';
import 'package:project_management/main.dart';


class NewProject extends StatefulWidget {
  @override
  State<NewProject> createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  List<PhaseField> phaseFields = [PhaseField()];
  DateFormat format = DateFormat('yyyy-MM-dd');
  String? dueDate;
  late String description;
  bool isLoading = false;

  TextEditingController projectNameController = TextEditingController();
  TextEditingController costController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MaterialProvider provider = Provider.of<MaterialProvider>(context);
    void createProject() async {
      setState(() {
        isLoading = true;
      });

      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        //Collect all phases
        List<Phase> phases = [];
        for (PhaseField phaseF in phaseFields) {
          if (phaseF.phaseName!.isNotEmpty) {
            Phase phase = Phase(phaseF.phaseName.toString(), '',
                phaseF.startDate, phaseF.dueDate, false);
            phases.add(phase);
          } else {
            throw Exception();
          }
        }

        //Setup project
        final String projectUid = Uuid().v4();
        dueDate = dueDate == null
            ? format.format(DateTime.now()).toString()
            : dueDate.toString();
        Project project = Project(projectUid, projectNameController.text,
            dueDate.toString(), costController.text, false, phases, []);
        String userId = FirebaseAuth.instance.currentUser!.uid;

        //Create new project in Firestore
        await firestore
            .collection('projectRepository')
            .doc(user!.projectRepositoryId)
            .update({
          projectUid: project.toMap(),
        });

        // Add project UID in user projects list
        await firestore.collection('users').doc(userId).update({
          'projectsId': FieldValue.arrayUnion([projectUid])
        });
        user!.projectsId.add(projectUid);

        //Update application
        await provider.getProjects();

        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: 'You forget some fields are empty.',
          title: 'Failed!',
        );
      }
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
                      prefixIcon: Icon(Icons.attach_money_outlined)),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Due date',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    TextButton(
                      child: Text(
                        dueDate == null
                            ? format.format(DateTime.now())
                            : dueDate.toString(),
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
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
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
                                        dueDate = format.format(
                                            DateTime.parse(data.toString()));
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
                Divider(
                  endIndent: 20,
                  indent: 20,
                  height: 20,
                ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Project phases',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xff4b556d),
                              borderRadius: BorderRadius.all(Radius.circular(50))
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        phaseFields.add(PhaseField());
                                      });
                                    },
                                    icon: Icon(Icons.add)),
                                Divider(color: Colors.red,),
                                IconButton(
                                    onPressed: () {
                                      if (phaseFields.length>1)
                                        setState(() {
                                          phaseFields.removeLast();
                                        });
                                    },
                                    icon: Icon(Icons.remove_outlined)),
                              ],
                            ),
                          )
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
                          if (x >= 0 && x <= phaseFields.length - 2) Divider()
                        ])
                    ],
                  ),
                ),
              ],
            )),
        GestureDetector(
          onTap: () {
            createProject();
          },
          child: Align(
            alignment: Alignment.bottomCenter,
            child: !isLoading
                ? Container(
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
                  )
                : Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Color(0x96633BE5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: CircularProgressIndicator()),
          ),
        ),
      ]),
    );
  }
}
