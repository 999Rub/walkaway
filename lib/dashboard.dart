import 'package:avatar_view/avatar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:go_outside_you_bitch/UserModel/user.dart';
import 'package:go_outside_you_bitch/geoposition.dart';
import 'package:go_outside_you_bitch/leaderboard.dart';
import 'package:go_outside_you_bitch/loading.dart';
import 'package:go_outside_you_bitch/podometer.dart';
import 'package:go_outside_you_bitch/service/auth.dart';
import 'package:go_outside_you_bitch/service/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Auth _auth = Auth();
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserData>(context);
    return StreamBuilder<UserData>(
        stream: DataBaseService(uid: _user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              UserData? _userData = snapshot.data;

              DataBaseService(uid: _userData!.uid).upToDateDailyRecord(
                  _userData.latestDailyRecord!,
                  (_userData.dailyPercentage / 3000) * 10,
                  _userData.totalXp,
                  _userData.currentLvl);
              DataBaseService(uid: _userData.uid).checkForLvlUpdate(
                  _userData.totalXp,
                  _userData.globalLevel,
                  _userData.currentLvl);

              return StreamProvider<UserData?>.value(
                initialData: null,
                value: DataBaseService(uid: _user.uid).userData,
                child: Scaffold(
                    backgroundColor: const Color(0xff17171a),
                    body: ListView(
                      scrollDirection: Axis.vertical,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 50, left: 20),
                          child: Row(
                            children: [
                              Text(_userData.name!,
                                  style: GoogleFonts.yanoneKaffeesatz(
                                      fontSize: 50,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                width: 20,
                              ),
                              Flexible(
                                child: AvatarView(
                                  radius: 20,
                                  avatarType: AvatarType.CIRCLE,
                                  backgroundColor: Colors.white,
                                  // rajouter un IF pour savoir quelle image on prend dans les badges suivant le nombres de pas de la personne
                                  imagePath:
                                      'assets/image/${_userData.ranking}.png',
                                ),
                                flex: 2,
                              ),
                            ],
                          ),
                        ),
                        const GeoCalculator(),
                        Wrap(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 60, bottom: 35),
                                  child: Text('LeaderBoard',
                                      style: GoogleFonts.yanoneKaffeesatz(
                                          fontSize: 50,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                                const LeaderBoard(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 100, bottom: 100),
                                  child: GlowButton(
                                      color: const Color(0xff5b36d2),
                                      child: const Text(
                                        'Log out',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        await _auth.signOut();
                                      }),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    )),
              );
            } else {
              return const Loading();
            }
          } else {
            return const Loading();
          }
        });
  }
}
