import 'dart:convert'; 
import 'dart:io'; // Импортируем пакет для работы с файлами 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; 
 
Future<dynamic> searchVideo(String videoTitle) async { 
    final String url = 'http://217.114.15.37:5001/search_video'; 
 
    // Выполняем POST-запрос с заголовками и телом запроса 
    final response = await http.post( 
      Uri.parse(url), 
      headers: { 
        'Content-Type': 'application/json', 
      }, 
      body: json.encode({'title': videoTitle}), 
    ); 
 
    // Проверяем статус ответа 
    if (response.statusCode == 200) { 
    // Успешный ответ, обрабатываем данные 
    final data = json.decode(response.body); 
    print('Response data: $data'); 
     
    // Проверяем, если данные представляют список, и сохраняем каждый элемент, если это список 
    if (data is List) { 
      await saveDataToFile(data); 
      return data;
    } else { 
      print('Получены данные не в ожидаемом формате'); 
      return []; // Возвращаем пустой список в случае ошибки
    } 
} else { 
    // Обработка ошибок 
    print('Error: ${response.statusCode} - ${response.body}'); 
    return []; // Возвращаем пустой список в случае ошибки
} 
} 
Future<void> saveDataToFile(List<dynamic> data) async { 
    Directory? appDocDir = await getDownloadsDirectory();
    final file = File('${appDocDir?.path.replaceAll('\\', '/')}/test.json');
    await file.writeAsString(json.encode(data));
    print('Данные успешно сохранены в test.json');
} 

void download_audio(String videoUrl, String id) async { 
  final String url = 'http://217.114.15.37:5001/download_audio'; 
  final Map<String, String> data = { 
    'url': videoUrl, 
  }; 
 
  try { 
    final response = await HttpClient().postUrl(Uri.parse(url)) 
      ..headers.contentType = ContentType.json 
      ..write(jsonEncode(data)); 
 
    final HttpClientResponse httpResponse = await response.close(); 
 
    if (httpResponse.statusCode == 200) { 
      Directory? appDocDir = await getDownloadsDirectory();
      final file = File('${appDocDir?.path.replaceAll('\\', '/')}/$id.mp3'); 
      final sink = file.openWrite(); 
 
      await for (var chunk in httpResponse) {
        sink.add(chunk); 
      } 
 
      await sink.close(); 
      print("мяу downloaded_video.mp3"); 
    } else { 
      print("не мяу: ${httpResponse.statusCode}"); 
    } 
  } catch (e) { 
    print("не мяу: $e"); 
  } 
}

void download_video(String videoUrl, String id) async { 
  final String url = 'http://217.114.15.37:5001/download_video'; 
  final Map<String, String> data = { 
    'url': videoUrl, 
  }; 
 
  try { 
    final response = await HttpClient().postUrl(Uri.parse(url)) 
      ..headers.contentType = ContentType.json 
      ..write(jsonEncode(data)); 
 
    final HttpClientResponse httpResponse = await response.close(); 
 
    if (httpResponse.statusCode == 200) { 
      Directory? appDocDir = await getDownloadsDirectory();
      final file = File('${appDocDir?.path.replaceAll('\\', '/')}/$id.mp4');
      final sink = file.openWrite(); 
 
      await for (var chunk in httpResponse) { 
        sink.add(chunk); 
      } 
 
      await sink.close(); 
      print("мяу downloaded_video.mp4"); 
    } else { 
      print("не мяу: ${httpResponse.statusCode}"); 
    } 
  } catch (e) { 
    print("не мяу: $e"); 
  } 
}

String idToUrl(String id) {
  
  if (id.isEmpty) {
    throw ArgumentError('ID cannot be empty');
  }

  return "https://www.youtube.com/watch?v=$id";
}
  
void download_text(String videoUrl, String id) async {  
  final String url = 'http://217.114.15.37:5001/transcribe_audio';  
  final Map<String, String> data = {  
    'video_url': videoUrl,  
    'video_id': id 
  };  

  try {  
    final response = await HttpClient().postUrl(Uri.parse(url))  
      ..headers.contentType = ContentType.json  
      ..write(jsonEncode(data));  
  
    final HttpClientResponse httpResponse = await response.close();  
  
    if (httpResponse.statusCode == 200) {  
      Directory? appDocDir = await getDownloadsDirectory();
      final file = File('${appDocDir?.path.replaceAll('\\', '/')}/$id.txt'); 
      final sink = file.openWrite();   
  
      await for (var chunk in httpResponse) {  
        sink.add(chunk);  
      }  
  
      await sink.close();  
      print("мяу ${id}.txt");  
    } else {  
      print("не мяу: ${httpResponse.statusCode}");  
    }  
  } catch (e) {  
    print("не мяу: $e");  
  }  
}



Future<void> saveVideosToJson(List<Map<String, dynamic>> newVideos) async {
  // Определяем путь к JSON файлу
  Directory? appDocDir = await getDownloadsDirectory();
  final filePath = '${appDocDir?.path.replaceAll('\\', '/')}/history.json';

  // Проверяем, существует ли файл
  final file = File(filePath);
  
  // Если файл существует, читаем его содержимое
  List<Map<String, dynamic>> existingVideos = [];
  if (await file.exists()) {
    final jsonString = await file.readAsString();
    existingVideos = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
  }

  // Обновляем существующие видео
  for (var newVideo in newVideos) {
    // Предполагаем, что 'id' является уникальным полем для идентификации видео
    existingVideos.removeWhere((video) => video['id'] == newVideo['id']);
    // Добавляем новое видео в начало списка
    existingVideos.insert(0, newVideo);
  }

  // Конвертируем обновленный список видео в формат JSON 
  final updatedJsonString = jsonEncode(existingVideos);

  // Записываем обновленную строку JSON в файл
  await file.writeAsString(updatedJsonString);

  print('Сохранено в истории');
}

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    duration: Duration(seconds: 2), // Продолжительность отображения
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}