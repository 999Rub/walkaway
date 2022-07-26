import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_outside_you_bitch/UserModel/user.dart';

class DataBaseService {
  final String? uid;

  DataBaseService({this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  UserData _userDataFromFirestore(DocumentSnapshot snapshot) {
    return UserData(
        uid: (snapshot.data() as Map)['uid'],
        name: (snapshot.data() as Map)['name'],
        lastPos: (snapshot.data() as Map)['lastPos'],
        globalLevel: (snapshot.data() as Map)['globalLevel'],
        ranking: (snapshot.data() as Map)['ranking'],
        totalDistance: (snapshot.data() as Map)['totalDistance'],
        dailyDistance: (snapshot.data() as Map)['dailyDistance'],
        dailyLevel: (snapshot.data() as Map)['dailyLevel'],
        latestDailyRecord: (snapshot.data() as Map)['latestDailyRecord'],
        totalXp: (snapshot.data() as Map)['totalXp'],
        dailyPercentage: (snapshot.data() as Map)['dailyPercentage'],
        totalPercentage: (snapshot.data() as Map)['totalPercentage'],
        currentLvl: (snapshot.data() as Map)['currentLvl']);
  }

  Stream<UserData> get userData {
    return usersCollection.doc(uid).snapshots().map(_userDataFromFirestore);
  }

  Future<UserData> getUserData() async {
    return await usersCollection.doc(uid).get().then((snapshot) => UserData(
        uid: (snapshot.data() as Map)['uid'],
        name: (snapshot.data() as Map)['name'],
        lastPos: (snapshot.data() as Map)['lastPos'],
        globalLevel: (snapshot.data() as Map)['globalLevel'],
        ranking: (snapshot.data() as Map)['ranking'],
        totalDistance: (snapshot.data() as Map)['totalDistance'],
        dailyDistance: (snapshot.data() as Map)['dailyDistance'],
        dailyLevel: (snapshot.data() as Map)['dailyLevel'],
        latestDailyRecord: (snapshot.data() as Map)['latestDailyRecord'],
        totalXp: (snapshot.data() as Map)['totalXp'],
        dailyPercentage: (snapshot.data() as Map)['dailyPercentage'],
        totalPercentage: (snapshot.data() as Map)['totalPercentage'],
        currentLvl: (snapshot.data() as Map)['currentLvl']));
  }

  Future updateWalking(
      double? currentDistance,
      double newDistance,
      GeoPoint newPos,
      double? dailyDistance,
      dynamic dailyPercentage,
      dynamic totalPercentage,
      dynamic totalXp,
      dynamic currentLvl) async {
    Position position = await Geolocator.getCurrentPosition();
    var percenteDay = (dailyPercentage! / 3000);
    var percentdayNext = dailyPercentage! + newDistance;
    var totalPercent = totalPercentage / 15000;
    var totalPercentNext = totalPercentage + newDistance;
    if (percenteDay > 1) {
      usersCollection.doc(uid).set({
        'dailyPercentage': 0.0,
        'totalXp': totalXp + 10,
        'currentLvl': currentLvl + 10
      }, SetOptions(merge: true));
    } else if (percentdayNext / 3000 > 1) {
      usersCollection.doc(uid).set({
        'dailyPercentage': 0.0,
        'totalXp': totalXp + 10,
        'currentLvl': currentLvl + 10
      }, SetOptions(merge: true));
    } else {
      usersCollection.doc(uid).set(
          {'dailyPercentage': dailyPercentage! + newDistance},
          SetOptions(merge: true));
    }
    if (totalPercent > 1) {
      usersCollection.doc(uid).set({
        'totalPercentage': 0.0,
        'totalXp': totalXp + 50,
        'currentLvl': currentLvl + 50
      }, SetOptions(merge: true));
    } else if (totalPercentNext / 15000 > 1) {
      usersCollection.doc(uid).set({
        'totalPercentage': 0.0,
        'totalXp': totalXp + 50,
        'currentLvl': currentLvl + 50
      }, SetOptions(merge: true));
    } else {
      usersCollection.doc(uid).set(
          {'totalPercentage': totalPercentage + newDistance},
          SetOptions(merge: true));
    }
    return await usersCollection.doc(uid).set({
      'totalDistance': currentDistance! + newDistance,
      'lastPos': newPos,
      'dailyDistance': dailyDistance! + newDistance
    }, SetOptions(merge: true));
  }

  Future upToDateDailyRecord(Timestamp latestRecord, double xpGains,
      dynamic totalXp, dynamic currentLvl) async {
    DateTime latestRecordDateTime = DateTime.fromMicrosecondsSinceEpoch(
        latestRecord.microsecondsSinceEpoch);
    final today = DateTime.now();
    //  print("UP TO DAILY RECORD IS CALLED");
    final difference = today.difference(latestRecordDateTime).inDays;
    if (difference >= 1) {
      return usersCollection.doc(uid).set({
        'dailyLevel': 0.0,
        'totalXp': totalXp + xpGains,
        'currentLvl': currentLvl + xpGains,
        'dailyDistance': 0.0,
        'latestDailyRecord': today
      }, SetOptions(merge: true));
    } else {}
  }

  Future checkForLvlUpdate(
      dynamic totalXp, dynamic globalLvl, dynamic currentLvl) async {
    switch (globalLvl) {
      case 0:
        usersCollection
            .doc(uid)
            .set({'ranking': 'Badge1'}, SetOptions(merge: true));
        break;
      case 1:
        usersCollection
            .doc(uid)
            .set({'ranking': 'Badge1'}, SetOptions(merge: true));
        break;
      case 2:
        usersCollection
            .doc(uid)
            .set({'ranking': 'Badge2'}, SetOptions(merge: true));
        break;
      case 3:
        usersCollection
            .doc(uid)
            .set({'ranking': 'Badge3'}, SetOptions(merge: true));
        break;

      case 4:
        usersCollection
            .doc(uid)
            .set({'ranking': 'Badge4'}, SetOptions(merge: true));
        break;
      case 5:
        usersCollection
            .doc(uid)
            .set({'ranking': 'Badge5'}, SetOptions(merge: true));
        break;
      default:
    }
    if (currentLvl >= 100) {
      return usersCollection.doc(uid).set(
          {'currentLvl': 0, 'globalLevel': globalLvl + 1},
          SetOptions(merge: true));
    } else {}
  }

  Future<List<UserData>> leaderBoard() async {
    List<UserData> leaderboardList = [];

    var coll = await usersCollection.get();

    for (var item in coll.docs) {
      if ((item.data() as Map)['totalDistance'] > 100) {
        leaderboardList.add(UserData(
            name: (item.data() as Map)['name'],
            totalDistance: ((item.data() as Map)['totalDistance']) != null
                ? ((item.data() as Map)['totalDistance']).round()
                : 0,
            globalLevel: (item.data() as Map)['globalLevel'],
            ranking: (item.data() as Map)['ranking']));
      }
    }

    leaderboardList.sort((a, b) => b.totalDistance.compareTo(a.totalDistance));
    return leaderboardList;
  }
}
