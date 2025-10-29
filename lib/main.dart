import 'package:flutter/material.dart';
import 'dogceointerface.dart';

void main() => runApp(DogApp());

class DogApp extends StatelessWidget {
  const DogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Browser',
      home: DogHomePage(),
    );
  }
}

class DogHomePage extends StatefulWidget {
  const DogHomePage({super.key});

  @override
  DogHomePageState createState() => DogHomePageState();
}

class DogHomePageState extends State<DogHomePage> {
  final DogCEOInterface _dogService = DogCEOInterface();
  List<String> _breeds = [];
  String? _selectedBreed;
  String? _imageUrl;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadBreeds();
    _loadImage();
  }

  Future<void> _loadBreeds() async {
    final breeds = await _dogService.getBreeds();
    setState(() => _breeds = breeds..sort());
  }

  Future<void> _loadImage() async {
    setState(() => _loading = true);
    final image = await _dogService.getRandomImage(_selectedBreed);
    setState(() {
      _imageUrl = image;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Browser'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
          Text(
            'Wähle eine Rasse!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              value: _selectedBreed,
              hint: Text('Wähle eine Rasse'),
              isExpanded: true,
              underline: SizedBox(), // entfernt die Standardlinie
              items: _breeds.map((breed) {
                return DropdownMenuItem(
                  alignment: Alignment.center,
                  value: breed,
                  child: Text(breed),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedBreed = value);
                _loadImage();
              },
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 250,
            child: Center(
              child: _loading
                  ? CircularProgressIndicator()
                  : _imageUrl != null
                      ? Image.network(
                          _imageUrl!,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Center(child: CircularProgressIndicator());
                          },
                        )
                      : Text('Kein Bild geladen'),
            ),
          ),
          SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextButton.icon(
                icon: Icon(Icons.refresh, color: Colors.black87),
                label: Text(
                  'Neues Bild laden',
                  style: TextStyle(color: Colors.black87),
                ),
                onPressed: _loadImage,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}