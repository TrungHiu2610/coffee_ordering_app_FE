import 'package:flutter/foundation.dart';
import '../models/api_models.dart';
import '../services/table_service.dart';

class TableProvider with ChangeNotifier {
  final TableService _tableService = TableService();
  
  List<Table> _tables = [];
  bool _isLoading = false;
  String? _error;
  Table? _selectedTable;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Table> get tables => _tables;
  Table? get selectedTable => _selectedTable;

  Future<void> loadTables() async {
    _setLoading(true);
    try {
      _tables = await _tableService.getTables();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> selectTable(int tableNumber) async {
    try {
      await _tableService.occupyTable(tableNumber);
      _selectedTable = await _tableService.getTableByNumber(tableNumber);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  Future<void> releaseTable() async {
    if (_selectedTable == null) return;

    try {
      await _tableService.releaseTable(_selectedTable!.tableNumber);
      _selectedTable = null;
      await loadTables(); // Refresh table list
    } catch (e) {
      _setError(e.toString());
      rethrow;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _isLoading = false;
    notifyListeners();
  }
}
