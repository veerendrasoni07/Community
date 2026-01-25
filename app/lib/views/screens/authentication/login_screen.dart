
import 'package:codingera2/services/manage_http_request.dart';
import 'package:codingera2/views/screens/authentication/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../components/container_button.dart';
import '../../../controllers/auth_controller.dart';


class LoginScreen extends ConsumerStatefulWidget {

  const LoginScreen({super.key});

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
              style: GoogleFonts.lato(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                  letterSpacing: 1.5
              ),
            ),
            Text("To explore the world exclusive",
              style: GoogleFonts.lato(
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
                  Icon(Icons.email,size: 20),
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
                  Icon(Icons.lock,size: 20,),
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
                  TextButton(onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePasswordFlow())), child: Text(
                    "Forgot password?",
                    style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ))
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
              showDialog(context: context, builder: (context){
                return Center(child: CircularProgressIndicator(color: Colors.white,),);
              });
              _authController.login(
                  context: context,
                  email: email,
                  password: password,
                  ref: ref
              );
              if(context.mounted){
                Navigator.pop(context);
              }
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>SignUpFlow())
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

class ChangePasswordFlow extends StatefulWidget {
  const ChangePasswordFlow({super.key});

  @override
  State<ChangePasswordFlow> createState() => _ChangePasswordFlowState();
}

class _ChangePasswordFlowState extends State<ChangePasswordFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(), // email
    GlobalKey<FormState>(), // otp
    GlobalKey<FormState>(), // password
  ];
  TextEditingController passController1 = TextEditingController();
  TextEditingController passController2 = TextEditingController();
  TextEditingController controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isEnable = false;

  void nextPage(){
    if(_currentPage < 2){
      setState(() => _currentPage++);
      _pageController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    }
  }
  void previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 15,
              color: Colors.black),
          onPressed: () => {
            _currentPage > 0 ? previousPage() : Navigator.pop(context)
          },
        )

      ),
      body: SafeArea(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Form(
                key: _formKeys[0],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        controller: emailController,
                        cursorColor: Colors.white,
                        validator: (value)=> value == null || value.isEmpty
                            ? "Please enter registered email"
                            : null,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                            hintText: "Enter registered email",
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            prefixIcon: Icon(Icons.email),
                            prefixIconColor: Colors.blue,
                            filled: true,
                            fillColor: Colors.grey.shade900,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              gapPadding: 10,
                            )
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: ()async{
                        if(_formKeys[0].currentState!.validate()){
                          showDialog(context: context, builder: (context){
                            return Center(child: CircularProgressIndicator(color: Colors.white,),);
                          });
                          await AuthController().getOTP(emailController.text, context);
                          Navigator.pop(context);
                          nextPage();
                        }
                      },
                      child: Text("Next"),
                    )
                  ],
                ),
              ) ,
              Form(
                key: _formKeys[1],
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          controller: controller,
                          cursorColor: Colors.white,
                          validator: (value)=> value == null || value.isEmpty
                              ? "Please confirm your password"
                              : null,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                              hintText: "Enter OTP here",
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(Icons.email),
                              prefixIconColor: Colors.blue,
                              filled: true,
                              fillColor: Colors.grey.shade900,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                gapPadding: 10,
                              )
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: ()async{
                          if(_formKeys[1].currentState!.validate()){
                            showDialog(context: context, builder: (context){
                              return Center(child: CircularProgressIndicator(color: Colors.white,),);
                            });
                            await AuthController().verifyOTP(emailController.text, int.parse(controller.text));
                            Navigator.pop(context);
                            nextPage();
                          }
                        },
                        child: Text("Submit"),
                      )
                    ]
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKeys[2],
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            controller: passController1,
                            cursorColor: Colors.white,
                            validator: (value) =>
                            value == null || value.isEmpty
                                ? "Please confirm your password"
                                : null,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                                hintText: "Enter new password",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(Icons.lock),
                                prefixIconColor: Colors.blue,
                                filled: true,
                                fillColor: Colors.grey.shade900,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  gapPadding: 10,
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            controller: passController2,
                            validator: (value) =>
                            value == null || value.isEmpty
                                ? "Please enter new password"
                                : null,
                            cursorColor: Colors.white,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                                hintText: "Confirm new password",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(Icons.lock),
                                prefixIconColor: Colors.blue,
                                filled: true,
                                fillColor: Colors.grey.shade900,
                                suffixIcon: IconButton(onPressed: (){
                                  setState(() {
                                    isEnable = !isEnable;
                                  });
                                }, icon: Icon(isEnable==true ? Icons.remove_red_eye_outlined : Icons.remove_red_eye)),
                                suffixIconColor: Colors.blue,
                                suffixStyle: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  gapPadding: 10,
                                )
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.all(12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                            shadowColor: Colors.black,
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16
                            ),
                            minimumSize: Size(200, 50),
                            maximumSize: Size(200, 50),
                            fixedSize: Size(200, 50),
                            side: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                            surfaceTintColor: Colors.blue,
                            foregroundColor: Colors.blue,
                            splashFactory: InkSplash.splashFactory,
                          ),
                          onPressed: ()async{
                            bool isValid = _formKeys[2].currentState!.validate();

                            if (isValid) {
                              if (passController1.text != passController2.text) {
                                showSnackBar(context, "Passwords do not match");
                              } else {
                                showDialog(context: context, builder: (context){
                                  return Center(child: CircularProgressIndicator(color: Colors.white,),);
                                });
                                await AuthController().resetPassword(
                                  email: emailController.text,
                                  password: passController1.text,
                                  context: context,
                                );
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                }
                              }
                            }
                            },
                          child: Text("Confirm",style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),),
                        )
                      ]
                  ),
                ),
              )
            ]
          )
      )
    );
  }
}

