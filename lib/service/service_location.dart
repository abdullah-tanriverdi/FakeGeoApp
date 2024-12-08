import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ServiceLocation {

  //Mevcut konumu alan fonksiyon
  static Future<Position?> getCurrentLocation(BuildContext context) async {

    //Konum servisinin etkin olup olmadığını kontrol eder
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    //Konum izni kontrol eder
    LocationPermission permission = await Geolocator.checkPermission();

    //İzin verilmemişse işlem başlatılır
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      //İzin vermezse
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        return null;
      }
    }

    //Konum alınır yüksek doğrulukta
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    //Alınan konum döndürülür
    return position;
  }
}
