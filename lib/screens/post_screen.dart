  import 'dart:io';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:flutter/material.dart';
  import 'package:image_picker/image_picker.dart';

  class PostScreen extends StatefulWidget {
    @override
    _PostScreenState createState() => _PostScreenState();
  }

  class _PostScreenState extends State<PostScreen> {
    final _postTextController = TextEditingController();
    final ImagePicker _picker = ImagePicker();
    XFile? _image;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Tambah Postingan'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              GestureDetector(
                onTap: () async {
                  await _showImageSourceDialog();
                },

                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],

                  ),
                  child: _image != null
                      ? Image.file(File(_image!.path))
                      : Icon(Icons.camera_alt),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _postTextController,
                decoration: InputDecoration(
                  hintText: 'Masukkan Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              ElevatedButton(
                onPressed: () async {
                  if (_image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select an image')),
                    );
                    return;
                  }

                  Reference referenceRoot = FirebaseStorage.instance.ref();
                  Reference referenceDirImages = referenceRoot.child("images");
                  Reference referenceImagesToUpload =
                  referenceDirImages.child(_image!.path.split("/").last);

                  try {
                    final uploadTask =
                    await referenceImagesToUpload.putFile(File(_image!.path));
                    final downloadUrl = await uploadTask.ref.getDownloadURL();

                    // Add Firebase Cloud Firestore functionality here
                    final CollectionReference posts =
                    FirebaseFirestore.instance.collection('posts');
                    await posts.add({
                      'text': _postTextController.text,
                      'image_url': downloadUrl,
                      'timestamp': Timestamp.now(),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Image uploaded successfully')),
                    );

                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error uploading image: $e')),
                    );
                  }
                },
                child: Text('Post'),
              ),
            ],
          ),
        ),
      );
    }

    Future<void> _showImageSourceDialog() async {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Take a new photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                  await _picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _image = pickedFile;
                    });
                  }
                },
              ),
              ListTile(
                title: Text('Choose from library'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final pickedFile =
                  await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _image = pickedFile;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    @override
    void dispose() {
      _postTextController.dispose();
      super.dispose();
    }
  }