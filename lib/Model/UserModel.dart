import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_management/Model/Project.dart';

class UserModel{
  late String _uid;
  late String _username;
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _createdAt;
  late List<dynamic> _allProjectsUid;
  late int _projectsCount;
  late int _finishedProjects;

  UserModel(this._username, this._firstName, this._lastName, this._email, this._createdAt, this._projectsCount, this._finishedProjects);
  UserModel.fromSnapshot(DocumentSnapshot snapshot, String uid){
    this._uid=uid;
    this._firstName=snapshot.get('firstName');
    this._lastName=snapshot.get('lastName');
    this._username=snapshot.get('username');
    this._email=snapshot.get('email');
    Timestamp timestamp=snapshot.get('createdAt');
    DateTime date = timestamp.toDate();
    this._createdAt='${date.year}-${date.month}-${date.day}';
    this._allProjectsUid=snapshot.get('allProjects').toList();
  }

  String get uid => _uid;

  set uid(String value) {
    _uid = value;
  }

  int get finishedProjects => _finishedProjects;

  set finishedProjects(int value) {
    _finishedProjects = value;
  }

  int get projectsCount => _projectsCount;

  set projectsCount(int value) {
    _projectsCount = value;
  }

  String get createdAt => _createdAt;

  set createdAt(String value) {
    _createdAt = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  List<dynamic> get allProjectsUid => _allProjectsUid;

  set allProjectsUid(List<dynamic> value) {
    _allProjectsUid = value;
  }
}