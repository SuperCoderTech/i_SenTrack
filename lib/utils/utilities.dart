import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

Future<LocationData?> getLocationCoOrdinates() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }
  _locationData = await location.getLocation();
  return _locationData;
}
