import 'package:project_management/Model/Task.dart';
import 'package:project_management/Model/Worker.dart';

class Phase{
  late String _phaseName;
  late String _dueDate;
  late String _startAt;
  late String _description;
  late bool _isDone;
  List<Task> _allTasks=[];
  List<Worker> _allWorkers= [];

  //Constructor
  Phase(this._phaseName, this._description, this._startAt, this._dueDate, this._isDone, this._allTasks);

  Phase.fromDocumentSnapshot(Map<String, dynamic> data){
    this._phaseName=data['phaseName'];
    this._dueDate=data['dueDate'];
    this._startAt=data['startAt'];
    this._description=data['description'];
    this._isDone=data['isDone'];
    this.allWorkers=getWorkerFromDocument(data['workers']);
    this._allTasks=getTaskFromDocument(data['tasks']);
  }

  List<Task> get allTasks => _allTasks;

  set allTasks(List<Task> value) {
    _allTasks = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  bool get isDone => _isDone;

  set isDone(bool value) {
    _isDone = value;
  }

  String get startAt => _startAt;

  set startAt(String value) {
    _startAt = value;
  }

  String get dueDate => _dueDate;

  set dueDate(String value) {
    _dueDate = value;
  }

  String get phaseName => _phaseName;

  set phaseName(String value) {
    _phaseName = value;
  }

  List<Worker> get allWorkers => _allWorkers;

  set allWorkers(List<Worker> value) {
    _allWorkers = value;
  }


  void testPhaseState() {
    bool phaseState=this.allTasks[0].isDone;
    for (var task in this.allTasks) {
      phaseState = phaseState && task.isDone;
    }
    this.isDone = phaseState;
  }

  void changeTaskState(Task task){
    task.isDone = !task.isDone;
    testPhaseState();
  }

  void finishPhase(){
    this._isDone=true;
    for(var task in allTasks)
      task.isDone=true;
  }

  List<Task> getTaskFromDocument(List<dynamic> data){
    List<Task> tasks=[];
    for(Map<String, dynamic> ph in data){
      tasks.add(Task.fromDocumentSnapshot(ph));
    }
    return tasks;
  }

  List<Worker> getWorkerFromDocument(List<dynamic> data){
    List<Worker> workers=[];
    for(Map<String, dynamic> worker in data)
      workers.add(Worker.fromSnapshot(worker));

    return workers;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map={
      'phaseName':this._phaseName,
      'description':this._description,
      'startAt':this._startAt,
      'dueDate':this._dueDate,
      'isDone':this.isDone,
      'workers':[
        for(Worker worker in this.allWorkers)
          worker.toMap()
      ],
      'tasks': [
        for(Task task in this.allTasks)
          task.toMap()
      ],
    };
    return map;
  }


  String toString(){
    return 'Phase name: $_phaseName - Description: $_description - Start at: $_startAt - Due date: $_dueDate - Is done $_isDone';
  }

}
