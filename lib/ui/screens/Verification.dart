import 'package:auto_size_text/auto_size_text.dart';
import 'package:feen/ui/widgets/button_widget.dart';
import 'package:feen/ui/widgets/colors.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

import 'SignUp.dart';

// ignore: must_be_immutable
class VerificationScreen extends StatefulWidget {
  String phone;
  final String verificationId;

  VerificationScreen({this.verificationId, this.phone});

  static String id = 'verification_page';

  @override
  _VerificationScreenState createState() =>
      _VerificationScreenState(phone: phone);
}

class _VerificationScreenState extends State<VerificationScreen> {
  final String phone;
  final _smsController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _VerificationScreenState({this.phone});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              backWidget(context, "الخطوة الثانية", kPrimaryColor),
              Container(
                  child: Image.asset('assets/icons/valid.png'),
                  height: screenSize.height * .2),
              Center(
                child: AutoSizeText(
                  'تأكيد رقم الهاتف',
                  style: kSloganTextStyle.apply(color: kPrimaryColor),
                  minFontSize: 14,
                  maxFontSize: 22,
                ),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                    'يرجى التحقق من رسائلك بحثًا عن رمز أمان مكون من ستة أرقام وإدخله في الاسفل',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1),
              ),
              SizedBox(height: screenSize.height * 0.02),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: PinEntryTextField(
                    fields: 6,
                    fontSize: screenSize.height * .03,
                    fieldWidth: screenSize.width * .085,
                    onSubmit: (String pin) => _smsController.text = pin,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.only(left: 16),
                alignment: Alignment.topLeft,
                child: RoundedButton(
                    onPressed: _signInWithPhoneNumber,
                    color: kPrimaryColor,
                    textColor: Colors.white,
                    title: 'التالي',
                    leftMarginValue: 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithPhoneNumber() async {
    String errorMessage;
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: widget.verificationId,
      smsCode: _smsController.text,
    );
    AuthResult result;
    await _auth.signInWithCredential(credential).then((u) async {
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(result.user.uid == currentUser.uid);
      if (result.user != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => SignUpScreen(phone: phone)));
      } else {
        Fluttertoast.showToast(msg: "فشل في محاولة تسجيل الدخول");
      }
    }).catchError((error) {
      print(error.code);
      switch (error.code) {
        case "ERROR_INVALID_VERIFICATION_CODE":
          errorMessage = "الرمز اللذي ادخاته غير صحيح";
          break;
        default:
          errorMessage = "اعد المحاولة لاحقا";
      }
      if (errorMessage != null) {
        Fluttertoast.showToast(msg: errorMessage);
      }
    });
  }
}
