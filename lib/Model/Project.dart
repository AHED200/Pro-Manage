import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management/Model/Note.dart';
import 'package:project_management/Model/Phase.dart';

class Project{
  late String _uid;
  late String _projectName;
  late String _dueDate;
  late String _theCost;
  late bool _isDone;
  List<Phase> _allPhases=[];
  List<Note> _notes=[];

  Project(this._uid ,this._projectName, this._dueDate, this._theCost, this._isDone);
  Project.formDocumentSnapshot(DocumentSnapshot data){
    this._uid=data.get('projectId');
    this._projectName=data.get('projectName');
    this._isDone=data.get('isDone');
    this._theCost=data.get('theCost');
    this._dueDate=data.get('dueDate');
    this._allPhases=getPhaseFromDocument(data.get('phases'));
    this._notes=[];
  }

  List<Note> get notes => _notes;

  set notes(List<Note> value) {
    _notes = value;
  }

  List<Phase> get allPhases => _allPhases;

  set allPhases(List<Phase> value) {
    _allPhases = value;
  }

  bool get isDone => _isDone;

  set isDone(bool value) {
    _isDone = value;
  }

  String get theCost => _theCost;

  set theCost(String value) {
    _theCost = value;
  }

  String get dueDate => _dueDate;

  set dueDate(String value) {
    _dueDate = value;
  }

  String get projectName => _projectName;

  set projectName(String value) {
    _projectName = value;
  }

  Map<String, dynamic> toMap(List<Phase> phases){
    Map<String, dynamic> map={
      'projectId':this._uid,
      'projectName': this._projectName,
      'dueDate':this._dueDate,
      'theCost':this._theCost,
      'isDone':false,
      'phases':[
        for(Phase phase in phases)
          phase.toMap()
      ],
    };
    return map;
  }

  List<Phase> getPhaseFromDocument(List<dynamic> data){
    List<Phase> phases=[];
    for(Map<String, dynamic> ph in data){
      phases.add(Phase.fromDocumentSnapshot(ph));
    }
    return phases;
  }
}