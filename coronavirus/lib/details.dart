import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:coronavirus/models/GraphData.dart';
import 'package:coronavirus/utils/DateTimeComboLineChart.dart';
import 'package:coronavirus/utils/globals.dart';
import 'package:coronavirus/models/place.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/painting/text_style.dart' as txstyle;

class CoronaDetails extends StatefulWidget {
  Place place;

  CoronaDetails({Key key, @required this.place}) : super(key: key);

  @override
  _CoronaDetailsState createState() => _CoronaDetailsState();
}

class _CoronaDetailsState extends State<CoronaDetails> {
  Place place;
  Completer<GoogleMapController> _controller = Completer();
  LatLng _center;
  MapType _currentMapType = MapType.normal;
  LatLng _lastMapPosition;

  @override
  void initState() {
    place = widget.place;
    _center = LatLng(place.lat, place.lon);
    _lastMapPosition = _center;
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double spaceBetweenRows = 30;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: primaryColor,
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: width - 50,
                    height: 50.0,
                    child: AutoSizeText(
                      place.country,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: txstyle.TextStyle(fontSize: 35),
                    ),
                  ),
                  Image(
                    width: place.flag == null ? 0 : 50,
                    height: place.flag == null ? 0 : 50,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return SizedBox(
                        width: 50,
                        height: 50,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        ),
                      );
                    },
                    image: NetworkImage(
                      place.flag == null
                          ? "https://www.transparenttextures.com/patterns/asfalt-light.png"
                          : place.flag,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Stack(
              children: <Widget>[
                Center(
                  child: Transform.rotate(
                    angle: pi / 15,
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, -0.001)
                        ..rotateX(0.6),
                      alignment: FractionalOffset.topCenter,
                      child: Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.green,
                            width: 5,
                          ),
                        ),
                        child: GoogleMap(
                          zoomControlsEnabled: false,
                          zoomGesturesEnabled: false,
                          scrollGesturesEnabled: false,
                          mapType: _currentMapType,
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: _center,
                            zoom: 4.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width,
                  height: 280,
                  child: DateTimeComboLinePointChart.withHistoryData(place),
                )
              ],
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              place.population != -1
                                  ? "Total Cases/population"
                                  : "Total Cases",
                              style: txstyle.TextStyle(fontSize: 15),
                            ),
                            Center(
                              child: SizedBox(
                                width: width,
                                height: 50.0,
                                child: AutoSizeText(
                                  place.cases == -1
                                      ? "-"
                                      : (place.cases.toString() +
                                          (place.population != -1
                                              ? " / " +
                                                  place.population.toString()
                                              : "")),
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: txstyle.TextStyle(fontSize: 45),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: spaceBetweenRows,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Today Cases",
                              style: txstyle.TextStyle(fontSize: 15),
                            ),
                            Text(
                              place.todayCases == -1
                                  ? "-"
                                  : place.todayCases.toString(),
                              style: txstyle.TextStyle(fontSize: 45),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 70,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Today Deaths",
                              style: txstyle.TextStyle(fontSize: 15),
                            ),
                            Text(
                              place.todayDeaths == -1
                                  ? "-"
                                  : place.todayDeaths.toString(),
                              style: txstyle.TextStyle(fontSize: 45),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: spaceBetweenRows,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Recovered",
                              style: txstyle.TextStyle(fontSize: 15),
                            ),
                            Text(
                              place.todayDeaths == -1
                                  ? "-"
                                  : place.recovered.toString(),
                              style: txstyle.TextStyle(fontSize: 45),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 70,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Active",
                              style: txstyle.TextStyle(fontSize: 15),
                            ),
                            Text(
                              place.active == -1
                                  ? "-"
                                  : place.active.toString(),
                              style: txstyle.TextStyle(fontSize: 45),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: spaceBetweenRows,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Deaths",
                              style: txstyle.TextStyle(fontSize: 15),
                            ),
                            Text(
                              place.deaths == -1
                                  ? "-"
                                  : place.deaths.toString(),
                              style: txstyle.TextStyle(fontSize: 45),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 70,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Critical",
                              style: txstyle.TextStyle(fontSize: 15),
                            ),
                            Text(
                              place.critical == -1
                                  ? "-"
                                  : place.critical.toString(),
                              style: txstyle.TextStyle(fontSize: 45),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: spaceBetweenRows,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Tests",
                              style: txstyle.TextStyle(fontSize: 15),
                            ),
                            Text(
                              place.tests == -1 ? "-" : place.tests.toString(),
                              style: txstyle.TextStyle(fontSize: 45),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 70,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Tests per One Million",
                              style: txstyle.TextStyle(fontSize: 15),
                            ),
                            Text(
                              place.testsPerOneMillion == -1
                                  ? "-"
                                  : place.testsPerOneMillion.toString(),
                              style: txstyle.TextStyle(fontSize: 45),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: spaceBetweenRows,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              "Deaths per One Million",
                              style: txstyle.TextStyle(fontSize: 15),
                            ),
                            Text(
                              place.deathsPerOneMillion == -1
                                  ? "-"
                                  : place.deathsPerOneMillion.toString(),
                              style: txstyle.TextStyle(fontSize: 45),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text("last update: " + place.lastUpdate.toString())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
