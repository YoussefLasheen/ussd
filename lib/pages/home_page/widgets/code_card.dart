import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:ussd/models/code.dart';

class CodeCard extends StatelessWidget {
  final Code code;
  final bool isCustomCode;
  final Function(String)? onDeleteCustomCode;

  const CodeCard({
    super.key,
    required this.code,
    this.isCustomCode = false,
    this.onDeleteCustomCode,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> call(String number) async {
      bool? res = await FlutterPhoneDirectCaller.callNumber(number);
      if (res == null || !res) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("لم يتم الاتصال بالرقم"),
            ),
          );
        }
      }
    }

    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        title: Text(
          code.code,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.end,
        ),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        subtitle: Text(code.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCustomCode && onDeleteCustomCode != null)
              IconButton(
                iconSize: 28,
                icon: const Icon(Icons.delete_outline_outlined),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        title: const Text('حذف الكود'),
                        content: const Text('هل أنت متأكد من حذف هذا الكود؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () {
                              onDeleteCustomCode!(code.id);
                              Navigator.pop(context);
                            },
                            child: const Text('حذف'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code.code));
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم نسخ الكود'),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () => call(code.code),
            ),
          ],
        ),
        onTap: () => call(code.code),
      ),
    );
  }
}
