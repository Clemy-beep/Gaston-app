import 'package:app/main.dart';
import 'package:app/services/router.dart';
import 'package:app/services/storage-services/auth_storage_service.dart';
import 'package:app/widget/custom_main_action_button.dart';
import 'package:app/widget/custom_text_button.dart';
import 'package:app/widget/custom_text_input.dart';
import 'package:app/widget/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? login;
  String? password;
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
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: CustomH1Title(text: 'Ravi de vous revoir'),
                ),
                const Padding(padding: EdgeInsets.all(8)),
                CustomTextInput(
                    labelText: 'identifiant',
                    hintText: 'pseudo ou mot de passe',
                    onChanged: (value) => {
                          setState(() {
                            login = value;
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
                CustomMainActionButton(
                    text: 'Se connecter',
                    onPressed: () async {
                      try {
                        if (login == null || password == null) {
                          throw Exception('Veuillez remplir tous les champs');
                        }
                        await getIt<AuthStorageService>()
                            .login(login, password);
                      } on Exception catch (e) {
                        setState(() {
                          error = e.toString();
                        });
                      }
                    },
                    icon: Icons.login),
                Text(error,
                    style: GoogleFonts.raleway(
                        color: Colors.redAccent[400],
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
                const Padding(padding: EdgeInsets.all(8)),
                CustomTextButton(
                    text: 'S\'inscrire', onPressed: () => router.go('/sign-up'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
