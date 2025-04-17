import 'dart:convert';

import 'package:flutter_app/models/albums.dart';
import 'package:flutter_app/utils/api_constants.dart';
import 'package:http/http.dart' as http;

class AlbumService {
  Future<Album> createAlbum(String title) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/albums'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'title': title}),
    );

    if (response.statusCode == 201) {
      return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to create');
    }
  }
}
