 // database.dart

 // required package imports
 import 'dart:async';
 import 'package:floor/floor.dart';
 import 'package:path/path.dart';
 import 'package:sqflite/sqflite.dart' as sqflite;

 import 'dao/httpData_dao.dart';
 import 'model/httpData.dart';

 part 'database.g.dart'; // the generated code will be there

 @Database(version: 1, entities: [HttpData])
 abstract class AppDatabase extends FloorDatabase {
   HttpDataDao get httpDataDao;
 }