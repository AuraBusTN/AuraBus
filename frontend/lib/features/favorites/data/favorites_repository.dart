import 'package:aurabus/core/network/dio_client.dart';
import 'package:aurabus/features/favorites/data/models/favorite_routes_model.dart';
import 'package:aurabus/features/map/data/models/route_info.dart';

class FavoritesRepository {
  final DioClient _dioClient;

  FavoritesRepository(this._dioClient);

  Future<List<RouteInfo>> fetchRoutes() async {
    final res = await _dioClient.dio.get('/routes');

    final list = res.data as List<dynamic>;
    return list
        .map((e) => RouteInfo.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<FavoriteRoutes> getFavoriteRoutes() async {
    final res = await  _dioClient.dio.get('/users/favorite-routes');

    return FavoriteRoutes.fromJson(res.data);
  }

  Future<List<int>> updateFavoriteRoutes(List<int> routes) async {
    final res = await  _dioClient.dio.post(
      '/users/favorite-routes',
      data: {'favoriteRoutes': routes},
    );

    return (res.data['favoriteRoutes'] as List<dynamic>)
        .map((e) => e as int)
        .toList();
  }
}
