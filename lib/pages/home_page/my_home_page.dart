import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ussd/data.dart';
import 'package:ussd/flavors.dart';
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

            final codeSections = snapshot.data!.codeSections;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: codeSections.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, sectionIndex) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: codeSections[sectionIndex].codes.length - 1,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemBuilder: (context, codeIndex) {
                          if (codeIndex == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Text(
                                codeSections[sectionIndex].name,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                          return CodeCard(
                            code: codeSections[sectionIndex].codes[codeIndex],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            );
          }),
    );
  }
}
