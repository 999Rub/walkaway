import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_outside_you_bitch/UserModel/user.dart';
import 'package:go_outside_you_bitch/authenticate_screen.dart';
import 'package:go_outside_you_bitch/connexion/login.dart';
import 'package:go_outside_you_bitch/dashboard.dart';
import 'package:go_outside_you_bitch/service/auth.dart';
import 'package:go_outside_you_bitch/wrapper_register.dart';

import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Auth().signOut();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData?>.value(
        initialData: null,
        value: Auth().user,
        child: const MaterialApp(
            debugShowCheckedModeBanner: false, home: WrapperRegister()));
  }
}
