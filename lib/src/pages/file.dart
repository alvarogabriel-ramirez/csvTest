
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'package:csv_test/src/models/csv_Model.dart';
import 'package:csv_test/src/providers/csv_Provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => new _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final formKey = GlobalKey<FormState>();
  
  SubmitModel submit = new  SubmitModel();
  Provider providers = new Provider();
  final firestoreInstance = Firestore.instance;

  String _p1;
  String _p2;
  int _p3;
  int _p4;


  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();
  List<List<dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, allowedExtensions: ["csv"]);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(type: FileType.any);
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('File Picker example app'),
        ),
        body: new Center(
            child: new Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: new SingleChildScrollView(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // new Padding(
                //   padding: const EdgeInsets.only(top: 20.0),
                //   child: new DropdownButton(
                //       hint: new Text('LOAD PATH FROM'),
                //       value: _pickingType,
                //       items: <DropdownMenuItem>[
                //         new DropdownMenuItem(
                //           child: new Text('FROM AUDIO'),
                //           value: FileType.audio,
                //         ),
                //         new DropdownMenuItem(
                //           child: new Text('FROM IMAGE'),
                //           value: FileType.image,
                //         ),
                //         new DropdownMenuItem(
                //           child: new Text('FROM VIDEO'),
                //           value: FileType.video,
                //         ),
                //         new DropdownMenuItem(
                //           child: new Text('FROM ANY'),
                //           value: FileType.any,
                //         ),
                //         new DropdownMenuItem(
                //           child: new Text('CUSTOM FORMAT'),
                //           value: FileType.custom,
                //         ),
                //       ],
                //       onChanged: (value) => setState(() {
                //             _pickingType = value;
                //             if (_pickingType != FileType.custom) {
                //               _controller.text = _extension = '';
                //             }
                //           })),
                // ),
                // new ConstrainedBox(
                //   constraints: BoxConstraints.tightFor(width: 100.0),
                //   child: _pickingType == FileType.custom
                //       ? new TextFormField(
                //           maxLength: 15,
                //           autovalidate: true,
                //           controller: _controller,
                //           decoration:
                //               InputDecoration(labelText: 'File extension'),
                //           keyboardType: TextInputType.text,
                //           textCapitalization: TextCapitalization.none,
                //           validator: (value) {
                //             RegExp reg = new RegExp(r'[^a-zA-Z0-9]');
                //             if (reg.hasMatch(value)) {
                //               _hasValidMime = false;
                //               return 'Invalid format';
                //             }
                //             _hasValidMime = true;
                //           },
                //         )
                //       : new Container(),
                // ),
                // new ConstrainedBox(
                //   constraints: BoxConstraints.tightFor(width: 200.0),
                //   child: new SwitchListTile.adaptive(
                //     title: new Text('Pick multiple files',
                //         textAlign: TextAlign.right),
                //     onChanged: (bool value) =>
                //         setState(() => _multiPick = value),
                //     value: _multiPick,
                //   ),
                // ),
                new Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: new RaisedButton(
                    onPressed: () => _openFileExplorer(),
                    child: new Text("Open fle picker"),
                  ),
                ),
                  new Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                  child: new RaisedButton(
                    onPressed:  () => subb,
                    child: new Text("submit"),
                  ),
                ),
                
                new Builder(
                  builder: (BuildContext context) => _path != null ||
                          _paths != null
                      ? new Container(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: new Scrollbar(
                              child: new ListView.separated(
                            itemCount: _paths != null && _paths.isNotEmpty
                                ? _paths.length
                                : 1,
                            itemBuilder: (BuildContext context, int index) {
                              final bool isMultiPath =
                                  _paths != null && _paths.isNotEmpty;
                              final String name = 'File $index: ' +
                                  (isMultiPath
                                      ? _paths.keys.toList()[index]
                                      : _fileName ?? '...');
                              final path = isMultiPath
                                  ? _paths.values.toList()[index].toString()
                                  : _path;

                              loadAsset(path);

                              return new Container(
                                child: SingleChildScrollView(
                                  child: Table(
                                    columnWidths: {
                                      0: FixedColumnWidth(50.0),
                                      1: FixedColumnWidth(150.0),
                                    },
                                    border: TableBorder.all(width: 2.0),
                                    children: data.map((item) {
                                      return TableRow(
                                          children: item.map((row) {
                                        return Container(
                                          color: row.toString().contains("10")
                                              ? Colors.red
                                              : Colors.green[100],
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              row.toString(),
                                              style: TextStyle(fontSize: 15.0),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      }).toList());
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    new Divider(),
                          )),
                        )
                      : new Container(),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

 loadAsset(String path) async {
    final myData = await rootBundle.loadString(path);
    List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
    data = csvTable;

    for (var i = 1; i < data.length - 1; i++) {
      var datos = data[i];
      _p1 = datos[0];
      _p2 = datos[1];
      _p3 = datos[2];
      _p4 = datos[3];

        submit.param1  =_p1;
        submit.param2  =_p2;
        submit.param3  =_p3;
        submit.param4 =_p4;
          //print(submit.param1);
    }

    setState(() {});
  }

 void subb()async{

    formKey.currentState.save();
          providers.crearJson(submit);

  }
}
