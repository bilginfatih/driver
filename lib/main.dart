import 'package:flutter/material.dart';
import 'helpers/package_info_helper.dart';
import 'helpers/theme_colors.dart';
import 'pages/start_page.dart';
import 'package:firebase_core/firebase_core.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  PackageInfoHelper.initialize();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rota Planlama',
      theme: ThemeData(
        primaryColor: ThemeColors.primaryColor,
        scaffoldBackgroundColor: ThemeColors.scaffoldBgColor,
      ),
      home: StartPage(),
    );
  }
}
