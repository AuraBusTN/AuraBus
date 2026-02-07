import 'dart:convert';
import 'package:aurabus/features/map/data/models/route_info.dart';
import 'package:http/http.dart' as http;
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

  Future<List<RouteInfo>> loadLocalRoutes() async {
    final jsonStr = await rootBundle.loadString('assets/data/routes.json');
    final jsonList = jsonDecode(jsonStr) as List<dynamic>;
    return jsonList.map((e) => RouteInfo.fromJson(e)).toList();
  }

  Future<List<RouteInfo>> fetchRoutesDetails() async {
    try {
 

      final res = await http.get(Uri.parse(baseUrl).resolve('routes'));


      if (res.statusCode != 200) {
        throw Exception(
          "Failed to fetch stop details: ${res.statusCode}",
        );
      }

      final jsonList = jsonDecode(res.body) as List<dynamic>;

      // PARSING CON DEBUG
      final parsedRoutes = <RouteInfo>[];
      for (final item in jsonList) {
        try {

          final route = RouteInfo.fromJson(item as Map<String, dynamic>);
          parsedRoutes.add(route);
        } catch (err) {
 
          rethrow; // per vedere il crash completo
        }
      }


      return parsedRoutes;

    } catch (e) {


      throw Exception("Failed to fetch stop details: $e");
    }
  }
}