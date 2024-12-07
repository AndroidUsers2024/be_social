import 'package:be_social/model/user_model.dart';
import 'package:be_social/providers/user_provider.dart';
import 'package:be_social/ui/auth/sign_up.dart';
import 'package:be_social/ui/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:be_social/firebase_options.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ).then((value){
        if(value.user!=null){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
        }
      });
    } catch (e) {
      print('Login failed: $e');
      // Show an alert or message to the user
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("images/bg_bes.jpg")
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Container(
                    height: MediaQuery.of(context).size.height*0.25,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.deepPurple[300],
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),bottomRight: Radius.circular(30))),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          'Be_Social',
                          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Email',
                                  border: OutlineInputBorder(borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: MediaQuery.of(context).size.width*0.8,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.key),
                                  labelText: 'Password',
                                  border: OutlineInputBorder(borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        InkWell(
                          child: Container(
                            width: MediaQuery.of(context).size.width*0.4,
                            height: MediaQuery.of(context).size.height*0.08,
                            child: Card(
                              color: Colors.blue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Text('Login',style: TextStyle(color:Colors.white,fontSize: MediaQuery.of(context).size.width*0.05,fontWeight: FontWeight.bold),)
                                )
                            ),
                          ),
                          onTap: (){
                            Provider.of<UserProvider>(context, listen: false).signIn(_emailController.text.trim(), _passwordController.text.trim());
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
                          }
                        ),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            // Navigate to sign-up or reset password page
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage(),));
                          },
                          child: Text('Don\'t have an account? Sign Up'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

