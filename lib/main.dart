import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/UserModel.dart';
import 'package:project_management/Screens/AuthScreens/SignUp.dart';
import 'package:project_management/Screens/MainScreen.dart';
import 'package:project_management/private.dart';
import 'package:provider/provider.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

import 'Helper/Constant.dart';

UserModel? user;
// bool bannerIsReady=false;
// bool bannerIsShown=false;
bool intersIsReady = false;
bool intersIsShown = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ConsentManager.requestConsentInfoUpdate(adKey);

  ConsentManager.setConsentInfoUpdateListener(
      (onConsentInfoUpdated, consent) async {
    var consentStatus = await ConsentManager.getConsentStatus();
    var shouldShow = await ConsentManager.shouldShowConsentDialog();
    ConsentManager.loadConsentForm();
    var isLoaded = await ConsentManager.consentFormIsLoaded();
    ConsentManager.showAsDialogConsentForm();
    ConsentManager.showAsActivityConsentForm();
  }, (onFailedToUpdateConsentInfo, error) => {});

  Status consentStatus = await ConsentManager.getConsentStatus();
  bool hasConsent = consentStatus == Status.PERSONALIZED ||
      consentStatus == Status.PARTLY_PERSONALIZED;

  //For enable test mode
  Appodeal.setTesting(false);
  Appodeal.disableNetwork("admob");
  Appodeal.setLogLevel(Appodeal.LogLevelVerbose);
  Appodeal.initialize(adKey, [Appodeal.INTERSTITIAL], hasConsent);

  // Appodeal.setBannerCallbacks(
  //         (onBannerLoaded, isPrecache) => {bannerIsReady=true},
  //         (onBannerFailedToLoad) => {},
  //         (onBannerShown) => {bannerIsShown=true},
  //         (onBannerShowFailed) => {bannerIsReady=false},
  //         (onBannerClicked) => {},
  //         (onBannerExpired) => {});

  Appodeal.setInterstitialCallbacks(
      (onInterstitialLoaded, isPrecache) => {intersIsReady = true},
      (onInterstitialFailedToLoad) => {},
      (onInterstitialShown) => {},
      (onInterstitialShowFailed) => {intersIsReady = false},
      (onInterstitialClicked) => {},
      (onInterstitialClosed) => {
            intersIsShown = true,
            intersIsReady = false,
            Timer(Duration(seconds: 55), () {
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
    return FutureBuilder(
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
                } else if (snapshot.data != null) return MainScreen();
                return Constant.waitingScreen();
              },
            ),
          );
        } else
          return Constant.waitingScreen();
      },
    );
  }
}
