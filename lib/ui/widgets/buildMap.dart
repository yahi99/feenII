import 'package:feen/models/PlaceResult.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BuildMapWidget extends StatefulWidget {
  final Position position;
  final List<PlaceResult> place;

  BuildMapWidget({this.position, this.place});

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
  static BitmapDescriptor offlinePin, withdrawPin, depositPin, pin;

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

  setPin(List<PlaceResult> place) {
    place.forEach((element) {
      if (element.rating.toString().startsWith("0")) {
        pin = offlinePin;
      } else if (element.rating.toString().startsWith("5")) {
        pin = depositPin;
      } else {
        pin = withdrawPin;
      }
      markers.add(Marker(
          markerId: MarkerId(element.placeId),
          icon: pin,
          position: LatLng(
              element.geometry.location.lat, element.geometry.location.long),
          infoWindow:
              InfoWindow(title: element.name, snippet: element.vicinity),
          onTap: () {
            moveCamera(LatLng(
                element.geometry.location.lat, element.geometry.location.long));
            setState(() {
              // place = element;
              // distance = element.distance;
              // setAtmType(element.rating.toString());
            });
          }));
    });
  }

  createMarker(context) {
    if (withdrawPin == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, 'assets/icons/withdrawPin.png')
          .then((withdraw) {
        setState(() {
          withdrawPin = withdraw;
        });
      });
    } else if (offlinePin == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, 'assets/icons/offlinePin.png')
          .then((offline) {
        setState(() {
          offlinePin = offline;
        });
      });
    } else if (depositPin == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(
              configuration, 'assets/icons/depositPin.png')
          .then((deposit) {
        setState(() {
          depositPin = deposit;
        });
      });
    }
  }

  moveCamera(LatLng latLng) {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 16.0, bearing: 45.0, tilt: 90.0)));
  }

  @override
  Widget build(BuildContext context) {
    createMarker(context);
    setPin(widget.place);
    return GoogleMap(
      myLocationButtonEnabled: false,
      mapToolbarEnabled: false,
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
          target: LatLng(_currentPosition.latitude ?? 30.5720681,
              _currentPosition.longitude ?? 31.0085726),
          zoom: 12.5),
    );
  }

  void _setStyle(GoogleMapController controller) async {
    String mapStyle = await DefaultAssetBundle.of(context)
        .loadString('assets/light_map.json');
    controller.setMapStyle(mapStyle);
  }
}
