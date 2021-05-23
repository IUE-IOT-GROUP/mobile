import 'dart:convert';

import 'package:prototype/models/place.dart';
import 'package:http/http.dart' as http;

import '../global.dart';

class PlaceService {
  static String placesUrl = "${Global.baseUrl}/places";

  static Future<List<Place>> getPlaces() async {
    print("we are in getPlaces now!");
    List<Place> places = [];
    final response = await Global.h_get(placesUrl, appendToken: true)
        .then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];
      places = List<Place>.from(data.map((model) {
        var place = Place.fromJson(model);
        List<dynamic> subPlaces = model['places'];
        print("71 ${model.runtimeType}");
        if (subPlaces.isNotEmpty) {
          place.places = List<Place>.from(
              subPlaces.map((model2) => Place.fromJson(model2)));
          print(place.places!.first.name);
        }
        return place;
      }));
    });

    print("global $places");

    return places;
  }

  static void deletePlace(Place place) async {
    final response = await Global.h_delete("$placesUrl/${place.id}");
  }
}
