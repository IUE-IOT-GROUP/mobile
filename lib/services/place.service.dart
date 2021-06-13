import 'dart:convert';
import 'package:prototype/models/place.dart';
import 'package:http/http.dart' as http;
import '../global.dart';

class PlaceService {
  static String placesUrl = "${Global.baseUrl}/places";

  static Future<List<Place>> getPlaces() async {
    List<Place> places = [];
    final response = await Global.h_get(placesUrl, appendToken: true).then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];
      places = List<Place>.from(data.map((model) {
        var place = Place.fromJson(model);
        List<dynamic> subPlaces = model['places'];
        if (subPlaces.isNotEmpty) {
          place.places = List<Place>.from(subPlaces.map((model2) => Place.fromJson(model2)));
        }
        return place;
      }));
    });

    return places;
  }

  static Future<List<Place>> getChildPlaces() async {
    List<Place> places = [];
    final response = await Global.h_get(placesUrl, appendToken: true).then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];
      places = List<Place>.from(data.map((model) {
        var place = Place.fromJson(model);
        List<dynamic> subPlaces = model['places'];
        if (subPlaces.isNotEmpty) {
          place.places = List<Place>.from(subPlaces.map((model2) => Place.fromJson(model2)));
        }

        return place;
      }));
    });
    List<Place> childPlaces = [];
    places.forEach((element) {
      if (element.places!.isNotEmpty) {
        element.places!.forEach((e) {
          childPlaces.add(e);
        });
      }
    });
    return childPlaces;
  }

  static Future<bool> deletePlace(
    Place place,
  ) async {
    final response = await Global.h_delete("$placesUrl/${place.id}", appendToken: true);
    if (response.statusCode == 404) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> postPlace(Object body) async {
    //name, parent
    bool responseCode = false;
    final response = await Global.h_post(placesUrl, body, appendToken: true);
    // .then((http.Response resp) {
    if (200 <= response.statusCode && response.statusCode <= 300)
      responseCode = true;
    else
      responseCode = false;

    return responseCode;
  }
}
