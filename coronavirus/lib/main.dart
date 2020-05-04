import 'dart:convert';
import 'dart:io';

import 'package:coronavirus/db/database.dart';
import 'package:coronavirus/db/model/httpData.dart';
import 'package:coronavirus/utils/DateTimeComboLineChart.dart';
import 'package:coronavirus/utils/globals.dart';
import 'package:coronavirus/map.dart';
import 'package:coronavirus/models/place.dart';
import 'package:flutter/material.dart';
import 'package:coronavirus/details.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'utils/globals.dart' as globals;
import 'models/marqueeWidget.dart';
import 'package:animated_background/animated_background.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoronaInfo',
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: globals.title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    loadData();
    loadWorldHistory();
    loadHistory();
    super.initState();
  }

  void loadData() async {
    var res;
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    try {
      res = await http.get("https://corona.lmao.ninja/v2/countries/");
    } catch (e) {
      if (e is SocketException) {
        //loading db cached data
        final apiDao = database.httpDataDao;
        res = Response((await apiDao.findDataByApi("ninja")).data, 202);
      }
    }
    HttpData resForDb = HttpData(0, res.body, "ninja");
    await database.httpDataDao.clean();
    await database.httpDataDao.insertApi(resForDb);
    List<dynamic> places = json.decode(res.body);
    ninjaStates = [];
    places.forEach((state) {
      ninjaStates.add(Place(
          country: state['country'],
          continent: state['continent'],
          flag: state['countryInfo']['flag'],
          lat: state['countryInfo']['lat'] is int
              ? state['countryInfo']['lat'].toDouble()
              : state['countryInfo']['lat'],
          lon: state['countryInfo']['long'] is int
              ? state['countryInfo']['long'].toDouble()
              : state['countryInfo']['long'],
          cases: state['cases'],
          todayCases: state['todayCases'],
          deaths: state['deaths'],
          todayDeaths: state['todayDeaths'],
          recovered: state['recovered'],
          critical: state['critical'],
          active: state['active'],
          casesPerOneMillion: state['casesPerOneMillion'],
          deathsPerOneMillion: state['deathsPerOneMillion'],
          tests: state['tests'],
          testsPerOneMillion: state['testsPerOneMillion'],
          lastUpdate: DateTime.now()));
    });

    setState(() {});
  }

  void loadWorldHistory() async {
    var res;
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    try {
      res = await http.get("https://corona.lmao.ninja/v2/historical/all");
    } catch (e) {
      if (e is SocketException) {
        //loading db cached data
        final apiDao = database.httpDataDao;
        res = Response((await apiDao.findDataByApi("history")).data, 202);
      }
    }
    HttpData resForDb = HttpData(3, res.body, "worldhistory");
    await database.httpDataDao.insertApi(resForDb);
    coronaTabHistoryWorld = json.decode(res.body);
    setState(() {});
  }

  void loadHistory() async {
    var res;
    final database =
        await $FloorAppDatabase.databaseBuilder('app_database.db').build();
    try {
      res = await http.get("https://corona.lmao.ninja/v2/historical/");
    } catch (e) {
      if (e is SocketException) {
        //loading db cached data
        final apiDao = database.httpDataDao;
        res = Response((await apiDao.findDataByApi("worldhistory")).data, 202);
      }
    }
    HttpData resForDb = HttpData(2, res.body, "history");
    await database.httpDataDao.insertApi(resForDb);
    List<dynamic> places = json.decode(res.body);
    coronaTabHistory = places;
  }

  FixedExtentScrollController fixedExtentScrollController =
      new FixedExtentScrollController();

  String filter = "";
  List<Place> filteredPlaces = [];
  TextEditingController searchController = new TextEditingController();
  filterData(searchTerms) {
    filter = searchTerms;
    filteredPlaces.clear();
    ninjaStates.forEach((f) {
      if (f.country.toLowerCase().contains(searchTerms.toLowerCase()) ||
          f.continent.toLowerCase().contains(searchTerms.toLowerCase()))
        filteredPlaces.add(f);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ParticleOptions particleOptions = ParticleOptions(
      image: Image.asset('images/virus.png'),
      baseColor: Colors.blue,
      spawnOpacity: 0.0,
      opacityChangeRate: 0.25,
      minOpacity: 0.1,
      maxOpacity: 0.4,
      spawnMinSpeed: 30.0,
      spawnMaxSpeed: 70.0,
      spawnMinRadius: 7.0,
      spawnMaxRadius: 15.0,
      particleCount: 40,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: AnimatedBackground(
              behaviour: RandomParticleBehaviour(options: particleOptions),
              vsync: this,
              child: Text('Hello'),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50),
                  Text((ninjaStates != null) ? "" : "Loading..."),
                  coronaTabHistoryWorld.isEmpty || filter.isNotEmpty
                      ? Container()
                      : SizedBox(
                          width: width,
                          height: 280,
                          child: DateTimeComboLinePointChart
                              .withHistoryDataWorld(),
                        ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filter.isEmpty
                          ? ((ninjaStates != null) ? ninjaStates.length : 0)
                          : filteredPlaces.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CoronaDetails(
                                    place: filter.isEmpty
                                        ? ninjaStates[index]
                                        : filteredPlaces[index])),
                          ),
                          child: new Row(children: <Widget>[
                            Image.network(
                                filter.isEmpty
                                    ? ninjaStates[index].flag
                                    : filteredPlaces[index].flag,
                                width: 100,
                                height: 100, loadingBuilder:
                                    (BuildContext context, Widget child,
                                        ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return SizedBox(
                                width: 100,
                                height: 100,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                ),
                              );
                            }),
                            Expanded(
                              child: Column(children: <Widget>[
                                Text(filter.isEmpty
                                    ? ninjaStates[index].country
                                    : filteredPlaces[index].country),
                                MarqueeWidget(
                                    animationDuration: Duration(seconds: 7),
                                    direction: Axis.horizontal,
                                    child: Text(filter.isEmpty
                                        ? ninjaStates[index].getInfo()
                                        : filteredPlaces[index].getInfo())),
                              ]),
                            ),
                          ]),
                        );
                      })
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: TextFormField(
              controller: searchController,
              textAlign: TextAlign.center,
              onChanged: (f) => filterData(f),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'enter a search term here',
                  suffixIcon: IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        searchController.clear();
                        filterData("");
                      })),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CoronaMap()),
          );
        },
        tooltip: 'Open map',
        child: Icon(Icons.map),
      ),
    );
  }
}
