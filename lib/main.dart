import 'package:falxynews/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Pastikan file ini ada
import 'screens/upload_news_screen.dart'; // Tambahkan impor untuk UploadNewsScreen

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Pastikan widget binding terinisialisasi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berita Anime & E-sport',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Halaman utama aplikasi
      routes: {
        '/upload-news': (context) =>
            UploadNewsScreen(), // Pastikan UploadNewsScreen ada
      },
    );
  }
}
