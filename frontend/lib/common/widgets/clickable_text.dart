import 'package:flutter/material.dart';

class ClickableText extends StatelessWidget {
  final String textLabel;
  final VoidCallback fun;
  const ClickableText({super.key, required this.textLabel, required this.fun});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(7),
      child: GestureDetector(
        onTap: fun,
        child: Text(
          textLabel,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
