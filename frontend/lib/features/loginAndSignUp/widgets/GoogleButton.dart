import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Googlebutton extends StatelessWidget {

  const Googlebutton( {super.key});

  @override
  Widget build(BuildContext context) {
    return Container
    (
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      width: 120,
      height: 40,
      child:OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor:Colors.blueGrey,
          backgroundColor: Colors.white,
          ),
        onPressed: () { },
        icon: Image.asset(
          'assets/google_48x48.png',
          width: 20,
          height: 20,
        ),

        label: Text(
          "Google",
            style:GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400,color: Colors.black ),
        ),
      ) 
    );
  }
}
