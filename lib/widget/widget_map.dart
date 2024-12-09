import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:geolocator/geolocator.dart';

class WidgetMap extends StatefulWidget {
  final Position? currentPosition;

  WidgetMap({this.currentPosition});

  @override
  _WidgetMapState createState() => _WidgetMapState();
}

class _WidgetMapState extends State<WidgetMap> {
  late MaplibreMapController mapController;

  // Başlangıç konumu Türkiye'nin merkezi (yaklaşık)
  final CameraPosition _initialPosition = CameraPosition(target: LatLng(39.9334, 32.8597), zoom: 4.0); // Türkiye'nin merkezi

  // Konum üzerinde marker ekleme
  void _updateMapWithCurrentLocation(Position position) async {
    // Konumu haritada göstermek için kamerayı animasyonla hareket ettir
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 10.0,
      ),
    ));

    // Marker ekle
    await mapController.addSymbol(SymbolOptions(
      geometry: LatLng(position.latitude, position.longitude),
      iconImage: "assets/marker/redmarker.png",
      iconSize: 0.8,
      iconAnchor: "bottom",
    ));
  }


  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _updateMapWithCurrentLocation(position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MaplibreMap(
            initialCameraPosition: _initialPosition,  // Türkiye'ye odaklanacak şekilde başlatıyoruz
            styleString: 'https://tile.ankageo.com/styles/anka-light/style.json',
            onMapCreated: (MaplibreMapController controller) {
              mapController = controller;

              if (widget.currentPosition != null) {
                _updateMapWithCurrentLocation(widget.currentPosition!);
              }
            },
          ),

          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: _getCurrentLocation,
              child: Icon(Icons.add_location_alt),
            ),
          ),
        ],
      ),
    );
  }
}
