import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aurabus/common/models/stop_data.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FavoritesRepository {
  final String baseUrl;

  FavoritesRepository() : baseUrl = dotenv.env['API_URL'] ?? '' {
    if (baseUrl.isEmpty) {
      throw Exception(
        'API_URL environment variable is not set. Please configure it in your .env file.',
      );
    }
  }

  Future<List<BusRoute>> loadLocalRoutes() async {
    final jsonStr = await rootBundle.loadString('assets/data/routes.json');
    final jsonList = jsonDecode(jsonStr) as List<dynamic>;
    return jsonList.map((e) => BusRoute.fromJson(e)).toList();
  }

  Future<List<BusRoute>> fetchRoutesDetails(int stopId) async {
    try {
      print("=== FETCHING ROUTES FOR stopId: $stopId ===");

      final url = "$baseUrl/routes/$stopId";
      print("REQUEST: GET $url");

      final res = await http.get(Uri.parse(url));

      print("RESPONSE CODE: ${res.statusCode}");

      if (res.body.isEmpty) {
        print("RESPONSE BODY EMPTY");
      } else {
        print("RAW RESPONSE BODY:\n${res.body}");
      }

      if (res.statusCode != 200) {
        throw Exception(
          "Failed to fetch stop details for stop $stopId: ${res.statusCode}",
        );
      }

      final jsonList = jsonDecode(res.body) as List<dynamic>;

      print("DECODED JSON LIST LENGTH: ${jsonList.length}");

      // PARSING CON DEBUG
      final parsedRoutes = <BusRoute>[];
      for (final item in jsonList) {
        try {
          print("\n--- PARSING ITEM ---");
          print(item);

          final route = BusRoute.fromJson(item as Map<String, dynamic>);
          parsedRoutes.add(route);
        } catch (err, stack) {
          print("!!! ERROR PARSING ITEM !!!");
          print("ITEM JSON: $item");
          print("ERROR: $err");
          print("STACK: $stack");
          rethrow; // per vedere il crash completo
        }
      }

      print("=== PARSED ROUTES SUCCESSFULLY: ${parsedRoutes.length} ===");

      return parsedRoutes;

    } catch (e, stack) {
      print("=== GLOBAL ERROR IN fetchRoutesDetails ===");
      print("ERROR: $e");
      print("STACK: $stack");

      throw Exception("Failed to fetch stop details for $stopId: $e");
    }
  }
}