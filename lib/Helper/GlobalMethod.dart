import 'package:intl/intl.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';


int getAllFinishedPhases(Project project){
  int count=0;
  for(int x=0; x<project.allPhases.length; x++){
    if(project.allPhases[x].isDone)
      count++;
  }
  return count;
}


int getProjectProgressPercent(Project project){
  if(project.allPhases.length!=0){
  int allPhases=project.allPhases.length;
  int allFinishedPhases=getAllFinishedPhases(project);

  return ((allFinishedPhases/allPhases)*100).toInt();
}else
  return 0;
}

List<Phase> getUncompletedPhases(List<Project> projects) {
  List<Phase> allPhases = [];
  for (Project x in projects) {
    for (Phase y in x.allPhases) {
      if (!y.isDone) {
        allPhases.add(y);
      }
    }
  }
  allPhases.sort((a, b) => reminderDay(a.dueDate).compareTo(b.dueDate));
  return allPhases;
}

String reminderDay(String dueDate) {
  DateTime dateTimeCreatedAt = DateTime.parse(dueDate);
  DateTime dateTimeNow = DateTime.now();
  int result = dateTimeCreatedAt.difference(dateTimeNow).inDays + 1;
  if (result > 0) {
    return result.toString()+' Days';
  } else {
    return 'Not finished';
  }
}

String getDate(DateTime? time){
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  String date =time==null?dateFormat.format(DateTime.now()):dateFormat.format(time);
  return date;
}

String? getPhaseState(Phase phase){
  DateTime now=DateTime.now();
  DateTime begging=DateTime.parse(phase.startAt);
  DateTime duDate=DateTime.parse(phase.dueDate);


  if(!phase.isDone){

    if (now.isAfter(begging) && now.isBefore(duDate))
      return 'begging';
    else if (now.isBefore(begging))
      return 'notBegging';
    else if (now.isAfter(duDate))
      return 'notFinish';

  }else
    return 'finish';
}