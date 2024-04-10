import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick and Morty App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Cual es tu nombre?'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondPage(name: nameController.text),
                  ),
                );
              },
              child: Text('Ingresar'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  final String name;

  SecondPage({required this.name});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  List<Character> characters = [];

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    final response =
        await http.get(Uri.parse('https://rickandmortyapi.com/api/character'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        characters = List<Character>.from(
            data['results'].map((character) => Character.fromJson(character)));
      });
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Rick & Morty'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Bienvenido ${widget.name}'),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.green, // Fondo verde
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(characters[index].imageUrl),
                    ),
                    title: Text(characters[index].name),
                    subtitle: Text(characters[index].status),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Character {
  final int id;
  final String name;
  final String status;
  final String imageUrl;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.imageUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      imageUrl: json['image'],
    );
  }
}
