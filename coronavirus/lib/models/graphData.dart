import 'dart:ui';

import 'package:charts_flutter/flutter.dart' as charts;

class GraphData {
  final DateTime time;
  final int value;
  final charts.Color color;
  GraphData(this.time, this.value, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
