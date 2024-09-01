import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _sortAscending = true;
  int _sortColumnIndex = 0;

  List<Map<String, dynamic>> data = [
    {
      "Stock": "JETFREIGHT.NS",
      "Date": "2023-01-11T00:00:00+05:30",
      "Pct_Change_High": 17.62,
      "Pct_Change_Close": 8.03
    },
    //... rest of the data
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 360 ? 12 : 14;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Stock Data Table'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              DataTable(
                columnSpacing: screenWidth < 360 ? 10 : 20,
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                columns: [
                  DataColumn(
                    label: Flexible(
                      child: Text('Stock', style: TextStyle(fontSize: fontSize)),
                    ),
                    onSort: (int columnIndex, bool ascending) {
                      _onSortColumn(columnIndex, ascending, 'Stock');
                    },
                  ),
                  DataColumn(
                    label: Flexible(
                      child: Text('Date', style: TextStyle(fontSize: fontSize)),
                    ),
                    onSort: (int columnIndex, bool ascending) {
                      _onSortColumn(columnIndex, ascending, 'Date');
                    },
                  ),
                  DataColumn(
                    label: Flexible(
                      child: Text('High', style: TextStyle(fontSize: fontSize)),
                    ),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) {
                      _onSortColumn(columnIndex, ascending, 'Pct_Change_High');
                    },
                  ),
                  DataColumn(
                    label: Flexible(
                      child: Text('Close', style: TextStyle(fontSize: fontSize)),
                    ),
                    numeric: true,
                    onSort: (int columnIndex, bool ascending) {
                      _onSortColumn(columnIndex, ascending, 'Pct_Change_Close');
                    },
                  ),
                ],
                rows: data.map((stockData) {
                  return DataRow(cells: [
                    DataCell(Text(stockData['Stock'], style: TextStyle(fontSize: fontSize))),
                    DataCell(Text(_formatDate(stockData['Date']), style: TextStyle(fontSize: fontSize))),
                    DataCell(Text(stockData['Pct_Change_High'].toStringAsFixed(2), style: TextStyle(fontSize: fontSize))),
                    DataCell(Text(stockData['Pct_Change_Close'].toStringAsFixed(2), style: TextStyle(fontSize: fontSize))),
                  ]);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSortColumn(int columnIndex, bool ascending, String columnName) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      if (ascending) {
        data.sort((a, b) => a[columnName].compareTo(b[columnName]));
      } else {
        data.sort((a, b) => b[columnName].compareTo(a[columnName]));
      }
    });
  }

  String _formatDate(String date) {
    final dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }
}
