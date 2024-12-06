import 'dart:convert'; 
import 'package:flutter/material.dart'; 
import 'package:flutter_svg/flutter_svg.dart'; 
import 'package:test1/pages/tags_page.dart'; 
import 'package:test1/pages/player_page.dart'; 
import 'package:flutter/services.dart' show rootBundle; 
import 'package:test1/components/get_data.dart';
 
class MainPage extends StatefulWidget { 
  @override 
  _MainPageState createState() => _MainPageState(); 
} 
 
class _MainPageState extends State<MainPage> { 
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





      // body: Column(
      //   children: Central(

      //   )
      // ),






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
      backgroundColor: const Color.fromARGB(234, 14, 14, 14), 
    ); 
  } 
}