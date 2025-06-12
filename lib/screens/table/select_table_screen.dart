import 'package:flutter/material.dart';
import '../../models/api_models.dart' as model;
import '../../services/table_service.dart';

class SelectTableScreen extends StatefulWidget {
  const SelectTableScreen({Key? key}) : super(key: key);

  @override
  State<SelectTableScreen> createState() => _SelectTableScreenState();
}

class _SelectTableScreenState extends State<SelectTableScreen> {
  final TableService _tableService = TableService();
  bool _isLoading = true;
  String? _error;
  List<model.Table> _tables = [];
  
  @override
  void initState() {
    super.initState();
    _loadTables();
  }
  
  Future<void> _loadTables() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final tables = await _tableService.getTables();
      setState(() {
        _tables = tables;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  Future<void> _selectTable(model.Table table) async {
    try {
      if (!table.isOccupied) {
        await _tableService.occupyTable(table.tableNumber);
        Navigator.pop(context, table.tableNumber);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error selecting table: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chọn bàn'),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_error!),
                      ElevatedButton(
                        onPressed: _loadTables,
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadTables,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _tables.length,
                    itemBuilder: (context, index) {
                      final table = _tables[index];
                      return Card(
                        color: table.isOccupied ? Colors.grey.shade300 : Colors.white,
                        child: InkWell(
                          onTap: table.isOccupied 
                              ? null 
                              : () => _selectTable(table),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.table_restaurant,
                                size: 32,
                                color: table.isOccupied ? Colors.grey : Colors.brown,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Bàn ${table.tableNumber}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: table.isOccupied ? Colors.grey : Colors.black,
                                ),
                              ),
                              if (table.isOccupied)
                                const Text(
                                  'Đã có người',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
