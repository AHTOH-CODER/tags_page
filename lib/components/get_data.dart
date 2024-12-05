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
    print('Данные успешно сохранены в response_data.json'); 
} 
