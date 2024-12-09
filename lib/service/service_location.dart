import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ServiceLocation {

  //Mevcut konumu alan fonksiyon
  static Future<Position?> getCurrentLocation(BuildContext context) async {

    //Konum servisinin etkin olup olmadığını kontrol eder
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      //Kullanıcıyı ayarlara yönlendirir
      _showLocationServiceDialog(context);
      return null;
    }

    //Konum izni kontrol eder
    LocationPermission permission = await Geolocator.checkPermission();

    //İzin verilmemişse işlem başlatılır
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      //İzin vermezse
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        _showPermissionDeniedDialog(context);
        return null;
      }
    }

    //Konum alınır yüksek doğrulukta
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    //Alınan konum döndürülür
    return position;
  }


  static Future <void> _showPermissionDeniedDialog (BuildContext context){
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Konum İzni Reddedildi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Konum izniniz reddedildi. Uygulama, konum bilgisine erişebilmek için izin vermeniz gerekmektedir.")
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Tekrar İzin Ver"),
              onPressed: () async {
                // Kullanıcı izni tekrar vermek için yönlendirilir
                await Geolocator.requestPermission();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  static Future <void> _showLocationServiceDialog(BuildContext context) async {
    return showDialog<void>(
      context:  context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Konum Servisi Kapalı"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Konum Servisi Kapalı. Uygulama, konum bilgisine erişebilmek için konum servisini açmak zorundadır.")
              ],
            ),
          ),
          actions:<Widget> [
            TextButton( child:Text("Hayır"), onPressed: (){
              Navigator.of(context).pop();
            },
            ),
            TextButton( child: Text("Ayarlara Git"), onPressed: () async  {
              await Geolocator.openLocationSettings();
              Navigator.of(context).pop();
            },)
          ],
        );
      }
    );
  }
}
