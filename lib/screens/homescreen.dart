import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login_new/imageupload/imageshow.dart';
import 'package:firebase_login_new/imageupload/imageupload.dart';
import 'package:firebase_login_new/models/user_model.dart';
import 'package:firebase_login_new/screens/loginscreen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? users = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(users!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: Image.asset("assets/images/papaya_icon.png"),
              ),
              const SizedBox(
                height: 35,
              ),
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 35,
              ),
              Text(
                "${loggedInUser.firstName} ${loggedInUser.lastName}",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                "${loggedInUser.email}",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UploadImage(
                                  userID: loggedInUser.uid,
                                )));
                  },
                  child: const Text("Upload Image")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ImageRetrive(userId: loggedInUser.uid)));
                  },
                  child: const Text("Show Image")),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  _appbar() {
    final appBarHeight = AppBar().preferredSize.height;
    return PreferredSize(
        child: AppBar(
          title: const Text("Welcome"),
          actions: [
            IconButton(
              onPressed: () {
                logout(context);
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        preferredSize: Size.fromHeight(appBarHeight));
  }
}
