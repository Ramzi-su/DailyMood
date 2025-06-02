import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

void main() {
  runApp(DailyMoodApp());
}

class DailyMoodApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DailyMood',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Lato',
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('fr', ''),
      ],
      locale: WidgetsBinding.instance.window.locale,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mood, size: 100, color: Colors.teal),
            SizedBox(height: 20),
            Text(
              'Bienvenue sur DailyMood',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Suivez votre humeur chaque jour', style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) => MoodHomePage()),
                );
              },
              child: Text('Commencer'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodHomePage extends StatefulWidget {
  @override
  _MoodHomePageState createState() => _MoodHomePageState();
}

class _MoodHomePageState extends State<MoodHomePage> {
  late Database _db;
  List<Map<String, dynamic>> _moodList = [];

  final List<String> _quotes = [
    "Chaque jour est une nouvelle chance de changer ta vie.",
    "Reste positif, même les petites victoires comptent.",
    "Un esprit calme apporte de la force intérieure.",
    "Tu es plus fort que tu ne le penses.",
    "Respire, tout ira bien."
  ];

  final Map<String, String> _moodTips = {
    '😄': 'Garde cette énergie et partage-la autour de toi !',
    '😐': 'Prends une pause, fais quelque chose que tu aimes.',
    '😢': 'Appelle un proche ou écris ce que tu ressens.',
    '😠': 'Respire profondément et éloigne-toi du stress.',
    '😍': 'Profite pleinement de ce moment de bonheur.'
  };

  String _getRandomQuote() {
    final rand = Random();
    return _quotes[rand.nextInt(_quotes.length)];
  }

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = p.join(databasePath, 'mood.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE moods(id INTEGER PRIMARY KEY, date TEXT, mood TEXT, note TEXT)',
        );
      },
    );

    _loadMoods();
  }

  Future<void> _loadMoods() async {
    final data = await _db.query('moods', orderBy: 'date DESC');
    setState(() {
      _moodList = data;
    });
  }

  void _addMood(String mood, String note) async {
    final now = DateTime.now();
    final today = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    await _db.insert('moods', {
      'date': today,
      'mood': mood,
      'note': note,
    });

    _loadMoods();

    final tip = _moodTips[mood] ?? '';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tip), duration: Duration(seconds: 3)),
    );
  }

  void _showAddMoodDialog() {
    String selectedMood = '😄';
    String note = '';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (builderContext, setState) => AlertDialog(
          title: Text("Comment te sens-tu aujourd'hui ?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 10,
                children: ['😄', '😐', '😢', '😠', '😍'].map((emoji) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedMood = emoji),
                    child: Text(
                      emoji,
                      style: TextStyle(fontSize: 28),
                    ),
                  );
                }).toList(),
              ),
              TextField(
                onChanged: (value) => note = value,
                decoration: InputDecoration(hintText: 'Une petite note...'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addMood(selectedMood, note);
                Navigator.pop(dialogContext);
              },
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodList() {
    if (_moodList.isEmpty) {
      return Center(child: Text("Aucune humeur enregistrée."));
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            '💬 "${_getRandomQuote()}"',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _moodList.length,
            itemBuilder: (context, index) {
              final mood = _moodList[index];
              return ListTile(
                leading: Text(mood['mood'], style: TextStyle(fontSize: 26)),
                title: Text(mood['date']),
                subtitle: Text(mood['note'] ?? ''),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Historique des Humeurs')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildMoodList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMoodDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
