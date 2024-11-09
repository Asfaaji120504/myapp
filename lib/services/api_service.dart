import 'dart:convert';
import 'package:http/http.dart' as http;

// URL API untuk Astronomy Picture of the Day (APOD)
const String baseUrl = 'https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY';

class ApiService {
  // Fungsi untuk mendapatkan data APOD
  Future<Map<String, dynamic>> fetchAstronomyPicture() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      // Memeriksa jika status code-nya 200 (OK)
      if (response.statusCode == 200) {
        // Mengonversi body JSON menjadi Map
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load astronomy picture');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching data: $e');
    }
  }
}
