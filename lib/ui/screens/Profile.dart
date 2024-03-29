import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:feen/models/userData.dart';
import 'package:feen/network/Auth.dart';
import 'package:feen/network/Database.dart';
import 'package:feen/ui/widgets/ProfileHeader.dart';
import 'package:feen/ui/widgets/colors.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/position/gf_position.dart';
import 'package:getwidget/types/gf_button_type.dart';

import 'Dashboard.dart';
import 'EditProfile.dart';
import 'Login.dart';

class ProfileScreen extends StatefulWidget {
  final UserData userData;
  final bool infoChanged;

  ProfileScreen({this.userData, this.infoChanged});

  @override
  _ProfileScreenState createState() => _ProfileScreenState(
      userData: this.userData, infoChanged: this.infoChanged);
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  UserData userData;
  bool infoChanged;

  _ProfileScreenState({this.userData, this.infoChanged});

  static String firstName, lastName, email;
  static String phone, bank, status;
  static bool historyKey = false, informationKey = true;
  FancyDrawerController _controller;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    DatabaseService.loadHistory();
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 150))
      ..addListener(() {
        setState(() {});
      });
    isInfoChanged(widget.infoChanged);
  }

  isInfoChanged(bool key) {
    if (key == true) _controller.toggle();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getCurrentUser() async {
    if (infoChanged == true) {
      currentUser = await Authnetwork().currentUser();
      currentUser = await Authnetwork().currentUser();
      firstName = currentUser.firstName;
      lastName = currentUser.lastName;
      phone = currentUser.phoneNumber;
      email = currentUser.email;
      status = currentUser.job;
    } else {
      firstName = userData.firstName;
      lastName = userData.lastName;
      phone = userData.phoneNumber;
      email = userData.email;
      status = userData.job;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);
    return FancyDrawerWrapper(
      controller: _controller,
      cornerRadius: 30,
      hideOnContentTap: true,
      drawerItems: <Widget>[
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 24),
              width: 180,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: kGrey, width: 2),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25)),
              ),
              child: Column(
                children: <Widget>[
                  GFButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (builder) =>
                                EditDataScreen(userData: currentUser))),
                    text: "تعديل البيانات",
                    fullWidthButton: true,
                    color: kPrimaryColor,
                    position: GFPosition.end,
                    icon: Icon(FlutterIcons.account_edit_outline_mco),
                    textStyle: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  ),
                  GFButton(
                    fullWidthButton: true,
                    onPressed: () => Fluttertoast.showToast(msg: "قريبا"),
                    text: "عن التطبيق",
                    color: kPrimaryColor,
                    position: GFPosition.end,
                    icon: Icon(FlutterIcons.alert_box_outline_mco),
                    textStyle: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  ),
                  GFButton(
                    fullWidthButton: true,
                    onPressed: () => Fluttertoast.showToast(msg: "قريبا"),
                    text: "تواصل معنا",
                    color: kPrimaryColor,
                    position: GFPosition.end,
                    icon: Icon(FlutterIcons.contacts_ant),
                    textStyle: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              width: 180,
              child: GFButton(
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => LoginScreen()));
                },
                text: "تسجيل الخروج",
                color: kPrimaryColor,
                type: GFButtonType.outline2x,
                position: GFPosition.end,
                icon: Icon(FlutterIcons.exit_to_app_mdi),
                textStyle: Theme.of(context).textTheme.button,
              ),
            ),
          ],
        )
      ],
      child: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipPath(
                    child: Container(
                      height: screenHeight * 0.3,
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(220)),
                      ),
                    ),
                  ),
                  backWidget(context, "الصفحة الشخصية", Colors.white),
                  ProfileHeader(
                    avatar: AssetImage('assets/icons/user.png'),
                    firstName: firstName != null ? firstName : "االاسم الأول",
                    lastName: lastName != null ? lastName : "الاسم الأخير",
                    radius: screenHeight * .07,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.fromLTRB(8, 32, 0, 0),
                    child: IconButton(
                        icon: Icon(FlutterIcons.md_menu_ion,
                            color: gold, size: 32),
                        onPressed: () => _controller.toggle()),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    color: informationKey ? kSilver : Colors.white,
                    onPressed: () => setState(() {
                      informationKey = !informationKey;
                      historyKey = !historyKey;
                    }),
                    child: Text(
                      'المعملومات الشخصية',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                  FlatButton(
                    color: historyKey ? kSilver : Colors.white,
                    onPressed: () => setState(() {
                      historyKey = !historyKey;
                      informationKey = !informationKey;
                    }),
                    child: Text(
                      'السجل',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              informationKey == true ? informationWidget() : historyWidget(),
            ],
          ),
        ),
      ),
    );
  }

  informationWidget() {
    final screenSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.email, color: kGrey)),
            title: Text(
              "البريد الاكتروني",
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(email ?? "البريد الاكتروني",
                style: TextStyle(fontWeight: FontWeight.w500, color: kGrey)),
          ),
          SizedBox(
            width: screenSize.width,
            child: Divider(height: 0.5, thickness: 1.0, color: Colors.black12),
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.smartphone, color: kGrey)),
            title: Text(
              "رقم الهاتف",
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(phone ?? "رقم الهاتف",
                style: TextStyle(fontWeight: FontWeight.w500, color: kGrey)),
          ),
          SizedBox(
            width: screenSize.width,
            child: Divider(height: 0.5, thickness: 1.0, color: Colors.black12),
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.business_center, color: kGrey)),
            title: Text(
              "حالة العمل",
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(status ?? "حالة العمل",
                style: TextStyle(fontWeight: FontWeight.w500, color: kGrey)),
          ),
          SizedBox(
            width: screenSize.width,
            child: Divider(height: 0.5, thickness: 1.0, color: Colors.black12),
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(FlutterIcons.bank_faw, color: kGrey)),
            title: Text(
              "البنك التابع له",
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(bank ?? "لم يحدد بعد",
                style: TextStyle(fontWeight: FontWeight.w500, color: kGrey)),
          ),
        ],
      ),
    );
  }

  historyWidget() {
    final screenSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: screenSize.width,
            child: Divider(height: 0.5, thickness: 1.0, color: Colors.black12),
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.smartphone, color: kGrey)),
            title: Text(
              "رقم الهاتف",
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(phone ?? "رقم الهاتف",
                style: TextStyle(fontWeight: FontWeight.w500, color: kGrey)),
          ),
          SizedBox(
            width: screenSize.width,
            child: Divider(height: 0.5, thickness: 1.0, color: Colors.black12),
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.business_center, color: kGrey)),
            title: Text(
              "حالة العمل",
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(status ?? "حالة العمل",
                style: TextStyle(fontWeight: FontWeight.w500, color: kGrey)),
          ),
          SizedBox(
            width: screenSize.width,
            child: Divider(height: 0.5, thickness: 1.0, color: Colors.black12),
          ),
          ListTile(
            leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(FlutterIcons.bank_faw, color: kGrey)),
            title: Text(
              "البنك التابع له",
              style:
                  TextStyle(color: kPrimaryColor, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(bank ?? "لم يحدد بعد",
                style: TextStyle(fontWeight: FontWeight.w500, color: kGrey)),
          ),
        ],
      ),
    );
  }
}
