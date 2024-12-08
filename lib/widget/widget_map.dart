// widget_map.dart

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';

class WidgetMap extends StatefulWidget {

  //Kullanıcın mevcut konumunu tutar
  final Position? currentPosition;

  //currentPosition parametresini opsiyonel alma
  WidgetMap({this.currentPosition});

  @override
  _WidgetMapState createState() => _WidgetMapState();
}

class _WidgetMapState extends State<WidgetMap> {

  //Maplibre harita denetleyici
  late MaplibreMapController mapController;

  // Başlangıç konumu
  final CameraPosition _initialPosition = CameraPosition(target: LatLng(41.0082, 28.9784), zoom: 8.0);

  @override
  Widget build(BuildContext context) {
    return MaplibreMap(

      //Başlangıç kamerası konumu
      initialCameraPosition: _initialPosition,

      //Harita stili
      styleString: 'https://tile.ankageo.com/styles/anka-light/style.json',

      //Harita oluşturulurken yapılacak işlemler
      onMapCreated: (MaplibreMapController controller) {
        mapController = controller;

        //Haritayı konuma focuslama
        if (widget.currentPosition != null) {
          mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
              //Mevcut konumu hedef alma
              target: LatLng(
                widget.currentPosition!.latitude,
                widget.currentPosition!.longitude,
              ),
              zoom: 8.0,
            ),
          ));
        }
      },
    );
  }
}
