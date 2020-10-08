import 'package:cached_network_image/cached_network_image.dart';
import 'package:feen/models/PlaceResult.dart';
import 'package:feen/ui/widgets/custom_container.dart';
import 'package:feen/ui/widgets/defaultData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'colors.dart';

class BuildSheetWidget extends StatefulWidget {
  final List<PlaceResult> placeList;

  BuildSheetWidget({this.placeList});

  @override
  _BuildSheetWidgetState createState() => _BuildSheetWidgetState();
}

class _BuildSheetWidgetState extends State<BuildSheetWidget> {
  SheetController controller;
  SheetState state;
  double rating = 0.0;
  String atmType = 'نوع الماكينة',
      atmVicinity = 'عنوان الماكينة',
      atmStatus = 'حاللة الماكينة',
      atmDistance = '0.0';

  bool get isExpanded => state?.isExpanded ?? false;

  bool get isCollapsed => state?.isCollapsed ?? true;

  @override
  void initState() {
    super.initState();
    controller = SheetController();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingSheet(
      controller: controller,
      color: Colors.white,
      elevation: 18,
      cornerRadius: 25,
      closeOnBackButtonPressed: true,
      border: Border.all(color: Colors.black45, width: 2),
      snapSpec: SnapSpec(
          snap: true, positioning: SnapPositioning.relativeToAvailableSpace),
      scrollSpec: ScrollSpec.bouncingScroll(),
      listener: (state) {
        this.state = state;
        setState(() => null);
      },
      headerBuilder: buildHeader,
      footerBuilder: buildFooter,
      builder: buildChild,
    );
  }

  Widget buildHeader(BuildContext context, SheetState state) {
    final screenSize = MediaQuery.of(context).size;
    return CustomContainer(
        animate: true,
        height: screenSize.height * 0.25,
        color: Colors.white,
        child: Column(children: <Widget>[
          SizedBox(height: 8),
          Align(
              alignment: Alignment.topCenter,
              child: CustomContainer(
                  width: 46,
                  height: 4,
                  borderRadius: 2,
                  color: Colors.black12)),
          bodyWidget()
        ]));
  }

  Widget bodyWidget() {
    List<PlaceResult> place = widget.placeList;
    final screenSize = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: screenSize.width * 0.95,
        height: screenSize.height * 0.22,
        child: ListView.builder(
          itemCount: place.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
                margin: EdgeInsets.fromLTRB(4, 8, 0, 0),
                width: screenSize.width * 0.85,
                child: Card(
                    color: silver,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black26),
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(25)),
                    ),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            atmDistance = place[index].distance;
                            atmVicinity = place[index].vicinity;
                            atmStatus = place[index].enoughMoney;
                          });
                        },
                        child: Row(children: <Widget>[
                          Expanded(
                              flex: 28,
                              child: CachedNetworkImage(
                                  imageUrl: "imgUrl",
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover))))),
                          SizedBox(width: 4.0),
                          Expanded(
                              flex: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(place[index].name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w700,
                                              color: primaryColor)),
                                      SizedBox(
                                          width: 150.0,
                                          child: Divider(
                                              thickness: 2.0,
                                              height: 3.0,
                                              color: Colors.white)),
                                      Text(place[index].vicinity,
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 10.5)),
                                      GFRating(
                                          value: place[index].rating,
                                          size: 15,
                                          color: Colors.amber,
                                          itemCount: 5,
                                          allowHalfRating: true,
                                          borderColor: Colors.black38,
                                          onChanged: (value) {
                                            setState(() => rating = value);
                                          }),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                              FlutterIcons
                                                  .map_marker_distance_mco,
                                              color: Colors.black38,
                                              size: 16),
                                          Text(
                                            "  على بعد  " +
                                                place[index].distance +
                                                "  كم",
                                            style: TextStyle(fontSize: 10.5),
                                          ),
                                        ],
                                      ),
                                    ]),
                              )),
                        ]))));
          },
        ),
      ),
    );
  }

  Widget buildFooter(BuildContext context, SheetState state) {
    final screenSize = MediaQuery.of(context).size;
    return CustomContainer(
        animate: true,
        height: screenSize.height * 0.08,
        elevation: !isCollapsed && !state.isAtBottom ? 8 : 0,
        shadowDirection: ShadowDirection.top,
        padding: EdgeInsets.all(4),
        color: Colors.white,
        shadowColor: Colors.black12,
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Expanded(
                child: GFButton(
                  onPressed: () async {
                    await controller.hide();
                    Future.delayed(const Duration(milliseconds: 2000), () {
                      controller.show();
                      controller.rebuild();
                    });
                  },
                  color: primaryColor,
                  text: 'إذهب',
                  shape: GFButtonShape.pills,
                  textStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                  icon: Icon(Ionicons.ios_navigate),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: GFButton(
                  onPressed: () {
                    controller.rebuild();
                    if (isExpanded == true) {
                      controller.collapse();
                    } else {
                      controller.expand();
                    }
                  },
                  type: GFButtonType.outline,
                  shape: GFButtonShape.pills,
                  color: primaryColor,
                  text: !isExpanded ? 'التفاصيل' : 'الخريطة',
                  textStyle: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w600),
                  icon: Icon(!isExpanded
                      ? Ionicons.ios_list
                      : FlutterIcons.map_legend_mco),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: GFButton(
                  onPressed: () async {
                    await controller.hide();
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      controller.show();
                      controller.rebuild();
                    });
                  },
                  type: GFButtonType.outline,
                  shape: GFButtonShape.pills,
                  color: primaryColor,
                  text: 'إعادة بحث',
                  textStyle: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.w600),
                  icon: Icon(Ionicons.ios_refresh),
                ),
              )
            ])));
  }

  Widget buildChild(BuildContext context, SheetState state) {
    final divider = Container(height: 1, color: Colors.black12);
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              divider,
              SizedBox(height: 12),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("التفاصيل",
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 16))),
              Padding(
                  padding: EdgeInsets.fromLTRB(8, 16, 16, 8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          AtmStatus.crowdingStatus != null
                              ? AtmStatus.crowdingStatus
                              : "كثافة الماكينة",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                        Text(
                          atmStatus,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                        Text(
                          atmType,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                        Text(
                          atmVicinity,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "على بعد  " + atmDistance + "  كم",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 16),
                        divider
                      ]))
            ]));
  }
}
