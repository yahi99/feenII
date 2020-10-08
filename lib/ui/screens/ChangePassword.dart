import 'package:auto_size_text/auto_size_text.dart';
import 'package:feen/models/userData.dart';
import 'package:feen/network/Auth.dart';
import 'package:feen/network/Database.dart';
import 'package:feen/network/Validate.dart';
import 'package:feen/ui/widgets/button_widget.dart';
import 'package:feen/ui/widgets/colors.dart';
import 'package:feen/ui/widgets/textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'Profile.dart';

class ChangePasswordScreen extends StatefulWidget {
  final UserData currentUser;

  ChangePasswordScreen({this.currentUser});

  @override
  _ChangePasswordScreenState createState() =>
      _ChangePasswordScreenState(currentUser: currentUser);
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final UserData currentUser;

  _ChangePasswordScreenState({this.currentUser});

  bool obsecureText;

  @override
  void initState() {
    super.initState();
    obsecureText = true;
  }

  final _formKey = GlobalKey<FormState>();
  String password, confirmPassword, oldPassword;
  DatabaseService databaseService = DatabaseService();
  Authnetwork authService = Authnetwork();

  @override
  Widget build(BuildContext context) {
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);

    return Form(
      key: _formKey,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 32, 16, 0),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Ionicons.md_arrow_round_forward,
                            color: kPrimaryColor),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(width: 2),
                      Container(
                        child: AutoSizeText(
                          "تغيير كلمة المرور",
                          maxFontSize: 40,
                          minFontSize: 20.0,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: screenHeight * 0.2,
                    child: Image.asset('assets/icons/lock.png'),
                  ),
                  SizedBox(
                    height: screenHeight * .02,
                  ),
                  Container(
                      child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black12),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          PasswordFieldWidget(
                            validator: (value) {
                              return PasswordValidator.validate(value);
                            },
                            onchanged: (value) {
                              password = value;
                            },
                            labeltext: 'كلمة المرور القديمة',
                            obsecureText: obsecureText,
                            prefixIcon: Ionicons.ios_lock,
                            suffixIcon: obsecureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            onpressed: () {
                              setState(() => obsecureText = !obsecureText);
                            },
                          ),
                          PasswordFieldWidget(
                            validator: (value) {
                              return PasswordValidator.validate(value);
                            },
                            onchanged: (value) {
                              password = value;
                            },
                            labeltext: 'كلمة المرور الجديدة',
                            obsecureText: obsecureText,
                            prefixIcon: Ionicons.ios_lock,
                            suffixIcon: obsecureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            onpressed: () {
                              setState(() => obsecureText = !obsecureText);
                            },
                          ),
                          PasswordFieldWidget(
                            validator: (value) {
                              return ConfirmPasswordValidator.validate(
                                  password, value);
                            },
                            onchanged: (value) {
                              confirmPassword = value;
                            },
                            labeltext: 'تأكيد كلمة المرور الجديدة',
                            obsecureText: obsecureText,
                            prefixIcon: Ionicons.ios_lock,
                            suffixIcon: obsecureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            onpressed: () {
                              setState(() => obsecureText = !obsecureText);
                            },
                          )
                        ],
                      ),
                    ),
                  )),
                  SizedBox(height: 16),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: RoundedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          confirmation();
                        }
                      },
                      title: 'التالي',
                      color: kPrimaryColor,
                      textColor: Colors.white,
                      leftMarginValue: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> confirmation() async {
    return (await showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('هل انت متأكد من تعديل كلمة المرور؟',
                  style: TextStyle(fontFamily: 'Cairo', color: grey)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('لا',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold)),
                ),
                FlatButton(
                  onPressed: () {
                    authService.updatePassword(password);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ProfileScreen(
                                  userData: currentUser,
                                )));
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
