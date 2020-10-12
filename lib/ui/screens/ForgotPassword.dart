import 'package:auto_size_text/auto_size_text.dart';
import 'package:feen/network/Auth.dart';
import 'package:feen/network/Validate.dart';
import 'package:feen/ui/widgets/button_widget.dart';
import 'package:feen/ui/widgets/colors.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:feen/ui/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'Login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static String id = 'forgotpassword_screen';

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  Authnetwork authService = Authnetwork();
  String email;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              backWidget(context, 'الخطوة الأولى', kPrimaryColor),
              Container(
                  child: Image.asset('assets/icons/lock.png'),
                  height: screenSize.height * .2),
              Center(
                child: AutoSizeText(
                  'تغيير كلمة المرور',
                  textAlign: TextAlign.center,
                  style: kSloganTextStyle.apply(color: kPrimaryColor),
                  minFontSize: 14,
                  maxFontSize: 22,
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                          'سوف يتم ارسال رسالة إلى بريدك الألكتروني تحتوي على رابط لتغيير كلمة المرور.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.subtitle1),
                      SizedBox(height: 20),
                      TextFieldWidget(
                          validator: (value) => EmailValidator.validate(value),
                          onchanged: (value) => email = value,
                          labeltext: 'البريد الألكتروني',
                          prefixIcon: FlutterIcons.email_outline_mco,
                          obsecureText: false,
                          inputType: TextInputType.emailAddress),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.only(left: 16),
                alignment: Alignment.centerLeft,
                child: RoundedButton(
                  onPressed: () {
                    authService.resetPassword(email);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  color: kPrimaryColor,
                  textColor: Colors.white,
                  title: 'التالي',
                  leftMarginValue: 0,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
