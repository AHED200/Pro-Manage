import 'dart:async';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_management/Helper/Constant.dart';
import 'package:project_management/Screens/AuthScreens/SignIn.dart';
import 'package:uuid/uuid.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  bool _obscureText = true;
  final _signUpFormKey = GlobalKey<FormState>();
  bool pageLoading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 50, right: 10, left: 10, bottom: 60),
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              SizedBox(height: 10,),
              Text(
                'Pro Manage',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20,),
              //Sign
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(10),
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
                      'Sign up',
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: firstNameController,
                                  textInputAction: TextInputAction.next,
                                  validator: (x) {
                                    if (x!.length <= 3)
                                      return 'Should be at least 3 characters.';
                                    else if (x.contains(' '))
                                      return "Shouldn't contain space";
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'First name',
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: TextFormField(
                                  controller: lastNameController,
                                  textInputAction: TextInputAction.next,
                                  validator: (x) {
                                    if (x!.length <= 3)
                                      return 'Should be at least 3 characters.';
                                    else if (x.contains(' '))
                                      return 'Shouldn\'t contain space';
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Last name',
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                                    color:
                                    _obscureText ? Colors.white : Constant.purple,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () => signUp(),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: size.width - 10,
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
                        child: !pageLoading
                            ? Text(
                          'Create account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                            : Center(
                            child: CircularProgressIndicator(
                              color: Colors.white70,
                            )),
                      ),
                    ),
                    //Navigator to sing in
                    Row(
                      children: [
                        Text(
                          " I have already an account",
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                            onPressed: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn())),
                            child: Text(
                              "Login.",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            )
                        )
                      ],
                    ),
                  ],
                ),
              ),

              //OR
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width/3,
                    child: Divider(
                      height: 30,
                      thickness: 3,
                      color: Colors.white10,
                    ),
                  ),
                  Text("Or", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white70,)),
                  Container(
                    width: size.width/3,
                    child: Divider(
                      height: 30,
                      thickness: 3,
                      color: Colors.white10,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              //Sign uo with google
              GoogleAuthButton(
                onPressed: () => signInWithGoogle(),
                text: "Sign up with Google",
                darkMode: true,
                style: AuthButtonStyle(
                  buttonType: AuthButtonType.secondary,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUp() async {
    try {
      if (_signUpFormKey.currentState!.validate()) {
        setState(() {
          pageLoading = true;
        });
        final FirebaseAuth auth = FirebaseAuth.instance;
        await auth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) => {
          signUpCore(value.user!.uid, firstNameController.text, lastNameController.text, emailController.text,)
        });
      }
    } catch (error) {
      setState(() {
        pageLoading = false;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithCredential(credential).then((auth) async{
      String? name=auth.user!.displayName;
      String? fName;
      String? lName;
      for (int x = 0; x < name!.length; x++) {
        if (name.substring(x, x + 1) == " ") {
          fName = name.substring(0, x);
          lName = name.substring(x, name.length);
          break;
        }
      }
      await FirebaseFirestore.instance.collection("users").doc(auth.user!.uid).get().then((value)async{
        if(!value.exists){
         await signUpCore(auth.user!.uid, fName!, lName!, auth.user!.email.toString());
        }
      });
    });
  }

  Future<void> signUpCore(String uid, String firstName, String lastName, String email)async{
    final fireStore = FirebaseFirestore.instance;
    final String projectRepository=Uuid().v4();
    await fireStore.collection('users').doc(uid).set({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'createdAt': Timestamp.now(),
      'showAd': true,
      'projectRepositoryId': projectRepository,
      'projectsId':[],
    });
    await fireStore.collection('projectRepository').doc(projectRepository).set({});
  }
}