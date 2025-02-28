import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test1/pages/main_page.dart';
import 'package:test1/components/get_data.dart';
import 'package:test1/pages/history_page.dart';

class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  final Set<String> _selectedTags = {};

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
              Navigator.pop(context,);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Самые популярные теги',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Просто выберите что понравится вам!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildTagItem('assets/car.svg', 'Автомобили', 'Cars'),
                          _buildTagItem('assets/airplane.svg', 'Авиация', 'Aviation'),
                          _buildTagItem('assets/businessman.svg', 'Бизнес', 'Business'),
                          _buildTagItem('assets/food.svg', 'Готовка', 'Cooking'),
                          _buildTagItem('assets/puppy.svg', 'Животные', 'Animals'),
                          _buildTagItem('assets/history.svg', 'История', 'History'),
                          _buildTagItem('assets/space.svg', 'Космос', 'Space'),
                          _buildTagItem('assets/music.svg', 'Музыка', 'Music'),
                          _buildTagItem('assets/programming.svg', 'Программирование', 'Programming'),
                          _buildTagItem('assets/sports.svg', 'Спорт', 'Sport'),
                          _buildTagItem('assets/physics.svg', 'Физика', 'Physics'),
                          _buildTagItem('assets/chemistry.svg', 'Химия', 'Chemistry'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Row (
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _selectedTags.isNotEmpty ? _saveSelectedTags : null,
                    child: const Text('Подтвердить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
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

  Widget _buildTagItem(String imagePath, String text, String teg) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedTags.contains(teg)) {
            _selectedTags.remove(teg);
          } else {
            _selectedTags.add(teg);
          }
        });
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
              border: _selectedTags.contains(teg)
                  ? Border.all(color: Colors.orange, width: 3) 
                  : null,
            ),
            child: ClipOval(
              child: SvgPicture.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
  void _saveSelectedTags() async {
    String tagsString = _selectedTags.join(' ');
    searchVideo(tagsString);
    await Future.delayed(Duration(seconds: 1));
    Navigator.push( 
      context, 
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }
}