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
        likedItems = F.code
            .expand((element) => element.codes)
            .where((element) =>
                prefs.getStringList('likedItems')?.contains(element.code) ??
                false)
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
        backgroundColor: F.color,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            if (likedItems.isNotEmpty) const SizedBox(height: 10),
            if (likedItems.isNotEmpty)
              Text(
                'المفضلة',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: likedItems.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return CodeCard(
                  code: likedItems[index],
                  isLiked: likedItems.contains(likedItems[index]),
                  onLike: () => toggleLike(likedItems[index]),
                );
              },
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: F.code.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, sectionIndex) {
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: F.code[sectionIndex].codes.length - 1,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, codeIndex) {
                    if (codeIndex == 0) {
                      return Text(
                        F.code[sectionIndex].name,
                        style: Theme.of(context).textTheme.titleLarge,
                      );
                    }
                    return CodeCard(
                      code: F.code[sectionIndex].codes[codeIndex],
                      isLiked: likedItems
                          .contains(F.code[sectionIndex].codes[codeIndex]),
                      onLike: () =>
                          toggleLike(F.code[sectionIndex].codes[codeIndex]),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
