import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fakegeo/service/service_location.dart';
import 'package:fakegeo/widget/widget_map.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Konum izni kontrolü ve alınması
  Future<void> _getCurrentLocation() async {
    Position? position = await LocationService.getCurrentLocation();

    // Eğer konum alınamadıysa, izin verilmediğini kontrol et
    if (position == null) {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showPermissionDeniedMessage();
      }
    }

    setState(() {
      _currentPosition = position;
    });
  }

  // Konum izni reddedildiğinde gösterilecek bilgilendirme mesajı
  void _showPermissionDeniedMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konum İzni Gerekli'),
          content: Text('Konum izni verilmedi. Lütfen izin vermek için "Tamam" butonuna basın.'),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () async {
                Navigator.of(context).pop();
                // Konum iznini tekrar iste
                LocationPermission permission = await Geolocator.requestPermission();

                if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
                  _getCurrentLocation();
                } else {
                  _showPermissionDeniedMessage();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : WidgetMap(currentPosition: _currentPosition),
    );
  }
}
