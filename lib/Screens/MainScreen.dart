import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project_management/Helper/Constant.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/UserModel.dart';
import 'package:project_management/Screens/AllProjects.dart';
import 'package:project_management/Screens/AllPhases.dart';
import 'package:project_management/Screens/Home.dart';
import 'package:project_management/Screens/Profile.dart';
import 'package:project_management/main.dart';
import 'package:project_management/private.dart';
import 'package:provider/provider.dart';


enum _SelectedTab { home, allTasks, allProjects, profile }

class MainScreen extends StatefulWidget {
  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  Enum _selectedTab = _SelectedTab.home;
  static bool isPageLoading=true;
  late MaterialProvider provider=Provider.of<MaterialProvider>(context, listen: false);
  static late InterstitialAd? _interstitialAd;
  static const int maxFailedLoadAttempts = 3;
  static int _numInterstitialLoadAttempts = 0;
  static bool intersIsReady=false;
  static bool firstTimeAd=true;

  void setup() async {
    final auth = FirebaseAuth.instance;
    final String uid = auth.currentUser!.uid;
    final fireStore = FirebaseFirestore.instance;
    await fireStore.collection('users').doc(uid).get().then((value) => {user = UserModel.fromSnapshot(value, uid)}).catchError((d){
      setState(() {
        setup();
      });
    });
    await provider.getProjects();
    setState(() {
      isPageLoading=false;
    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _interstitialAd!.dispose();
  }
  @override
  void initState(){
    super.initState();
    setup();
    // For ad creation
    createInterstitialAd();
  }
  static void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: getIntKey(),
        request: AdRequest(nonPersonalizedAds: true,),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            //To avoid repetition the ad
            if(firstTimeAd){
              intersIsReady=true;
              firstTimeAd=false;
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            intersIsReady=false;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }
  static void showInterstitialAd() {
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();

    //Stop Inters
    intersIsReady=false;
    Timer(Duration(seconds: 50), () {
      intersIsReady = true;
    });
  }


  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 0);
    return isPageLoading?
    Constant.waitingScreen():
    Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: BouncingScrollPhysics(),
            onPageChanged: (x) {
              setState(() {
                _selectedTab = _SelectedTab.values[x];
              });
            },
            children: [
              Home(),
              AllPhases(),
              AllProjects(),
              Profile(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10, left: 15, right: 15, top: 1),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: GNav(
                  backgroundColor: Color(0xFF440EAF),
                  selectedIndex: _selectedTab.index,
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
                  tabMargin: EdgeInsets.all(0),
                  activeColor: Color(0xFF330099),
                  tabBackgroundColor: Color(0xE0C09FDB),
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.task_outlined,
                      text: 'Tasks',
                    ),
                    GButton(
                      icon: Icons.handyman_outlined,
                      text: 'Projects',
                    ),
                    GButton(
                      icon: Icons.person_outlined,
                      text: 'Profile',
                    ),
                  ],
                  onTabChange: (x) {
                    _pageController.animateToPage(x,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeOutCirc);
                    _selectedTab = _SelectedTab.values[x];
                  },
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}