import 'package:flutter_coffee_shop_app/models/api_models.dart';
import 'package:flutter_coffee_shop_app/services/dio_client.dart';
import 'package:http/http.dart';

import 'api_client.dart';

class TableService {
  final ApiClient _apiClient;

  TableService():_apiClient = ApiClient(DioClient().dio);

  Future<List<Table>> getTables() async {
    try {
      return await _apiClient.getTables();
    } catch (e) {
      print('Error getting tables: $e');
      throw e;
    }
  }

  Future<Table> getTableByNumber(int tableNumber) async{
    try{
      return await _apiClient.getTableByNumber(tableNumber);
    }catch (e) {
      print('Error getting table: $e');
      throw e;
    }
  }
  
  Future<Table> occupyTable(int tableNumber) async {
    try {
      return await _apiClient.occupyTable(tableNumber);
    } catch (e) {
      print('Error occupying table: $e');
      throw e;
    }
  }
  
  Future<Table> releaseTable(int tableNumber) async {
    try {
      return await _apiClient.releaseTable(tableNumber);
    } catch (e) {
      print('Error releasing table: $e');
      throw e;
    }
  }
}
