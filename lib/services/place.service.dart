import 'dart:convert';
import 'package:prototype/models/fog.dart';
import 'package:prototype/models/place.dart';
import 'package:http/http.dart' as http;
import '../global.dart';

class PlaceService {
  static String placesUrl = '${Global.baseUrl}/places';

  static Future<List<Place>> getParentPlaces() async {
    var places = <Place>[];
    await Global.h_get('${placesUrl}?with=children', appendToken: true)
        .then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];
      places = List<Place>.from(data.map((model) {
        var place = Place.fromJson(model);

        List<dynamic> subPlaces = model['places'] ?? {};

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
    await Global.h_get(placesUrl, appendToken: true)
        .then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];
      parentPlaces = List<Place>.from(data.map((model) {
        var place = Place.fromJson(model);
        // print('placestype ${model['places'].runtimeType}');
        // List<dynamic?> subPlaces = model['places'] ?? {};
        // if (subPlaces.isNotEmpty) {
        //   place.places = List<Place>.from(subPlaces.map((model2) => Place.fromJson(model2)));
        // }

        return place;
      }));
    });
    var childPlaces = <Place>[];
    parentPlaces.forEach((element) {
      print('51: ${element.places}');
      if (element.places!.isNotEmpty) {
        print("${element.name} isimli place if'e girdi");
        element.places!.forEach((e) {
          print('Child placese ${e.name} isimli place eklendi');
          childPlaces.add(e);
        });
      }
    });
    print('555 child places: $childPlaces');
    print('555 parent places: $parentPlaces');
    var allPlaces = childPlaces + parentPlaces;

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

  static Future<bool> updatePlace(String? id, Object body) async {
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

  static Future<Place> getPlaceById(String? placeId) async {
    var url = '$placesUrl/$placeId';

    var place = Place(name: 'sd');

    await Global.h_get(url, appendToken: true)
        .then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      place = Place.fromJson(jsonResponse['data']);
    });

    return place;
  }

  static Future<List<Fog>> getFogs(String? placeId) async {
    var url = '$placesUrl/$placeId/fogs';

    var fogs = <Fog>[];

    await Global.h_get(url, appendToken: true)
        .then((http.Response response) async {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      List<dynamic> data = jsonResponse['data'];
      print('fogdata $data');
      fogs = List<Fog>.from(data.map((model) {
        var fog = Fog.fromJson(model);

        return fog;
      }));
    });

    return fogs;
  }
}
