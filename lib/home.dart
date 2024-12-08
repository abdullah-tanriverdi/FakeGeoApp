import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MaplibreMapController mapController;

  // Harita başlatıldığında kullanılacak başlangıç konumu
  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(41.0082, 28.9784),  // İstanbul, Türkiye
    zoom: 12.0,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaplibreMap(
        initialCameraPosition: _initialPosition,
        styleString: 'https://tile.ankageo.com/styles/anka-light/style.json', // MapLibre'nin varsayılan harita stili
        onMapCreated: (MaplibreMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
