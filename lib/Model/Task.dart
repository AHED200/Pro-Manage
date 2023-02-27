class Task{
  late String _taskName;
  late bool _isDone;

  Task(this._taskName, this._isDone);

  bool get isDone => _isDone;

  set isDone(bool value) {
    _isDone = value;
  }

  String get taskName => _taskName;

  set taskName(String value) {
    _taskName = value;
  }

  Task.fromDocumentSnapshot(Map<String, dynamic> data){
    this._isDone=data['isDone'];
    this._taskName=data['taskName'];
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map={
      'taskName':this._taskName,
      'isDone':this.isDone,
    };

    return map;
  }
}