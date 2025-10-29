import 'dart:convert';
import 'package:http/http.dart' as http;

class DogCEOInterface {
  static const String baseUrl = 'https://dog.ceo/api';

  Future<List<String>> getBreeds() async {
    final response = await http.get(Uri.parse('$baseUrl/breeds/list/all'));
    final data = jsonDecode(response.body);
    final breeds = data['message'] as Map<String, dynamic>;

    return breeds.entries.expand((entry) {
      final breed = entry.key;
      final subBreeds = entry.value as List;
      if (subBreeds.isEmpty) return [breed];
      return subBreeds.map((sub) => '$breed/$sub');
    }).toList();
  }

  Future<String> getRandomImage([String? breed]) async {
    final url = breed == null
        ? '$baseUrl/breeds/image/random'
        : '$baseUrl/breed/$breed/images/random';
    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);
    return data['message'];
  }
}
