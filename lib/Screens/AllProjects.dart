import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:project_management/Helper/GlobalMethod.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Screens/NewProject.dart';
import 'package:project_management/Screens/ProjectDetail.dart';
import 'package:project_management/Widget/AppBarContainer.dart';
import 'package:provider/provider.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import '../main.dart';

class AllProjects extends StatefulWidget {
  @override
  _AllProjectsState createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjects> {
  List<Project> allProjects = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    MaterialProvider provider = Provider.of<MaterialProvider>(context);
    allProjects = provider.allProjects;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All projects',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outlined, size: 35),
            padding: EdgeInsets.all(20),
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (builder)=>NewProject())),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 65),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: allProjects.length,
                  shrinkWrap: true,
                  itemBuilder: (context, x) {
                    return getProjectSummary(allProjects[x]);
                  },
                ),
              ],
            ),
          ),
          AppBarContainer(
            height: 40,
            width: size.width,
          ),
        ],
      ),
    );
  }

  Widget getProjectSummary(Project project) {
    project.getProjectProgress();
    MaterialProvider provider = Provider.of<MaterialProvider>(context, listen: false);
    return FocusedMenuHolder(
      menuItems: [
        //Finish project
        project.isDone?
        FocusedMenuItem(title: Text("This project is already finished",style: TextStyle(color: Colors.green),), onPressed: (){}):
        FocusedMenuItem(
            title: Text("Finish project",style: TextStyle(color: Colors.black),),
            trailingIcon: Icon(Icons.done_outlined,color: Colors.black,),
            onPressed: (){
              CoolAlert.show(
                context: context,
                type: CoolAlertType.confirm,
                title: 'Are you sure?',
                text: 'Are you sure for finish this project.',
                confirmBtnText: 'Confirm',
                cancelBtnText: 'Cancel',
                showCancelBtn: true,
                onCancelBtnTap: (){
                  Navigator.pop(context);
                },
                onConfirmBtnTap: (){
                  setState(() {
                    project.finishProject();
                  });
                  provider.updateProject(project);
                  Navigator.pop(context);
                }
              );
            }
        ),
        //Rename project
        FocusedMenuItem(
            title: Text("Rename project",style: TextStyle(color: Colors.black),),
            trailingIcon: Icon(Icons.edit_outlined,color: Colors.black,),
            onPressed: (){
              final TextEditingController _controller=TextEditingController();
              showDialog(context: context, barrierDismissible: false, builder: (c)=>AlertDialog(
                title: Text('Rename project',style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700
                ),),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: Wrap(
                  children: [
                    Text(
                      'New project name',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Project name',
                        ),
                      ),
                    )
                  ],
                ),
                actions: [
                  TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel')),
                  TextButton(onPressed: (){
                    setState(() {
                      project.projectName=_controller.text;
                    });
                    provider.updateProject(project);
                    Navigator.pop(context);
                  }, child: Text('Save')),
                ],
              ));
            }
        ),
        //Delete project
        FocusedMenuItem(
            title: Text("Delete this project",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.redAccent),),
            trailingIcon: Icon(Icons.delete,color: Colors.redAccent,),
            onPressed: (){
              CoolAlert.show(
                context: context,
                type: CoolAlertType.warning,
                text: "Are you sure for delete project.",
                title: 'Warning!',
                confirmBtnText: 'Delete',
                confirmBtnColor: Colors.redAccent,
                onConfirmBtnTap: (){
                  setState(() {
                    provider.deleteProject(project);
                  });
                  Navigator.pop(context);
                },
                cancelBtnText: 'Cancel',
                showCancelBtn: true,
                onCancelBtnTap: () => Navigator.pop(context),
              );
            }
        ),
      ],
      onPressed: (){
        if (intersIsReady&&user!.showAd)
          Appodeal.show(Appodeal.INTERSTITIAL);
        else
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProjectDetail(project: project)));
      },
      child: Container(
        padding: EdgeInsets.all(17),
        margin: const EdgeInsets.symmetric(vertical: 9, horizontal: 13),
        height: 248,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
                colors: [Color(0x964379F9), Color(0x6C44237E)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                project.dueDate,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w300),
              ),
              heightFactor: 2,
            ),
            Text(
              project.projectName,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Progress',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
              child: FAProgressBar(
                borderRadius: BorderRadius.circular(50),
                currentValue: getProjectProgressPercent(project),
                maxValue: 100,
                size: 10,
                progressColor: getProgressColor(project.getProjectProgress()),
                backgroundColor: Color(0xFFD0D5D4),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '%' + getProjectProgressPercent(project).toString(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            project.isDone?
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              decoration: BoxDecoration(
                color: Color(0xffeadaf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Finished',
                style: TextStyle(
                    color: Color(0xFF000000), fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ):Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              decoration: BoxDecoration(
                color: Color(0xffeadaf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Finish: ' + reminderDay(project.dueDate),
                style: TextStyle(color: Color(0xFF000000), fontWeight: FontWeight.w600, fontSize: 15),
              ),
            )
          ],
        ),
      ),
    );
  }
  
  Color getProgressColor(double number){
    if(number>75)
      return Color(0xFF0CD965);
    else if(number>50)
      return Color(0xFF35DBD5);
    else
      return Color(0xFFC759E0);
  }
}