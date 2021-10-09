import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/UserModel.dart';
import 'package:project_management/Screens/AuthScreens/SignUp.dart';
import 'package:project_management/Screens/MainScreen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

UserModel? user;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<MaterialProvider>(
      create: (_) => MaterialProvider(),
    ),
  ], child: AppState()));
}

class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder (
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
                if (snapshot.data == null) {
                  return SignUp();
                } else if(snapshot.data!=null)
                  return MainScreen();
                return waitingScreen();
              },
            ),
          );
        } else
          return waitingScreen();
      },
    );
  }

  Widget waitingScreen() {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFF1D1E2A),
        ),
        home: Scaffold(
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
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 48.0,
                            height: 48.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 8.0,
                                  color: Colors.white,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
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
        ));
  }
}