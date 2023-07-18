import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../dominio/agregados/Entidades/userLocation.dart';


class LocationServices {
  UserLocation? userLocation;
  Position? _currentLocation;

  Geolocator geolocator = Geolocator();
  bool serviceEnabled = false;
  late LocationPermission permission;

  final StreamController<UserLocation> _locationController =
      StreamController<UserLocation>();
  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationServices() {
    isLocationServiceEnabled();
  }

  void isLocationServiceEnabled() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
  }

  void enableLocation() async {
    if (!serviceEnabled) {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
      }
      if (permission == LocationPermission.denied) {
        //
      }
    }
  }

  void closeLocation() {
    _locationController.close();
  }

  Future<UserLocation> getCurrentLocation() async {
    try {
      var isServiceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!isServiceEnabled) {
        isServiceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!isServiceEnabled) {
          throw Exception("The Location service is disabled!");
        }
      }

      var isPermission = await Geolocator.checkPermission();
      if (isPermission == LocationPermission.denied ||
          isPermission == LocationPermission.deniedForever) {
        isPermission = await Geolocator.requestPermission();
      }
      if (isPermission == LocationPermission.denied ||
          isPermission == LocationPermission.deniedForever) {
        throw Exception("Location Permission requests has been denied!");
      }

      if (isServiceEnabled &&
          (isPermission == LocationPermission.always ||
              isPermission == LocationPermission.whileInUse)) {
        _currentLocation = await Geolocator.getCurrentPosition().timeout(
          const Duration(seconds: 3),
          onTimeout: () {
            throw TimeoutException(
                "Location information could not be obtained within the requested time.");
          },
        );

        userLocation = UserLocation(
            _currentLocation!.latitude, _currentLocation!.longitude);
        return userLocation!;
      } else {
        throw Exception("Location Service requests has been denied!");
      }
    } on TimeoutException catch (_) {
      print(_);
      rethrow;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
