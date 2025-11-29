import 'package:aurabus/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class Googlebutton extends StatelessWidget {
  final VoidCallback? onPressed;

  const Googlebutton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          backgroundColor: Colors.white,
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        onPressed: onPressed ?? () {},
        icon: Image.asset(
          'assets/images/google_48x48.png',
          width: 24,
          height: 24,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.g_mobiledata, size: 30, color: Colors.blue),
        ),
        label: Text(
          AppLocalizations.of(context)!.signInWithGoogle,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
