import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:go_outside_you_bitch/common/constants.dart';
import 'package:go_outside_you_bitch/loading.dart';
import 'package:go_outside_you_bitch/service/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthenticateScreen extends StatefulWidget {
  const AuthenticateScreen({Key? key}) : super(key: key);

  @override
  _AuthenticateScreenState createState() => _AuthenticateScreenState();
}

class _AuthenticateScreenState extends State<AuthenticateScreen> {
  final _formKey = GlobalKey<FormState>();
  final Auth _auth = Auth();
  String error = '';
  bool loading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool showSignIn = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void toggleView() {
    setState(() {
      emailController.text = '';
      passwordController.text = '';
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color(0xff17171a),
            body: Padding(
              padding: EdgeInsets.only(left: 60, top: size.height / 2 - 200),
              child: SizedBox(
                width: size.width / 1.5,
                //height: 400,
                child: Card(
                  elevation: 5,
                  color: Color(0xff17171a),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                  showSignIn ? 'Connexion' : 'Inscription',
                                  style: GoogleFonts.yanoneKaffeesatz(
                                      fontSize: 50, color: Colors.white)),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'email'),
                              controller: emailController,
                              validator: (value) =>
                                  value!.isEmpty ? "Entrer un email" : null,
                            ),
                          ),
                          showSignIn
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    decoration: textInputDecoration.copyWith(
                                        hintText: 'name'),
                                    controller: nameController,
                                    validator: (value) =>
                                        value!.isEmpty ? "Entrer un nom" : null,
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: passwordController,
                              decoration: textInputDecoration.copyWith(
                                  hintText: 'password'),
                              obscureText: true,
                              validator: (value) => value!.length < 6
                                  ? 'Entrez un mot de passe'
                                  : null,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GlowButton(
                              color: const Color(0xff5b36d2),
                              child: Text(
                                'Valider',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  var password = passwordController.value.text;
                                  var email = emailController.value.text;
                                  var name = nameController.value.text;
                                  showSignIn
                                      ? _auth.signInWithEmailAndPassword(
                                          email, password)
                                      : _auth.registerWithEmailAndPassword(
                                          email, password, name);
                                }
                              }),
                          Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: GlowButton(
                              width: 200,
                              height: 50,
                              color: Color(0xff58cebb),
                              child: Text(
                                showSignIn ? "S'inscrire" : 'Se connecter',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: toggleView,
                              //   borderRadius: BorderRadius.circular(45),
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
          );
  }
}
