import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class BasicoPage extends StatefulWidget {
  @override
  _BasicoPage createState() => _BasicoPage();
}

class _BasicoPage extends State<BasicoPage> {
  List<List<dynamic>> data = [];
  loadAsset() async {
    final myData = await rootBundle.loadString("assets/sales.csv");
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    print(csvTable);
    data = csvTable;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () async {
            await loadAsset();
            //print(data);
          }),
      appBar: AppBar(
        title: Text("Table Layout and CSV"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.file_upload), onPressed: () => {})
        ],
      ),
      body: SingleChildScrollView(
        child: Table(
          columnWidths: {
            0: FixedColumnWidth(100.0),
            1: FixedColumnWidth(200.0),
          },
          border: TableBorder.all(width: 1.0),
          children: data.map((item) {
            return TableRow(
                children: item.map((row) {
              return Container(
                color:
                    row.toString().contains("NA") ? Colors.red : Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    row.toString(),
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              );
            }).toList());
          }).toList(),
        ),
      ),
    );
  }
}
