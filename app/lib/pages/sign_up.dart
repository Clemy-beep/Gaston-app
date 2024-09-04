import 'package:app/main.dart';
import 'package:app/services/router.dart';
import 'package:app/services/storage-services/user_storage_service.dart';
import 'package:app/widget/custom_main_action_button.dart';
import 'package:app/widget/custom_text_button.dart';
import 'package:app/widget/custom_text_input.dart';
import 'package:app/widget/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? username;
  String? password;
  String? firstname;
  String? lastname;
  String? email;
  String? biography;
  String error = '';
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      position: DecorationPosition.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: CustomH1Title(text: 'Bienvenue chez Gaston'),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                CustomTextInput(
                    labelText: 'nom d\'utilisateur',
                    hintText: 'pseudo',
                    onChanged: (value) => {
                          setState(() {
                            username = value;
                          }),
                        }),
                const Padding(padding: EdgeInsets.all(8)),
                CustomTextInput(
                    labelText: 'prénom',
                    hintText: 'prénom',
                    onChanged: (value) => {
                          setState(() {
                            firstname = value;
                          }),
                        }),
                const Padding(padding: EdgeInsets.all(8)),
                CustomTextInput(
                    labelText: 'nom',
                    hintText: 'nom',
                    onChanged: (value) => {
                          setState(() {
                            lastname = value;
                          }),
                        }),
                const Padding(padding: EdgeInsets.all(8)),
                CustomTextInput(
                    labelText: 'email',
                    hintText: 'email',
                    onChanged: (value) => {
                          setState(() {
                            email = value;
                          }),
                        }),
                const Padding(padding: EdgeInsets.all(8)),
                CustomTextInput(
                  labelText: 'mot de passe',
                  hintText: 'mot de passe',
                  obscureText: true,
                  onChanged: (value) => {
                    setState(() {
                      password = value;
                    }),
                  },
                ),
                const Padding(padding: EdgeInsets.all(8)),
                CustomTextInput(
                    labelText: 'biographie',
                    hintText: 'biographie',
                    maxlines: 4,
                    onChanged: (value) => {
                          setState(() {
                            biography = value;
                          }),
                        }),
                const Padding(padding: EdgeInsets.all(8)),
                CustomMainActionButton(
                    text: 'S\'inscrire',
                    onPressed: () {
                      try {
                        getIt<UserStorageService>().createUser(firstname,
                            lastname, email, username, biography, password);
                      } on Exception catch (e) {
                        setState(() {
                          error = e.toString();
                        });
                      }
                    },
                    icon: Icons.person_add_alt_1_outlined),
                Text(error,
                    style: GoogleFonts.raleway(
                        color: Colors.redAccent[400],
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
                const Padding(padding: EdgeInsets.all(8)),
                CustomTextButton(
                    text: 'Se connecter', onPressed: () => router.go('/login'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
