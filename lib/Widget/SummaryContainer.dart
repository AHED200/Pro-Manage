import 'package:flutter/material.dart';
import 'package:project_management/Helper/GlobalMethod.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Screens/ProjectDetail.dart';
import 'package:project_management/Widget/TrackContainer.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SummaryContainer extends StatelessWidget {
  final Size size;
  final Project project;

  SummaryContainer({required this.project, required this.size});

  @override
  Widget build(BuildContext context) {

    int completedPhases = getAllFinishedPhases(project);

    int inProgress() {
      int count = 0;
      DateTime now = DateTime.now();
      for (int x = 0; x < project.allPhases.length; x++) {
        if (DateTime.parse(project.allPhases[x].startAt).isBefore(now) &&
            !project.allPhases[x].isDone) count++;
      }
      return count;
    }

    int notBegging() {
      return project.allPhases.length - (inProgress() + completedPhases) ;
    }

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProjectDetail(project: project)));
      },
      child: Container(
        width: size.width,
        height: 280,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(left: 7, right: 7),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF000000), blurRadius: 10, offset: Offset(2, 3))
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            gradient: LinearGradient(
              colors: [
                Color(0xA93D66E3),
                Color(0xA9001044),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text(
                    project.projectName,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                CircularStepProgressIndicator(
                  totalSteps: 100,
                  currentStep:
                      ((completedPhases / (project.allPhases.length)) * 100)
                          .toInt(),
                  roundedCap: (_, __) => true,
                  unselectedColor: Colors.transparent,
                  selectedColor: Color(0xFF00FFC2),
                  child: Center(
                      child: Text(
                    '%' +
                        ((completedPhases / (project.allPhases.length)) * 100)
                            .toInt()
                            .toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
                  selectedStepSize: 9,
                  width: 80,
                  height: 80,
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Project phases',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 115,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  TrackContainer(
                      text: 'Completed',
                      count: getAllFinishedPhases(project),
                      color: Color(0xFF00AF58),
                      icon: Icons.check_circle_outlined),
                  SizedBox(
                    width: 13,
                  ),
                  TrackContainer(
                    text: 'In progress',
                    count: inProgress(),
                    color: Color(0xFFE5B635),
                    icon: Icons.hourglass_bottom_outlined,
                  ),
                  SizedBox(
                    width: 13,
                  ),
                  TrackContainer(
                    text: 'Not begging',
                    count: notBegging(),
                    color: Color(0xFF8E8E8E),
                    icon: Icons.hourglass_disabled_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
