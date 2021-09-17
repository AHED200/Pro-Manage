import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:project_management/Helper/GlobalMethod.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Screens/ProjectDetail.dart';
import 'package:project_management/Widget/AppBarContainer.dart';
import 'package:provider/provider.dart';

class AllProjects extends StatefulWidget {
  @override
  _AllProjectsState createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjects> {
  List<Project> allProjects=[];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    MaterialProvider provider = Provider.of<MaterialProvider>(context);
    allProjects=provider.allProjects;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'All projects',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProjectDetail(project: project)));
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  project.dueDate,
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w300),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert_outlined,
                    size: 30,
                  ),
                  enableFeedback: false,
                )
              ],
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
                progressColor: Color(0xFF00FFC2),
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              decoration: BoxDecoration(
                color: Color(0xffeadaf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Finish: ' + reminderDay(project.dueDate),
                style: TextStyle(
                    color: Color(0xFF000000), fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}