import 'package:aurabus/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class Termsandconditon extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Row
      (
        mainAxisAlignment: MainAxisAlignment.center,
        children: 
        [
          Checkbox(value: false, onChanged:(bool? value) {context.go(AppRoute.login);},),
          Text(
            "I Agree with privacy and policy",
            style:GoogleFonts.inter(fontSize: 13)
        )
        ],
      );

  }
}

