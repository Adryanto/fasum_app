import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final String postId; // tambahkan properti postId untuk menerima id postingan

  DetailScreen({required this.postId});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isFavorited = false; // flag untuk menandai apakah postingan telah difavoritkan
  int _favoriteCount = 0; // counter untuk jumlah favorit
  final _commentController = TextEditingController(); // controller untuk input komentar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Postingan'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final post = snapshot.data!;
            final timestamp = post['timestamp']; // assume 'timestamp' is the field name in Firestore
            final date = timestamp.toDate(); // convert Timestamp to DateTime
            final formattedDate = DateFormat.yMMMd().format(date); // format the date
            final formattedTime = DateFormat.jm().format(date); // format the time

            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post['text']),
                      Text('Tanggal = $formattedDate'),  // display the formatted date
                      Text('Jam = $formattedTime'),  // display the formatted time
                      Text('Email = ${post['email']}'), // display the email of the post creator
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(post['image_url']),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(_isFavorited? Icons.favorite : Icons.favorite_border),
                      onPressed: () async {
                        setState(() {
                          _isFavorited =!_isFavorited;
                          if (_isFavorited) {
                            _favoriteCount++;
                          } else {
                            _favoriteCount--;
                          }
                        });
                        await FirebaseFirestore.instance.collection('posts').doc(widget.postId).update({
                          'favoriteCount': _favoriteCount,
                        });
                      },
                    ),
                    Text('$_favoriteCount Favorit'),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () {
                        // tambahkan fungsi untuk menampilkan dialog komentar
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Tambah Komentar'),
                              content: TextField(
                                controller: _commentController,
                                decoration: InputDecoration(
                                  labelText: 'Komentar',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  child: Text('Kirim'),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').add({
                                      'text': _commentController.text,
                                      'timestamp': Timestamp.now(),
                                    });
                                    _commentController.clear();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                // tambahkan listview untuk menampilkan komentar
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('posts').doc(widget.postId).collection('comments').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final comment = snapshot.data!.docs[index];
                          return ListTile(
                            title: Text(comment['text']),
                          );
                        },
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}