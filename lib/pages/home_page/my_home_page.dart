import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ussd/data.dart';
import 'package:ussd/flavors.dart';
import 'package:ussd/pages/home_page/widgets/banners.dart';
import 'package:ussd/pages/home_page/widgets/code_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<AppResponse> future;
  @override
  void initState() {
    super.initState();
    future = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(F.identity.name),
        backgroundColor: F.identity.color,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      title: const Text('عن التطبيق'),
                      content: const Text(
                        'تطبيق يساعدك على الوصول لأكواد الشبكات المصرية بسهولة وبدون الحاجة للبحث عنها في الإنترنت.\n اذا واجهتك أي مشكلة برجاء الضغط على تواصل معنا',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => launchUrl(Uri(
                              scheme: 'mailto',
                              path: 'ussd@lasheen.dev',
                              queryParameters: {
                                'subject': '${F.identity.name} تطبيق:'
                              })),
                          child: const Text('تواصل معنا'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('حسناً'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<AppResponse>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'يرجي التأكد من الاتصال بالإنترنت لأول مره فقط',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }

          final children = <Widget>[
            const SizedBox(
              height: 25,
            ),
            Banners(
              banners: snapshot.data!.banners,
            ),
          ];

          final codeSections = snapshot.data!.codeSections;
          for (final codeSection in codeSections) {
            children.add(
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text(
                  codeSection.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );

            for (final code in codeSection.codes) {
              children.add(CodeCard(code: code));
              children.add(
                const SizedBox(
                  height: 10,
                ),
              );
            }
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(children: children),
          );
        },
      ),
    );
  }
}
