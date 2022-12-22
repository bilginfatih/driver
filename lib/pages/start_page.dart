import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Widgets/main_button.dart';
import '../helpers/font_size.dart';
import '../helpers/theme_colors.dart';
import '../screens/map_screen.dart';
import 'login_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: const AssetImage('assets/back.jpg'),
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  ThemeColors.scaffoldBgColor,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  /* Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      'ROTAM',
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.xxxLarge,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),*/
                  const Spacer(),
                  Text(
                    'Bir sonraki Yolculuğunuzu\nen uygun şekilde planlayın.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: ThemeColors.whiteTextColor,
                      fontSize: FontSize.medium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: MainButton(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) {
                            return StreamBuilder<User?>(
                              stream: FirebaseAuth.instance.authStateChanges(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return MapScreen();
                                } else {
                                  return LoginPage();
                                }
                              },
                            );
                          },
                        ),
                        result: false,
                      ),
                      text: 'Hemen Başla',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
