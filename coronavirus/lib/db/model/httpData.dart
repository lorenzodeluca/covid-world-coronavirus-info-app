 // entity/person.dart

 import 'package:floor/floor.dart';

 @entity
 class HttpData {
   @primaryKey
   final int id;

   String apiName;

   final String data;

   HttpData(this.id, this.data, this.apiName);
 }