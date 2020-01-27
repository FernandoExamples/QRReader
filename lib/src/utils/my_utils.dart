import 'package:flutter/material.dart';
import 'package:qrreader/src/models/scann_model.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> showConfirmDialog({BuildContext context, String title, String content}) async {

    bool res = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context){
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[

            FlatButton(
              child: Text('Cancelar'),
              onPressed: (){
                Navigator.of(context).pop(false);
              },
            ),

            FlatButton(
              child: Text('Si'),
              onPressed: (){
                Navigator.of(context).pop(true);
              },
            ),

          ],
        );
      }
    );

    return res;
  }

 Future openScan(ScannModel scann, BuildContext context) async {
  String url = scann.value;

  if(scann.type == 'http'){

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }  

  }else if(scann.type == 'geo'){
    Navigator.pushNamed(context, 'maps', arguments: scann);
  }else{
    throw 'Could not open other thing than http or geo links yet';
  }
  
}

void showToast(BuildContext context, String msg) {
    // Toast.show(msg, context, duration: duration, gravity: gravity);
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
}