// import 'package:formvalidation/src/models/producto_model.dart';
// import 'package:mime_type/mime_type.dart';

import 'dart:convert';

import 'package:csv_test/src/models/csv_Model.dart';
import 'package:http_parser/http_parser.dart';
// import 'package:mime_type/mime_type.dart';
import 'package:http/http.dart' as http;


class Provider {

    final String _url ='https://flutter-varios-f1115.firebaseio.com';
    
    Future<bool>crearJson(SubmitModel submit )async{

        print(submit );
      final url ='$_url/submit.json';
          final resp = await http.post(url,body:submitModelToJson(submit));

        final decodedData = json.decode(resp.body);

        print (decodedData);
        return true ;
    }
}