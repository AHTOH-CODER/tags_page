import 'dart:convert';
import 'dart:io'; 
import 'package:flutter/material.dart'; 
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart'; 
import 'package:test1/pages/tags_page.dart'; 
import 'package:test1/pages/player_page.dart'; 
import 'package:flutter/services.dart' show rootBundle; 
import 'package:test1/components/get_data.dart';
import 'package:test1/pages/main_page.dart';
 
class HistoryPage extends StatefulWidget { 
  @override 
  _HistoryPageState createState() => _HistoryPageState(); 
} 
 
class _HistoryPageState extends State<HistoryPage> { 
  List<dynamic> items = []; 
 
   @override
  void initState() {
    loadAssets();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    
    super.didChangeDependencies();
    loadAssets();
  }
 
  Future<void> loadAssets() async { 
    Directory? appDocDir = await getDownloadsDirectory();
    final filePath = '${appDocDir?.path.replaceAll('\\', '/')}/history.json';
    final String response = await File(filePath).readAsString();
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
            width: 250, 
            child: Padding( 
              padding: const EdgeInsets.symmetric(horizontal: 10.0), 
              child: TextField( 
                onSubmitted: (value) async {
                  searchVideo(value);
                  await Future.delayed(Duration(seconds: 3));
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
          SizedBox(width: 10,)
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
                          link: items[index]['thumb'], // Передаем первую ссылку 
                          simpleData: items[index]['simple_data'], 
                          id: items[index]['id'],
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
                              items[index]['thumb'],
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
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), 
                          ), 
                        ), 
                        Padding( 
                          padding: const EdgeInsets.symmetric(horizontal: 8.0), 
                          child: Text(
                            items[index]['simple_data'],
                            style: TextStyle(color: Colors.white), 
                          ), 
                        ), 
                      ], 
                    ), 
                    color: Colors.grey[800],
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
                icon: Icon(Icons.history, color: Colors.yellow), 
                onPressed: () {}, 
              ), 
            ), 
          ], 
        ), 
        color: Colors.black, 
      ), 
      backgroundColor: const Color.fromARGB(234, 14, 14, 14), 
    ); 
  } 
}