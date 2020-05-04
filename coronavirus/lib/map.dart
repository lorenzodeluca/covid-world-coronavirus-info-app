import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coronavirus/utils/apiservicerapidapi.dart';
import 'package:coronavirus/db/database.dart';
import 'package:coronavirus/db/model/httpData.dart';
import 'package:coronavirus/details.dart';
import 'package:coronavirus/utils/globals.dart';
import 'package:coronavirus/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class CoronaMap extends StatefulWidget {
  @override
  _CoronaMapState createState() => _CoronaMapState();
}

class _CoronaMapState extends State<CoronaMap> {
  bool detailedMap = false;
  BitmapDescriptor myIcon;
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(24, 24)), 'images/virus.png')
        .then((onValue) {
      myIcon = onValue;
      loadDataFromNinja();
      downlaodCoronaTab();
    });
  }

  void loadDataFromNinja() {
    //data already loaded on app start
    ninjaStates.forEach((place) {
      LatLng ltln = new LatLng(0, 0);
      if (place.lat != null && place.lon != null)
        ltln = LatLng(place.lat, place.lon);
      _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(ltln.toString()),
          position: ltln,
          icon: myIcon,
          infoWindow: InfoWindow(
              title: place.country + "(" + place.cases.toString() + ")",
              snippet: 'Click here',
              onTap: () {
                print("redirecting...");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CoronaDetails(place: place),
                    ));
              })));
    });
    setState(() {});
  }

  Future<void> loadDataCoronaTabApi() async {
    coronaTabStates.forEach((state) {
      LatLng latlng = LatLng(state.lat, state.lon);
      _markers.add(Marker(
        markerId: MarkerId(latlng.toString()),
        position: latlng,
        icon: myIcon,
        infoWindow: InfoWindow(
            title: state.country + "(" + state.cases.toString() + ")",
            snippet: 'Click here',
            onTap: () {
              print("redirecting...");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoronaDetails(place: state),
                  ));
            }),
      ));
    });
  }

  downlaodCoronaTab() async {
    var res;
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    try {
      res = await http.get("https://api.coronatab.app/places");
    } catch (e) {
      if (e is SocketException) {
        //loading db cached data
        final apiDao = database.httpDataDao;
        res = Response((await apiDao.findDataByApi("coronatab")).data, 202);
      }
    }
    HttpData resForDb = HttpData(1, res.body, "coronatab");
    await database.httpDataDao.insertApi(resForDb);
    List<dynamic> places = json.decode(res.body)['data'];
    coronaTabStates = [];
    places.forEach((state) {
      coronaTabStates.add(Place(
        country: state['name'],
        cases: state['latestData']['cases'],
        deaths: state['latestData']['deaths'],
        lat: state['location'] != null
            ? (state['location']['coordinates'][1] is int
                ? state['location']['coordinates'][1].toDouble()
                : state['location']['coordinates'][1])
            : 0,
        lon: state['location'] != null
            ? (state['location']['coordinates'][0] is int
                ? state['location']['coordinates'][0].toDouble()
                : state['location']['coordinates'][0])
            : 0,
        population: state['population'] != null ? state['population'] : -1,
        recovered: state['latestData']['recovered'],
        hospitalBedOccupancy: state['hospitalBedOccupancy'],
        hospitalBeds: state['hospitalBeds'],
        icuBeds: state['icuBeds'],
        lastUpdate: DateTime.parse(state['latestData']['date']),
      ));
    });
  }

  Future<void> loadDataRapidApi() async {
    APIService api = APIService();
    var res = await api.get(endpoint: '/geojson-ww', query: {});
    List<dynamic> states = res['features'];
    states.forEach((state) {
      String name = state['properties']['name'];
      double lat = double.tryParse(state['properties']['latitude']);
      double lon = double.tryParse(state['properties']['longitude']);
      if (lat == null || lon == null) {
        print("Invalid State" + name);
      } else {
        int all = state['properties']['confirmed'] is int
            ? state['properties']['confirmed']
            : null;
        int deaths = state['properties']['deaths'] is int
            ? state['properties']['deaths']
            : null;
        int positive = state['properties']['active'] is int
            ? state['properties']['active']
            : null;
        int recovered = state['properties']['recovered'] is int
            ? state['properties']['recovered']
            : null;
        LatLng latlng = LatLng(lat, lon);
        _markers.add(Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: MarkerId(latlng.toString()),
          position: latlng,
          icon: myIcon,
          infoWindow: InfoWindow(
            title: name + "(" + all.toString() + ")",
            snippet: 'P:' + positive.toString(),
          ),
        ));
      }
    });
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        icon: myIcon,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating\nnice and cool\nidcare',
        ),
      ));
    });
  }

  toggleDetail() {
    print("Changing map");
    detailedMap = !detailedMap;
    _markers.clear();
    if (detailedMap) {
      loadDataFromNinja();
      loadDataCoronaTabApi();
    } else {
      loadDataFromNinja();
    }
    setState(() {});
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _tapMapInfo(LatLng pos) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CoronaDetails(place: coronaTabStates[0]),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
          backgroundColor: primaryColor,
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            GoogleMap(
              mapToolbarEnabled: false,
              mapType: _currentMapType,
              markers: _markers,
              onCameraMove: _onCameraMove,
              onMapCreated: _onMapCreated,
              onTap: (pos) {
                _tapMapInfo(pos);
              },
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 0.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                      heroTag: null,
                      onPressed: _onMapTypeButtonPressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.map, size: 36.0),
                    ),
                    SizedBox(height: 16.0),
                    FloatingActionButton(
                      heroTag: null,
                      onPressed: () => toggleDetail(),
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: Icon(
                          detailedMap ? Icons.zoom_out : Icons.add_location,
                          size: 36.0),
                    ),
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
