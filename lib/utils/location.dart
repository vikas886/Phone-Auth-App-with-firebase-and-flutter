import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

Future<String> getLocation() async {
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  Coordinates coordinates = Coordinates(position.latitude, position.longitude);
  List<Address> list =
      await Geocoder.local.findAddressesFromCoordinates(coordinates);
  Address address = list.first;
  String fullAddress = "${address.countryName} ${address.locality}";
  return fullAddress;
  // return [position.latitude,position.longitude];
}
