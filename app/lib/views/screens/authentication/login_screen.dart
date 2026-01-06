
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';


import '../../../components/container_button.dart';
import '../../../components/text_fields.dart';
import '../../../controllers/auth_controller.dart';
import 'register_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {

  LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final AuthController _authController = AuthController();

  late String email;
  late String password;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool isEnable = false;

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: _form()),
            _bottomButton()
          ],
        ),
      ),
    );
  }
  Widget _form(){
    return SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.1,),
            Text(
              "Login Your Account!",
              style: GoogleFonts.getFont(
                  "Lato",
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  letterSpacing: 1.5
              ),
            ),
            Text("To explore the world exclusive",
              style: GoogleFonts.getFont(
                  "Lato",
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 1.5
              ),
            ),
            SizedBox(height: 20,),
            Lottie.asset(
                'assets/animations/loginanimation.json',
                width: 200,
                height: 200,
                fit: BoxFit.cover
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
              child: Row(
                children: [
                  Image.asset("assets/icons/email-icon.jpg",height: 25,width: 25,fit: BoxFit.fill,),
                  SizedBox(width: 10,),

                  Text("email",
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                onChanged: (value)=>{
                  email = value
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your email";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  hintText: "Enter the email here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 5.0),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.lock,size: 20,),
                  SizedBox(width: 10,),
                  Text("Password",
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextFormField(
                onChanged: (value)=>{
                  password = value
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter your password";
                  } else {
                    return null;
                  }
                },
                obscureText: isEnable, // This hides or shows the password
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      isEnable ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                    ),
                    onPressed: () {
                      setState(() {
                        isEnable = !isEnable;
                      });
                    },
                  ),
                  hintText: "Enter the password here...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Forgot password?",
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _bottomButton(){
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            if(_formkey.currentState!.validate()){
              _authController.login(
                  context: context,
                  email: email,
                  password: password,
                  ref: ref
              );
            }
          },
          child: ContainerButton(height: 60, width: 350, text: "Log-in"),
        ),
        SizedBox(height: 10,),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Need an account?",style:GoogleFonts.roboto(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),),
            SizedBox(width: 10,),

            GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context)=>RegisterScreen())
                );
              },
              child: Text("Sign-up",
                style:GoogleFonts.roboto(
                    color: Colors.lightBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),),
            ),
          ],
        ),
      ],
    );
  }
}
