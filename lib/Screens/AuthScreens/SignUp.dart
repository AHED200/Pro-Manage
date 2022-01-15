import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_management/Helper/constant.dart';
import 'package:project_management/Model/UserModel.dart';
import 'package:project_management/Screens/AuthScreens/SignIn.dart';
import 'package:project_management/Screens/MainScreen.dart';
import 'package:project_management/main.dart';
import 'package:uuid/uuid.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  bool _obscureText = true;
  final _signUpFormKey = GlobalKey<FormState>();
  bool pageLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50, right: 10, left: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Pro Manage!',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10,),
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
                      'Sign up',
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20,
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
                            controller: usernameController,
                            textInputAction: TextInputAction.next,
                            validator: (x) {
                              if (x!.length <= 3) {
                                return 'The name should be at least 3 characters.';
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Username',
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              prefixIcon: Icon(Icons.alternate_email_outlined),
                            ),
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
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => SignIn())),
                      child: Container(
                        width: size.width - 11,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(color: Constant.purple, width: 1),
                        ),
                        child: Text(
                          'Log in',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
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
        await auth.createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        final String uid = auth.currentUser!.uid;
        final String projectRepository=Uuid().v4();

        final fireStore = FirebaseFirestore.instance;
        await fireStore.collection('users').doc(uid).set({
          'username': usernameController.text,
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'email': emailController.text,
          'createdAt': Timestamp.now(),
          'projectRepositoryId': projectRepository,
          'projectsId':[],
        });
        await fireStore.collection('projectRepository').doc(projectRepository).set({});
        await fireStore
            .collection('users')
            .doc(uid)
            .get()
            .then((value) => {user = UserModel.fromSnapshot(value, uid)});

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      }
    } catch (error) {
      setState(() {
        pageLoading = false;
      });
    }
  }
}
