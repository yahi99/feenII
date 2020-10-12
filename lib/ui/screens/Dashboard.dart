import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feen/blocs/AtmBloc.dart';
import 'package:feen/blocs/BankBloc.dart';
import 'package:feen/models/userData.dart';
import 'package:feen/network/Auth.dart';
import 'package:feen/network/Database.dart';
import 'package:feen/ui/screens/AtmFinder.dart';
import 'package:feen/ui/widgets/animation/FadeAnimation.dart';
import 'package:feen/ui/widgets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';

import 'BankFinder.dart';
import 'Profile.dart';
import 'Tips.dart';

final CollectionReference usersRef = Firestore.instance.collection('User');
UserData currentUser;

// ignore: must_be_immutable
class DashboardInfo extends StatefulWidget {
  String userSurvey;

  DashboardInfo({this.userSurvey});

  @override
  _DashboardInfoState createState() =>
      _DashboardInfoState(userSurvey: this.userSurvey);
}

class _DashboardInfoState extends State<DashboardInfo> {
  String userSurvey;

  _DashboardInfoState({this.userSurvey});

  @override
  Widget build(BuildContext context) {
    return DashboardScreen(userSurvey: userSurvey);
  }
}

class DashboardScreen extends StatefulWidget {
  final String userSurvey;

  DashboardScreen({this.userSurvey});

  static String id = 'dashboard_page';

  @override
  _DashboardScreenState createState() =>
      _DashboardScreenState(userSurvey: userSurvey);
}

class _DashboardScreenState extends State<DashboardScreen> {
  String userSurvey;

  _DashboardScreenState({this.userSurvey});

  int restSurveys;
  Position currentPosition;
  List<int> surveyList = List();

  DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    Geolocator()
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      ).then((position) {
        if (mounted) {
          setState(() {
            currentPosition = position;
          });
        }
      }).catchError((e) {
        print(e + " *********** Error in getLocation Method ");
        Navigator.of(context).pop(true);
        super.dispose();
      });
    AtmBloc.atmList = List();
    BankBloc.bankList = List();
  }

  getCurrentUser() async {
    currentUser = await Authnetwork().currentUser();
  }

  @override
  Widget build(BuildContext context) {
    restSurveys = 8 - int.parse(userSurvey);
    final screenSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(children: <Widget>[
              Positioned(
                  top: 32,
                  left: 8,
                  child: FloatingActionButton(
                      mini: true,
                      elevation: 0,
                      onPressed: null,
                      child: Icon(Ionicons.md_notifications_outline,
                          color: Colors.amber))),
              Padding(
                padding: EdgeInsets.only(right: 16, top: 32),
                child: FadeAnimation(
                  1,
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "اهلا بك",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: Colors.amber)),
                        TextSpan(
                            text: "\nالصفحة الرئيسية",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        16, screenSize.height * 0.03, 16, 8),
                    height: screenSize.height * 0.2,
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      child: FadeAnimation(
                        1.2,
                        Container(
                          padding: EdgeInsets.only(right: 8, left: 4),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text("سجل الاستبيانات",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              .copyWith(color: kPrimaryColor)),
                                      Container(
                                          height: screenSize.height * 0.05,
                                          width: screenSize.width * 0.6,
                                          child: survey()),
                                      Text(
                                        'أكمل جميع الاستبيانات لترقية حسابك',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      )
                                    ]),
                                Container(
                                  child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 45,
                                      child: Image.asset(
                                          'assets/icons/survey.png')),
                                )
                              ]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenSize.height * 0.03),
                  SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      padding: EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              FadeAnimation(
                                1.6,
                                Row(children: <Widget>[
                                  Expanded(
                                    child: cardWidget(
                                        'أفضل ماكينة', 'assets/icons/atm.png',
                                        () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  AtmFinder(currentPosition)));
                                    }),
                                  ),
                                  SizedBox(width: screenSize.width * 0.05),
                                  Expanded(
                                    child: cardWidget(
                                        'أفضل بنك', 'assets/icons/bank.png',
                                        () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (builder) =>
                                                  BankFinder(currentPosition)));
                                    }),
                                  ),
                                ]),
                              ),
                              SizedBox(height: screenSize.height * 0.02),
                              FadeAnimation(
                                1.8,
                                Row(children: <Widget>[
                                  Expanded(
                                      child: cardWidget('الصفحة الشخصية',
                                          'assets/icons/user.png', () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => ProfileScreen(
                                                userData: currentUser,
                                                infoChanged: false)));
                                  })),
                                  SizedBox(width: screenSize.width * 0.05),
                                  Expanded(
                                      child: cardWidget("إرشادات و تعليمات",
                                          'assets/icons/tips.png', () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (builder) => Tips()));
                                  }))
                                ]),
                              ),
                            ]),
                      ),
                    ),
                  )
                ],
              ),
            ]),
          )),
    );
  }

  Widget survey() {
    int p = int.tryParse(userSurvey);

    return ListView.builder(
      itemCount: 10,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Ionicons.ios_paper,
                color: index <= 4 ? kPrimaryColor : kLightGreen),
          ],
        );
      },
    );
  }

  Widget cardWidget(String title, String img, Function onTap) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.25,
      child: Card(
          clipBehavior: Clip.hardEdge,
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: InkWell(
              onTap: onTap,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 50,
                        child: Image.asset(img)),
                    Text(title,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: kPrimaryColor))
                  ]))),
    );
  }

  Future<bool> _onBackPressed() async {
    return (await showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              content: Text('هل تريد حقًا الخروج من التطبيق؟',
                  style: Theme.of(context).textTheme.subtitle1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              backgroundColor: kSilver,
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('لا',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold)),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    super.dispose();
                  },
                  child: Text('نعم',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        )) ??
        false;
  }
}
