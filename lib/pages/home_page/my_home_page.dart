import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ussd/flavors.dart';
import 'package:ussd/models/code.dart';
import 'package:ussd/pages/home_page/widgets/code_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Code> likedItems = [];
  @override
  void initState() {
    super.initState();
    _loadLikedStatus();
  }

  Future<void> _loadLikedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(
      () {
        likedItems = (prefs.getStringList('likedItems') ?? [])
            .map((e) => F.code.firstWhere(
                  (element) => element.code == e,
                ))
            .toList();
      },
    );
  }

  Future<void> _saveLikedItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'likedItems', likedItems.map((e) => e.code).toList());
    setState(() {});
  }

  void toggleLike(Code item) {
    if (likedItems.contains(item)) {
      likedItems.remove(item);
    } else {
      likedItems.add(item);
    }
    _saveLikedItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(F.title),
      ),
      body: Center(
          child: ListView(
        children: [
          if (likedItems.isNotEmpty)
            Text(
              'المفضلة',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: likedItems.length,
            itemBuilder: (context, index) {
              return CodeCard(
                code: likedItems[index],
                isLiked: likedItems.contains(likedItems[index]),
                onLike: () => toggleLike(likedItems[index]),
              );
            },
          ),
          Text(
            'كل الكودات',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: F.code.length,
            itemBuilder: (context, index) {
              return CodeCard(
                code: F.code[index],
                isLiked: likedItems.contains(F.code[index]),
                onLike: () => toggleLike(F.code[index]),
              );
            },
          )
        ],
      )),
    );
  }
}
