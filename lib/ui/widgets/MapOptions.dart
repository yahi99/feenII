import 'package:feen/ui/widgets/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MapOptionsWidget extends StatefulWidget {
  final List<String> optionList;
  final Function(String) function;

  MapOptionsWidget({this.optionList, this.function});

  @override
  _MapOptionsWidgetState createState() => _MapOptionsWidgetState();
}

class _MapOptionsWidgetState extends State<MapOptionsWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 25,
        width: screenSize.width * 0.8,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.optionList.length,
          itemBuilder: (context, index) => buildCategory(index),
        ),
      ),
    );
  }

  Widget buildCategory(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        padding: EdgeInsets.fromLTRB(4, 0, 4, 8),
        labelStyle: TextStyle(
            fontSize: 10, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        label: selectedIndex == index
            ? Text(widget.optionList[index],
                style: TextStyle(color: Colors.white))
            : Text(widget.optionList[index],
                style: TextStyle(color: Colors.black)),
        backgroundColor: selectedIndex == index ? kPrimaryColor : kSilver,
        elevation: 8,
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onSelected: (bool selected) {
          setState(() {
            selectedIndex = index;
            widget.function(widget.optionList[index]);
            print(widget.optionList[index]);
          });
        },
      ),
    );
  }
}
