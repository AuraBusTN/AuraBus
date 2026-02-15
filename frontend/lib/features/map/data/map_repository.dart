import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'models/stop_info.dart';
import 'models/stop_trip_info.dart';
import 'package:aurabus/core/network/dio_client.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';

class MapRepository {
  final DioClient _dioClient;

  MapRepository(this._dioClient);

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
      final res = await _dioClient.dio.get("/stops/$stopId");

      final jsonList = res.data as List<dynamic>;

      return jsonList
          .map((e) => StopTrip.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch stop details for $stopId: $e");
    }
  }

  Future<List<RouteInfo>> fetchAllRoutes() async {
    try {
      final res = await _dioClient.dio.get("/routes");
      final jsonList = res.data as List<dynamic>;
      return jsonList
          .map((e) => RouteInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch routes: $e");
    }
  }
}
