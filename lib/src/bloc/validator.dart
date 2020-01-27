
import 'dart:async';

import 'package:qrreader/src/providers/db_provider.dart';

class Validators {

  final validateGeo = StreamTransformer<List<ScannModel>, List<ScannModel>>.fromHandlers(
    handleData: (scans, sink){

      List geoScans = scans.where((sc) => sc.type == 'geo' || sc.type == 'other' ).toList();

      sink.add(geoScans);            
    }
  );

  final validateHttp = StreamTransformer<List<ScannModel>, List<ScannModel>>.fromHandlers(
    handleData: (scans, sink){

      List httpScans = scans.where((sc) => sc.type == 'http' || sc.type == 'other' ).toList();

      sink.add(httpScans);            
    }
  );
  
}