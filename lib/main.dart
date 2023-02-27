import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/UserModel.dart';
import 'package:project_management/Screens/AuthScreens/SignUp.dart';
import 'package:project_management/Screens/MainScreen.dart';
import 'package:provider/provider.dart';

import 'Helper/Constant.dart';

UserModel? user;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(AppState());
}

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<MaterialProvider>(
        create: (_) => MaterialProvider(),
      ),
    ],
      child: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (c, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                brightness: Brightness.dark,
                scaffoldBackgroundColor: Color(0xFF292C32),
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
                  } else if (snapshot.data != null) {
                    return MainScreen();
                  }
                  return Constant.waitingScreen();
                },
              ),
            );
          } else
            return Constant.waitingScreen();
        },
      ),
    );
  }
}
