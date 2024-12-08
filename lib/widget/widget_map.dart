// widget_map.dart

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fakegeo/service/service_location.dart';

class WidgetMap extends StatefulWidget {
  final Position? currentPosition;

  WidgetMap({this.currentPosition});

  @override
  _WidgetMapState createState() => _WidgetMapState();
}

class _WidgetMapState extends State<WidgetMap> {
  late MaplibreMapController mapController;

  final CameraPosition _initialPosition = CameraPosition(target: LatLng(41.0082, 28.9784), zoom: 10.0);

  @override
  Widget build(BuildContext context) {
    return MaplibreMap(
      initialCameraPosition: _initialPosition,
      styleString: 'https://tile.ankageo.com/styles/anka-light/style.json',
      onMapCreated: (MaplibreMapController controller) {
        mapController = controller;
        if (widget.currentPosition != null) {
          mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                widget.currentPosition!.latitude,
                widget.currentPosition!.longitude,
              ),
              zoom: 14.0,
            ),
          ));
        }
      },
    );
  }
}
