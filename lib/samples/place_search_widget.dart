import 'dart:convert';
import 'package:map_test/utils/color.dart';
import 'package:mapmyindia_place_widget/mapmyindia_place_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class PlaceSearchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PlaceSearchWidgetState();
  }
}

class PlaceSearchWidgetState extends State {
  ELocation _eLocation = ELocation();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColor.colorPrimary,
        brightness: Brightness.dark,
        title: Text(
          'Place Search Widget',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.2,
      ),
      body: Center(
          child: Column(
              children: [
                SizedBox(height: 20,),
                Text(_eLocation.eLoc == null? 'ELoc: ':'ELoc: ${_eLocation.eLoc}'),
                SizedBox(height: 20,),
                Text( _eLocation.placeName == null? 'Place Name: ': 'Place Name: ${_eLocation.placeName}'),
                SizedBox(height: 20,),
                Text( _eLocation.placeAddress == null? 'Place Address: ': 'Place Address: ${_eLocation.placeAddress}'),
                SizedBox(height: 20,),
                Text( _eLocation.latitude == null? 'Latitude: ': 'Latitude: ${_eLocation.latitude}'),
                SizedBox(height: 20,),
                Text( _eLocation.longitude == null? 'Longitude: ': 'Longitude: ${_eLocation.longitude}'),
                SizedBox(height: 20,),
                Text( _eLocation.type == null? 'Type: ': 'Type: ${_eLocation.type}'),
                SizedBox(height: 20,),
                Text( _eLocation.entryLatitude == null? 'Entry Latitude: ': 'Entry Latitude: ${_eLocation.entryLatitude?.toString()}'),
                SizedBox(height: 20,),
                Text( _eLocation.entryLongitude == null? 'Entry Longitude: ': 'Entry Longitude: ${_eLocation.entryLongitude?.toString()}'),
                SizedBox(height: 20,),
                Text( _eLocation.orderIndex == null? 'Order Index: ': 'Order Index: ${_eLocation.orderIndex?.toString()}'),
                SizedBox(height: 20,),
                Text( _eLocation.keywords == null? 'Keywords: ': 'Keywords: ${_eLocation.keywords?.toString()}'),
                SizedBox(height: 20,),
                Text( _eLocation.typeX == null? 'Type X: ': 'Type X: ${_eLocation.typeX}'),
                SizedBox(height: 20,),
                TextButton(onPressed: openMapmyIndiaSearchWidget ,child:Text("Open Place Autocomplete")),
              ]
          )
        //    RaisedButton(onPressed: initPlatformState ,child: Text("Go to native"),)
      ),
    );
  }

  openMapmyIndiaSearchWidget() async {
    ELocation eLocation;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      eLocation = await openPlaceAutocomplete(
          PlaceOptions());
    } on PlatformException {
      eLocation = ELocation();
    }
    print(json.encode(eLocation.toJson()));

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _eLocation = eLocation;
    });
  }

}
