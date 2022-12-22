import 'package:driver/pages/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/main_button.dart';
import '../helpers/font_size.dart';
import '../helpers/theme_colors.dart';
import '../screens/home.dart';
import '../screens/map_screen.dart';
import 'start_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0.0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Merhaba, Hoşgeldin",
                style: GoogleFonts.poppins(
                  color: ThemeColors.whiteTextColor,
                  fontSize: FontSize.xxLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  "Hesabınıza giriş yapınız.",
                  style: GoogleFonts.poppins(
                    color: ThemeColors.greyTextColor,
                    fontSize: FontSize.medium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 70),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //Email
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (_emailController.text.isEmpty) {
                          return "Bu alan boş olamaz";
                        }
                      },
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: ThemeColors.primaryColor,
                      decoration: InputDecoration(
                        fillColor: ThemeColors.textFieldBgColor,
                        filled: true,
                        hintText: "Email",
                        hintStyle: GoogleFonts.poppins(
                          color: ThemeColors.textFieldHintColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    //Password
                    TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (_passwordController.text.isEmpty) {
                          return "Bu alan boş olamaz";
                        }
                      },
                      obscureText: true,
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: ThemeColors.primaryColor,
                      decoration: InputDecoration(
                        fillColor: ThemeColors.textFieldBgColor,
                        filled: true,
                        hintText: "Şifre",
                        hintStyle: GoogleFonts.poppins(
                          color: ThemeColors.textFieldHintColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w400,
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 70),
                    MainButton(
                      text: 'Giriş Yap',
                      onTap: () {
                        _formKey.currentState!.validate();
                        signIn();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hesabın yok mu? ",
                      style: GoogleFonts.poppins(
                        color: ThemeColors.whiteTextColor,
                        fontSize: FontSize.medium,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpPage(),
                        ),
                      ),
                      child: Text(
                        "Kayıt ol",
                        style: GoogleFonts.poppins(
                          color: ThemeColors.primaryColor,
                          fontSize: FontSize.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapScreen()));
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }
}
