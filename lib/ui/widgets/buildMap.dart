import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BuildMapWidget extends StatefulWidget {
  final Position position;

  BuildMapWidget({this.position});

  @override
  _BuildMapWidget createState() => _BuildMapWidget();
}

//Sheben, 30.5720681  ---- 31.0085726
class _BuildMapWidget extends State<BuildMapWidget> {
  static GoogleMapController _controller;
  static Position _currentPosition;
  PolylinePoints polylinePoints;
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  List<Marker> markers = <Marker>[];

  @override
  void initState() {
    super.initState();
    _currentPosition = widget.position;
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    Geolocator()
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      ).then((position) {
        if (mounted) {
          setState(() => _currentPosition = position);
        }
      }).catchError((e) {
        print(e);
      });
  }

  _getLocation() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      zoom: 17.0,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      myLocationEnabled: true,
      polylines: Set<Polyline>.of(polylines.values),
      markers: Set<Marker>.of(markers),
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          _controller = controller;
          _setStyle(controller);
        });
      },
      initialCameraPosition: CameraPosition(
          target: LatLng(
              _currentPosition.latitude != null
                  ? _currentPosition.latitude
                  : 30.5720681,
              _currentPosition.longitude != null
                  ? _currentPosition.longitude
                  : 31.0085726),
          zoom: 12.5),
    );
  }

  void _setStyle(GoogleMapController controller) async {
    String mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/light_map.json');
    controller.setMapStyle(mapStyle);
  }
}
