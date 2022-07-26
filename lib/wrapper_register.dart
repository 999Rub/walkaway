import 'package:flutter/material.dart';
import 'package:go_outside_you_bitch/UserModel/user.dart';
import 'package:go_outside_you_bitch/authenticate_screen.dart';
import 'package:go_outside_you_bitch/dashboard.dart';
import 'package:provider/provider.dart';

class WrapperRegister extends StatefulWidget {
  const WrapperRegister({Key? key}) : super(key: key);

  @override
  _WrapperRegisterState createState() => _WrapperRegisterState();
}

class _WrapperRegisterState extends State<WrapperRegister> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);
    if (user?.uid != null) {
      return Dashboard();
    } else {
      return AuthenticateScreen();
    }
  }
}
