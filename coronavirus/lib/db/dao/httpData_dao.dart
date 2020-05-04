 // dao/httpData_dao.dart

 import 'package:coronavirus/db/model/httpData.dart';
import 'package:floor/floor.dart';

 @dao
 abstract class HttpDataDao {
   @Query('SELECT * FROM HttpData')
   Future<List<HttpData>> getAll();

   @Query('SELECT * FROM HttpData WHERE apiName = :api')
   Future<HttpData> findDataByApi(String api);

   @Query('DELETE FROM HttpData')
   Future<void> clean();

   @insert
   Future<void> insertApi(HttpData data);
 }