import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/GlobalMethod.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Screens/NewProject.dart';
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
      body: DraggableHome(
        title: Text('Summary', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),),
        headerWidget: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              'Hello, ${user!.firstName}',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        stretchMaxHeight: 0.50,
        headerExpandedHeight: 0.17,
        body: [
          Stack(
            children: [
              // AppBarContainer(height: size.height * 0.19, width: size.width),
              allProjects.length == 0
                  ? Padding(
                    padding: const EdgeInsets.only(left: 7, right: 7, top: 8, bottom: 10),
                    child: Column(
                      children: [
                        Text(
                          'There are no projects yet, let\'s to create new project.',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                          GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => NewProject())),
                            child: Container(
                              width: 220,
                              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
                              margin: EdgeInsets.only(top: 16, bottom: 10),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFF000000),
                                        blurRadius: 10,
                                        offset: Offset(2, 3))
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xA93E65E5),
                                      Color(0xA90D39DB),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  )),
                              child: Center(
                                child: Text(
                                  'Create new project.',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ],
                    ),
                  ) :
              Column(
                children: [
                  //All projects card summary
                  Container(
                    height: 310,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allProjects.length,
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index){
                        return SummaryContainer(project: allProjects[index], size: size);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Ends soon',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
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
                  SizedBox(height: 70,)
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
  // Container(
  // width: size.width-20,
  // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
  // margin: EdgeInsets.only(left: 7, right: 7, top: 8, bottom: 10),
  // decoration: BoxDecoration(
  // boxShadow: [
  // BoxShadow(
  // color: Color(0xFF000000), blurRadius: 10, offset: Offset(2, 3))
  // ],
  // color: Colors.white,
  // borderRadius: BorderRadius.circular(20),
  // gradient: LinearGradient(
  // colors: [
  // Color(0xA93E65E5),
  // Color(0xA90E37BD),
  // ],
  // begin: Alignment.topCenter,
  // end: Alignment.bottomCenter,
  // )),
  // child: Column(
  // children: [
  // Text(
  // 'There are no projects yet, let\'s to create new project.',
  // style: TextStyle(
  // fontSize: 20,
  // fontWeight: FontWeight.w600
  // ),
  //
  // ),
  // ],
  // ),
  // ),
}