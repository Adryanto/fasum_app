import 'package:fasum_app/screens/home_screen.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  // Fungsi untuk membuka kamera saat tombol "upload" ditekan
  Future<void> _openCamera() async {
    // Tambahkan logika untuk membuka kamera dan mengambil foto di sini
    print('Opening camera...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post Screen"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tombol "upload" untuk membuka kamera
          GestureDetector(
            onTap: _openCamera,
            child: Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Icon(
                Icons.upload, // Ganti dengan ikon upload Anda
                size: 100,
              ),
            ),
          ),
          // TextField untuk mengisi teks postingan
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tulis postingan Anda...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
          // Tombol "Post" untuk menyimpan postingan
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                // Tambahkan logika untuk menyimpan posting ke Firebase Cloud Firestore di sini
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Text('Post'),
            ),
          ),
        ],
      ),
    );
  }
}
