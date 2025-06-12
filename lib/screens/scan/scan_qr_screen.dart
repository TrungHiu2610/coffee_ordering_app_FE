import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_coffee_shop_app/screens/home/home_screen.dart';
import 'package:flutter_coffee_shop_app/services/dio_client.dart';
import 'package:flutter_coffee_shop_app/services/table_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../providers/table_provider.dart';

class ScanQRScreen extends StatefulWidget {
  const ScanQRScreen({Key? key}) : super(key: key);

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  final TextEditingController _tableNumberController = TextEditingController();
  final TableService _tableService = TableService();
  late TableProvider tableProvider;
  int? _selectedTableNumber;

  late int? tableNumber;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isScanning = true;
  MobileScannerController _scannerController = MobileScannerController();
  late Future<void> _tablesFuture;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
    _tablesFuture =
        Provider.of<TableProvider>(context, listen: false).loadTables();
    // Get table num
    tableProvider = Provider.of<TableProvider>(context, listen: false);
    tableNumber = tableProvider.selectedTable?.tableNumber;
  }

  Future<void> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isDenied) {
      setState(() {
        _isScanning = false;
        _errorMessage = 'Cần cấp quyền camera để quét mã QR';
      });
    }
  }

  @override
  void dispose() {
    _tableNumberController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _processTableNumber(String tableNumber) async {
    if (tableNumber.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng chọn số bàn';
      });
      return;
    }

    // Try to parse the table number
    int? tableNum;
    try {
      tableNum = int.parse(tableNumber);
    } catch (e) {
      setState(() {
        _errorMessage = 'Số bàn không hợp lệ';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Verify table exists and try to occupy it
      final tableProvider = Provider.of<TableProvider>(context, listen: false);
      await tableProvider.selectTable(tableNum);

      // Table was successfully occupied, navigate to menu
      if (!mounted) return;
      // Instead of pushing HomeScreen directly, pushReplacementNamed to '/home' and pass tableNum as argument
      Navigator.pushReplacementNamed(context, '/home', arguments: tableNum);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi: ${e.toString()}';
      });
    }
  }

  void _switchToManualInput() {
    setState(() {
      _isScanning = false;
    });
  }

  void _switchToScanner() {
    setState(() {
      _isScanning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quét mã QR bàn'),
        actions: [
          IconButton(
            icon: Icon(_isScanning ? Icons.edit : Icons.qr_code_scanner),
            onPressed: _isScanning ? _switchToManualInput : _switchToScanner,
            tooltip: _isScanning ? 'Chọn thủ công' : 'Quét QR',
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _isScanning
              ? _buildQRScanner()
              : _buildManualInput(),
    );
  }

  Widget _buildQRScanner() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: MobileScanner(
            controller: _scannerController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                final String code = barcodes.first.rawValue ?? '';
                // Try to extract table number from QR code
                // Assuming QR code contains just the table number
                _scannerController.stop();
                _processTableNumber(code);
              }
            },
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        const Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Hướng camera vào mã QR trên bàn để quét. Mã QR chứa số bàn của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildManualInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Chọn số bàn:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          FutureBuilder(
            future: _tablesFuture,
            builder: (context, snapshot) {
              if (tableProvider.isLoading) {
                return Center(child: CircularProgressIndicator());
              }
              final availableTables =
                  tableProvider.tables.where((t) => !t.isOccupied).toList();
              if (availableTables.isEmpty) {
                return Text(
                  'Không còn bàn trống',
                  style: TextStyle(color: Colors.red),
                );
              }
              return DropdownButton<int>(
                hint: const Text('Chọn số bàn'),
                value: _selectedTableNumber,
                items:
                    availableTables.map((table) {
                      return DropdownMenuItem<int>(
                        value: table.tableNumber,
                        child: Text('Bàn ${table.tableNumber}'),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTableNumber = value;
                  });
                },
              );
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed:
                _selectedTableNumber == null
                    ? null
                    : () async {
                      if (_selectedTableNumber != null) {
                        try {
                          await tableProvider.selectTable(
                            _selectedTableNumber!,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Đã chọn bàn ${_selectedTableNumber} thành công!',
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          // Xử lý lỗi khi gọi API
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Lỗi khi chọn bàn: $e')),
                          );
                        }
                      }
                    },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }
}
