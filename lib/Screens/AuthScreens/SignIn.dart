import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Helper/Constant.dart';
import 'package:project_management/Model/UserModel.dart';
import 'package:project_management/Screens/AuthScreens/SignUp.dart';
import 'package:project_management/main.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../MainScreen.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final fireStore = FirebaseFirestore.instance;
  bool _obscureText = true;
  final _signInFormKey = GlobalKey<FormState>();
  bool pageLoading = false;
  final auth = FirebaseAuth.instance;

  //For handel errors
  bool thereError=false;
  String errorMessage='';

  //For reset password
  final _key=GlobalKey<FormState>();
  final _controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: 70, right: 10, left: 10),
          child: SingleChildScrollView(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hello Again!\n',
                        style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: 'Welcome back to our app.',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white70),
                      ),
                    ]
                  ),
                )
              ),
              SizedBox(height: 20,),
              Center(
                child: SizedBox(
                    width: 150,
                    height: 150,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/image/Newappicon.png',
                          fit: BoxFit.fill,
                        ))),
              ),
              SizedBox(height: 25,),
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0x343D3144),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                      BoxShadow(
                          color: Color(0x343D3144),
                          blurRadius: 3,
                          offset: Offset(0, 1))
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sign in',
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Form(
                        key: _signInFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              validator: (x) {
                                if(!EmailValidator.validate(x!))
                                  return 'Please enter a valid email';
                                else if (x.isEmpty) {
                                  return 'Email filed is empty.';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: passwordController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _obscureText,
                              validator: (x) {
                                if (x!.length <= 7) {
                                  return 'The password should be at least 7 characters.';
                                }
                              },
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
                                      color: _obscureText
                                          ? Colors.white
                                          : Constant.purple,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 10,),
                    thereError?Text(errorMessage, style: TextStyle(color: Colors.redAccent, fontSize: 20),):Container(),

                    GestureDetector(
                      onTap: () => signIn(),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: size.width - 11,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            color: Constant.purple,
                            borderRadius: BorderRadius.circular(9),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white12,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 1))
                            ]),
                        child: !pageLoading?
                        Text(
                          'Sign in',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ):
                        Center(
                            child: CircularProgressIndicator(
                              color: Colors.white70,
                            )),
                      ),
                    ),
                  ],
                ),
              ),

              //Login
              Row(
                children: [
                  Text(
                    " Don\'t have account",
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  TextButton(
                      onPressed: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp())),
                      child: Text(
                        "Register.",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      )
                  )
                ],
              ),

              //Forgot password text button
              TextButton(
                child: Text(
                  'Forgot your password ?',
                  style: Constant.style,
                ),
                onPressed: () {
                  showSlidingBottomSheet(context,
                      builder: (context) => SlidingSheetDialog(
                          isDismissable: false,
                          snapSpec: SnapSpec(snappings: [0.7, 0.7]),
                          // controller: controller,
                          cornerRadius: 20,
                          border: Border.all(color: Colors.white54),
                          builder: (context, state) {
                            return Material(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 17),
                                child: Column(
                                  children: [
                                    Text(
                                      'Reset password',
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: 10),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Your email',
                                        style: TextStyle(
                                          fontSize: (20),
                                        ),
                                      ),
                                    ),
                                    Form(
                                      key: _key,
                                      child: TextFormField(
                                        controller: _controller,
                                        validator: (value) => EmailValidator.validate(value!) ? null:'Please enter a valid email',
                                        decoration: InputDecoration(
                                          hintText: 'Email',
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.center,
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
                                          //Submit request button
                                          GestureDetector(
                                            onTap: () async {
                                              try {
                                                if(_key.currentState!.validate()){
                                                  await FirebaseAuth.instance.sendPasswordResetEmail(email: _controller.text).onError((error, stackTrace) {
                                                    throw new Exception();
                                                  });
                                                  Navigator.pop(context);
                                                  CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.success,
                                                    text: "You will receive a password reset message in your email.",
                                                    title: 'Done successfully!',
                                                    confirmBtnText: 'Ok',
                                                  );
                                                }
                                              } on Exception catch (e) {
                                                showFlash(
                                                    context: context,
                                                    duration: Duration(seconds: 4),
                                                    builder: (context, controller) {
                                                      return Flash.bar(
                                                          controller: controller,
                                                          backgroundColor: Color(0xBB393939),
                                                          borderRadius: BorderRadius.circular(10),
                                                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                                                          forwardAnimationCurve:
                                                          Curves.easeOutBack,
                                                          child: FlashBar(
                                                              content: Text('That email account doesn\'t exist. Enter a different account or get a new one.')));
                                                    });
                                              }
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
                                                'Submit',
                                                style: TextStyle(
                                                    fontSize: 19,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          )
                                        ])
                                  ],
                                ),
                              ),
                            );
                          }));
                },
              ),
            ],
          ))),
    );
  }

  Future<void> signIn() async {
    try {
      if (_signInFormKey.currentState!.validate()) {
        setState(() {
          pageLoading = true;
        });
        await auth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
        final String uid = auth.currentUser!.uid;
        await fireStore.collection('users').doc(uid).get().then((value) => {user = UserModel.fromSnapshot(value, uid)});
        MaterialProvider provider=Provider.of<MaterialProvider>(context, listen: false);
        provider.getProjects();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
      }
    } on FirebaseAuthException catch (error) {
      thereError=true;
      switch (error.code) {
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "invalid-email":
          errorMessage = "User with this email doesn't exist.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      setState(() {
        pageLoading = false;
      });
    }
  }
}
