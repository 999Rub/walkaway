import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:go_outside_you_bitch/UserModel/user.dart';
import 'package:go_outside_you_bitch/loading.dart';
import 'package:go_outside_you_bitch/service/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
// Future<Position> _determinePosition() async {
//   bool serviceEnabled;
//   LocationPermission permission;

//   // Test if location services are enabled.
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     // Location services are not enabled don't continue
//     // accessing the position and request users of the
//     // App to enable the location services.
//     return Future.error('Location services are disabled.');
//   }

//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       // Permissions are denied, next time you could try
//       // requesting permissions again (this is also where
//       // Android's shouldShowRequestPermissionRationale
//       // returned true. According to Android guidelines
//       // your App should show an explanatory UI now.
//       return Future.error('Location permissions are denied');
//     }
//   }

//   if (permission == LocationPermission.deniedForever) {
//     // Permissions are denied forever, handle appropriately.
//     return Future.error(
//         'Location permissions are permanently denied, we cannot request permissions.');
//   }

//   // When we reach here, permissions are granted and we can
//   // continue accessing the position of the device.
//   return await Geolocator.getCurrentPosition();
// }

Future<Position> get_current_position() async {
  var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);

  return position;
}

Stream<Position> get pos {
  return Geolocator.getPositionStream();
}

StreamSubscription<Position> positionStream =
    Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.high)
        .listen((Position position) {});

class GeoCalculator extends StatefulWidget {
  const GeoCalculator({Key? key}) : super(key: key);

  @override
  _GeoCalculatorState createState() => _GeoCalculatorState();
}

class _GeoCalculatorState extends State<GeoCalculator> {
  @override
  @override
  Widget build(BuildContext context) {
    UserData? _user = Provider.of<UserData?>(context);

    return StreamBuilder<Position>(
        stream: pos,
        builder: (context, snapshot) {
          if (snapshot.data != null &&
              snapshot.hasData &&
              _user?.lastPos != null) {
            var meters = Geolocator.distanceBetween(
                _user!.lastPos!.latitude,
                _user.lastPos!.longitude,
                snapshot.data!.latitude,
                snapshot.data!.longitude);
            if (meters > 1) {
              //  print(_user.totalDistance);
              DataBaseService(uid: _user.uid).updateWalking(
                  _user.totalDistance,
                  meters,
                  GeoPoint(snapshot.data!.latitude, snapshot.data!.longitude),
                  _user.dailyDistance,
                  _user.dailyPercentage,
                  _user.totalPercentage,
                  _user.totalXp,
                  _user.currentLvl);
            }

            //print('METRE PARCOURU : $meters');
            return Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 50),
                  child: Column(
                    children: [
                      Wrap(
                        direction: Axis.vertical,
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text('Total',
                                    style: GoogleFonts.yanoneKaffeesatz(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic)),
                              ),
                              CircularPercentIndicator(
                                radius: 120,
                                lineWidth: 13,
                                backgroundColor: Colors.transparent,
                                animation: false,
                                maskFilter:
                                    const MaskFilter.blur(BlurStyle.solid, 3.5),
                                percent: _user.totalPercentage! / 15000,
                                animationDuration: 1200,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: const Color(0xff58cebb),
                                center: Text(
                                  _user.totalDistance!.round().toString() + 'm',
                                  style: GoogleFonts.yanoneKaffeesatz(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 50),
                                child: Text('LvL',
                                    style: GoogleFonts.yanoneKaffeesatz(
                                        fontSize: 40,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic)),
                              ),
                              CircularPercentIndicator(
                                radius: 120,
                                lineWidth: 13,
                                backgroundColor: Colors.transparent,
                                animation: false,
                                maskFilter:
                                    const MaskFilter.blur(BlurStyle.solid, 3.5),
                                percent: _user.currentLvl! / 100,
                                animationDuration: 1200,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: const Color(0xfff7466f),
                                center: Text(
                                  _user.globalLevel!.round().toString(),
                                  style: GoogleFonts.yanoneKaffeesatz(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 60),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text('Daily',
                            style: GoogleFonts.yanoneKaffeesatz(
                                fontSize: 40,
                                color: Colors.white,
                                fontStyle: FontStyle.italic)),
                      ),
                      CircularPercentIndicator(
                        radius: 120,
                        lineWidth: 13,
                        backgroundColor: Colors.transparent,
                        animation: false,
                        maskFilter: const MaskFilter.blur(BlurStyle.solid, 3.5),
                        percent: _user.dailyPercentage! / 3000,
                        animationDuration: 1200,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Color(0xfffbbe5f),
                        center: Text(
                          _user.dailyDistance!.round().toString() + 'm',
                          style: GoogleFonts.yanoneKaffeesatz(
                              fontSize: 20,
                              color: Colors.white,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90)),
                          width: 150,
                          height: 150,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(90)),
                            child: GoogleMap(
                                myLocationButtonEnabled: false,
                                //  zoomControlsEnabled: true,
                                myLocationEnabled: true,
                                mapType: MapType.hybrid,
                                liteModeEnabled: true,
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(_user.lastPos!.latitude,
                                        _user.lastPos!.longitude),
                                    zoom: 11.5)),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          } else {
            return const Loading();
          }
        });
    ;
  }
}
