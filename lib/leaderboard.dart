// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:avatar_view/avatar_view.dart';
import 'package:go_outside_you_bitch/UserModel/user.dart';
import 'package:go_outside_you_bitch/loading.dart';
import 'package:go_outside_you_bitch/service/database.dart';
import 'package:provider/provider.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

Widget TemplateLigne(UserData userData, int i) {
  return Card(
    margin: EdgeInsets.only(top: 5, left: 30, right: 30, bottom: 5),
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    color: Colors.white30,
    child: Column(
      children: <Widget>[
        Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            // Username
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  userData.name!,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              flex: 6,
              fit: FlexFit.tight,
            ),

            // Badge
            Flexible(
              child: AvatarView(
                radius: 20,
                avatarType: AvatarType.CIRCLE,
                backgroundColor: Colors.white,
                // rajouter un IF pour savoir quelle image on prend dans les badges suivant le nombres de pas de la personne
                imagePath: 'assets/image/${userData.ranking}.png',
              ),
              flex: 2,
            ),

            // Nombre de pas
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  userData.totalDistance.toString(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              flex: 2,
            ),

            // Classement
            Flexible(
              child: Text(
                // Placer le bon chiffre qui dans le classement
                '#' + (i + 1).toString(),

                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
              flex: 0,
            )
          ],
        ),
      ],
    ),
  );
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    UserData? _user = Provider.of<UserData?>(context);
    return FutureBuilder(
        future: DataBaseService(uid: _user?.uid).leaderBoard(),
        builder: (context, AsyncSnapshot<List<UserData>> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              List<UserData>? leaderboard = snapshot.data;

              return Stack(children: <Widget>[
                Positioned(
                  child: Column(
                    children: <Widget>[
                      for (int i = 0; i < leaderboard!.length; i++)
                        TemplateLigne(leaderboard[i], i),
                      SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ]);
            } else {
              return Loading();
            }
          } else {
            return Loading();
          }
        });
  }
}
