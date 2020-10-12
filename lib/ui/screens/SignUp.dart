import 'package:auto_size_text/auto_size_text.dart';
import 'package:feen/network/Auth.dart';
import 'package:feen/network/Validate.dart';
import 'package:feen/ui/widgets/button_widget.dart';
import 'package:feen/ui/widgets/colors.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:feen/ui/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'Introduction.dart';

class SignUpScreen extends StatefulWidget {
  final String phone;

  SignUpScreen({this.phone});

  static String id = 'signup_page';

  @override
  _SignUpScreen createState() => _SignUpScreen(phone: this.phone);
}

class _SignUpScreen extends State<SignUpScreen> {
  final String phone;

  _SignUpScreen({this.phone});

  Authnetwork _auth = Authnetwork();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool obsecureText;

  @override
  void initState() {
    super.initState();
    obsecureText = true;
  }

  String email;
  String password;
  String confirmPassword;
  String firstName;
  String mobileNumber;
  String lastName;
  int _selected;
  String job;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Form(
        key: _formKey,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  backWidget(context, 'الخطوة الثالثة', kPrimaryColor),
                  Container(
                      child: Image.asset('assets/icons/form.png'),
                      height: screenSize.height * .2),
                  AutoSizeText(
                    'إنشاء حساب',
                    minFontSize: 16,
                    maxFontSize: 26,
                    textAlign: TextAlign.center,
                    style: kSloganTextStyle.copyWith(
                        fontSize: 26.0, color: kPrimaryColor),
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Card(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Column(
                          children: <Widget>[
                            TextFieldWidget(
                              validator: (value) =>
                                  NameValidator.validate(value),
                              onchanged: (value) => firstName = value,
                              labeltext: 'الأسم الاول',
                              hintText: 'الأسم الأول',
                              obsecureText: false,
                              prefixIcon: FlutterIcons.user_circle_faw5s,
                            ),
                            TextFieldWidget(
                              validator: (value) =>
                                  NameValidator.validate(value),
                              onchanged: (value) => lastName = value,
                              labeltext: 'أسم العائلة',
                              hintText: 'أسم العائلة',
                              obsecureText: false,
                              prefixIcon: FlutterIcons.user_circle_faw5s,
                            ),
                            TextFieldWidget(
                              validator: (value) =>
                                  EmailValidator.validate(value),
                              onchanged: (value) => email = value,
                              labeltext: 'البريد الألكتروني',
                              hintText: 'abcd@example.com',
                              inputType: TextInputType.emailAddress,
                              obsecureText: false,
                              prefixIcon: FlutterIcons.email_outline_mco,
                            ),
                            PasswordFieldWidget(
                              validator: (value) =>
                                  PasswordValidator.validate(value),
                              onchanged: (value) => password = value,
                              labeltext: 'كلمة المرور',
                              obsecureText: obsecureText,
                              prefixIcon: Ionicons.ios_lock,
                              suffixIcon: obsecureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              onpressed: () =>
                                  setState(() => obsecureText = !obsecureText),
                            ),
                            PasswordFieldWidget(
                              validator: (value) =>
                                  ConfirmPasswordValidator.validate(
                                      password, value),
                              labeltext: 'تأكيد كلمة المرور',
                              onchanged: (value) => confirmPassword = value,
                              obsecureText: obsecureText,
                              prefixIcon: Ionicons.ios_lock,
                              suffixIcon: obsecureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              onpressed: () =>
                                  setState(() => obsecureText = !obsecureText),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Radio(
                                  activeColor: kLightGreen,
                                  value: 0,
                                  groupValue: _selected,
                                  onChanged: (value) {
                                    setState(() => _selected = value);
                                  },
                                ),
                                Text('متقاعد', style: kLabelTextStyle),
                                Radio(
                                  activeColor: kLightGreen,
                                  value: 1,
                                  groupValue: _selected,
                                  onChanged: (value) {
                                    setState(() => _selected = value);
                                  },
                                ),
                                Text('تعمل', style: kLabelTextStyle),
                              ],
                            )
                          ],
                        ),
                      )),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    alignment: Alignment.centerLeft,
                    child: RoundedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if (_selected == 0) {
                              job = 'متقاعد';
                            } else {
                              job = 'تعمل';
                            }
                            dynamic result = await _auth.createAuthUser(email,
                                password, firstName, lastName, phone, job);
                            if (result != null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (builder) =>
                                          IntroductionScreen()));
                            }
                          }
                        },
                        color: kPrimaryColor,
                        textColor: Colors.white,
                        title: 'التالي',
                        leftMarginValue: 0),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
