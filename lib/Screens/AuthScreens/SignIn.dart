import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/Provider.dart';
import 'package:project_management/Helper/constant.dart';
import 'package:project_management/Model/UserModel.dart';
import 'package:project_management/Screens/AuthScreens/SignUp.dart';
import 'package:project_management/main.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: 70, right: 10, left: 10),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Log in',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
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
                          if (x!.isEmpty) {
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
                    'Log in',
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
              GestureDetector(
                onTap: () => Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => SignUp())),
                child: Container(
                  width: size.width - 10,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: Constant.purple, width: 1),
                  ),
                  child: Text(
                    'Create account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 2,
                height: 48,
              ),
              TextButton(
                child: Text(
                  'Forget your password ?',
                  style: Constant.style,
                ),
                onPressed: () {},
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
        await auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        final String uid = auth.currentUser!.uid;
        await fireStore
            .collection('users')
            .doc(uid)
            .get()
            .then((value) => {user = UserModel.fromSnapshot(value, uid)});
        MaterialProvider provider=Provider.of<MaterialProvider>(context, listen: false);
        provider.getProjects();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      }
    } catch (error) {
      setState(() {
        pageLoading = false;
      });
      print('Error in Sign up screen is:' + error.toString());
    }
  }
}
