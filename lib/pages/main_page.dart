import 'dart:convert'; 
import 'package:flutter/material.dart'; 
import 'package:flutter_svg/flutter_svg.dart'; 
import 'package:test1/pages/tags_page.dart'; 
import 'package:test1/pages/player_page.dart'; 
import 'package:flutter/services.dart' show rootBundle; 
import 'package:dio/dio.dart'; 
import 'package:test1/components/get_data.dart';
 
class MainPage extends StatefulWidget { 
  @override 
  _MainPageState createState() => _MainPageState(); 
} 
 
class _MainPageState extends State<MainPage> { 
  List<dynamic> items = []; 
  final Dio dio = Dio(); 
 
  @override 
  void initState() { 
    super.initState(); 
    loadAssets(); 
  } 
 
  Future<void> loadAssets() async { 
    // final List<dynamic> data = searchVideo('dart') as List; 
    final String response = await rootBundle.loadString('assets/test.json'); 
    final List<dynamic> data = json.decode(response); 
 
    setState(() { 
      items = data; 
    }); 
  } 
 
  @override 
  Widget build(BuildContext context) { 
    return Scaffold( 
      appBar: AppBar( 
        leading: SvgPicture.asset( 
          'assets/logo.svg', 
        ), 
        actions: [ 
          Container( 
            width: 360, 
            child: Padding( 
              padding: const EdgeInsets.symmetric(horizontal: 10.0), 
              child: TextField( 
                onChanged: (value) {}, 
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
              Navigator.push( 
                context, 
                MaterialPageRoute(builder: (context) => TagsPage()), 
              ); 
            }, 
            child: const Text('Теги'), 
            style: ElevatedButton.styleFrom( 
              backgroundColor: Colors.yellow, 
              foregroundColor: Colors.black, 
            ), 
          ), 
        ], 
        backgroundColor: Colors.black, 
      ), 
      body: items.isEmpty 
          ? Center(child: CircularProgressIndicator()) 
          : ListView.builder( 
              itemCount: items.length, 
              itemBuilder: (context, index) { 
                return GestureDetector( 
                  onTap: () { 
                    Navigator.push( 
                      context, 
                      MaterialPageRoute( 
                        builder: (context) => PlayerPage( 
                          title: items[index]['title'], 
                          link: items[index]['thumb'][0], // Передаем первую ссылку 
                          simpleData: items[index]['simple_data'], 
                        ), 
                      ), 
                    ); 
                  }, 
                  child: Card( 
                    margin: EdgeInsets.all(8.0), 
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.start, 
                      children: [ 
                        // Установка ширины и высоты контейнера, в котором будет изображение 
                        Container( 
                          width: double.infinity, // Занимает всю доступную ширину 
                          height: 200, // Задайте желаемую высоту 
                          child: ClipRRect( 
                            borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)), 
                            child: Image.network(
                              items[index]['thumb'][0],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey, // Цвет заглушки
                                  child: Center(child: Text('Ошибка загрузки изображения')),
                                );
                              },
                            )
                          ), 
                        ), 
                        Padding( 
                          padding: const EdgeInsets.all(8.0), 
                          child: Text( 
                            items[index]['title'], 
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), 
                          ), 
                        ), 
                        Padding( 
                          padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                          child: Text(items[index]['simple_data']), 
                        ), 
                      ], 
                    ), 
                  ), 
                ); 
              }, 
            ), 
      bottomNavigationBar: BottomAppBar( 
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.spaceAround, 
          children: [ 
            SizedBox( 
              width: 100, 
              height: 50, 
              child: IconButton( 
                icon: Icon(Icons.home, color: Colors.yellow), 
                onPressed: () { 
                  // ... 
                }, 
              ), 
            ), 
            SizedBox( 
              width: 100, 
              height: 50, 
              child: IconButton( 
                icon: Icon(Icons.history, color: Colors.grey), 
                onPressed: () {}, 
              ), 
            ), 
          ], 
        ), 
        color: Colors.black, 
      ), 
      backgroundColor: const Color.fromARGB(234, 0, 0, 0), 
    ); 
  } 
}