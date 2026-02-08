import 'package:aurabus/features/auth/presentation/providers/auth_provider.dart';
import 'package:aurabus/features/favorites/data/favorites_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final dio = ref.watch(dioClientProvider);
  return FavoritesRepository(dio);
});
