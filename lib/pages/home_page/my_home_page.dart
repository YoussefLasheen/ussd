import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ussd/custom_code_repository.dart';
import 'package:ussd/data.dart';
import 'package:ussd/flavors.dart';
import 'package:ussd/models/code.dart';
import 'package:ussd/pages/home_page/widgets/add_code_dialog.dart';
import 'package:ussd/pages/home_page/widgets/banners.dart';
import 'package:ussd/pages/home_page/widgets/code_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<AppResponse> future;
  late Future<List<Code>> customCodes;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Get custom codes
    customCodes = CustomCodeRepository().getCustomCodeSection();

    // Get API codes
    future = fetchData();
  }

  void _showAddCodeDialog() {
    showDialog(
      context: context,
      builder: (context) => AddCodeDialog(
        onAddCode: _addCustomCode,
      ),
    );
  }

  Future<void> _addCustomCode(Code code) async {
    final val = await CustomCodeRepository().addCustomCode(code);
    setState(() {
      customCodes = Future.value(val);
    });

    // Show confirmation to user
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة الكود بنجاح')),
      );
    }
  }

  Future<void> _deleteCustomCode(String id) async {
    final val = await CustomCodeRepository().deleteCustomCode(id);
    setState(() {
      customCodes = Future.value(val);
    });

    // Show confirmation to user
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حذف الكود بنجاح')),
      );
    }
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
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCodeDialog,
        backgroundColor: F.identity.color,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: Future.wait([future, customCodes]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'يرجي التأكد من الاتصال بالإنترنت لأول مره فقط',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _initializeData();
                      });
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          final appResponse = snapshot.data?.elementAt(0) as AppResponse;
          final customCodes = snapshot.data?.elementAt(1) as List<Code>;

          final children = <Widget>[
            const SizedBox(
              height: 25,
            ),
            if (appResponse.banners.isNotEmpty)
              Banners(
                banners: appResponse.banners,
              ),
          ];

          // Add custom codes section if available
          if (customCodes.isNotEmpty) {
            children.add(
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Text(
                  'اكوادي المخصصة',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );

            for (final code in customCodes) {
              children.add(CodeCard(
                code: code,
                isCustomCode: true,
                onDeleteCustomCode: _deleteCustomCode,
              ));
              children.add(
                const SizedBox(
                  height: 10,
                ),
              );
            }
          }

          // Add API code sections
          final codeSections = appResponse!.codeSections;
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
          children.add(SizedBox(
            height: 80 + MediaQuery.paddingOf(context).bottom,
          ));
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(children: children),
          );
        },
      ),
    );
  }
}
