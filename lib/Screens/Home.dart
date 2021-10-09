import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/GlobalMethod.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Screens/NewProject.dart';
import 'package:project_management/Widget/AppBarContainer.dart';
import 'package:project_management/Widget/SummaryContainer.dart';
import 'package:project_management/main.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    MaterialProvider provider = Provider.of<MaterialProvider>(context);
    List<Project> allProjects=provider.allProjects;
    List<Phase> phases =getUncompletedPhases(provider.allProjects);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 30,),
            padding: EdgeInsets.all(15),
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (builder)=>NewProject())),
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            AppBarContainer(height: size.height * 0.19, width: size.width),
            ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: Text(
                    'Hello, ${user!.firstName}',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                allProjects.length==0?
                    nonProjectMassage():
                SummaryContainer(project: allProjects[0], size: size),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Ends soon',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: phases.length,
                    itemBuilder: (context, x) {
                      return Container(
                        height: 100,
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Color(0xFFE1E1E1),
                          borderRadius: BorderRadius.circular(27),
                        ),
                        child: Center(
                          child: ListTile(
                            title: Text(
                              phases[x].phaseName,
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            trailing: Text(
                              reminderDay(phases[x].dueDate),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                              phases[x].description,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
  Center nonProjectMassage(){
    return Center(
      child: Text(
        'There are no projects yet',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}