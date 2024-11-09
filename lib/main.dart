import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NASA APOD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: APODScreen(),
    );
  }
}

class APODScreen extends StatefulWidget {
  @override
  _APODScreenState createState() => _APODScreenState();
}

class _APODScreenState extends State<APODScreen> {
  String? imageUrl;
  String? title;
  String? explanation;
  bool showExplanation = false; // Flag to toggle explanation visibility

  // Fungsi untuk mengambil data dari NASA API
  Future<void> fetchAPODData() async {
    const apiKey = 'DEMO_KEY'; // Gantilah dengan API key Anda jika perlu
    final url = Uri.parse('https://api.nasa.gov/planetary/apod?api_key=$apiKey');
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Jika response berhasil, parse JSON
      final data = json.decode(response.body);
      setState(() {
        imageUrl = data['url'];
        title = data['title'];
        explanation = data['explanation'];
      });
    } else {
      throw Exception('Failed to load APOD data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAPODData(); // Memanggil API saat widget pertama kali dimuat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NASA Astronomy Picture of the Day'),
      ),
      body: imageUrl == null
          ? Center(child: CircularProgressIndicator()) // Loading indicator jika data belum tersedia
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? 'No Title',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    CachedNetworkImage(
                      imageUrl: imageUrl!,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    SizedBox(height: 16),
                    // Tombol untuk menampilkan penjelasan lebih lanjut
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showExplanation = !showExplanation;
                        });
                      },
                      child: Text(showExplanation ? 'Hide Explanation' : 'Show Explanation'),
                    ),
                    SizedBox(height: 16),
                    // Menampilkan penjelasan jika flag showExplanation adalah true
                    if (showExplanation)
                      Text(explanation ?? 'No Explanation', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
    );
  }
}
