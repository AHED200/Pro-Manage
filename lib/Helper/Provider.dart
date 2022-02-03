import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Model/Task.dart';
import 'package:project_management/main.dart';

class MaterialProvider with ChangeNotifier {
  List<Project> allProjects = [];
  final firestore = FirebaseFirestore.instance;

  Future<void> getProjects() async {
    //This list for delete REPETITION
    List<Project> projects = [];

    await firestore
        .collection('projectRepository')
        .doc(user!.projectRepositoryId)
        .get()
        .then((value) {
      for (int x = 0; x < user!.projectsId.length; x++) {
        projects.add(Project.formDocumentSnapshot(value.get(user!.projectsId[x])));
      }
    });
    allProjects=projects;
    notifyListeners();
  }

  Future<void> updateProject(Project project) async {
    await firestore
        .collection('projectRepository')
        .doc(user!.projectRepositoryId)
        .update({project.uid: project.toMap()});

    notifyListeners();
  }

  Future<void> deleteProject(Project project) async {

    await firestore
        .collection('projectRepository')
        .doc(user!.projectRepositoryId)
        .update({project.uid: FieldValue.delete()});

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'projectsId': FieldValue.arrayRemove([project.uid])
    });
    user!.projectsId.remove(project.uid);
    allProjects.removeWhere((element) => element == project);
    notifyListeners();
  }

  void insertNewPhase(String phaseName, String phaseDescription, String startDate, String dueDate, int index, List<Task> tasks, Project project) async{
    Phase newPhase = Phase.withTask(
        phaseName, phaseDescription, startDate, dueDate, false, tasks);
    project.allPhases.insert(index - 1, newPhase);
    await firestore
        .collection('projectRepository')
        .doc(user!.projectRepositoryId)
        .update({project.uid: project.toMap()});
    notifyListeners();
  }
}
