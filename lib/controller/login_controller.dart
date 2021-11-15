import 'package:firebase_login_new/models/user_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController with ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;
  UserDetails? userDetails;

  googleLogin() async {
    googleSignInAccount = await _googleSignIn.signIn();
    userDetails = UserDetails(
        displayName: googleSignInAccount!.displayName,
        photoUrl: googleSignInAccount!.photoUrl,
        email: googleSignInAccount!.email);
    notifyListeners();
  }

  facebookLogin() async {
    var result = await FacebookAuth.i.login(permissions: [
      'public_profile',
      "email",
    ]);
    if (result.status == LoginStatus.success) {
      final requestData = await FacebookAuth.i.getUserData(
        fields: "email, name, picture",
      );
      userDetails = UserDetails(
        displayName: requestData["name"],
        email: requestData['email'],
        photoUrl: requestData["picture"]["data"]["url"] ?? " ",
      );
      notifyListeners();
    }
  }

  logout() async {
    googleSignInAccount = await _googleSignIn.signOut();
    await FacebookAuth.i.logOut();
    userDetails = null;
    notifyListeners();
  }
}
