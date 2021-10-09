import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Helper/constant.dart';
import 'package:project_management/Model/UserModel.dart';
import 'package:project_management/Screens/AllProjects.dart';
import 'package:project_management/Screens/AllPhases.dart';
import 'package:project_management/Screens/Home.dart';
import 'package:project_management/Screens/Profile.dart';
import 'package:project_management/Screens/ProjectDetail.dart';
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
  late MaterialProvider provider;

  void setup() async {
    final auth = FirebaseAuth.instance;
    final String uid = auth.currentUser!.uid;
    final fireStore = FirebaseFirestore.instance;
    await fireStore
        .collection('users')
        .doc(uid)
        .get()
        .then((value) => {user = UserModel.fromSnapshot(value, uid)});

    provider=Provider.of<MaterialProvider>(context, listen: false);
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
    waitingScreen():
    Scaffold(
      body: PageView(
        controller: _pageController,
        physics: BouncingScrollPhysics(),
        onPageChanged: (x) {
          setState(() {
            _selectedTab = _SelectedTab.values[x];
          });
        },
        children: [
          ProjectDetail(project: provider.allProjects[0],),
          Home(),
          AllPhases(),
          AllProjects(),
          Profile(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 20, left: 15, right: 15, top: 1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: GNav(
            backgroundColor: Constant.purple,
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
    );
  }

  Scaffold waitingScreen(){
    return Scaffold(
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
    );
  }
}