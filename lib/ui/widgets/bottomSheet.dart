import 'package:cached_network_image/cached_network_image.dart';
import 'package:feen/models/PlaceResult.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:feen/ui/widgets/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/rating/gf_rating.dart';
import 'package:getwidget/shape/gf_button_shape.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import 'colors.dart';

class BottomSheetWidget extends StatefulWidget {
  final List<PlaceResult> placeList;

  BottomSheetWidget({this.placeList});

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
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
    final screenSize = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SlidingSheet(
        controller: controller,
        color: Colors.white,
        elevation: 15,
        cornerRadius: 30,
        closeOnBackButtonPressed: true,
        border: Border.all(color: Colors.black45, width: 2),
        snapSpec: SnapSpec(
            positioning: SnapPositioning.relativeToSheetHeight,
            snappings: const [SnapSpec.headerFooterSnap, SnapSpec.expanded]),
        listener: (state) {
          this.state = state;
          setState(() => null);
        },
        headerBuilder: buildHeader,
        footerBuilder: buildFooter,
        builder: buildChild,
      ),
    );
  }

  Widget buildHeader(BuildContext context, SheetState state) {
    final screenSize = MediaQuery.of(context).size;
    return CustomContainer(
        animate: true,
        height: screenSize.height * 0.25,
        child: Column(children: <Widget>[
          SizedBox(height: 8),
          Align(
              alignment: Alignment.topCenter,
              child: CustomContainer(
                  width: 46,
                  height: 4,
                  borderRadius: 5,
                  color: Colors.black12)),
          Expanded(child: bodyWidget())
        ]));
  }

  Widget bodyWidget() {
    List<PlaceResult> place = widget.placeList;
    final screenSize = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: place.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            setState(() {
              atmDistance = place[index].distance;
              atmVicinity = place[index].vicinity;
              atmStatus = place[index].enoughMoney;
            });
          },
          child: Container(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 4),
            width: screenSize.width * 0.85,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(20)),
                border: Border.all(color: Colors.grey)),
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 28,
                    child: CachedNetworkImage(
                        imageUrl: alahlyImgUrl,
                        imageBuilder: (context, imageProvider) => Container(
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(place[index].name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(color: kPrimaryColor, height: 1.5),
                            overflow: TextOverflow.ellipsis),
                        SizedBox(
                            width: 150.0,
                            child: Divider(
                                thickness: 2.0,
                                height: 3.0,
                                color: Colors.black12)),
                        Text(place[index].vicinity,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(height: 1.5),
                            overflow: TextOverflow.ellipsis),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(FlutterIcons.map_marker_distance_mco,
                                  color: Colors.black38, size: 16),
                              Text(
                                  "  على بعد  " +
                                      place[index].distance +
                                      "  كم",
                                  style: TextStyle(fontSize: 10.5))
                            ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildFooter(BuildContext context, SheetState state) {
    final screenSize = MediaQuery.of(context).size;
    return CustomContainer(
      animate: true,
      height: screenSize.height * 0.08,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GFButton(
            onPressed: () async {
              await controller.hide();
              Future.delayed(Duration(milliseconds: 2000), () {
                controller.show();
                controller.rebuild();
              });
            },
            color: kPrimaryColor,
            text: 'إذهب',
            shape: GFButtonShape.pills,
            textStyle: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Colors.white),
            icon: Icon(Ionicons.ios_navigate),
          ),
          GFButton(
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
            color: kPrimaryColor,
            text: !isExpanded ? 'التفاصيل' : 'الخريطة',
            textStyle: Theme.of(context).textTheme.button,
            icon: Icon(
                !isExpanded ? Ionicons.ios_list : FlutterIcons.map_legend_mco),
          ),
        ],
      ),
    );
  }

  Widget buildChild(BuildContext context, SheetState state) {
    final divider = Container(height: 1, color: Colors.black12);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 12),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("التفاصيل",
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: kPrimaryColor, fontWeight: FontWeight.bold))),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 16, 8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  atmDetails(atmStatus, Ionicons.ios_people, context),
                  SizedBox(height: 16),
                  atmDetails(atmStatus, Ionicons.ios_cash, context),
                  SizedBox(height: 16),
                  atmDetails(atmType, Icons.atm, context),
                  SizedBox(height: 16),
                  atmDetails(atmVicinity, Icons.location_on, context),
                  SizedBox(height: 16),
                  atmDetails("على بعد  " + atmDistance + "  كم",
                      FlutterIcons.map_marker_distance_mco, context),
                  SizedBox(height: 16),
                  divider
                ]),
          )
        ],
      ),
    );
  }

  Row atmDetails(String text, IconData icon, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        Container(
            width: screenSize.width - 48,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(text,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1)),
      ],
    );
  }
}
