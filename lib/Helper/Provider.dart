import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/main.dart';

class MaterialProvider with ChangeNotifier {
  List<Project> allProjects = [];

  Future<void> getProjects() async {
    if (user!.allProjectsUid.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('project')
          .where('projectId', whereIn: user!.allProjectsUid,)
          .get()
          .then((value) {
            List<Project> projects = [];
        for (int x = 0; x < value.size; x++) {
          projects.add(Project.formDocumentSnapshot(value.docs[x]));
        }
        allProjects=projects;
      });
      notifyListeners();
    }
  }

  Future<void> updateProject(Project project)async{
    await FirebaseFirestore.instance
        .collection('project').doc(project.uid).update(project.toMap(project.allPhases));

    notifyListeners();
  }

  Future<void> deleteProject(Project project)async{
    await FirebaseFirestore.instance
        .collection('project').doc(project.uid).delete();
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'allProjects':FieldValue.arrayRemove([project.uid])
    });
    allProjects.removeWhere((element) => element==project);
    notifyListeners();
  }
}
