import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Genericbutton extends StatelessWidget {

  final String textlabel;
  const Genericbutton( 
    {super.key,
    required this.textlabel,}
    );

  @override
  Widget build(BuildContext context) {
    return Container
    (
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      width: double.infinity,
      height: 45,
      child:TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          foregroundColor:Colors.black,
          backgroundColor: Colors.black,
          ),
        onPressed: () { },
        child: Text(
          textlabel,
            style:GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600,color: Colors.white ),
        ),
      )
    );
  }
}

