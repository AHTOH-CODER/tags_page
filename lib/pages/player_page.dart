import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test1/components/get_data.dart';
import 'package:test1/pages/main_page.dart';
import 'package:test1/pages/reader_page.dart';
import 'package:test1/pages/history_page.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'package:path_provider/path_provider.dart';

class PlayerPage extends StatefulWidget {
  final String title;
  final String link;
  final String simpleData;
  final String id;

  PlayerPage({required this.title, required this.link, required this.simpleData, required this.id});

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late List<Map<String, dynamic>> history_videos;

  @override
  void initState() {
    super.initState();
    history_videos = [{
      'id': widget.id,
      'simple_data': widget.simpleData,
      'thumb': widget.link,
      'title': widget.title,
    }];
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
                foregroundColor: Colors.black),
          ),
          SizedBox(width: 10,)
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
                        widget.link,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey,
                            child: Center(child: Text('Ошибка загрузки изображения')),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10,),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            Directory? appDocDir = await getDownloadsDirectory();
                            final filePath = '${appDocDir?.path.replaceAll('\\', '/')}/${widget.id}.mp3';
                            if (await File(filePath).exists()) { 
                              final uri = Uri.file(filePath); 
                              if (await canLaunch(uri.toString())) { 
                                await launch(uri.toString()); 
                              } else { 
                                showSnackBar(context, 'Не удалось запустить приложение для открытия файла'); 
                              } 
                            } else { 
                              showSnackBar(context, 'Файл не найден'); 
                            } 
                          },
                          child: const Text('Воспроизвести аудио'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              foregroundColor: Colors.black),
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(
                          onPressed: () async { 
                            Directory? appDocDir = await getDownloadsDirectory();
                            final filePath = '${appDocDir?.path.replaceAll('\\', '/')}/${widget.id}.mp4';
                            if (await File(filePath).exists()) { 
                              final uri = Uri.file(filePath); 
                              if (await canLaunch(uri.toString())) { 
                                await launch(uri.toString()); 
                              } else { 
                                showSnackBar(context, 'Не удалось запустить приложение для открытия файла'); 
                              } 
                            } else { 
                              showSnackBar(context, 'Файл не найден'); 
                            } 
                          },
                          child: const Text('Воспроизвести видео'),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow,
                              foregroundColor: Colors.black),
                        ),
                        SizedBox(height: 10,),
                      ]
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.simpleData,
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
                  onPressed: () async {
                    download_audio(idToUrl(widget.id), widget.id);
                    showSnackBar(context, 'Это может занять некоторое время');
                    await Future.delayed(Duration(seconds: 3));
                    showSnackBar(context, 'Аудио успешно установлено');
                    saveVideosToJson(history_videos);
                  },
                  child: const Text('Скачать аудио'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () async {
                    download_video(idToUrl(widget.id), widget.id);
                    showSnackBar(context, 'Это может занять некоторое время');
                    await Future.delayed(Duration(seconds: 3));
                    showSnackBar(context, 'Видео успешно установлено');
                    saveVideosToJson(history_videos);
                  },
                  child: const Text('Скачать видео'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () async {
                    download_text(idToUrl(widget.id), widget.id);
                    showSnackBar(context, 'Это может занять некоторое время');
                    await Future.delayed(Duration(seconds: 3));
                    saveVideosToJson(history_videos);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReaderPage(
                          id: widget.id,
                        ),
                      ),
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
                    MaterialPageRoute(builder: (context) => MainPage()),
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
}
