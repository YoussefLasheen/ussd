import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:ussd/models/code.dart';

class CodeCard extends StatelessWidget {
  final Code code;
  final bool isLiked;
  final VoidCallback onLike;
  const CodeCard(
      {super.key,
      required this.code,
      required this.isLiked,
      required this.onLike});

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
        title: Text(code.name),
        subtitle: Text(code.code),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.copy),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
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
            IconButton(
              icon: Icon(isLiked ? Icons.star : Icons.star_border_outlined),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () => onLike(),
            ),
          ],
        ),
        onTap: () => call(code.code),
      ),
    );
  }
}
