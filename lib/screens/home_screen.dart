import 'package:fasum_app/screens/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fasum_app/screens/sign_in_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<bool> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignInScreen()));
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data!.docs[index];
                  return ListTile(
                    title: Text(post['text']),
                    leading: Image.network(post['image_url']),
                  );
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Color.fromARGB(255, 129, 214, 248),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  PostScreen()),
            );
          },
          label: const Text('Add'),
          icon: const Icon(Icons.add,
              color: Color.fromARGB(255, 3, 3, 3), size: 25),
        ));
  }
}