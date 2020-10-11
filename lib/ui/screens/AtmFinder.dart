import 'dart:async';
import 'dart:ui';

import 'package:feen/blocs/AtmBloc.dart';
import 'package:feen/models/Geometry.dart';
import 'package:feen/models/PlaceResult.dart';
import 'package:feen/ui/widgets/MapOptions.dart';
import 'package:feen/ui/widgets/buildMap.dart';
import 'package:feen/ui/widgets/colors.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';

class AtmFinder extends StatefulWidget {
  final Position position;

  const AtmFinder(this.position);

  State<AtmFinder> createState() {
    return _AtmFinder();
  }
}

class _AtmFinder extends State<AtmFinder> {
  AtmBloc _atmBloc;
  String bankName = "البنك الأهلي المصري", transaction = "سحب", imgUrl;
  List<String> bankNameList = [
    "البنك الأهلي المصري    ",
    "بنك مصر",
    "بنك القاهرة",
  ];
  List<String> transactionList = [
    "سحب",
    "إيداع",
  ];

  @override
  void initState() {
    super.initState();
    // try {
    //   initializing();
    // } catch (e) {
    //   print(" **************");
    // }

    _atmBloc = AtmBloc(
        Location(
            lat: widget.position.latitude, long: widget.position.longitude),
        bankName,
        transaction);
  }

  Future<bool> waitNotification() async {
    return (await showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text(
                  'للاستفادة بخدمة اكثر تميزاً ما عليك سوى ملئ البيانات لتقيم الماكينة من خلال اشعار سيصلك بعد قليل ✨',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Cairo', color: kPrimaryColor, fontSize: 16)),
              content: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: Image.asset('assets/icons/notification.png')),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('متابعة',
                      style: TextStyle(
                          fontFamily: 'Cairo',
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    checkInternet(context);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: StreamBuilder<List<PlaceResult>>(
            stream: _atmBloc.streamAtmList,
            builder: (context, AsyncSnapshot<List<PlaceResult>> snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: <Widget>[
                    BuildMapWidget(
                        position: widget.position, place: snapshot.data),
                    backWidget(context, '', kGrey),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              MapOptionsWidget(
                                optionList: bankNameList,
                                function: (bankName) => setState(() {
                                  this.bankName = bankName;
                                  _atmBloc = AtmBloc(
                                      Location(
                                          lat: widget.position.latitude,
                                          long: widget.position.longitude),
                                      bankName,
                                      transaction);
                                }),
                              ),
                              SizedBox(height: 8),
                              MapOptionsWidget(
                                optionList: transactionList,
                                function: (transaction) => setState(() {
                                  this.transaction = transaction;
                                  _atmBloc = AtmBloc(
                                      Location(
                                          lat: widget.position.latitude,
                                          long: widget.position.longitude),
                                      bankName,
                                      transaction);
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              }
              return loadResult(context);
            }),
      ),
    );
  }

// Notifications
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

// void initializing() async {
//   androidInitializationSettings =
//       AndroidInitializationSettings('@mipmap/appicon');
//   iosInitializationSettings = IOSInitializationSettings(
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//   initializationSettings = InitializationSettings(
//       android: androidInitializationSettings, iOS: iosInitializationSettings);
//   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//       onSelectNotification: (String payload) async {
//     if (payload != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) {
//             return SurveyScreen(atm: _atm, bankName: bankName);
//           },
//         ),
//       );
//     }
//   });
// }
//
// Future<void> notificationAfterSec() async {
//   var timeDelayed = DateTime.now().add(Duration(seconds: 5));
//   AndroidNotificationDetails androidNotificationDetails =
//       AndroidNotificationDetails(
//           'second channel ID', 'second Channel title', 'second channel body',
//           priority: Priority.high,
//           importance: Importance.max,
//           ticker: 'test');
//
//   IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
//
//   NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails, iOS: iosNotificationDetails);
//   await flutterLocalNotificationsPlugin.schedule(
//       1,
//       'تود افضل الخدمات لمكينات ال ATM 💳',
//       'فبملء البيانات التالية سنضمن لك خدمة اكثر راحة اضغط هنا 👇🏻',
//       timeDelayed,
//       notificationDetails);
// }
//
// Future onDidReceiveLocalNotification(
//     int id, String title, String body, String payload) async {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) {
//         return SurveyScreen(atm: _atm, bankName: bankName);
//       },
//     ),
//   );
// }
}
