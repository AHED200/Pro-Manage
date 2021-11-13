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

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  Project(this._uid ,this._projectName, this._dueDate, this._theCost, this._isDone, this._allPhases, this._notes);
  Project.formDocumentSnapshot(Map data){
    this._uid=data['projectId'];
    this._projectName=data['projectName'];
    this._isDone=data['isDone'];
    this._theCost=data['theCost'];
    this._dueDate=data['dueDate'];
    this._allPhases=getPhaseFromDocument(data['phases']);
    this._notes=getNoteFromDocument(data['notes']);
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

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map={
      'projectId':this._uid,
      'projectName': this._projectName,
      'dueDate':this._dueDate,
      'theCost':this._theCost,
      'isDone':false,
      'phases':[
        for(Phase phase in this._allPhases)
          phase.toMap()
      ],
      'notes':[
        for(Note note in this._notes)
          note.toMap()
      ]
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

  List<Note> getNoteFromDocument(List<dynamic> data){
    List<Note> notes=[];
    for(Map<String, dynamic> note in data){
      notes.add(Note.fromSnapshot(note));
    }
    return notes;
  }
}