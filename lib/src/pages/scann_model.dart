import 'package:latlong/latlong.dart';

class ScannModel {
    int id;
    String type;
    String value;

    ScannModel({
        this.id,
        this.type,
        this.value,
    }){
      if(this.value.contains('http'))
        this.type = 'http';
      else
        this.type = 'geo';
    }

    factory ScannModel.fromMap(Map<String, dynamic> map) => ScannModel(
        id: map["id"],
        type: map["type"],
        value: map["value"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "value": value,
    };

    LatLng getLatLng(){
      //geo:40.797046384130965,-74.16249647578128

      var lalo = value
                    .substring(4)
                    .split(',');

      var lat = double.parse(lalo[0]);
      var lon = double.parse(lalo[1]);

      return LatLng(lat, lon);
    }
}
