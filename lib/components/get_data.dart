import 'dart:convert'; 
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
    return data; 
  } else { 
    // Обработка ошибок 
    print('Error: ${response.statusCode} - ${response.body}'); 
  } 
} 
