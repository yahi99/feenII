import 'package:feen/models/userData.dart';
import 'package:feen/network/Auth.dart';
import 'package:feen/network/Database.dart';
import 'package:feen/network/Validate.dart';
import 'package:feen/ui/screens/Profile.dart';
import 'package:feen/ui/widgets/ProfileHeader.dart';
import 'package:feen/ui/widgets/button_widget.dart';
import 'package:feen/ui/widgets/colors.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:feen/ui/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'ChangePassword.dart';

class EditDataScreen extends StatefulWidget {
  final UserData userData;

  EditDataScreen({this.userData});

  @override
  _EditDataScreenState createState() =>
      _EditDataScreenState(userData: userData);
}

class _EditDataScreenState extends State<EditDataScreen> {
  final UserData userData;

  _EditDataScreenState({this.userData});

  final _formKey = GlobalKey<FormState>();
  String email, firstName, phone, lastName;
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
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                backWidget(context, "تعديل البيانات", kPrimaryColor),
                Avatar(
                    image: AssetImage('assets/icons/user.png'),
                    borderWidth: MediaQuery.of(context).size.height * .005,
                    bordercolor: Colors.white,
                    backgroundcolor: Colors.white,
                    radius: screenHeight * .08),
                SizedBox(height: screenHeight * .02),
                Container(
                    height: screenHeight * 0.6,
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            TextFieldWidget(
                              onchanged: (value) {
                                firstName = value;
                              },
                              labeltext: 'الأسم الأول',
                              validator: (value) {
                                if (value.isEmpty) {
                                  return null;
                                } else {
                                  return NameValidator.validate(value);
                                }
                              },
                              prefixIcon: FlutterIcons.user_circle_faw5s,
                            ),
                            TextFieldWidget(
                                onchanged: (value) {
                                  lastName = value;
                                },
                                labeltext: 'أسم العائلة',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return null;
                                  } else {
                                    return NameValidator.validate(value);
                                  }
                                },
                                prefixIcon: FlutterIcons.user_circle_faw5s),
                            TextFieldWidget(
                                onchanged: (value) {
                                  email = value;
                                },
                                labeltext: 'البريد الألكتروني',
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return null;
                                  } else {
                                    return EmailValidator.validate(value);
                                  }
                                },
                                prefixIcon: FlutterIcons.email_outline_mco),
                            TextFieldWidget(
                              validator: (value) {
                                if (value.isEmpty) {
                                  return null;
                                } else {
                                  return PhoneNumberValidator.validate(value);
                                }
                              },
                              onchanged: (value) {
                                phone = value;
                              },
                              labeltext: 'رقم الهاتف',
                              prefixIcon: FlutterIcons.mobile_phone_faw,
                            ),
                            FlatButton(
                              child: Text('تغيير كلمة المرور',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          ChangePasswordScreen())),
                            ),
                          ],
                        ),
                      ),
                    )),
                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.only(left: 16),
                  alignment: Alignment.centerLeft,
                  child: RoundedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        if (firstName != null ||
                            lastName != null ||
                            email != null ||
                            phone != null) {
                          confirmation();
                        }
                      }
                    },
                    title: 'تأكيد',
                    textColor: Colors.white,
                    color: kPrimaryColor,
                    leftMarginValue: 0,
                  ),
                ),
              ],
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
              title: Text('هل انت متأكد من تعديل البيانات؟',
                  style: TextStyle(color: kGrey)),
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
                  onPressed: () async {
                    editProfileData();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => ProfileScreen(
                                userData: userData, infoChanged: true)));
                    //editUser =  await Authnetwork().CurrentUser();
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

  void editProfileData() async {
    if (firstName != null) {
      databaseService.editData("firstName", firstName);
    }
    if (lastName != null) {
      databaseService.editData("lastName", lastName);
    }
    if (email != null) {
      authService.updateEmail(email);
      databaseService.editData("email", email);
    }
    if (phone != null) {
      databaseService.editData("phoneNumber", phone);
    }
  }
}
