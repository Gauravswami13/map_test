import 'package:flutter/material.dart';


import 'package:mapmyindia_gl/mapmyindia_gl.dart';

import '../utils/color.dart';

class CurrentLocationWidget extends StatefulWidget {
  const CurrentLocationWidget({super.key});

  @override
  State<StatefulWidget> createState() {
    return CurrentLocationState();
  }
}

class CurrentLocationState extends State {
  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(25.321684, 82.987289),
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
            'Location Camera Option',
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.2,
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: MapmyIndiaMap(
            initialCameraPosition: _kInitialPosition,
            myLocationEnabled: true,
            myLocationTrackingMode: MyLocationTrackingMode.Tracking,
          ))
        ]));
  }
}
