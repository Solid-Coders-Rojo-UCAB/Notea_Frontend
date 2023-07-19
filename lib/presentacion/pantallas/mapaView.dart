import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../aplicacion/locationService.dart';
import '../../dominio/agregados/Entidades/userLocation.dart';



class MapaView extends StatefulWidget {
  double? latitud;
  double? longitud;
  bool creando;
  MapaView({super.key, required this.creando, this.latitud, this.longitud});

  @override
  State<MapaView> createState() => _MapaViewState();
}

class _MapaViewState extends State<MapaView> {
  static AudioPlayer player = AudioPlayer();

  static String alarmAudioPath = "audios/birdSoundEdit.mp3";

  LocationServices locationService = LocationServices();
  UserLocation? userLocation;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Placemark placemark = Placemark();
  late BitmapDescriptor icon = BitmapDescriptor.defaultMarker;

  bool SoloVer = false;

  Future<Placemark> _getCurrentLocation() async {
    userLocation = await locationService.getCurrentLocation();
    print(
        " get curren loc \n ${userLocation!.latitude} ${userLocation!.longitude}");
    return (await placemarkFromCoordinates(
        userLocation!.latitude, userLocation!.longitude))[0];
  }

  Future<Placemark> _loadCurrentLocation() async {
    return (await placemarkFromCoordinates(
        userLocation!.latitude, userLocation!.longitude))[0];
  }

  @override
  void initState() {
    super.initState();
    if (widget.latitud == 0 || widget.longitud == 0) {
      userLocation = UserLocation(0, 0);
      SoloVer = false;
    } else {
      userLocation = UserLocation(widget.latitud!, widget.longitud!);
      SoloVer = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        placemark = await _loadCurrentLocation();
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    locationService.closeLocation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Mapa",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF21579C),
        ),
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(userLocation!.latitude, userLocation!.longitude),
                    zoom: 14.4746,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  markers: {
                    Marker(
                        markerId: const MarkerId("User"),
                        position: LatLng(
                            userLocation!.latitude, userLocation!.longitude),
                        infoWindow: const InfoWindow(
                          title: "Ubicacion de la Nota",
                        ),
                        icon: icon)
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            if (userLocation!.latitude != 0 && userLocation!.longitude != 0)
              Text(
                "Ubicacion Actual: ${placemark.thoroughfare}, ${placemark.subAdministrativeArea}, ${placemark.locality} ",
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF21579C)),
                textAlign: TextAlign.center,
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(

                    
                    onPressed: () {
                      Navigator.pop(context,
                          [userLocation!.latitude , userLocation!.longitude]);
                    },
                    style:  ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF21579C),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    child: const Text("Listo")
                ),
                const SizedBox(
                  width: 10,
                ),
                (SoloVer == false && widget.creando == true)
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, [0.0, 0.0]);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF21579C),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        child: const Text("Cancelar")
                        )
                    : const SizedBox.shrink(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
        floatingActionButton: (SoloVer == false && widget.creando == true)
            ? FloatingActionButton(
                heroTag: "btnLocation",
                onPressed: () async {
                  placemark = await _getCurrentLocation();
                  player.play(AssetSource(alarmAudioPath));

                  setState(() {
                    _controller.future.then((value) => value.animateCamera(
                        CameraUpdate.newCameraPosition(CameraPosition(
                            target: LatLng(userLocation!.latitude,
                                userLocation!.longitude),
                            zoom: 14.4746))));
                  });
                },
                tooltip: 'Obtener Ubicacion',
                hoverColor: Colors.redAccent,
                splashColor: Colors.greenAccent,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
              )
            : const SizedBox.shrink());
  }
}
