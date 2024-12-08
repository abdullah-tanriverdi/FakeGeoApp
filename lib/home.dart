import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fakegeo/service/service_location.dart';
import 'package:fakegeo/widget/widget_map.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {

  //Geolocatordan gelen mevcut konum değişkeni
  Position? _currentPosition;


  @override
  void initState() {
    super.initState();
    //Uygulama açıldığında mevcut konumu almak için çağrılır
    _getCurrentLocation();
  }

  //Mevcut konumu almak için fonksiyon
  Future<void> _getCurrentLocation() async {

    //Konum servisini kullanarak mevcut konumu alır
    Position? position = await ServiceLocation.getCurrentLocation(context);

    //Konum alındığında durumu güncelle
    setState(() {
      _currentPosition = position;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Konum alınmamışsa yükleniyor göstergesi
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
      //Konum alındığında map widgetı gösterilir
          : WidgetMap(currentPosition: _currentPosition),
    );
  }
}
