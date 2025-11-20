import 'package:aurabus/features/loginAndSignUp/widgets/ClickableText.dart';
import 'package:aurabus/features/loginAndSignUp/widgets/GenericButton.dart';
import 'package:aurabus/features/loginAndSignUp/widgets/GoogleButton.dart';
import 'package:aurabus/features/loginAndSignUp/widgets/TermsAndConditon.dart';
import 'package:aurabus/features/loginAndSignUp/widgets/text_field.dart';
import 'package:aurabus/routing/router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {

  const SignupPage({super.key});
  @override
  State<StatefulWidget> createState()   => _SignupPageState();

}

class _SignupPageState extends State<SignupPage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromARGB(255, 242, 242, 242),
          body: Stack(
            children: 
            [
              SingleChildScrollView(
              child:Center(
                child:Container(
                  margin: EdgeInsets.only(top:40),
                  child: Column
                  (
                  children:[ 
                    Text("AURABUS",style:GoogleFonts.ubuntu(fontSize: 30, fontWeight: FontWeight.bold ),),
                    Text("SignUp",style:GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w300 ,color: Colors.grey ),),
                    SizedBox(height: 50-27),

                    Row(children:[
                      Expanded(child: Textfield(textlabel: 'FIRST NAME' ,marginRight:false,)),
                      Expanded(child: Textfield(textlabel: 'LAST NAME'  ,marginLeft:false,)),

                      ]),
                    Textfield(textlabel: 'EMAIL'),
                    Textfield(textlabel: 'PASSWORD', obscuretext:true),
                    Textfield(textlabel: 'CONFIRM PASSWORD', obscuretext:true),

                    Termsandconditon(),

                    Genericbutton(textlabel: 'Sign-Up'),
                    Googlebutton(),
                    ]
                    )
                  )
                ),
              ),
              Align(
                    alignment: Alignment.bottomCenter,
                    child: (Clickabletext(textlabel: "Do you already have an account? Log in", fun: () => context.go(AppRoute.login)))
                  )
            ]
          )
          
          
        );
  }
}


