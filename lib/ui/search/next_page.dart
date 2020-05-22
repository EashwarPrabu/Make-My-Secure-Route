import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:xml2json/xml2json.dart';
import 'L.dart';
import 'package:geodesy/geodesy.dart';
import 'package:location/location.dart';
import 'spinkit.dart';

class NextPage extends StatefulWidget {
  final String from;
  final String to;
  final List<LatLng> routepoints;
  final List<Marker> marks;
  final LatLng source;
  final LatLng dest;
  final bool enable;
  NextPage(this.from, this.to, this.routepoints, this.marks, this.source,
      this.dest, this.enable);

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  Future userFuture;

  bool enable;
  Geodesy geodesy = Geodesy();

  Location location = new Location();
  LocationData locationData;

  void getLocation() async {
    final locationData = await location.getLocation();
    location.changeSettings(accuracy: LocationAccuracy.navigation);
    setState(() {
      user_lat = locationData.latitude;
      user_long = locationData.longitude;
    });
  }

  Future<void> _asyncConfirmDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: enable
              ? Text('Start from your location?')
              : Text('உங்கள் இருப்பிடத்திலிருந்து தொடங்கவா?'),
          content: enable
              ? Text(
                  'Yor are far from your source location.Do you want to fetch route from your location?')
              : Text(
                  'உங்கள் இருப்பிடத்திலிருந்து நீங்கள் வெகு தொலைவில் உள்ளீர்கள்.உங்கள் இருப்பிடத்திலிருந்து வழியைப் பெற விரும்புகிறீர்களா?'),
          actions: <Widget>[
            FlatButton(
              child: enable ? Text('Cancel') : Text('வேண்டாம்'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: enable ? Text('OK') : Text('சரி'),
              onPressed: () {
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                        LoadingScreen('Your Location', places[1], enable));
                Navigator.of(context).pushReplacement(route);
              },
            )
          ],
        );
      },
    );
  }

  final myTransformer = Xml2Json();
  List<Marker> allMarkers = [];
  List<String> places = [];
  List<LatLng> route1 = [];
  List<LatLng> saferoute1 = [];
  List<List> coordinates = [];
  List<Polyline> polyline = [];
  LatLng source;
  LatLng dest;
  double user_lat;
  double user_long;
  double dest_lat;
  double dest_long;

  @override
  void initState() {
    places.add(widget.from);
    places.add(widget.to);
    enable = widget.enable;
    route1.addAll(widget.routepoints);
    allMarkers.addAll(widget.marks);
    source = widget.source;
    dest = widget.dest;
    getLocation();
    super.initState();
  }

//  fetchroute() async {
//    try {
//      final query = places[0];
//      var addresses = await Geocoder.local.findAddressesFromQuery(query);
//      var first = addresses.first;
//      final query1 = places[1];
//      var addresses1 = await Geocoder.local.findAddressesFromQuery(query1);
//      var first1 = addresses1.first;
//      allMarkers.add(
//        new Marker(
//          width: 45.0,
//          height: 45.0,
//          point: new LatLng(
//              first.coordinates.latitude, first.coordinates.longitude),
//          builder: (context) => new Container(
//            child: IconButton(
//              color: Colors.deepPurple,
//              icon: Icon(Icons.location_on),
//              iconSize: 45.0,
//              onPressed: () {
//                print(first.featureName);
//              },
//            ),
//          ),
//        ),
//      );
//      allMarkers.add(
//        new Marker(
//          width: 45.0,
//          height: 45.0,
//          point: new LatLng(
//              first1.coordinates.latitude, first1.coordinates.longitude),
//          builder: (context) => new Container(
//            child: IconButton(
//              color: Colors.deepPurple,
//              icon: Icon(Icons.location_on),
//              iconSize: 45.0,
//              onPressed: () {
//                print(first1.featureName);
//              },
//            ),
//          ),
//        ),
//      );
//      await getSafestRouteUsingApi(
//        LatLng(first.coordinates.latitude, first.coordinates.longitude),
//        LatLng(first1.coordinates.latitude, first1.coordinates.longitude),
//      );
//    } catch (e) {
//      showAlertDialog(context);
//    }
//  } //geocodes the input source and destination,gets the route if error,shows a dialog box

  Future<void> ajyncConfirmDialog0(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: enable ? Text('Uh ho!') : Text('Uh ho!'),
          content: enable
              ? Text('No Places Found')
              : Text('இடங்கள் எதுவும் கிடைக்கவில்லை'),
          actions: <Widget>[
            FlatButton(
              child: enable ? Text('OK') : Text('சரி'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // show the dialog

//  Future<void> getSafestRouteUsingApi(LatLng start, LatLng end) async {
//    double lat1 = start.latitude;
//    double lng1 = start.longitude;
//    double lat2 = end.latitude;
//    double lng2 = end.longitude;
//
//    Response response = await get(
//        "https://ceg-maps.herokuapp.com/getRoute?st_lat=$lat1&st_lng=$lng1&e_lat=$lat2&e_lng=$lng2&lang=en-gb");
//    print(response.body);
//    var data = json.decode(response.body);
//
//    List<dynamic> coordinates1 = data['route'];
//    for (String i in coordinates1) {
//      var a = i.split(",");
//      double o = double.parse(a[0]);
//      double p = double.parse(a[1]);
//      route1.add(LatLng(o, p));
//    }
//    setState(() {
//      saferoute1 = List.from(route1);
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(18.0),
          child: Theme(
            data: Theme.of(context).copyWith(accentColor: Colors.white),
            child: Container(
              height: 18.0,
              alignment: Alignment.center,
              child: enable
                  ? Text(
                      'Route Preview',
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      'பாதை முன்னோட்டம்',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        ),
        bottomOpacity: 0.5,
        backgroundColor: Colors.deepPurple,
        title: Text("Make My Safest Route"),
      ),
      body: Stack(
        children: <Widget>[
          FlutterMap(
              options: new MapOptions(
                  center: source, zoom: 15.0, minZoom: 5.0, maxZoom: 18.0),
              layers: [
                new TileLayerOptions(
                    urlTemplate:
                        "https://api.mapbox.com/styles/v1/ammaamma/ck98c24q356631ip7xkk1vkq0/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYW1tYWFtbWEiLCJhIjoiY2s5OGNxdmN2MDE5aDNlbjJkY2JhZmV6NyJ9.WY2_d6FZBxTHbibBaW9vAg",
                    additionalOptions: {
                      'accessToken':
                          'pk.eyJ1IjoiYW1tYWFtbWEiLCJhIjoiY2s5OGNxdmN2MDE5aDNlbjJkY2JhZmV6NyJ9.WY2_d6FZBxTHbibBaW9vAg',
                      'id': 'mapbox.mapbox-streets-v7'
                    }),
                new MarkerLayerOptions(markers: allMarkers),
                new PolylineLayerOptions(polylines: [
                  new Polyline(
                    points: route1,
                    strokeWidth: 6.0,
                    color: Colors.blue,
                  ),
                ]),
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RaisedButton(
                    onPressed: () {
                      LatLng l = LatLng(user_lat, user_long);
                      num distance =
                          geodesy.distanceBetweenTwoGeoPoints(l, source);
                      if (distance <= 200) {
                        var route = new MaterialPageRoute(
                            builder: (BuildContext context) => navigation1(
                                widget.routepoints,
                                widget.dest,
                                enable,
                                widget.source));
                        Navigator.of(context).push(route);
                      } else {
                        print(
                            'ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss');
                        _asyncConfirmDialog(context);
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.navigation, color: Colors.white), // icon
                        enable
                            ? Text(
                                "Start Navigation",
                                style: TextStyle(color: Colors.white),
                              )
                            : Text(
                                "வழிசெலுத்து(Navigate)",
                                style: TextStyle(color: Colors.white),
                              ), // text
                      ],
                    ),
                    color: Colors.deepPurple,
                    textColor: Colors.white,
                    elevation: 5,
                  ),
                ),
              ),
//              Padding(
//                padding: const EdgeInsets.all(4.0),
//                child: Align(
//                  alignment: Alignment.bottomRight,
//                  child: RaisedButton(
//                    onPressed: () {},
//                    child: Row(
//                      mainAxisSize: MainAxisSize.min,
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      children: <Widget>[
////                        Icon(Icons.list, color: Colors.white), // icon
////                        enable
////                            ? Text(
////                                "Steps",
////                                style: TextStyle(color: Colors.white),
////                              )
////                            : Text(
////                                "வழிகள்",
////                                style: TextStyle(color: Colors.white),
////                              ), // text
//                      ],
//                    ),
//                    color: Colors.deepPurple,
//                    textColor: Colors.white,
//                    elevation: 5,
//                  ),
//                ),
//              ),
            ],
          ),
        ],
      ),
    );
  }
}
/*
@override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => navigation1());
              Navigator.of(context).push(route);
            },
          ),
          backgroundColor: Colors.deepPurple,
          title: Text("Make My Safest Route"),
        ),
        body: Container(
          child: FutureBuilder(
            future: userFuture,
            builder: (context, snapshot){
              switch (snapshot.connectionState){
                case ConnectionState.none:
                  return Text('hi');
                case ConnectionState.active:
                  return Text('hiii');
                case ConnectionState.waiting:
                  return Text('hiiiiiiii');
                case ConnectionState.done:
                  return Text('hi');
                default:
                  return Text('hi');
              }
            },
          ),
        ));
  }
}




FlutterMap(
          options: new MapOptions(
              center: new LatLng(13.0109, 80.2354), minZoom: 5.0),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/ammaamma/ck98c24q356631ip7xkk1vkq0/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYW1tYWFtbWEiLCJhIjoiY2s5OGNxdmN2MDE5aDNlbjJkY2JhZmV6NyJ9.WY2_d6FZBxTHbibBaW9vAg",
                additionalOptions: {
                  'accessToken':
                      'pk.eyJ1IjoiYW1tYWFtbWEiLCJhIjoiY2s5OGNxdmN2MDE5aDNlbjJkY2JhZmV6NyJ9.WY2_d6FZBxTHbibBaW9vAg',
                  'id': 'mapbox.mapbox-streets-v7'
                }),
            new MarkerLayerOptions(markers: allMarkers),
            new PolylineLayerOptions(polylines: [
              new Polyline(
                points: route1,
                strokeWidth: 6.0,
                color: Colors.blue,
              ),
            ]),
          ]),
 */