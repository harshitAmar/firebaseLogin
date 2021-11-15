// ignore_for_file: avoid_print, must_be_immutable

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage extends StatefulWidget {
  String? userID;
  UploadImage({Key? key, required this.userID}) : super(key: key);

  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadURL;
  Future imagePick() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        showSnackBar("No file Selected", const Duration(milliseconds: 400));
      }
    });
  }

  showSnackBar(String snackText, Duration d) {
    final snackBarText = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBarText);
  }

  Future uploadImage() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${widget.userID}/images")
        .child("post_$postID");
    await ref.putFile(_image!);
    downloadURL = await ref.getDownloadURL();
    await firebaseFirestore
        .collection("users")
        .doc(widget.userID)
        .collection("images")
        .add({'downloadURL': downloadURL}).whenComplete(() => showSnackBar(
            "Image Upladed Successfully", const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Image"),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: SizedBox(
            height: 500,
            width: double.infinity,
            child: Column(
              children: [
                const Text("Upload Image"),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              child: _image == null
                                  ? const Center(
                                      child: Text("No Image selected"),
                                    )
                                  : Image.file(_image!)),
                          ElevatedButton(
                              onPressed: () {
                                imagePick();
                              },
                              child: const Text("Select Image")),
                          ElevatedButton(
                              onPressed: () {
                                uploadImage();
                              },
                              child: const Text("Upload Image")),
                        ],
                      ),
                    ),
                  ),
                  flex: 4,
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
