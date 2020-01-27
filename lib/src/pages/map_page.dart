import 'package:flutter/material.dart';
import 'package:qrreader/src/providers/db_provider.dart';

import 'package:flutter_map/flutter_map.dart';

class MapPage extends StatefulWidget {

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final String _token = 
  'pk.eyJ1IjoiZmVybmFuZG9hY29zdGEiLCJhIjoiY2s1dTgyZGMxMGE5eDNkbnBqNDFqNGlneCJ9.PQnt1r8ZBblGtWs6GsyltQ';

  final mapController = MapController();
  
  //streets, dark, light, outdoors, satellite
  final mapStyles = ['streets',  'dark',  'light',  'outdoors',  'satellite'];
  int style = 0;

  ScannModel scan;

  @override
  Widget build(BuildContext context) {

    scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: _createAppBar(),
      body: _createFlutterMap(),       
      floatingActionButton: _createFloatingButton(),
    );
  }

  AppBar _createAppBar(){
    return AppBar(
      title: Text('Maps'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[

        IconButton(
          icon: Icon(Icons.gps_fixed),
          onPressed: (){
            mapController.move(scan.getLatLng(), 15.0);
          },
        )

      ],
    );
  }
  
  FloatingActionButton _createFloatingButton(){
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        style++;
        if(style == mapStyles.length)
          style = 0;

        setState(() {});
      },
    );
  }

  Widget _createFlutterMap() {

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scan.getLatLng(),
        zoom: 15.0
      ),

      layers: [
        _createMap(),
        _createMarks(scan),
      ],
    );
  }

  LayerOptions _createMap(){

    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
      '{style_id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',

      additionalOptions: {
        'accessToken' : _token,
        'style_id' : 'mapbox.${mapStyles[style]}', 
      }
    );
  }

  LayerOptions _createMarks(ScannModel scan){
    return MarkerLayerOptions(
      markers: [

        Marker(
          width: 100.0,
          height: 100.0,
          point: scan.getLatLng(),
          builder: (context) => Container(
              // color: Colors.blue,
              child: Icon(
                 Icons.location_on, 
                  size: 70.0, 
                  color: Theme.of(context).primaryColor,
              ),
          ),
        ),
        
      ]
    );
  }
}