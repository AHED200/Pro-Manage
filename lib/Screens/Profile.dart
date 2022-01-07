import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Helper/constant.dart';
import 'package:project_management/Model/Phase.dart';
import 'package:project_management/Model/Project.dart';
import 'package:project_management/Screens/AuthScreens/SignIn.dart';
import 'package:project_management/Screens/AuthScreens/SignUp.dart';
import 'package:project_management/main.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:uuid/uuid.dart';

class Profile extends StatelessWidget {
  final TextStyle styleTitle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w600);
  final TextStyle styleSubTitle =
      TextStyle(fontSize: 19, fontWeight: FontWeight.w700);
  final TextStyle titleStyle =
      TextStyle(fontSize: 25, fontWeight: FontWeight.w600);

  final Color color = Color(0xFF38393B);
  final Color red = Color(0xFFF83B3B);

  List<Project> allProjects = [];

  @override
  Widget build(BuildContext context) {
    MaterialProvider provider = Provider.of<MaterialProvider>(context);
    allProjects = provider.allProjects;

    //For change user name
    TextEditingController firstName =
        TextEditingController(text: user!.firstName);
    TextEditingController lastName =
        TextEditingController(text: user!.lastName);
    TextEditingController email = TextEditingController(text: user!.email);
    TextEditingController password = TextEditingController();
    bool emailValidate = false;

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),

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
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Joined at: ' + user!.createdAt,
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: allProjects.length.toString(),
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600))
                            ])),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: [
                              TextSpan(
                                  text: 'Finished\n',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                              TextSpan(
                                  text: finishedProjects(),
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600))
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
                  //Full name
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, top: 15, bottom: 8),
                    child: Text(
                      'Information',
                      style: titleStyle,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showSlidingBottomSheet(context,
                          builder: (context) => SlidingSheetDialog(
                              isDismissable: false,
                              snapSpec: SnapSpec(snappings: [0.7, 0.7]),
                              // controller: controller,
                              cornerRadius: 20,
                              border: Border.all(color: Colors.white54),
                              builder: (context, state) {
                                return Material(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Change name',
                                        style: titleStyle,
                                      ),
                                      SizedBox(height: 30),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          children: [
                                            //First name
                                            TextField(
                                              controller: firstName,
                                              decoration: InputDecoration(
                                                  labelText: 'First name'),
                                            ),

                                            SizedBox(
                                              height: 15,
                                            ),

                                            //Last name
                                            TextField(
                                              controller: lastName,
                                              decoration: InputDecoration(
                                                  labelText: 'Last name'),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 30),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          //Cancel changes
                                          GestureDetector(
                                            onTap: () => Navigator.pop(context),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 35, vertical: 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.purple,
                                                    width: 4),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                          //Save changes
                                          GestureDetector(
                                            onTap: () async {
                                              await provider.firestore
                                                  .collection('users')
                                                  .doc(user!.uid)
                                                  .update({
                                                'firstName': firstName.text,
                                                'lastName': lastName.text,
                                              });
                                              user!.firstName = firstName.text;
                                              user!.lastName = lastName.text;
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 35, vertical: 8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.purple,
                                                    width: 4),
                                                color: Colors.purple,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10)
                                    ],
                                  ),
                                );
                              }));
                    },
                    child: Container(
                      color: color,
                      child: ListTile(
                        title: Text('Full name', style: styleTitle),
                        subtitle: Text(
                          user!.firstName + ' ' + user!.lastName,
                          style: styleSubTitle,
                        ),
                        leading: Icon(Icons.account_circle_outlined),
                      ),
                    ),
                  ),
                  //Email
                  Divider(
                    height: 0,
                    color: Colors.black,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                content: LoginValidation(),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        try {
                                          if (_LoginValidationState
                                                  .passwordController
                                                  .text
                                                  .isNotEmpty &&
                                              _LoginValidationState
                                                      .passwordController
                                                      .text
                                                      .length >=
                                                  7) {
                                            FirebaseAuth.instance
                                                .signInWithEmailAndPassword(
                                                    email: user!.email,
                                                    password:
                                                        _LoginValidationState
                                                            .passwordController
                                                            .text)
                                                .then((auth) {
                                              if (auth.user!.uid.length > 0) {
                                                _LoginValidationState
                                                    .passwordController
                                                    .clear();
                                                Navigator.pop(context);
                                                showSlidingBottomSheet(context,
                                                    builder: (context) =>
                                                        SlidingSheetDialog(
                                                            isDismissable:
                                                                false,
                                                            snapSpec: SnapSpec(
                                                                snappings: [
                                                                  0.7,
                                                                  0.7
                                                                ]),
                                                            // controller: controller,
                                                            cornerRadius: 20,
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white54),
                                                            builder: (context,
                                                                state) {
                                                              return Material(
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Text(
                                                                      'Change email',
                                                                      style:
                                                                          titleStyle,
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            30),
                                                                    Padding(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      child:
                                                                          TextFormField(
                                                                        controller:
                                                                            email,
                                                                        textInputAction:
                                                                            TextInputAction.done,
                                                                        keyboardType:
                                                                            TextInputType.emailAddress,
                                                                        validator:
                                                                            (x) {
                                                                          emailValidate =
                                                                              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.text);
                                                                          if (x!
                                                                              .isEmpty) {
                                                                            return 'Email filed is empty.';
                                                                          } else if (!emailValidate)
                                                                            return 'Email is\'t validate';
                                                                        },
                                                                        decoration:
                                                                            InputDecoration(
                                                                          labelText:
                                                                              'Email',
                                                                          prefixIcon:
                                                                              Icon(Icons.email),
                                                                          floatingLabelBehavior:
                                                                              FloatingLabelBehavior.auto,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            30),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        //Cancel changes
                                                                        GestureDetector(
                                                                          onTap: () =>
                                                                              Navigator.pop(context),
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(color: Colors.purple, width: 4),
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              'Cancel',
                                                                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        //Save changes
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            emailValidate =
                                                                                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.text);
                                                                            if (emailValidate) {
                                                                              await provider.firestore.collection('users').doc(user!.uid).update({
                                                                                'email': email.text
                                                                              });
                                                                              await FirebaseAuth.instance.currentUser!.updateEmail(email.text);
                                                                              user!.email = email.text;
                                                                              Navigator.pop(context);
                                                                            }
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.symmetric(horizontal: 35, vertical: 8),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(color: Colors.purple, width: 4),
                                                                              color: Colors.purple,
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                Text(
                                                                              'Save',
                                                                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            10)
                                                                  ],
                                                                ),
                                                              );
                                                            }));
                                              }
                                            });
                                          } else {
                                            throw new Exception(
                                                'Password filed is empty');
                                          }
                                        } catch (error) {
                                          showFlash(
                                              context: context,
                                              duration: Duration(seconds: 4),
                                              builder: (context, controller) =>
                                                  Flash.bar(
                                                      controller: controller,
                                                      backgroundColor:
                                                          Color(0xF0393939),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 15,
                                                              vertical: 40),
                                                      forwardAnimationCurve:
                                                          Curves.easeOutBack,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            'Password is\'t correct, try again',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                            )),
                                                      )));
                                        }
                                      },
                                      child: Text(
                                        'Ok',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17),
                                      ))
                                ],
                              ));
                    },
                    child: Container(
                      color: color,
                      child: ListTile(
                        title: Text('Email', style: styleTitle),
                        subtitle: Text(
                          user!.email,
                          style: styleSubTitle,
                        ),
                        leading: Icon(Icons.email),
                      ),
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
                    padding:
                        const EdgeInsets.only(left: 12, top: 15, bottom: 8),
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
                  Divider(
                    color: Colors.black,
                    height: 0,
                  ),
                  //Change password
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      color: color,
                      child: ListTile(
                        title: Text(
                          'Change password',
                          style: styleSubTitle,
                        ),
                        leading: Icon(Icons.lock_outlined),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    height: 0,
                  ),
                  //Delete user account
                  GestureDetector(
                    onTap: () {
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.warning,
                          title: 'Are you sure for deleting your account?',
                          showCancelBtn: true,
                          cancelBtnText: 'No',
                          confirmBtnText: 'Yes',
                          onConfirmBtnTap: () {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      backgroundColor: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      title: Text('Delete account'),
                                      content: SizedBox(
                                        height: 150,
                                        width: 250,
                                        child: Column(
                                          children: [
                                            Text(
                                                'Please enter your password to confirm the deletion.'),
                                            SizedBox(
                                              height: 90,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 15),
                                                child: TextFormField(
                                                  controller: password,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  keyboardType: TextInputType
                                                      .visiblePassword,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    labelText: 'Password',
                                                    floatingLabelBehavior:
                                                        FloatingLabelBehavior
                                                            .auto,
                                                    focusColor: Colors.black,
                                                    prefixIcon: Icon(
                                                        Icons.lock_outlined),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () async{
                                              await FirebaseFirestore.instance.collection('projectRepository').doc(user!.projectRepositoryId).delete();
                                              await FirebaseFirestore.instance.collection('users').doc(user!.uid).delete();
                                              await FirebaseAuth.instance.currentUser!.delete();
                                              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>SignIn()));
                                            },
                                            child: Text(
                                              'Delete account',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ))
                                      ],
                                    ));
                          },
                          onCancelBtnTap: () => Navigator.pop(context));
                    },
                    child: Container(
                      color: color,
                      child: ListTile(
                        title: Text(
                          'Delete account',
                          style: TextStyle(
                              color: red,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                        leading: Icon(
                          Icons.close_outlined,
                          color: red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            GestureDetector(
              onTap: () {
                CoolAlert.show(
                    context: context,
                    type: CoolAlertType.warning,
                    title: 'Are you sure?',
                    showCancelBtn: true,
                    confirmBtnText: 'yes',
                    onConfirmBtnTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    },
                    onCancelBtnTap: () => Navigator.pop(context));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                padding: EdgeInsets.symmetric(vertical: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: red, borderRadius: BorderRadius.circular(10)),
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

      //Temp floating button
      floatingActionButton: FloatingActionButton(
        child: Text('T'),
        backgroundColor: Colors.orange[400],
        onPressed: () async {
          MaterialProvider provider =
              Provider.of<MaterialProvider>(context, listen: false);
          //Setup project
          final phases = [
            Phase('Phase 1', 'This is first phase', '2020-09-20', '2022-09-20',
                false),
            Phase('Phase 2', 'This is second phase', '2022-09-20', '2022-09-20',
                false),
            Phase('Phase 3', 'This is first phase', '2023-09-20', '2022-09-20',
                false),
            Phase('Phase 4', 'This is first phase', '2024-09-20', '2022-09-20',
                false),
            Phase('Phase 5', 'This is first phase', '2021-09-20', '2022-09-20',
                true),
          ];

          final String projectUid = Uuid().v4();
          final String dueDate = '2022-07-24';
          Project project = Project(
              projectUid, 'Test project', dueDate, '10000', false, phases, []);
          String userId = FirebaseAuth.instance.currentUser!.uid;

          final firestore = FirebaseFirestore.instance;

          //Create new project in Firestore
          await firestore
              .collection('projectRepository')
              .doc(user!.projectRepositoryId)
              .update({
            projectUid: project.toMap(),
          });

          // Add project UID in user projects list
          await firestore.collection('users').doc(userId).update({
            'projectsId': FieldValue.arrayUnion([projectUid])
          });
          user!.projectsId.add(projectUid);

          //Update application
          await provider.getProjects();
        },
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

class LoginValidation extends StatefulWidget {
  @override
  State<LoginValidation> createState() => _LoginValidationState();
}

class _LoginValidationState extends State<LoginValidation> {
  static final TextEditingController passwordController =
      TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password validation',
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Email',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          // SizedBox(height: 5,),
          Text(
            user!.email,
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 90,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  focusColor: Colors.black,
                  prefixIcon: Icon(Icons.lock_outlined),
                  suffix: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        Icons.visibility_outlined,
                        size: 25,
                        color: _obscureText ? Colors.white : Constant.purple,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ]);
  }
}
