import 'package:flutter/material.dart';


import 'package:mapmyindia_gl/mapmyindia_gl.dart';

import '../utils/color.dart';

class MapLongClick extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MapLongClickState();
  }

}

class MapLongClickState extends State {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(28.551087, 77.257373),
    zoom: 14.0,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MyColor.colorPrimary,
        brightness: Brightness.dark,
        title: Text(
          'Map Long Click',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.2,
      ),
      body: MapmyIndiaMap(
        initialCameraPosition: _kInitialPosition,
        onMapLongClick: (point, latlng) =>{
          print(latlng.toString()),
          SnackBar(content: Text(latlng.toString()),)
        },
      ),
    );
  }

}