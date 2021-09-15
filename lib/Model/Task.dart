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


}