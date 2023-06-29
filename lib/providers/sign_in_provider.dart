import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInProvider extends ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isSignIn = false;
  bool get isSignIn => _isSignIn;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uuid;
  String? get uuid => _uuid;

  String? _name;
  String? get name => _name;

  String? _email;
  String? get email => _email;

  String? _imageUrl;
  String? get imageUrl => _imageUrl;

  SignInProvider() {
    checkSignInUser();
  }

  Future checkSignInUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _isSignIn = sharedPreferences.getBool("signed_in") ?? false;
    notifyListeners();
  }

  Future setSignIn() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _isSignIn = true;
    sharedPreferences.setBool("signed_in", _isSignIn);
    notifyListeners();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if(googleSignInAccount == null) {
      _hasError = true;
      notifyListeners();
      return;
    }

    try {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken
      );

      final User userDetails = (await firebaseAuth.signInWithCredential(credential)).user!;

      _name = userDetails.displayName;
      _email = userDetails.email;
      _imageUrl = userDetails.photoURL;
      _uuid = userDetails.uid;
      _provider = "GOOGLE";
      notifyListeners();

    } on FirebaseAuthException catch(firebaseAuthException) {
      switch(firebaseAuthException.code) {
        case "account-exists-with-different-credential":
          _errorCode = "You already have an account with us. Use correct provider";
          _hasError = true;
          break;

        case "null":
          _errorCode = "Unexpected error while tying to sign in";
          _hasError = true;
          break;

        default:
          _errorCode = firebaseAuthException.toString();
          _hasError = true;
      }

      notifyListeners();
    }
  }

  Future getUserDataFromFirestore(uuid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uuid)
        .get()
        .then((DocumentSnapshot snapshot) => {
          _uuid = snapshot['uid'],
          _name = snapshot['name'],
          _email = snapshot['email'],
          _imageUrl = snapshot['image_url'],
          _provider = snapshot['provider'],
        });
  }
  
  Future saveUserDataToFirestore() async {
    final DocumentReference documentReference = FirebaseFirestore.instance.collection("users").doc(uuid);

    await documentReference
        .set({
          "uid": uuid,
          "name": name,
          "email": email,
          "image_url": imageUrl,
          "provider": provider,
        });

    notifyListeners();
  }

  Future saveUserDataToSharedPreferences() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("uid", uuid!);
    await sharedPreferences.setString("name", name!);
    await sharedPreferences.setString("email", email!);
    await sharedPreferences.setString("image_url", imageUrl!);
    await sharedPreferences.setString("provider", provider!);
    notifyListeners();
  }

  Future getDataFromSharedPreferences() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _uuid = sharedPreferences.getString("uid");
    _name = sharedPreferences.getString("name");
    _email = sharedPreferences.getString("email");
    _imageUrl = sharedPreferences.getString("image_url");
    _provider = sharedPreferences.getString("provider");
    notifyListeners();
  }

  Future<bool> checkUserExists() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(uuid).get();
    if(snapshot.exists) {
      print("Existing USER");
      return true;
    } else {
      print("New USER");
      return false;
    }
  }

  Future userSignOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();

    _isSignIn = false;

    notifyListeners();
    clearStoredData();
  }

  Future clearStoredData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  // TODO : refactor isolé les process google, firbase etc ..
  // TODO : doc : save
  void phoneNumberUser(User user, email, name) {
    _name = name;
    _email = email;
    // TODO : change this ico ?
    _imageUrl = "https://winaero.com/blog/wp-content/uploads/2017/12/User-icon-256-blue.png";
    _uuid = user.phoneNumber;
    _provider = "PHONE";
    notifyListeners();
  }

}