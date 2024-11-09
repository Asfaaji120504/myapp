import 'package:flutter/material.dart';
import 'package:nasa_apod_app/services/api_service.dart';
import 'package:nasa_apod_app/models/astronomy_picture.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<AstronomyPicture> _futureAstronomyPicture;

  @override
  void initState() {
    super.initState();
    // Memanggil API saat halaman dimuat
    _futureAstronomyPicture = fetchAstronomyPicture();
  }

  Future<AstronomyPicture> fetchAstronomyPicture() async {
    final data = await ApiService().fetchAstronomyPicture();
    return AstronomyPicture.fromJson(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NASA APOD'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<AstronomyPicture>(
        future: _futureAstronomyPicture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          } else {
            final astronomyPicture = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gambar
                  CachedNetworkImage(
                    imageUrl: astronomyPicture.url,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error, size: 50),
                  ),
                  const SizedBox(height: 20),

                  // Judul
                  Text(
                    astronomyPicture.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  // Tanggal
                  Text(
                    'Date: ${astronomyPicture.date}',
                    style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Penjelasan
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      astronomyPicture.explanation,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
