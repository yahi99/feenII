import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:feen/network/Validate.dart';
import 'package:feen/ui/widgets/button_widget.dart';
import 'package:feen/ui/widgets/colors.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:feen/ui/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Login.dart';
import 'SignUp.dart';
import 'Verification.dart';

class PhoneInsertionScreen extends StatefulWidget {
  PhoneInsertionScreen({Key key}) : super(key: key);

  static String id = 'phoneinsertion_screen';

  @override
  _PhoneInsertionScreenState createState() => _PhoneInsertionScreenState();
}

class _PhoneInsertionScreenState extends State<PhoneInsertionScreen> {
  _PhoneInsertionScreenState();

  String phone;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    phone = "";
  }

  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {}
    } on SocketException catch (_) {
      noInternetConnection();
    }
  }

  Future<bool> noInternetConnection() async {
    return (await showDialog(
          context: context,
          builder: (context) => Directionality(
            textDirection: TextDirection.rtl,
            child: new AlertDialog(
              title: new Text('عذرا ، لا يوجد اتصال بالإنترنت',
                  style: TextStyle(fontFamily: 'Cairo', color: kPrimaryColor)),
              content: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: Image.asset('lib/assets/icons/noInternet.png')),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
            ),
          ),
        )) ??
        false;
  }

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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  backWidget(context, "الخطوة الأولى", kPrimaryColor),
                  Container(
                      child: Image.asset('assets/icons/sms.png'),
                      height: screenSize.height * .2),
                  AutoSizeText(
                    'تسجيل رقم الهاتف',
                    textAlign: TextAlign.center,
                    style: kSloganTextStyle.apply(color: kPrimaryColor),
                    minFontSize: 14,
                    maxFontSize: 22,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                              'سوف يتم ارسال رسالة تحتوي على ستة أرقام للرقم الذي سيتم ادخاله.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.subtitle1),
                          SizedBox(height: 20),
                          TextFieldWidget(
                            validator: (value) =>
                                PhoneNumberValidator.validate(value),
                            onchanged: (value) => phone = value,
                            labeltext: 'رقم الهاتف',
                            prefixIcon: FlutterIcons.mobile_phone_faw,
                            obsecureText: false,
                            inputType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.only(left: 16),
                    alignment: Alignment.topLeft,
                    child: RoundedButton(
                      onPressed: () {
                        checkInternet();
                        if (_formKey.currentState.validate()) {
                          phoneNumber();
                        }
                      },
                      color: kPrimaryColor,
                      textColor: Colors.white,
                      title: 'التالي',
                      leftMarginValue: 0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void phoneNumber() async {
    showDialog(
      context: context,
      builder: (_) => loadResult(context),
    );

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) async {
      final result = (await _auth.signInWithCredential(phoneAuthCredential));

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(result.user.uid == currentUser.uid);

      if (result.user != null) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => SignUpScreen(phone: phone)));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
        Fluttertoast.showToast(msg: "اعد المحاولة لاحقا");
      }
    };

    final PhoneVerificationFailed verificationFailed = (authException) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'عذرا, رقم الهاتف غير صحيح');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VerificationScreen(
                  verificationId: verificationId, phone: phone)));
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {};

    await _auth.verifyPhoneNumber(
        phoneNumber: "+2$phone",
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}
