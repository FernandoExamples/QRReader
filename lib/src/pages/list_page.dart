import 'package:flutter/material.dart';
import 'package:qrreader/src/bloc/scann_bloc.dart';
import 'package:qrreader/src/models/scann_model.dart';
import 'package:qrreader/src/utils/my_utils.dart' as utils;

class ListPage extends StatelessWidget {

  final bloc = ScannsBloc();
  final type;

  ListPage({@required this.type});
  
  @override
  Widget build(BuildContext context) {

    bloc.getAllScanns();
    
    return StreamBuilder(
      stream: _getStream(),
      builder: (context, AsyncSnapshot<List<ScannModel>> snapshot){

        if(!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        var scans = snapshot.data;

        if(scans.length == 0)
          return Center(child: Text('No hay informacion para mostrar'));
      
        return _builder(context, snapshot.data);
      },
    );
  }

  ListView _builder(BuildContext context, List<ScannModel> scans){

    return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, index){

            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.startToEnd,
              background: _deleteBackground(),

              confirmDismiss: (direction) async {
                return await utils.showConfirmDialog(
                  context: context,
                  title: 'Borrar',
                  content: '¿Deseas borrar el elemento?',
                );
              },

              onDismissed: (direction){
                bloc.deleteScan(scans[index].id);
              },

              child: ListTile(
                leading: Icon(_getLeadingicon(), color: Theme.of(context).primaryColor),
                trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                title: Text(scans[index].value),  
                subtitle: Text('ID: ${scans[index].id}'),
                onTap: () {

                  utils.openScan(scans[index], context).catchError((error){
                    utils.showToast(context, error.toString());                      
                  });                

                }                           
              ),
            );
          },
        );
  }

  Widget _deleteBackground(){
    return Container(
       color: Colors.red,
       child: ListTile(
         leading: Icon(Icons.delete, color: Colors.black),
       )
    );
  }

  Stream<List<ScannModel>> _getStream(){
    return type == 'http' ? bloc.scansStreamHttp : bloc.scansStreamGeo;
  }

  IconData _getLeadingicon(){
    // return type == 'http' ? Icons.wifi_tethering : Icons.map;
    switch (type) {
      case 'http':
        return Icons.wifi_tethering;
      case 'geo':
        return Icons.map;
      default:
        return Icons.widgets;
    }
    
  }
  
}