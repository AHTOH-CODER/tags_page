import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test1/pages/main_page.dart';
import 'package:test1/components/player.dart';
import 'package:test1/pages/reader_page.dart';


class PlayerPage extends StatelessWidget {
  final String title;
  final String link;
  final String simpleData;

  PlayerPage({required this.title, required this.link, required this.simpleData});

  @override
  Widget build(BuildContext context) {
    late AudioPlayer player = AudioPlayer();
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset(
          'assets/logo.svg',
        ),
        actions: [
          Container (
            width: 350,
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
              Navigator.pop(context);
            },
            child: const Text('Назад'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow,
              foregroundColor: Colors.black
            )
          ),
        ],
        backgroundColor: Colors.black,
      ),


body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Image.network(
                          link,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey, // Цвет заглушки
                              child: Center(child: Text('Ошибка загрузки изображения')),
                            );
                          },
                        ),
                      ),
                      PlayerWidget(player: player), // Ваш виджет плеера
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        simpleData,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      //////////////////////////////
                    },
                    child: const Text('Скачать аудио'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push( 
                        context, 
                        MaterialPageRoute(builder: (context) => ReaderPage()), 
                      ); 
                    },
                    child: const Text('Читалка'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
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