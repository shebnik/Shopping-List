import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoppinglist/models/app_user.dart';
import 'package:shoppinglist/models/user_auth.dart';
import 'package:shoppinglist/services/firestore_service.dart';
import 'package:shoppinglist/services/app_utils.dart';
import 'package:shoppinglist/ui/pages/home_page.dart';
import 'package:shoppinglist/ui/pages/login_page.dart';

class AuthService {
  static final FirebaseAuth _instance = FirebaseAuth.instance;

  static String? getUserId() => _instance.currentUser?.uid;

  static Future<String> defineInitRoutePath() async =>
      await _instance.authStateChanges().first != null
          ? HomePage.routeName
          : LoginPage.routeName;

  static void listenAuthState(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        }
      },
    );
  }

  static Future<String?> createAccount(UserAuth userAuth) async {
    try {
      UserCredential userCredential =
          await _instance.createUserWithEmailAndPassword(
        email: userAuth.email,
        password: userAuth.password,
      );
      User? user = userCredential.user;
      if (user == null) return 'Create account error';
      await FirestoreService.addUser(
        AppUser(
          uid: user.uid,
          email: user.email ?? '',
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> login(UserAuth userAuth) async {
    try {
      await _instance.signInWithEmailAndPassword(
        email: userAuth.email,
        password: userAuth.password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
      return e.message.toString();
    }
  }

  static Future<bool> signInGoogle(BuildContext context) async {
    UserCredential? userCredential;
    if (kIsWeb) {
      userCredential = await signInWithGoogleWeb();
    } else {
      userCredential = await signInWithGoogle();
    }
    if (userCredential == null) return false;
    User? user = userCredential.user;
    if (user == null) {
      AppUtils.showSnackBar(context, 'Login error');
      return false;
    }
    await FirestoreService.addUser(
      AppUser(
        uid: user.uid,
        email: user.email ?? '',
      ),
    );
    return true;
  }

  static Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    try {
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
  }

  static Future<UserCredential?> signInWithGoogleWeb() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    try {
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } catch (e) {
      print(e);
    }
  }

  static Future<void> logout() async => await _instance.signOut();
}
