import 'package:aurabus/core/network/dio_client.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'models/stop_info.dart';
import 'models/stop_trip_info.dart';

class MapRepository {
  final DioClient _dioClient;

  MapRepository(this._dioClient);

  Future<List<StopInfo>> loadLocalStops() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/stops.json');
      final jsonData = jsonDecode(jsonString) as List<dynamic>;
      return jsonData
          .map((e) => StopInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load stops data: $e');
    }
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


}
