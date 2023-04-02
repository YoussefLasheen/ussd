import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'flavors.dart';
import 'pages/home_page/my_home_page.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        title: F.title,
        theme: ThemeData.light(useMaterial3: true).copyWith(
          colorScheme: ColorScheme.light(
            primary: F.color,
          ),
        ),
        home: MyHomePage(),
      ),
    );
  }
}
