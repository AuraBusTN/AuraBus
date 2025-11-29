import 'package:flutter/material.dart';

class Genericbutton extends StatelessWidget {
  final String textlabel;
  final VoidCallback? onPressed;

  const Genericbutton({super.key, required this.textlabel, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.4),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed ?? () {},
        child: Text(
          textlabel,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
