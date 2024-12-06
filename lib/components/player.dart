import 'package:flutter/material.dart'; 
import 'package:url_launcher/url_launcher.dart'; 
import 'dart:io'; 
 
class Player extends StatefulWidget { 
  final String id;
  Player({required this.id});

  @override 
  _PlayerState createState() => _PlayerState(); 
} 
 
class _PlayerState extends State<Player> { 
  @override 
  Widget build(BuildContext context) { 
    return MaterialApp( 
      home: Scaffold( 
        appBar: AppBar( 
          title: Text('MP3 Player Finder'), 
        ), 
        body: Center( 
          child: ElevatedButton( 
            onPressed: () async { 
              final filePath = 'D:/flutter_projects/anton/audio_player/assets/audio/test.mp3'; // Замените на полный путь к вашему файлу 
 
              if (await File(filePath).exists()) { 
                final uri = Uri.file(filePath); 
 
                if (await canLaunch(uri.toString())) { 
                  await launch(uri.toString()); 
                } else { 
                  print('Не удалось запустить приложение для открытия файла.'); 
                } 
              } else { 
                print('Файл не найден по указанному пути: $filePath'); 
              } 
            }, 
            child: Text('Открыть MP3 приложение'), 
          ), 
        ), 
      ), 
    ); 
  } 
}