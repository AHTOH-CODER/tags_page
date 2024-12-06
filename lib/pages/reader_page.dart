import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test1/components/get_data.dart';
import 'package:test1/pages/main_page.dart';
import 'package:test1/pages/history_page.dart';

class ReaderPage extends StatefulWidget { 
  final String id;
  ReaderPage({required this.id});

  @override 
  _ReaderPageState createState() => _ReaderPageState(); 
} 
 
class _ReaderPageState extends State<ReaderPage> { 
  String _statusMessage = ''; // Сообщение о статусе 
  TextEditingController _controller = TextEditingController(); // Контроллер для TextField 
  File? _currentFile; // Ссылка на текущий файл

  @override
  void initState() {
    super.initState();
    // Инициализируем filePath с использованием id из виджета
    late final String filePath = 'downloaded/texts/${widget.id}.txt';
    _loadFile(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset(
          'assets/logo.svg',
        ),
        actions: [
          Container (
            width: 250,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0), 
              child: TextField(
                onSubmitted: (value) async {
                  searchVideo(value);
                  Navigator.push( 
                    context, 
                    MaterialPageRoute(builder: (context) => MainPage()), 
                  ); 
                },
                decoration: InputDecoration(
                  hintText: 'Поиск',
                  hintStyle: const TextStyle(
                    color: Colors.grey, 
                  ),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Назад'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black
            )
          ),
          SizedBox(width: 10,)
        ],
        backgroundColor: Colors.black,
      ),


      body: Padding( 
        padding: const EdgeInsets.all(16.0), 
        child: Column( 
          children: [ 
            SizedBox(height: 20), 
            Text( 
              _statusMessage, 
              style: TextStyle(fontSize: 16, color: Colors.yellow), 
            ), 
            SizedBox(height: 20), 
            Expanded( 
              child: TextField( 
                controller: _controller, 
                maxLines: null, // Позволяет использовать несколько строк 
                decoration: InputDecoration( 
                  border: OutlineInputBorder(), 
                  // hintText: 'Редактируйте содержимое файла...', 
                  hintStyle: TextStyle(color: Colors.grey), // Цвет подсказки (hint) белый
                ), 
                style: TextStyle(fontSize: 16, color: Colors.white), // Белый текст в TextField
              ), 
            ), 
            SizedBox(height: 20), 
            ElevatedButton( 
              onPressed: _saveFile, 
              child: Text('Сохранить изменения'), 
              style: ElevatedButton.styleFrom( 
              backgroundColor: Colors.yellow, 
              foregroundColor: Colors.black, 
            ), 
            ), 
          ], 
        ), 
      ), 


      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 100,
              height: 50,
              child: IconButton(
                icon: Icon(Icons.home, color: Colors.grey),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage())
                  );
                },
              ),
            ),
            SizedBox(
              width: 100, 
              height: 50,
              child: IconButton(
                icon: Icon(Icons.history, color: Colors.grey),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryPage())
                  );
                },
              ),
            ),
          ],
        ),
        color: Colors.black,
      ),
      backgroundColor: const Color.fromARGB(234, 14, 14, 14),
    );
  }

  Future<void> _loadFile(String filePath) async {
    File file = File(filePath); // Указываем путь к файлу
    if (await file.exists()) { 
      setState(() {
        _currentFile = file; // Сохраняем текущий файл
      });
      await _readTxtFile(file); // Читаем содержимое файла
    } else {
      setState(() {
        _statusMessage = 'Подождите немного и попробуйте снова';
      });
    }
  }

  Future<void> _readTxtFile(File file) async { 
    try { 
      // Читаем файл как текст
      String fileContent = await file.readAsString(); 
      setState(() { 
        _controller.text = fileContent; // Помещаем содержимое в контроллер
        _statusMessage = '';  // Очищаем сообщение об ошибке
      }); 
    } catch (e) { 
      setState(() { 
        _controller.text = ''; 
        _statusMessage = 'Ошибка при чтении файла: $e'; 
      }); 
    } 
  } 

  Future<void> _saveFile() async { 
    if (_currentFile == null) { 
      setState(() { 
        _statusMessage = 'Файл не загружен'; 
      }); 
      return; 
    } 

    String newContent = _controller.text; // Получаем измененный текст 

    try { 
      // Сохраняем текст в тот же файл
      await _currentFile!.writeAsString(newContent); 
      setState(() { 
        _statusMessage = 'Изменения успешно сохранены'; 
      }); 
      await Future.delayed(Duration(seconds: 3));
      setState(() {
        _statusMessage = '';
      });
    } catch (e) { 
      setState(() { 
        _statusMessage = 'Ошибка при сохранении файла: $e'; 
      }); 
    } 
  } 
}