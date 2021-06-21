import 'dart:convert';
import 'package:prototype/models/place.dart';
import 'package:http/http.dart' as http;
import '../global.dart';

class PlaceService {
  static String placesUrl = '${Global.baseUrl}/places';

  static Future<List<Place>> getParentPlaces() async {
    var places = <Place>[];
    await Global.h_get(placesUrl, appendToken: true)
        .then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];
      places = List<Place>.from(data.map((model) {
        var place = Place.fromJson(model);
        List<dynamic> subPlaces = model['places'];

        if (subPlaces.isNotEmpty) {
          place.places = List<Place>.from(
              subPlaces.map((model2) => Place.fromJson(model2)));
        }
        return place;
      }));
    });

    return places;
  }

  static Future<List<Place>> getPlaces() async {
    var parentPlaces = <Place>[];
    final response = await Global.h_get(placesUrl, appendToken: true)
        .then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];
      parentPlaces = List<Place>.from(data.map((model) {
        var place = Place.fromJson(model);
        List<dynamic> subPlaces = model['places'];
        if (subPlaces.isNotEmpty) {
          place.places = List<Place>.from(
              subPlaces.map((model2) => Place.fromJson(model2)));
        }

        return place;
      }));
    });
    var childPlaces = <Place>[];
    parentPlaces.forEach((element) {
      if (element.places!.isNotEmpty) {
        element.places!.forEach((e) {
          childPlaces.add(e);
        });
      }
    });
    var allPlaces = childPlaces + parentPlaces;
    print("56: $allPlaces");
    return allPlaces;
  }

  static Future<bool> deletePlace(
    Place place,
  ) async {
    final response =
        await Global.h_delete('$placesUrl/${place.id}', appendToken: true);
    if (response.statusCode == 404) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> postPlace(Object body) async {
    //name, parent
    var responseCode = false;
    final response = await Global.h_post(placesUrl, body, appendToken: true);
    // .then((http.Response resp) {
    if (200 <= response.statusCode && response.statusCode <= 300) {
      responseCode = true;
    } else {
      responseCode = false;
    }

    return responseCode;
  }

  static Future<bool> updatePlace(int? id, Object body) async {
    var url = '$placesUrl/$id';
    var responseCode = false;
    final response = await Global.h_update(url, body, appendToken: true);

    if (200 <= response.statusCode && response.statusCode <= 300) {
      responseCode = true;
    } else {
      responseCode = false;
    }

    return responseCode;
  }

  static Future<Place> getPlaceById(int? placeId) async {
    var url = '$placesUrl/$placeId';

    var place = Place(name: 'sd');

    await Global.h_get(url, appendToken: true)
        .then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      place = Place.fromJson(jsonResponse['data']);
    });

    return place;
  }
}
