import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project_management/Helper/Constant.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/UserModel.dart';
import 'package:project_management/Screens/AllProjects.dart';
import 'package:project_management/Screens/AllPhases.dart';
import 'package:project_management/Screens/Home.dart';
import 'package:project_management/Screens/Profile.dart';
import 'package:project_management/main.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';


enum _SelectedTab { home, allTasks, allProjects, profile }

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Enum _selectedTab = _SelectedTab.home;
  bool isLoading=true;
  late MaterialProvider provider=Provider.of<MaterialProvider>(context, listen: false);

  void setup() async {
    final auth = FirebaseAuth.instance;
    final String uid = auth.currentUser!.uid;
    final fireStore = FirebaseFirestore.instance;
    await fireStore
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => {user = UserModel.fromSnapshot(value, uid)});
    await provider.getProjects();
    setState(() {
      isLoading=false;
    });
  }

  @override
  void initState(){
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PageController _pageController = PageController(initialPage: 0);
    return isLoading?
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