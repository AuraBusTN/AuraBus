import 'package:aurabus/core/network/dio_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'models/stop_info.dart';
import 'models/stop_trip_info.dart';
  List<StopInfo> parseStops(String jsonString) {
  final jsonData = jsonDecode(jsonString) as List<dynamic>;
  return jsonData
      .map((e) => StopInfo.fromJson(e as Map<String, dynamic>))
      .toList();
  }
class MapRepository {
  final DioClient _dioClient;

  MapRepository(this._dioClient);


  Future<List<StopInfo>> loadLocalStops() async {
  try {
    final jsonString =
        await rootBundle.loadString('assets/data/stops.json');

    return compute(parseStops, jsonString);
  } catch (e) {
    throw Exception('Failed to load stops data: $e');
  }
}
  

  Future<List<StopTrip>> fetchStopTrips(int stopId) async {
    try {
      final res = await _dioClient.dio.get("/stops/$stopId");

      final data = res.data;
      if (data == null) return <StopTrip>[];
      if (data is! List) {
        throw Exception("Unexpected response format for stop $stopId: ${data.runtimeType}");
      }

      final jsonList = (data).cast<Map<String, dynamic>>();
      return jsonList.map((e) => StopTrip.fromJson(e)).toList();
    } catch (e) {
      throw Exception("Failed to fetch stop details for $stopId: $e");
    }
  }

}
