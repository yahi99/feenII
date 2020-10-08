import 'package:feen/models/userData.dart';
import 'package:feen/network/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Dashboard.dart';
import 'Login.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isCurrentUser;
  UserData currentUser = UserData();
  Route route;

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  readLocal() async {
    _auth.currentUser != null ? isCurrentUser = true : isCurrentUser = false;
    currentUser = await Authnetwork().currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return isCurrentUser
        ? DashboardScreen(userSurvey: currentUser.survey ?? '0')
        : LoginScreen();
  }
}
