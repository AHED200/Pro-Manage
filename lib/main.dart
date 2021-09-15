import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Model/Note.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Model/Task.dart';
import 'package:project_management/Model/UserModel.dart';
import 'package:project_management/Model/Worker.dart';
import 'package:project_management/Screens/AuthScreens/SignUp.dart';
import 'package:project_management/Screens/MainScreen.dart';
import 'package:project_management/Screens/NewProject.dart';
import 'package:shimmer/shimmer.dart';

//Temp data
UserModel? user;

// Project project = Project(
//   'Application',
//   '2021-12-20',
//   '90000',
//   false,
// );
// Project project2 = Project('Tempo', '2022-03-10', '90000', false);
// Phase phase5 =
//     Phase('Analyze', 'Analyze all phases', '2022-01-15', '2022-01-30', true);
// Phase phase55 =
//     Phase('Analyze', 'Analyze all phases', '2022-01-15', '2022-01-30', false);
// Task task6 = Task('Implement code', false);
// Task task66 = Task('Test code', false);
//
// Phase createUI =
//     Phase('Design UI', 'Use creative idea', '2021-07-12', "2021-07-30", true);
// Task task1 = Task('Create intro screen', true);
// Task task11 = Task('Create intro screen', true);
//
// Phase createDi = Phase('Create class diagram', 'without firebase classes',
//     '2021-08-01', "2021-08-15", false);
// Task task2 = Task('Identify classes', false);
//
// Phase imple = Phase('Implement code', 'without firebase classes', '2021-08-01',
//     "2023-08-15", false);
//
// Phase implement = Phase('Implement All codes', 'With firebase classes',
//     '2021-09-31', "2021-10-15", false);
// Task task3 = Task('Implement code', true);
// Task task33 = Task('Test code', false);
// Task task333 = Task('Deliver code', false);
//
// Note test = Note('Test', 'This note for test', '2021-09-02');
// Note test1 = Note('Test', 'This note for test', '2021-09-02');
// Note test11 = Note(
//     'Test',
//     'This note for test dddddddddddddddddddddddddddddddddddddddddddddddddd',
//     '2021-09-02');
// Note test111 = Note('Test', 'This note for test', '2021-09-02');
// Note test1111 = Note('Test', 'This note for test', '2021-09-02');
//
// Project test9 = Project('Test 9', '2022-05-09', '0', false);
// Worker person1 =
//     Worker('Ahmed', '+966123456789', 'Test@test.com', 'Software engineering');
// Worker person11 = Worker('Osama', '+966123456789', '', 'Software engineering');

List<Project> allProjects = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // createUI.allTasks.addAll([task1, task11]);
  // createDi.allTasks.add(task2);
  // implement.allTasks.addAll([task3, task33, task333]);
  // project.allPhases.addAll([createUI, createDi, implement, imple]);
  // project.notes.addAll([test, test1, test11, test111, test1111]);
  // phase55.allTasks.addAll([task6, task66]);
  // project2.allPhases.addAll([phase5, phase55]);
  // createUI.allWorkers.addAll([person1, person11]);
  // allProjects.addAll([project, project2, test9]);

  runApp(AppState());
}

class AppState extends StatelessWidget {
  bool _isLoading = true;

  void setup() async {
    final auth = FirebaseAuth.instance;
    final String uid = auth.currentUser!.uid;
    final fireStore = FirebaseFirestore.instance;
    await fireStore
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => {user = UserModel.fromSnapshot(value, uid)});
    _isLoading = false;
  }

  Future<void> getAllProjects() async {
    final firestore = FirebaseFirestore.instance;
    for (int x = 0; x < user!.allProjectsUid.length; x++) {
      await firestore
          .collection('project')
          .doc(user!.allProjectsUid[x])
          .get()
          .then((value) => {
                allProjects.add(Project.formDocumentSnapshot(
                    value, user!.allProjectsUid[x]))
              });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (c, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Color(0xFF1D1E2A),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Color(0x25633BE5),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: Color(0xE7633BE5))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(13),
                    borderSide: BorderSide(color: Colors.black12)),
              ),
              appBarTheme: AppBarTheme(
                  color: Color(0xFF633BE5), shadowColor: Colors.transparent),
              fontFamily: 'Nunito',
            ),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              initialData: FirebaseAuth.instance,
              builder: (
                BuildContext context,
                AsyncSnapshot<dynamic> snapshot,
              ) {
                if (snapshot.data != null) {
                  setup();
                  return _isLoading
                      ? Scaffold(
                          body: Column(
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              Expanded(
                                child: Shimmer.fromColors(
                                  enabled: true,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder: (_, __) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: 48.0,
                                            height: 48.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: double.infinity,
                                                  height: 8.0,
                                                  color: Colors.white,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 8.0,
                                                  color: Colors.white,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 2.0),
                                                ),
                                                Container(
                                                  width: 40.0,
                                                  height: 8.0,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    itemCount: 6,
                                  ),
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade700,
                                ),
                              )
                            ],
                          ),
                        )
                      : MainScreen();
                } else
                  return SignUp();
              },
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
