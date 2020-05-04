import 'package:google_maps_flutter/google_maps_flutter.dart';
class Place{
  Place({this.continent,this.country,this.flag,this.lat,this.lon,this.cases=-1,this.todayCases=-1,this.deaths=-1,this.todayDeaths=-1,this.recovered=-1,this.active=-1,this.critical=-1,this.casesPerOneMillion=-1,this.deathsPerOneMillion=-1,this.tests=-1,this.testsPerOneMillion=-1,this.lastUpdate,this.population=-1,this.hospitalBedOccupancy=-1,this.hospitalBeds=-1,this.icuBeds=-1});
  String continent;
  String country;
  String flag;
  double lat;
  double lon;
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int critical;
  int casesPerOneMillion;
  int deathsPerOneMillion;
  int tests;
  int testsPerOneMillion;
  int population;
  DateTime lastUpdate;
  double hospitalBedOccupancy;
  int hospitalBeds;
  int icuBeds;
  String getInfo(){
    return "Continent: "+continent+
    ",total cases: "+cases.toString()+
    ", today cases: "+todayCases.toString()+
    ", deaths: "+deaths.toString()+
    ", todayDeaths: "+todayDeaths.toString()+
    ", critical: "+critical.toString()+
    ", casesPerOneMillion: "+casesPerOneMillion.toString()+
    ", deathsPerOneMillion: "+deathsPerOneMillion.toString()+
    ", tests: "+tests.toString()+
    ", testsPerOneMillion: "+testsPerOneMillion.toString()+".";
  }
}