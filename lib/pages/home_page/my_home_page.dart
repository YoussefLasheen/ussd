import 'package:flutter/material.dart';
import 'package:ussd/flavors.dart';
import 'package:ussd/pages/home_page/widgets/code_card.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(F.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: F.code.length,
          itemBuilder: (context, index) {
            return CodeCard(
              code: F.code[index],
            );
          },
        )
      ),
    );
  }
}
