import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Model/Note.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Model/Task.dart';
import 'package:project_management/main.dart';

class MaterialProvider with ChangeNotifier {
  List<Project> allProjects = [];
  final firestore = FirebaseFirestore.instance;

  Future<void> getProjects() async {
    if (user!.allProjectsUid.isNotEmpty) {
      await firestore
          .collection('project')
          .where(
            'projectId',
            whereIn: user!.allProjectsUid,
          )
          .get()
          .then((value) {
        List<Project> projects = [];
        for (int x = 0; x < value.size; x++) {
          print("value Size is:"+value.size.toString());
          projects.add(Project.formDocumentSnapshot(value.docs[x]));
        }
        allProjects = projects;
      });
      notifyListeners();
    }
  }

  Future<void> updateProject(Project project) async {
    await firestore
        .collection('project')
        .doc(project.uid)
        .update(project.toMap());

    notifyListeners();
  }

  Future<void> deleteProject(Project project) async {
    await firestore.collection('project').doc(project.uid).delete();
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'allProjects': FieldValue.arrayRemove([project.uid])
    });
    allProjects.removeWhere((element) => element == project);
    notifyListeners();
  }

  void insertNewPhase(
      String phaseName,
      String phaseDescription,
      String startDate,
      String dueDate,
      int index,
      List<Task> tasks,
      Project project) async {
    Phase newPhase = Phase.withTask(
        phaseName, phaseDescription, startDate, dueDate, false, tasks);
    project.allPhases.insert(index - 1, newPhase);
    await firestore
        .collection('project')
        .doc(project.uid)
        .update(project.toMap());
    notifyListeners();
  }

  void updatePhase(Project project) async {
    //Save all changes
    await firestore.collection('project').doc(project.uid).update({
      'phases': [for (Phase phase in project.allPhases) phase.toMap()]
    });
    notifyListeners();
  }

  void newNote(Note note, String projectUid) async {
    await firestore.collection('project').doc(projectUid).update({
      'notes': FieldValue.arrayUnion([note.toMap()])
    });
    notifyListeners();
  }

  void deletePhase(String projectUid, Phase phase) async {
    await firestore.collection('project').doc(projectUid).update({
      'phases': FieldValue.arrayRemove([phase.toMap()])
    });
    notifyListeners();
  }
}
