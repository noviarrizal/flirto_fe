
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/result.dart';
import 'data/feed_repo.dart';
import 'domain/profile.dart';

final feedRepoProvider = Provider((ref) => FeedRepo());

final feedFutureProvider = FutureProvider<List<Profile>>((ref) async {
  final repo = ref.watch(feedRepoProvider);
  final res = await repo.getRecommendations(limit: 20);
  return switch (res) { Ok(value: final v) => v, Err() => [] };
});