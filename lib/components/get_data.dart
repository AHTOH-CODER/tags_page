import 'dart:convert'; 
import 'dart:io'; // Импортируем пакет для работы с файлами 
import 'package:http/http.dart' as http; 
 
Future<void> searchVideo(String videoTitle) async { 
    final String url = 'http://217.12.40.218:5001/search_video'; 
 
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
    } else { 
      print('Получены данные не в ожидаемом формате'); 
    } 
} else { 
    // Обработка ошибок 
    print('Error: ${response.statusCode} - ${response.body}'); 
} 
} 
Future<void> saveDataToFile(List<dynamic> data) async { 
    final file = File('assets/test.json'); // Указываем имя файла 
    // Сохраняем данные в файле в формате JSON 
    await file.writeAsString(json.encode(data)); 
    print('Данные успешно сохранены в test.json'); 
} 

void download_audio(String videoUrl, String id) async { 
  final String url = 'http://217.12.40.218:5001/download_audio'; 
  final Map<String, String> data = { 
    'url': videoUrl, 
  }; 
 
  try { 
    final response = await HttpClient().postUrl(Uri.parse(url)) 
      ..headers.contentType = ContentType.json 
      ..write(jsonEncode(data)); 
 
    final HttpClientResponse httpResponse = await response.close(); 
 
    if (httpResponse.statusCode == 200) { 
      final file = File('downloaded/audios/${id}.mp3'); 
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
  final String url = 'http://217.12.40.218:5001/download_video'; 
  final Map<String, String> data = { 
    'url': videoUrl, 
  }; 
 
  try { 
    final response = await HttpClient().postUrl(Uri.parse(url)) 
      ..headers.contentType = ContentType.json 
      ..write(jsonEncode(data)); 
 
    final HttpClientResponse httpResponse = await response.close(); 
 
    if (httpResponse.statusCode == 200) { 
      final file = File('downloaded/videos/${id}.mp4'); 
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