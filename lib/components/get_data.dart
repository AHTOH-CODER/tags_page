import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<void> searchVideo(String videoTitle) async {
  final String url = 'http://217.12.40.218:5001/search_video';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'title': videoTitle}),
    );

    if (response.statusCode == 200) {
      // Successful response
      try {
        final data = json.decode(response.body);
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/search_results.json');

        await file.writeAsString(json.encode(data));
        print('Данные сохранены в ${file.path}');
      } catch (jsonError) {
        print('Ошибка разбора JSON: $jsonError');
        // Handle invalid JSON response from server
      }
    } else {
      // Error response from server
      print('Ошибка сервера: ${response.statusCode} - ${response.body}');
      // Handle error response (e.g., show a message to the user)
    }
  } catch (httpError) {
    print('Ошибка HTTP запроса: $httpError');
    // Handle network errors (e.g., no internet connection)
    // Show an appropriate message to the user
  }
}