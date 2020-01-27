import 'dart:async';

import 'package:qrreader/src/bloc/validator.dart';
import 'package:qrreader/src/providers/db_provider.dart';

class ScannsBloc with Validators {

  int random;
  static final ScannsBloc _singleTown = ScannsBloc._();

  final _scansController = StreamController<List<ScannModel>>.broadcast();

  Sink<List<ScannModel>> get scannSink => _scansController.sink;

  Stream<List<ScannModel>> get scansStreamGeo => _scansController.stream.transform(validateGeo);
  Stream<List<ScannModel>> get scansStreamHttp => _scansController.stream.transform(validateHttp);


  factory ScannsBloc() {
    return _singleTown;
  }

  ScannsBloc._() {
    //Obtener los Scans de la BD
    getAllScanns();
  }

  void dispose() {
    _scansController?.close();
  }

  void getAllScanns() async {
    scannSink.add(await DBProvider.db.getAllScanns());
  }

  void addScann(ScannModel scann) async {
    await DBProvider.db.saveScann(scann);
    getAllScanns();
  }

  void deleteScan(int id) async {
    await DBProvider.db.deleteScann(id);
    getAllScanns();
  }

  void deleteAllScanns() async {
    await DBProvider.db.deleteAll();
    getAllScanns();
  }
}
