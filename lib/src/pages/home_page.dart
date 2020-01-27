import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qrreader/src/bloc/scann_bloc.dart';
import 'package:qrreader/src/models/scann_model.dart';
import 'package:qrreader/src/pages/list_page.dart';
import 'package:qrreader/src/utils/my_utils.dart' as utils;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ScannsBloc bloc = ScannsBloc();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _appBar(context),
       body: _changePage(_currentIndex),
       bottomNavigationBar: _bottomNavigationBar(context),
       floatingActionButton: _floattingButton(),
       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AppBar _appBar(BuildContext context){
    return AppBar(
      title: Text('QR Scanner'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () => _showConfirmDialog(context)
        ),
      ],
    );
  }

  BottomNavigationBar _bottomNavigationBar(BuildContext context){
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index){
        setState(() {
          _currentIndex = index;
        });
      },
      items: [
        _bottonNavItem(Icons.map, 'Mapas'),
        _bottonNavItem(Icons.brightness_5, 'Direcciones')
      ],
    );
  }

  BottomNavigationBarItem _bottonNavItem(IconData icon, String text){
    return BottomNavigationBarItem(
      icon: Icon(icon),
      title: Text(text)
    );
  }

  Widget _floattingButton(){  
    return Builder(
      builder: (context) {

        return FloatingActionButton(
          child: Icon(Icons.filter_center_focus),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => _scannQR(context),
        );
      }
    );
  } 
    
  

  Widget _changePage(int currentPage){
    switch (currentPage) {
      case 0:
        return ListPage(type: 'geo');
        break;
      case 1:
      return ListPage(type: 'http');
        break;

      default:
      return ListPage(type: 'geo');
    }
  }

  void _scannQR(BuildContext context) async {
    //https://sii.itcelaya.edu.mx/sii/index.php?r=cruge/ui/login
    //geo:20.482293,-100.961758

    String futureString = 'texto';

    // try {
    //   futureString = await BarcodeScanner.scan();
    // } catch (e) {
    //   print(e.toString());
    // }

    if(futureString != null){
      ScannModel scann = ScannModel(value: futureString);
      bloc.addScann(scann);

      //la animacion de IOS en cerrar la camara tarda aprox 750 milisegundos
      //y causa conflicto on la apertura del url. 
      if(Platform.isIOS){
        Future.delayed(Duration(milliseconds: 750), (){

          _openScan(scann, context);

        });
      }else{
          _openScan(scann, context);
      }           
    }

    // print(futureString);
  }

  void _openScan(ScannModel scann, BuildContext context){
    utils.openScan(scann, context).catchError((error){
        utils.showToast(context, error.toString());
    }); 
  }

  void _showConfirmDialog(BuildContext context) async {
    bool res = await utils.showConfirmDialog(
                        context: context,
                        title: 'Borrar Todo',
                        content: '¿Deseas borrar todos los elementos?',
                    );

    if(res)
      bloc.deleteAllScanns();
  }

  

}