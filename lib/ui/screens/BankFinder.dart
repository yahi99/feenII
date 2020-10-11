import 'dart:ui';

import 'package:feen/blocs/BankBloc.dart';
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
import 'package:geolocator/geolocator.dart';

class BankFinder extends StatefulWidget {
  final Position position;

  const BankFinder(this.position);

  State<BankFinder> createState() {
    return _AtmFinder();
  }
}

class _AtmFinder extends State<BankFinder> {
  Position _currentPosition;
  String bankName = "البنك الأهلي المصري", imgUrl, workTime, distance;
  List<String> bankNameList = [
    "البنك الأهلي المصري    ",
    "بنك مصر",
    "بنك القاهرة",
  ];
  BankBloc _bankBloc;

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.position;
    _bankBloc = BankBloc(
        Location(
            lat: widget.position.latitude, long: widget.position.longitude),
        bankName);
  }

  @override
  Widget build(BuildContext context) {
    checkInternet(context);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: StreamBuilder<List<PlaceResult>>(
            stream: _bankBloc.streamBankList,
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
                          child: MapOptionsWidget(
                            optionList: bankNameList,
                            function: (bankName) => setState(() {
                              this.bankName = bankName;
                              _bankBloc = BankBloc(
                                  Location(
                                      lat: widget.position.latitude,
                                      long: widget.position.longitude),
                                  bankName);
                            }),
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

  _workTime(String bankName) {
    if (bankName == "بنك مصر") {
      workTime = "مواعيد العمل من 8:30 حتى 16:00";
    } else if (bankName == "البنك الأهلي المصري") {
      workTime = "مواعيد العمل من 8:30 حتى 15:30";
    } else if (bankName == "بنك القاهرة")
      workTime = "مواعيد العمل من 8:30 حتى 15:00";
  }
}
