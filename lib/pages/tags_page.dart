import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test1/database/database_helper.dart';


class TagsPage extends StatefulWidget {
  const TagsPage({super.key});

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> {
  final Set<String> _selectedTags = {};
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SvgPicture.asset(
          'assets/logo.svg',
        ),
        actions: [
          Container (
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
            onPressed: () {_printSavedTags();},
            child: const Text('Теги'),
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
          crossAxisAlignment: CrossAxisAlignment.center,
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
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildTagItem('assets/car.svg', 'Автомобили'),
                _buildTagItem('assets/airplane.svg', 'Авиация'),
                _buildTagItem('assets/businessman.svg', 'Бизнес'),
                _buildTagItem('assets/food.svg', 'Готовка'),
                _buildTagItem('assets/puppy.svg', 'Животные'),
                _buildTagItem('assets/history.svg', 'История'),
                _buildTagItem('assets/space.svg', 'Космос'),
                _buildTagItem('assets/music.svg', 'Музыка'),
                _buildTagItem('assets/programming.svg', 'Программирование'),
                _buildTagItem('assets/sports.svg', 'Спорт'),
                _buildTagItem('assets/physics.svg', 'Физика'),
                _buildTagItem('assets/chemistry.svg', 'Химия'),
              ],
            ),
            const SizedBox(height: 40),
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
      ),
      backgroundColor: const Color.fromARGB(234, 0, 0, 0),
    );
  }

  Widget _buildTagItem(String imagePath, String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedTags.contains(text)) {
            _selectedTags.remove(text);
            print(text);
          } else {
            _selectedTags.add(text);
            print(text);
          }
        });
      },
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
              border: _selectedTags.contains(text)
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
    for (String tag in _selectedTags) {
      await _dbHelper.addTag(tag);  
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Теги успешно сохранены!')),
    );
  }
  void _printSavedTags() async { 
    List<Map<String, dynamic>> savedTags = await _dbHelper.getTags(); 
    for (var tag in savedTags) { 
      print('Сохранённый тег: ${tag['tag']}'); 
    } 
  }
}