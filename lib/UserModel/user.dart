import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String? uid;
  String? name;
  GeoPoint? lastPos;
  dynamic globalLevel;
  String? ranking;
  dynamic totalDistance;
  double? dailyDistance;
  double? dailyLevel;
  Timestamp? latestDailyRecord;
  dynamic totalXp;
  dynamic dailyPercentage;
  dynamic totalPercentage;
  dynamic currentLvl;

  UserData(
      {this.uid,
      this.name,
      this.lastPos,
      this.dailyDistance,
      this.dailyLevel,
      this.globalLevel,
      this.ranking,
      this.totalDistance,
      this.latestDailyRecord,
      this.totalXp,
      this.dailyPercentage,
      this.totalPercentage,
      this.currentLvl});
}
