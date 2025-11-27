import 'package:flutter/material.dart';

class Googlebutton extends StatelessWidget {
  final double height;
  final double width;
  const Googlebutton({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      width: width,
      height: height,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.secondary,
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        onPressed: () {},
        icon: Image.asset(
          'assets/images/google_48x48.png',
          width: 20,
          height: 20,
        ),

        label: Text(
          "Google",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
