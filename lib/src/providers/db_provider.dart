import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:qrreader/src/models/scann_model.dart';
export 'package:qrreader/src/models/scann_model.dart';

class DBProvider{

  static Database _database;
  static final DBProvider db = DBProvider._();

  final String _TABLE_SCANS = 'Scans';
  final String _SCANS_COL_ID = 'id';
  final String _SCANS_COL_TYPE = 'type';
  final String _SCANS_COL_VALUE = 'value';
  
  DBProvider._();

  Future<Database> get database async{
    if(_database != null) return _database;

    _database = await initDB();
    
    return _database;
  }

  Future<Database> initDB()async{
    Directory docsDirectory = await getApplicationDocumentsDirectory();

    String path = join(docsDirectory.path, 'ScansDB.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE $_TABLE_SCANS ('
          ' $_SCANS_COL_ID INTEGER PRIMARY KEY,'
          ' $_SCANS_COL_TYPE TEXT,'
          ' $_SCANS_COL_VALUE TEXT);'
        );
      }
    );

  }

  //OPERACIONES CRUD

  Future<int> saveScann(ScannModel scann) async {
    final db = await database;

    // int res = await db.insert(_TABLE_SCANS, {
    //   _SCANS_COL_ID:scann.id,
    //   _SCANS_COL_TYPE:scann.type,
    //   _SCANS_COL_VALUE:scann.value
    // });

    //para esta forma, las propiedades del toMap() programado, deben coincidir
    //con las columnas de la base de datos
    int res = await db.insert(_TABLE_SCANS, scann.toMap());

    return res;
  }

  Future<ScannModel> getScannId(int id) async {

    final db = await database;

    List res = await db.query(
      _TABLE_SCANS,
      where: '$_SCANS_COL_ID = ?',
      whereArgs: [id],
    );

    return res.isNotEmpty ? ScannModel.fromMap(res.first) : null;
  }

  Future<List<ScannModel>> getAllScanns() async {

    final db = await database;

     List res = await db.query(_TABLE_SCANS);

    List<ScannModel> list = 
              res.map((map) => ScannModel.fromMap(map)).toList();            

    return list;
  }

  Future<List<ScannModel>> getAllScannsByType(String type) async {

    final db = await database;

     List res = await db.query(
       _TABLE_SCANS,
       where: '$_SCANS_COL_TYPE = ?',
       whereArgs: [type]
    );

    List<ScannModel> list = 
            res.isNotEmpty ? 
            res.map((map) => ScannModel.fromMap(map)).toList() 
            : null;

    return list;
  }

  Future<int> updateScann(ScannModel newScan) async{
    final db = await database;

    int res = await db.update(
      _TABLE_SCANS, newScan.toMap(),
      where: '$_SCANS_COL_ID = ?',
      whereArgs: [newScan.id],
    );

    return res;
  }

  Future<int> deleteScann(int id) async{
    final db = await database;

    int res = await db.delete(
      _TABLE_SCANS,
      where: '$_SCANS_COL_ID = ?',
      whereArgs: [id],
    );

    return res;
  }


  Future<int> deleteAll() async{
    final db = await database;

    int res = await db.delete(_TABLE_SCANS);

    return res;
  }

}