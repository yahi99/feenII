import 'package:auto_size_text/auto_size_text.dart';
import 'package:feen/models/userData.dart';
import 'package:feen/network/Auth.dart';
import 'package:feen/network/Validate.dart';
import 'package:feen/ui/screens/ForgotPassword.dart';
import 'package:feen/ui/screens/PhoneInsertion.dart';
import 'package:feen/ui/widgets/animation/FadeAnimation.dart';
import 'package:feen/ui/widgets/button_widget.dart';
import 'package:feen/ui/widgets/colors.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:feen/ui/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Dashboard.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);
  static String id = 'login_page';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _LoginScreenState();

  bool obsecureText;

  @override
  void initState() {
    super.initState();
    obsecureText = true;
  }

  final _formKey = GlobalKey<FormState>();

  String email;
  String pass;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FadeAnimation(
                    1,
                    Container(
                        margin: EdgeInsets.only(top: screenSize.height * 0.2),
                        child: Image(
                            image: AssetImage('assets/icons/feenLogo.png')),
                        height: screenSize.height * .2)),
                SizedBox(height: 8),
                FadeAnimation(
                  1.2,
                  AutoSizeText('وفر وقتك. وفر مجهودك.',
                      minFontSize: 12.0,
                      maxFontSize: 18.0,
                      textAlign: TextAlign.center,
                      style: kSloganTextStyle),
                ),
                SizedBox(height: screenSize.height * 0.03),
                FadeAnimation(
                  1.4,
                  Card(
                    elevation: 8,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          FadeAnimation(
                            1.6,
                            TextFieldWidget(
                                validator: (value) =>
                                    EmailValidator.validate(value),
                                onchanged: (value) => email = value,
                                labeltext: 'البريد الألكتروني',
                                hintText: 'abcd@example.com',
                                inputType: TextInputType.emailAddress,
                                obsecureText: false,
                                prefixIcon: FlutterIcons.user_circle_faw5s),
                          ),
                          FadeAnimation(
                            1.8,
                            PasswordFieldWidget(
                              onchanged: (value) => pass = value,
                              labeltext: 'كلمة المرور',
                              validator: (value) =>
                                  PasswordValidator.validate(value),
                              obsecureText: obsecureText,
                              prefixIcon: Ionicons.ios_lock,
                              suffixIcon: obsecureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              onpressed: () =>
                                  setState(() => obsecureText = !obsecureText),
                            ),
                          ),
                          FadeAnimation(
                            2.0,
                            FlatButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen())),
                              child: Text('نسيت كلمة السر؟'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.025),
                FadeAnimation(
                  2.2,
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerLeft,
                    child: RoundedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate())
                            signIn(email, pass);
                        },
                        title: 'تسجيل الدخول',
                        textColor: Colors.white,
                        color: kPrimaryColor,
                        leftMarginValue: 0),
                  ),
                ),
                FadeAnimation(
                  2.4,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('ليس لديك حساب؟'),
                      SizedBox(width: 8),
                      InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, PhoneInsertionScreen.id),
                          child: Text(
                            'إنشاء حساب',
                            style: TextStyle(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w600),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future signIn(String email, String password) async {
    String errorMessage;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      UserData userdata = await Authnetwork().currentUser();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return DashboardScreen(userSurvey: userdata.survey);
          },
        ),
      );
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "البريد الأكتروني غير صحيح";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "كلمة المروم غير صحيحة";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "البريد الأكتروني غير مسجل";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "اعد المحاولة لاحقا";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "اعد المحاولة لاحقا";
      }
    }

    if (errorMessage != null) {
      Fluttertoast.showToast(msg: errorMessage);
    }
  }
}
