import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:ussd/models/code.dart';

class CodeCard extends StatelessWidget {
  final Code code;
  const CodeCard({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    Future<void> call(String number) async {
      bool? res = await FlutterPhoneDirectCaller.callNumber(number);
      if (res == null || !res) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("لم يتم الاتصال بالرقم"),
          ),
        );
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
            IconButton(
              icon: Icon(Icons.copy),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم نسخ الكود'),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.phone),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () => call(code.code),
            ),
          ],
        ),
        onTap: () => call(code.code),
      ),
    );
  }
}
