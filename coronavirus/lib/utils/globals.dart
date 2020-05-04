library coronavirus.globals;

import 'package:coronavirus/models/place.dart';
import 'package:flutter/material.dart';

List<Place> ninjaStates;
List<Place> coronaTabStates=[];
List<dynamic> coronaTabHistory=[]; 
dynamic coronaTabHistoryWorld=[]; 

String title="Covid World";
var primaryColor=primaryBlack;

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);
const int _blackPrimaryValue = 0xFF000000;