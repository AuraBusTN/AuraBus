import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'models/stop_info.dart';
import 'models/stop_trip_info.dart';

class MapRepository {
  final String baseUrl;

  MapRepository() : baseUrl = dotenv.env['API_URL'] ?? '' {
    if (baseUrl.isEmpty) {
      throw Exception(
        'API_URL environment variable is not set. Please configure it in your .env file.',
      );
    }
  }

  Future<List<StopInfo>> loadLocalStops() async {
    final jsonStr = await rootBundle.loadString('assets/data/stops.json');
    return compute(_parseStops, jsonStr);
  }

  static List<StopInfo> _parseStops(String jsonStr) {
    final jsonList = jsonDecode(jsonStr) as List<dynamic>;
    return jsonList.map((e) => StopInfo.fromJson(e)).toList();
  }

  Future<List<StopTrip>> fetchStopTrips(int stopId) async {
    try {
      final res = await http.get(Uri.parse("$baseUrl/stops/$stopId"));
      if (res.statusCode != 200) {
        throw Exception(
          "Failed to fetch stop details for stop $stopId: ${res.statusCode}",
        );
      }
      final jsonList = jsonDecode(res.body) as List<dynamic>;
      return jsonList
          .map((e) => StopTrip.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch stop details for $stopId: $e");
    }
  }
}
