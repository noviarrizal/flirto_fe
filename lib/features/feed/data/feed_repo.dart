
import 'package:dio/dio.dart';
import 'package:flirto_fe/core/dio_client.dart';
import 'package:flirto_fe/core/result.dart';
import 'package:flirto_fe/features/feed/domain/profile.dart';

class FeedRepo {
  final Dio _dio = makeDio();

  Future<Result<List<Profile>>> getRecommendations({int limit = 20}) async {
    try {
      final res = await _dio.get('/recommendations', queryParameters: { 'limit': limit });
      final list = (res.data as List).map((e) => Profile.fromJson(e)).toList();
      return Ok(list);
    } catch (e) { return Err(e); }
  }

  Future<Result<void>> sendLike(String toId) async {
    try {
      await _dio.post('/like/$toId');
      return const Ok(null);
    } catch (e) {
      return Err(e);
    }
  }

  Future<Result<void>> sendPass(String toId) async {
    try {
      await _dio.post('/pass/$toId'); return const Ok(null);
    }
    catch (e) { return Err(e); }
  }
}