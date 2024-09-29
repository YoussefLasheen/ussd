import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'flavors.dart';
import 'pages/home_page/my_home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: F.identity.name,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.light(
          primary: F.identity.color,
        ),
        textTheme: GoogleFonts.cairoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const Directionality(
          textDirection: TextDirection.rtl, child: MyHomePage()),
    );
  }
}
