import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:feen/ui/widgets/colors.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Tips extends StatefulWidget {
  @override
  State<Tips> createState() => _Tips();
}

class _Tips extends State<Tips> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = (MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top);

    return Scaffold(
      backgroundColor: primaryColor,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: <Widget>[
            backWidget(context, "إرشادات و تعليمات", Colors.white),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: ListView(
                    children: <Widget>[
                      tipsItem(
                          tip000 +
                              tip001 +
                              tip002 +
                              tip003 +
                              tip004 +
                              tip005 +
                              tip006 +
                              tip007 +
                              tip008 +
                              tip009 +
                              tip010 +
                              tip011 +
                              tip012 +
                              tip013 +
                              tip014,
                          'assets/icons/important.png',
                          'معلومات اساسية'),
                      SizedBox(height: 8),
                      tipsItem(tip01000 + tip01001 + tip01002 + tip01003,
                          'assets/icons/withdraw.png', 'خمة السحب'),
                      SizedBox(height: 8),
                      tipsItem(tip1 + tip2 + tip3 + tip4 + tip5 + tip6,
                          'assets/icons/deposit.png', 'خدمة الإيداع'),
                      SizedBox(height: 8),
                      tipsItem(
                          tip101 +
                              tip102 +
                              tip103 +
                              tip104 +
                              tip105 +
                              tip106 +
                              tip107 +
                              tip108 +
                              tip109 +
                              tip1010,
                          'assets/icons/deposit.png',
                          'خدمة الإيداع بدون بطاقة'),
                      SizedBox(height: 8),
                      tipsItem(tip01 + tip02 + tip03, 'assets/icons/bill.png',
                          'خدمة معرفة الرصيد'),
                      SizedBox(height: 8),
                      tipsItem(
                          tip11 + tip12 + tip13 + tip14 + tip15 + tip16,
                          'assets/icons/dollarToEuro.png',
                          'خدمة التحويل من عملة الي اخري'),
                      SizedBox(height: 8),
                      tipsItem(
                          tip111 +
                              tip112 +
                              tip113 +
                              tip114 +
                              tip115 +
                              tip116 +
                              tip117 +
                              tip118,
                          'assets/icons/smartWallet.png',
                          'خدمة المحفظة الذكية'),
                      SizedBox(height: 8),
                      tipsItem(tip110 + tip120 + tip130 + tip140 + tip150,
                          'assets/icons/donate.png', 'خدمة التبرع'),
                      SizedBox(height: 8),
                      tipsItem(tipp + tippp, 'assets/icons/problem.png',
                          'مشكلة سحب النقدية و عدم الإيداع'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tipsItem(String text, String imgPath, String title) {
    return ExpansionTileCard(
      leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 40,
          child: Image.asset(imgPath)),
      title: Text(title, style: normalText.apply(color: primaryColor)),
      subtitle:
          Text(' إضغط للمزيد', style: smallText.apply(color: Colors.black87)),
      baseColor: Colors.white,
      elevation: 8,
      borderRadius: BorderRadius.all(Radius.circular(15)),
      expandedColor: silver,
      children: <Widget>[
        Divider(thickness: 1.0, height: 1.0),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(text,
                style: normalText.apply(
                    color: Colors.black87, fontSizeFactor: 0.9)),
          ),
        ),
      ],
    );
  }
}
