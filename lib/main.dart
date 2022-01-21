import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/UserModel.dart';
import 'package:project_management/Screens/AuthScreens/SignIn.dart';
import 'package:project_management/Screens/MainScreen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

UserModel? user;
// bool bannerIsReady=false;
// bool bannerIsShown=false;
bool intersIsReady=false;
bool intersIsShown=false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ConsentManager.requestConsentInfoUpdate("0810e48f6f32ed11c2b84ff7adda432143d676a63cb6aceb");

  ConsentManager.setConsentInfoUpdateListener(
          (onConsentInfoUpdated, consent) async {
        var consentStatus = await ConsentManager.getConsentStatus();
        var shouldShow = await ConsentManager.shouldShowConsentDialog();
        ConsentManager.loadConsentForm();
        var isLoaded = await ConsentManager.consentFormIsLoaded();
        ConsentManager.showAsDialogConsentForm();
        ConsentManager.showAsActivityConsentForm();
      },
          (onFailedToUpdateConsentInfo, error) => {}
  );

  Status consentStatus = await ConsentManager.getConsentStatus();
  bool hasConsent = consentStatus == Status.PERSONALIZED ||
      consentStatus == Status.PARTLY_PERSONALIZED;

  //For enable test mode
  Appodeal.setTesting(false);
  Appodeal.setLogLevel(Appodeal.LogLevelVerbose);
  Appodeal.initialize("0810e48f6f32ed11c2b84ff7adda432143d676a63cb6aceb", [Appodeal.INTERSTITIAL], hasConsent);

  // Appodeal.setBannerCallbacks(
  //         (onBannerLoaded, isPrecache) => {bannerIsReady=true},
  //         (onBannerFailedToLoad) => {},
  //         (onBannerShown) => {bannerIsShown=true},
  //         (onBannerShowFailed) => {bannerIsReady=false},
  //         (onBannerClicked) => {},
  //         (onBannerExpired) => {});

  Appodeal.setInterstitialCallbacks(
          (onInterstitialLoaded, isPrecache) => {intersIsReady=true},
          (onInterstitialFailedToLoad) => {},
          (onInterstitialShown) => {},
          (onInterstitialShowFailed) => {intersIsReady=false},
          (onInterstitialClicked) => {},
          (onInterstitialClosed) => {
            intersIsShown = true,
            intersIsReady = false,
            Timer(Duration(minutes: 1, seconds: 30), (){
              intersIsReady = true;
            }),
          },
          (onInterstitialExpired) => {});

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
                  return SignIn();
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