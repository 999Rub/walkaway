import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_outside_you_bitch/UserModel/user.dart';

class Auth {
  FirebaseAuth auth = FirebaseAuth.instance;

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  UserData? _userFromFirebaseUser(User? user, [String? name]) {
    return user != null ? UserData(uid: user.uid, name: name) : null;
  }

  Stream<UserData?> get user {
    return auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print(user!.uid);
      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      print(user!.uid);
      await usersCollection.doc(user.uid).set({
        'name': name,
        'email': email,
        'uid': user.uid,
        'totalStep': 0,
        'dailyStep': 0,
        'lastPos': GeoPoint(position.latitude, position.longitude),
        'globalLevel': 0.0,
        'ranking': 'Badge1',
        'totalDistance': 0.0,
        'dailyDistance': 0.0,
        'dailyLevel': 0.0,
        'latestDailyRecord': DateTime.now(),
        'totalXp': 0.0,
        'dailyPercentage': 0.0,
        'totalPercentage': 0.0,
        'currentLvl': 0.0
      });
      return _userFromFirebaseUser(user, name);
    } catch (e) {
      return null;
    }
  }

  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      return null;
    }
  }
}
