import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/main.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  final TextStyle styleTitle=TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600
  );
  final TextStyle styleSubTitle=TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w700
  );
  final TextStyle titleStyle=TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w600
  );

  final Color color=Color(0xFF2A2B30);
  final Color red=Color(0xFFF83B3B);

  List<Project> allProjects=[];

  @override
  Widget build(BuildContext context) {
    MaterialProvider provider = Provider.of<MaterialProvider>(context);
    allProjects=provider.allProjects;
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 50,),

            //Username
            Container(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0x3F6600FF),
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '@' + user!.username,
                          style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Joined at: ' + user!.createdAt,
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'All project\n',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: allProjects.length.toString(),
                                  style: TextStyle(
                                      fontSize: 23, fontWeight: FontWeight.w600))
                            ])),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Finished\n',
                                  style: TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: finishedProjects(),
                                  style: TextStyle(
                                      fontSize: 23, fontWeight: FontWeight.w600))
                            ])),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            //Information
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 15, bottom: 8),
                    child: Text('Information', style: titleStyle,),
                  ),
                  Container(
                    color: color,
                    child: ListTile(
                      title: Text(
                        'Full name',
                        style: styleTitle
                      ),
                      subtitle: Text(
                        user!.firstName+' '+user!.lastName,
                        style: styleSubTitle,
                      ),
                      leading: Icon(Icons.account_circle_outlined),
                    ),
                  ),
                  Divider(height: 0, color: Colors.black,),
                  Container(
                    color: color,
                    child: ListTile(
                      title: Text(
                        'Email',
                        style: styleTitle
                      ),
                      subtitle: Text(
                        user!.email,
                        style: styleSubTitle,
                      ),
                      leading: Icon(Icons.email),
                    ),
                  ),
                ],
              ),
            ),

            //Services
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 15, bottom: 8),
                    child: Text(
                      'Services',
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    color: color,
                    child: ListTile(
                      title: Text(
                        'Settings',
                        style: styleSubTitle,
                      ),
                      leading: Icon(Icons.settings),
                    ),
                  ),
                  Divider(color: Colors.black, height: 0,),
                  Container(
                    color: color,
                    child: ListTile(
                      title: Text(
                        'Change password',
                        style: styleSubTitle,
                      ),
                      leading: Icon(Icons.lock_outlined),
                    ),
                  ),
                  Divider(color: Colors.black, height: 0,),
                  Container(
                    color: color,
                    child: ListTile(
                      title: Text(
                        'Delete account',
                        style: TextStyle(
                          color: red,
                            fontSize: 20,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      leading: Icon(
                        Icons.close_outlined,
                        color: red,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: (){
                FirebaseAuth.instance.signOut();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                padding: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: red,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  'Logout',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String finishedProjects() {
    int count = 0;
    for (var project in allProjects) {
      if (project.isDone) count++;
    }
    return count.toString();
  }

}
