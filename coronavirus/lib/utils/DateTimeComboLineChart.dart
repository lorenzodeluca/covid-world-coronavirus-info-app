import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:coronavirus/models/GraphData.dart';
import 'package:coronavirus/models/place.dart';
import 'package:coronavirus/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeComboLinePointChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  final Place place;
  DateTimeComboLinePointChart(this.seriesList, {this.place, this.animate});

  List<Series<GraphData, DateTime>> serieCases = [];
  List<Series<GraphData, DateTime>> serieDeaths = [];
  List<Series<GraphData, DateTime>> serieRecovered = [];

  /// Creates a [GraphData] chart with a place data
  factory DateTimeComboLinePointChart.withHistoryData(Place place) {
    return new DateTimeComboLinePointChart(
      _loadHistoryData(place),
      // Disable animations for image tests.
      animate: true,
    );
  }

  factory DateTimeComboLinePointChart.withHistoryDataWorld() {
    return new DateTimeComboLinePointChart(
      _loadWorldData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      // Configure the default renderer as a line renderer. This will be used
      // for any series that does not define a rendererIdKey.
      //
      // This is the default configuration, but is shown here for  illustration.
      defaultRenderer: new charts.LineRendererConfig(),
      // Custom renderer configuration for the point series.
      customSeriesRenderers: [
        new charts.PointRendererConfig(
            // ID used to link series to this renderer.
            customRendererId: 'customPoint')
      ],
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
      behaviors: [
        new charts.SeriesLegend(
          // Positions for "start" and "end" will be left and right respectively
          // for widgets with a build context that has directionality ltr.
          // For rtl, "start" and "end" will be right and left respectively.
          // Since this example has directionality of ltr, the legend is
          // positioned on the right side of the chart.
          position: charts.BehaviorPosition.bottom,
          // For a legend that is positioned on the left or right of the chart,
          // setting the justification for [endDrawArea] is aligned to the
          // bottom of the chart draw area.
          outsideJustification: charts.OutsideJustification.endDrawArea,
          // By default, if the position of the chart is on the left or right of
          // the chart, [horizontalFirst] is set to false. This means that the
          // legend entries will grow as new rows first instead of a new column.
          horizontalFirst: false,
          // By setting this value to 2, the legend entries will grow up to two
          // rows before adding a new column.
          desiredMaxRows: 1,
          // This defines the padding around each legend entry.
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          // Render the legend entry text with custom styles.
          entryTextStyle: charts.TextStyleSpec(
              color: charts.Color.black, fontFamily: 'Comic', fontSize: 19),
        )
      ],
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GraphData, DateTime>> _loadHistoryData(
      Place place) {
    List<GraphData> cases = [], deaths = [], recovered = [], positives = [];
    coronaTabHistory.forEach((f) {
      if (f['country'] == place.country) {
        f['timeline']['cases'].forEach((String date, number) {
          cases.add(
              GraphData(DateFormat('yMd').parse(date), number, Colors.red));
        });
        f['timeline']['deaths'].forEach((String date, number) {
          deaths.add(
              GraphData(DateFormat('yMd').parse(date), number, Colors.yellow));
        });
        f['timeline']['recovered'].forEach((String date, number) {
          recovered.add(
              GraphData(DateFormat('yMd').parse(date), number, Colors.black));
        });
        f['timeline']['cases'].forEach((String date, number) {
          int totalc = number;
          int d = f['timeline']['deaths'][date];
          int r = f['timeline']['recovered'][date];
          int positivesn = totalc - d - r;
          positives.add(
              GraphData(DateFormat('yMd').parse(date), positivesn, Colors.red));
        });
      }
    });

    return [
      new charts.Series<GraphData, DateTime>(
        id: 'Cases',
        colorFn: (_, __) => charts.Color.black,
        domainFn: (GraphData sales, _) => sales.time,
        measureFn: (GraphData sales, _) => sales.value,
        data: cases,
      ),
      new charts.Series<GraphData, DateTime>(
        id: 'Deaths',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GraphData sales, _) => sales.time,
        measureFn: (GraphData sales, _) => sales.value,
        data: deaths,
      ),
      new charts.Series<GraphData, DateTime>(
          id: 'Recovered',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (GraphData sales, _) => sales.time,
          measureFn: (GraphData sales, _) => sales.value,
          data: recovered),
      new charts.Series<GraphData, DateTime>(
          id: 'Positives',
          colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
          domainFn: (GraphData sales, _) => sales.time,
          measureFn: (GraphData sales, _) => sales.value,
          data: positives)
    ];
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<GraphData, DateTime>> _loadWorldData() {
    List<GraphData> cases = [], deaths = [], recovered = [], positives = [];
    coronaTabHistoryWorld['cases'].forEach((String date, number) {
      cases.add(GraphData(DateFormat('yMd').parse(date), number, Colors.red));
    });
    coronaTabHistoryWorld['deaths'].forEach((String date, number) {
      deaths
          .add(GraphData(DateFormat('yMd').parse(date), number, Colors.yellow));
    });
    coronaTabHistoryWorld['recovered'].forEach((String date, number) {
      recovered
          .add(GraphData(DateFormat('yMd').parse(date), number, Colors.black));
    });
    coronaTabHistoryWorld['cases'].forEach((String date, number) {
      int totalc = number;
      int d = coronaTabHistoryWorld['deaths'][date];
      int r = coronaTabHistoryWorld['recovered'][date];
      int positivesn = totalc - d - r;
      positives.add(
          GraphData(DateFormat('yMd').parse(date), positivesn, Colors.red));
    });

    return [
      new charts.Series<GraphData, DateTime>(
        id: 'Cases',
        colorFn: (_, __) => charts.Color.black,
        domainFn: (GraphData sales, _) => sales.time,
        measureFn: (GraphData sales, _) => sales.value,
        data: cases,
      ),
      new charts.Series<GraphData, DateTime>(
        id: 'Deaths',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (GraphData sales, _) => sales.time,
        measureFn: (GraphData sales, _) => sales.value,
        data: deaths,
      ),
      new charts.Series<GraphData, DateTime>(
          id: 'Recovered',
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (GraphData sales, _) => sales.time,
          measureFn: (GraphData sales, _) => sales.value,
          data: recovered),
      new charts.Series<GraphData, DateTime>(
          id: 'Positives',
          colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
          domainFn: (GraphData sales, _) => sales.time,
          measureFn: (GraphData sales, _) => sales.value,
          data: positives)
    ];
  }
}
