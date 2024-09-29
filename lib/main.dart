// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:map_test/samples/add_marker.dart';
import 'package:map_test/samples/add_polygon_widget.dart';
import 'package:map_test/samples/add_polyline_wdget.dart';
import 'package:map_test/samples/autosuggest_widget.dart';
import 'package:map_test/samples/camera_feature.dart';
import 'package:map_test/samples/current_location_widget.dart';
import 'package:map_test/samples/direction_ui_widget.dart';
import 'package:map_test/samples/direction_widget.dart';
import 'package:map_test/samples/geocode_widget.dart';
import 'package:map_test/samples/location_camera_option.dart';
import 'package:map_test/samples/map_long_click.dart';
import 'package:map_test/samples/nearby_ui_widget.dart';
import 'package:map_test/samples/nearby_widget.dart';
import 'package:map_test/samples/place_detail_widget.dart';
import 'package:map_test/samples/place_picker_widget.dart';
import 'package:map_test/samples/place_search_widget.dart';
import 'package:map_test/samples/poi_along_route_widget.dart';
import 'package:map_test/samples/reverse_geocode_widget.dart';
import 'package:map_test/utils/color.dart';
import 'package:map_test/utils/feature_type.dart';
import 'package:mapmyindia_gl/mapmyindia_gl.dart';

import 'model/feature_list.dart';
import 'samples/map_click_event.dart';

final List<FeatureList> mapEvents = <FeatureList>[
  const FeatureList(
      "Map Tap", "Click on map and get Latitude Longitude", "/MapClick"),
  const FeatureList("Map Long Click", "Long press on map and get Latitude Longitude",
      "/MapLongClick"),
];

final List<FeatureList> cameraFeatures = <FeatureList>[
  const FeatureList('Camera Features', "Animate, Move or Ease Camera Position",
      '/CameraFeature'),
  const FeatureList("Location Camera Options", "Location camera and render mode",
      '/LocationCameraOptions')
];

final List<FeatureList> markerFeatures = <FeatureList>[
  const FeatureList('Add Marker', 'Way to add Marker on Map', '/AddMarker'),
  // FeatureList('Marker Dragging', 'Drag a marker', '/MarkerDragging')
];

final List<FeatureList> locationFeatures = <FeatureList>[
  const FeatureList('Current Location', 'Location camera options for render and tracking modes', '/CurrentLocation')
];

final List<FeatureList> customWidgetFeature = <FeatureList>[
  const FeatureList("Place Autocomplete Widget", "Location search functionality and UI to search a place", '/PlaecSearchUI'),
  const FeatureList("Place Picker", "Place Picker to search and choose a specific location", '/PlacePickerUI'),
  const FeatureList('Direction Widget', "MapmyIndia Direction Widget to show Route on map", '/DirectionUI'),
  const FeatureList('Nearby Widget', "MapmyIndia Nearby Widget to search nearby result on map", '/NearbyUI')
];

final List<FeatureList> polylineFeatures = <FeatureList>[
  const FeatureList('Draw Polyline', 'Draw a polyline with given list of latitude and longitude', '/AddPolyline'),
  const FeatureList('Draw Polygon', 'Draw a polygon with given list of latitude and longitude', '/AddPolygon')
];

final List<FeatureList> restApiFeatures = <FeatureList>[
  const FeatureList('Autosuggest', 'Auto suggest places on the map', '/AutoSuggest'),
  const FeatureList('Geocode', 'Geocode rest API call', '/Geocode'),
  const FeatureList('Reverse Geocode', 'Reverse Geocode rest API call', '/ReverseGeocode'),
  const FeatureList('Nearby', 'Show nearby results on the map', '/Nearby'),
  const FeatureList('Direction', 'Get directions between two points and show on the map', '/Direction'),
  const FeatureList('POI Along Route', 'User will be able to get the details of POIs of a particular category along his set route', '/POIAlongRoute'),
  const FeatureList('Place Detail', 'To get the place details from eLoc', '/PlaceDetail'),
];


class MapsDemo extends StatefulWidget {
  const MapsDemo({super.key});

  @override
  State<StatefulWidget> createState() {
    return MapDemoState();
  }
}

void main() {
  runApp(MaterialApp(
    home: const MapsDemo(),
    routes: <String, WidgetBuilder>{
      '/MapClick': (BuildContext context) => MapClickEvent(),
      '/MapLongClick': (BuildContext context) => MapLongClick(),
      '/CameraFeature': (BuildContext context) => CameraFeature(),
      '/LocationCameraOptions': (BuildContext context) => LocationCameraOption(),
      '/AddMarker': (BuildContext context) => const AddMarkerWidget(),
      '/CurrentLocation': (BuildContext context) => const CurrentLocationWidget(),
      '/AddPolyline': (BuildContext context) => AddPolylineWidget(),
      '/AddPolygon': (BuildContext context) => AddPolygonWidget(),
      '/AutoSuggest': (BuildContext context) => const AutoSuggestWidget(),
      '/Geocode': (BuildContext context) => GeocodeWidget(),
      '/ReverseGeocode': (BuildContext context) => ReverseGeocodeWidget(),
      '/Nearby': (BuildContext context) => NearbyWidget(),
      '/Direction': (BuildContext context) => DirectionWidget(),
      '/POIAlongRoute': (BuildContext context) => POIAlongRouteWidget(),
      '/DirectionUI': (BuildContext context) => DirectionUIWidget(),
     // '/NearbyUI': (BuildContext context) => NearbyUIWidget(),
      '/PlaecSearchUI': (BuildContext context) => PlaceSearchWidget(),
      '/PlacePickerUI': (BuildContext context) => PlacePickerWidget(),
      '/PlaceDetail': (BuildContext context) => PlaceDetailWidget(),
    },
  ));
}

class MapDemoState extends State {
  static const String MAP_SDK_KEY = "b23e147720a7e8233939f76daaeb2f05";
  static const String REST_API_KEY = "b23e147720a7e8233939f76daaeb2f05";
  static const String ATLAS_CLIENT_ID = "33OkryzDZsIDH5oRuglAtHUxZBZFxa6JLiduqeU2YtWBpO4i0kmOeMj-CegHTXdC8HS0l_BwB6b--aV-vwK99DCgwkF7NP6L";
  static const String ATLAS_CLIENT_SECRET = "lrFxI-iSEg_UXnyUPaYW3NUkthwzkmPNpl8kzIIBXTZ87oqRzqxWlhpG0c74PAdIOZi65NdOPQysGfbcPdlg5OEs1X9q1gZNeidQQw5Gk9E=";

  FeatureType? selectedFeatureType;

  void setPermission() async {
    if (!kIsWeb) {
      final location = Location();
      final hasPermissions = await location.hasPermission();
      if (hasPermissions != PermissionStatus.granted) {
        await location.requestPermission();
      }
    }
  }

  @override
  void initState() {
    super.initState();

    MapmyIndiaAccountManager.setMapSDKKey(MAP_SDK_KEY);
    MapmyIndiaAccountManager.setRestAPIKey(REST_API_KEY);
    MapmyIndiaAccountManager.setAtlasClientId(ATLAS_CLIENT_ID);
    MapmyIndiaAccountManager.setAtlasClientSecret(ATLAS_CLIENT_SECRET);
    setState(() {
      selectedFeatureType = FeatureType.MAP_EVENT;
    });
    setPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
        AppBar(backgroundColor: MyColor.colorPrimary, title: titleMap()),
        drawer: mapDrawer(),
        body: itemList(context));
  }

  Drawer mapDrawer() {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
        children: <Widget>[
          Container(
            decoration:const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    MyColor.colorPrimary,
                    MyColor.colorPrimaryDark,
                    MyColor.colorAccent
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )),
            height: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: const [
                SizedBox(
                  height: 110,
                ),
                Text(
                  "MapmyIndia Flutter Sample",
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Map Events'),
            onTap: () => {
              setState(() {
                selectedFeatureType = FeatureType.MAP_EVENT;
              }),
              Navigator.pop(context)
            },
          ),
          ListTile(
            title: const Text('Camera'),
            onTap: () => {
              setState(() {
                selectedFeatureType = FeatureType.CAMERA_FEATURE;
              }),
              Navigator.pop(context)
            },
          ),
          ListTile(
            title: const Text('Marker'),
            onTap: () => {
              setState(() {
                selectedFeatureType = FeatureType.MARKER_FEATURE;
              }),
              Navigator.pop(context)
            },
          ),
          ListTile(
            title: const Text('Location'),
            onTap: () => {
              setState(() {
                selectedFeatureType = FeatureType.LOCATION_FEATURE;
              }),
              Navigator.pop(context)
            },
          ),
          ListTile(
            title: const Text('Rest Api Call'),
            onTap: () => {
              setState(() {
                selectedFeatureType = FeatureType.REST_API_CALLS;
              }),
              Navigator.pop(context)
            },
          ),
          ListTile(
            title: const Text('Custom Widgets'),
            onTap: () => {
              setState(() {
                selectedFeatureType = FeatureType.CUSTOM_WIDGET_FEATURE;
              }),
              Navigator.pop(context)
            },
          ),
          ListTile(
            title: const Text('Polylines'),
            onTap: () => {
              setState(() {
                selectedFeatureType = FeatureType.POLYLINE_FEATURE;
              }),
              Navigator.pop(context)
            },
          )
        ],
      ),
    );
  }

  Widget itemList(BuildContext context) {
    if (selectedFeatureType == FeatureType.CAMERA_FEATURE) {
      return ListView.builder(
          itemCount: cameraFeatures.length,
          itemBuilder: (_, int index) =>
              itemWidget(cameraFeatures[index], context));
    } else if (selectedFeatureType == FeatureType.MARKER_FEATURE) {
      return ListView.builder(
          itemCount: markerFeatures.length,
          itemBuilder: (_, int index) =>
              itemWidget(markerFeatures[index], context));
    } else if (selectedFeatureType == FeatureType.LOCATION_FEATURE) {
      return ListView.builder(
          itemCount: locationFeatures.length,
          itemBuilder: (_, int index) =>
              itemWidget(locationFeatures[index], context));
    } else if (selectedFeatureType == FeatureType.REST_API_CALLS) {
      return ListView.builder(
          itemCount: restApiFeatures.length,
          itemBuilder: (_, int index) =>
              itemWidget(restApiFeatures[index], context));
    } else if (selectedFeatureType == FeatureType.CUSTOM_WIDGET_FEATURE) {
      return ListView.builder(
          itemCount: customWidgetFeature.length,
          itemBuilder: (_, int index) =>
              itemWidget(customWidgetFeature[index], context));
    } else if (selectedFeatureType == FeatureType.POLYLINE_FEATURE) {
      return ListView.builder(
          itemCount: polylineFeatures.length,
          itemBuilder: (_, int index) =>
              itemWidget(polylineFeatures[index], context));
    } else {
      return ListView.builder(
          itemCount: mapEvents.length,
          itemBuilder: (_, int index) => itemWidget(mapEvents[index], context));
    }
  }

  titleMap() {
    if (selectedFeatureType == FeatureType.CAMERA_FEATURE) {
      return const Text('Camera');
    } else if (selectedFeatureType == FeatureType.MARKER_FEATURE) {
      return const Text('Marker');
    } else if (selectedFeatureType == FeatureType.LOCATION_FEATURE) {
      return const Text('Location');
    } else if (selectedFeatureType == FeatureType.REST_API_CALLS) {
      return const Text('Rest Api Call');
    } else if (selectedFeatureType == FeatureType.CUSTOM_WIDGET_FEATURE) {
      return const Text('Custom Widgets');
    } else if (selectedFeatureType == FeatureType.POLYLINE_FEATURE) {
      return const Text('Polyline');
    } else {
      return const Text('Map Events');
    }
  }
}

Widget itemWidget(FeatureList featureList, BuildContext context) {
  return GestureDetector(
    child: Column(
      children: <Widget>[
        const SizedBox(
          height: 12,
        ),
        Text(
          featureList.featureTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          featureList.featureDescription,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(
          height: 12,
        ),
        const Divider(
          height: 4,
          thickness: 2,
        )
      ],
    ),
    onTap: () => {Navigator.pushNamed(context, featureList.routeName)},
  );
}
