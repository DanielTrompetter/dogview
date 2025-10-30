import 'package:dio/dio.dart';

class DogCEOInterface {
  static const String baseUrl = 'https://dog.ceo/api';
  final Dio dio;

  DogCEOInterface({Dio? dio}) : dio = dio ?? Dio();

  Future<List<String>> getBreeds() async {
    final url = '$baseUrl/breeds/list/all';
    final response = await dio.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch $url. Status code: ${response.statusCode}');
    }
    final data = response.data;
    final breeds = data['message'] as Map<String, dynamic>;

    return breeds.entries.expand((entry) {
      final breed = entry.key;
      final subBreeds = List<String>.from(entry.value);
      if (subBreeds.isEmpty) return [breed];
      return subBreeds.map((sub) => '$breed/$sub');
    }).toList();
  }

  Future<String> getRandomImage([String? breed]) async {
    final url = breed == null
        ? '$baseUrl/breeds/image/random'
        : '$baseUrl/breed/$breed/images/random';
    final response = await dio.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to access data on dog.ceo! Error: ${response.statusCode}');
    }
    final data = response.data;
    return data['message'];
  }
}
