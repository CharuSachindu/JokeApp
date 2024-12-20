import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:jokes_app/models/jokes_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response;

    try {
      // Fetch jokes from API
      response = await dio.get(
        'https://v2.jokeapi.dev/joke/Any?amount=3',
        queryParameters: {"type": "twopart"},
      );

      if (response.statusCode == 200) {
        // Process and cache jokes
        setState(() {
          jokes = response.data['jokes'];
          jokesList = jokes
              .map((joke) => Joke.fromMap(joke as Map<String, dynamic>))
              .toList();
        });

        // Convert jokesList to a List of Strings for SharedPreferences
        List<String> jokesStringList =
            jokesList.map((joke) => joke.toJson()).toList();
        await prefs.setStringList('cachedJokesList', jokesStringList);
      }
    } catch (e) {
      // Handle Dio errors
      print("Dio Error: $e");

      // Load cached jokes when offline
      List<String>? cachedJokes = prefs.getStringList('cachedJokesList');
      if (cachedJokes != null) {
        setState(() {
          jokesList = cachedJokes
              .map((jokeString) => Joke.fromJson(jokeString))
              .toList();
        });
      } else {
        throw Exception("No jokes available offline.");
      }
    } catch (e) {
      // Handle other exceptions
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
