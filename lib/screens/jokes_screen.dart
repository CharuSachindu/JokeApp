import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jokes_app/models/jokes_model.dart';

class JokesScreen extends StatefulWidget {
  const JokesScreen({super.key});

  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  final dio = Dio();
  // List<Map<String, dynamic>> jokes = [];
  List<dynamic> jokes = [];
  List<Joke> jokesList = [];

  void fetchJokes() async {
    Response response;
    response = await dio.get('https://v2.jokeapi.dev/joke/Any\?amount\=3',
        queryParameters: {"type": "twopart"});
    try {
      if (response.statusCode == 200) {
        // Directly access the response data
        setState(() {
          jokes = response.data['jokes'];
          jokesList = jokes
              .map((joke) => Joke.fromMap(joke as Map<String, dynamic>))
              .toList();
        });
      } else {}
    } on Exception catch (e) {
      throw Exception("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Joke App',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            'Welcome to the Joke App!',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
          ),
          const SizedBox(height: 10),
          const Text(
            'Click the button to fetch random jokes!',
            style: TextStyle(fontSize: 16, color: Colors.deepPurple),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: fetchJokes,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
            child: const Text(
              'Fetch Jokes',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: jokesList.length,
              itemBuilder: (context, index) {
                final joke = jokesList[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '{\n  "category: "${joke.category}",\n  "type": "${joke.type}",\n  "setup": "${joke.setup}",\n  "delivery": "${joke.delivery}",\n  "id": ${joke.id}\n}',
                    ),
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
