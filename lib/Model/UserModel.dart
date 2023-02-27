import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  late String _uid;
  late String _firstName;
  late String _lastName;
  late String _email;
  late String _createdAt;
  late String _projectRepositoryId;
  late List<dynamic> _projectsId;
  late int _projectsCount;
  late int _finishedProjects;
  late bool _showAd;

  UserModel(this._firstName, this._lastName, this._email, this._createdAt, this._projectsCount, this._finishedProjects, this._showAd);
  UserModel.fromSnapshot(DocumentSnapshot snapshot, String uid){
    this._uid=uid;
    this._firstName=snapshot.get('firstName');
    this._lastName=snapshot.get('lastName');
    this._email=snapshot.get('email');
    this._showAd=snapshot.get('showAd');
    Timestamp timestamp=snapshot.get('createdAt');
    DateTime date = timestamp.toDate();
    this._createdAt='${date.year}-${date.month}-${date.day}';
    this._projectRepositoryId=snapshot.get('projectRepositoryId');
    this._projectsId=snapshot.get('projectsId').toList();
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

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  String get projectRepositoryId => _projectRepositoryId;

  set projectRepositoryId(String value) {
    _projectRepositoryId = value;
  }

  List<dynamic> get projectsId => _projectsId;

  set projectsId(List<dynamic> value) {
    _projectsId = value;
  }

  bool get showAd => _showAd;

  set showAd(bool value) {
    _showAd = value;
  }
}