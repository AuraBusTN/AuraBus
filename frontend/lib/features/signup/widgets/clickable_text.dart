import 'package:flutter/material.dart';

class Clickabletext extends StatelessWidget {
  final String textlabel;
  final VoidCallback fun;
  const Clickabletext({super.key, required this.textlabel, required this.fun});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: GestureDetector(
        onTap: fun,
        child: Text(
          textlabel,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
