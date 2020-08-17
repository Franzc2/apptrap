import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MarcarLugarResidenciaPage extends StatefulWidget {
  final Map datosUbicacionLugarResidencia;
  MarcarLugarResidenciaPage({Key key,this.datosUbicacionLugarResidencia}) : super(key: key);
  @override
  _MarcarLugarResidenciaPageState createState() {
    return _MarcarLugarResidenciaPageState();
  }
}

class _MarcarLugarResidenciaPageState extends State<MarcarLugarResidenciaPage> {


  MapType _defaultMapType = MapType.normal;
  Map <MarkerId, Marker> _markers=Map();//es un array de marcadores pero en este caso solo guardaremos un marcador en la posicion 0
  String lugarResidencia=""; //posicion 0 en el array
  static LatLng latitud_longitud=LatLng(-19.047084, -65.259701); //posicion 1 en el array



  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  CameraPosition _initialPosition = CameraPosition(target: latitud_longitud,zoom: 17,);
  Completer<GoogleMapController> _controller = Completer();



  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();

    if(widget.datosUbicacionLugarResidencia.isEmpty){
      _getUserLocation();
    }
    else{
      GeoPoint geoPoint=widget.datosUbicacionLugarResidencia['geoPoint'];
      _moverCamera(CameraPosition(target: LatLng(geoPoint.latitude, geoPoint.longitude) ,zoom: 18));
      _markers[MarkerId("0")]=Marker(markerId: MarkerId("0"),position: LatLng(geoPoint.latitude, geoPoint.longitude));
    }
  }

  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitud_longitud = LatLng(position.latitude, position.longitude);
      _markers[MarkerId("0")]=Marker(markerId: MarkerId("0"),position: latitud_longitud);
    });
    _moverCamera(CameraPosition(target: latitud_longitud,zoom: 18));
    _cargarLugarResidencia(position.latitude, position.longitude);
  }

  _seleccionandoUbicacion(LatLng posicion){
    final markerid=MarkerId("0");
    final marker=Marker(markerId: markerid,position: posicion);
    setState(() {
      _markers[markerid]=marker;
    });
    _cargarLugarResidencia(posicion.latitude, posicion.longitude);
  }

  Future<void> _moverCamera(CameraPosition cameraPosition) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _cargarLugarResidencia(double latitud, double longitud)async{
    var addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(latitud, longitud));
    var first = addresses.first;
    setState(() {
      lugarResidencia=first.locality+', '+first.countryName;
//      print(lugarResidencia);
    });
    widget.datosUbicacionLugarResidencia['nombreLugar']=lugarResidencia;
    widget.datosUbicacionLugarResidencia['geoPoint']=GeoPoint(latitud,longitud);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Seleccionar ubicación'),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(63, 81, 181, 1.0),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.pop(context, widget.datosUbicacionLugarResidencia);
        },
        label: Text("Guardar ubicación"),
        icon: Icon(Icons.save),
        heroTag: "heroTagFloatingActionButton",
        backgroundColor: Color.fromRGBO(255, 193, 7, 1.0),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
          children: <Widget>[
            GoogleMap(
              myLocationButtonEnabled: true,
              mapType: _defaultMapType,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialPosition,
//              onCameraMove: _onCameraMove,
              markers: Set.of(_markers.values),
              onTap: _seleccionandoUbicacion,
              onLongPress: _seleccionandoUbicacion,
            ),
            Container(
              margin: EdgeInsets.only(top: 80, right: 10),
              alignment: Alignment.topRight,
              child: Column(
                  children: <Widget>[
                    FloatingActionButton(
                        child: Icon(Icons.layers),
                        elevation: 5,
                        backgroundColor: Colors.teal[200],
                        heroTag: "a",
                        onPressed: () {
                          _changeMapType();
                          print('Changing the Map Type');
                        }),
                  ]),
            ),
          ]),
    );
  }


}