import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:latlong/latlong.dart';
import 'dart:core';
import 'spinkit.dart';
import 'package:translator/translator.dart';
import 'markonmap.dart';

/// I am really sorry for the unordered code without proper documentations...
/// please suggest me some measures in writing the code effectively n properly
///

class SearchPaage extends StatelessWidget {
  final bool enable;
  final String addr;
  SearchPaage(this.enable, this.addr);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Soup(enable, addr),
    );
  }
}

class Soup extends StatelessWidget {
  final bool enable;
  final String addr;
  Soup(this.enable, this.addr);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make your Safe Route'),
        backgroundColor: Colors.deepPurple,
      ),
      backgroundColor: Colors.white70,
      body: Container(
        child: SearchPage(enable, addr),
      ),
    );
  }
}

class SearchPage extends StatefulWidget {
  final bool enable;
  final String addr;
  SearchPage(this.enable, this.addr);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final translator = GoogleTranslator();
  bool enable;
  bool repeat = false;
  double currentlat;
  double currentlng;
  String addr;

  @override
  void initState() {
    enable = widget.enable;
    addr = widget.addr;
    _textController1.text += addr;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FlutterMap(
            options:
                new MapOptions(center: new LatLng(13.00, 80.17), zoom: 15.0),
            layers: [
              new TileLayerOptions(
                  urlTemplate:
                      "https://api.mapbox.com/styles/v1/ammaamma/ck98c24q356631ip7xkk1vkq0/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYW1tYWFtbWEiLCJhIjoiY2s5OGNxdmN2MDE5aDNlbjJkY2JhZmV6NyJ9.WY2_d6FZBxTHbibBaW9vAg",
                  additionalOptions: {
                    'accessToken':
                        'pk.eyJ1IjoiYW1tYWFtbWEiLCJhIjoiY2s5OGNxdmN2MDE5aDNlbjJkY2JhZmV6NyJ9.WY2_d6FZBxTHbibBaW9vAg',
                    'id': 'mapbox.mapbox-streets-v7'
                  }),
            ]),
        Positioned(
          top: 50.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 5.0),
                    blurRadius: 10,
                    spreadRadius: 3)
              ],
            ),
            child: CustomTextField(
              textController: _textController1,
              hintText: enable ? "From" : "புறப்படும் இடம்",
              prefixIcon: Icon(
                Icons.my_location,
                color: Colors.deepPurple,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapBoxAutoCompleteWidget(
                      apiKey:
                          "pk.eyJ1IjoiYW1tYWFtbWEiLCJhIjoiY2s5OGNxdmN2MDE5aDNlbjJkY2JhZmV6NyJ9.WY2_d6FZBxTHbibBaW9vAg",
                      hint: "From",
                      language: enable ? 'en' : 'ta',
                      country: 'in',
                      onSelect: (place) {
                        String src = place.placeName;
                        print(src);
                        _textController1.text = src;
                        Navigator.pop(context);
                        _textController1.selection =
                            TextSelection.collapsed(offset: 0);
                      },
                      limit: 30,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 100,
          right: 170,
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: SizedBox.fromSize(
              size: Size(36, 36), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.deepPurple, // button color
                  child: InkWell(
                    splashColor: Colors.green, // splash color
                    onTap: () {
                      String z = _textController1.text;
                      _textController1.text = _textController2.text;
                      _textController2.text = z;
                      if (_textController2.text == _textController1.text) {
                        _textController2.text = '';
                      }
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.swap_vert, color: Colors.white), // icon
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 100,
          right: 130,
          child: Padding(
            padding: EdgeInsets.all(14.0),
            child: SizedBox.fromSize(
              size: Size(36, 36), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.deepPurple, // button color
                  child: InkWell(
                    splashColor: Colors.green, // splash color
                    onTap: () {
                      _textController1.text =
                          enable ? 'Your Location' : 'நீங்கள் இருக்கும் இடம்';
                      if (_textController2.text == _textController1.text) {
                        _textController2.text = '';
                      }
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.my_location, color: Colors.white), // icon
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 165.0,
          right: 15.0,
          left: 15.0,
          child: Container(
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(1.0, 5.0),
                      blurRadius: 10,
                      spreadRadius: 3)
                ],
              ),
              child: CustomTextField(
                textController: _textController2,
                hintText: enable ? "To" : "சேரும் இடம்",
                prefixIcon: Icon(
                  Icons.local_taxi,
                  color: Colors.deepPurple,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapBoxAutoCompleteWidget(
                        apiKey:
                            "pk.eyJ1IjoiYW1tYWFtbWEiLCJhIjoiY2s5OGNxdmN2MDE5aDNlbjJkY2JhZmV6NyJ9.WY2_d6FZBxTHbibBaW9vAg",
                        hint: 'To',
                        country: 'in',
                        language: enable ? 'en' : 'ta',
                        onSelect: (place) {
                          String destination = place.placeName;
                          print(destination);
                          _textController2.text = destination;
                          Navigator.pop(context);
                          _textController2.selection =
                              TextSelection.collapsed(offset: 0);
                        },
                        limit: 10,
                      ),
                    ),
                  );
                },
              )),
        ),
        SizedBox(height: 30),
        Positioned(
          top: 225.0,
          right: 15.0,
          left: 15.0,
          child: RaisedButton(
            onPressed: () {
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => LoadingScreen(
                      _textController1.text,
                      _textController2.text,
                      enable,
                      repeat));
              Navigator.of(context).push(route);
            },
            color: Colors.deepPurple,
            child: enable
                ? const Text('Find The Safest Route',
                    style: TextStyle(fontSize: 20, color: Colors.white))
                : const Text('பாதுகாப்பான பாதையைக் கண்டறியவும்',
                    style: TextStyle(fontSize: 13, color: Colors.white)),
          ),
        ),
        Positioned(
          top: 275.0,
          right: 15.0,
          left: 15.0,
          child: RaisedButton(
            onPressed: () {
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => markonmap(enable));
              Navigator.of(context).push(route);
            },
            color: Colors.deepPurple,
            child: enable
                ? const Text('Mark Place on Map',
                    style: TextStyle(fontSize: 20, color: Colors.white))
                : const Text('வரைபடத்தில் இடம் குறிக்கவும்',
                    style: TextStyle(fontSize: 13, color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
