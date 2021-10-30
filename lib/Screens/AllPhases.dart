import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Widget/AppBarContainer.dart';
import 'package:project_management/Widget/PhaseState.dart';
import 'package:provider/provider.dart';

class AllPhases extends StatefulWidget {
  @override
  _AllTasksState createState() => _AllTasksState();
}

class _AllTasksState extends State<AllPhases> {

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
          'All tasks',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          AppBarContainer(
            height: 40,
            width: size.width,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 8, right: 10),
                  child:  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                  itemCount: allProjects.length,
                  shrinkWrap: true,
                  itemBuilder: (context, x) {
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Text(
                          allProjects[x].projectName,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        PhaseState(project: allProjects[x]),
                        SizedBox(
                          height: 23,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 10, bottom: 5),
                          child: x != allProjects.length - 1
                              ? Divider(
                                  thickness: 2,
                                )
                              : null,
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}