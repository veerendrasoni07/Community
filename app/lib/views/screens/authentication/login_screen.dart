
import 'dart:math';

import 'package:codingera2/services/manage_http_request.dart';
import 'package:codingera2/views/screens/authentication/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pinput/pinput.dart';
import '../../../components/container_button.dart';
import '../../../controllers/auth_controller.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';


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
          child: ContainerButton(height: 50, width: MediaQuery.of(context).size.width*0.75, text: "Login"),
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
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;
  bool isEnable = false;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();


  }


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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
    pinController.dispose();
    focusNode.dispose();
    formKey.currentState!.dispose();
    emailController.dispose();
    passController1.dispose();
    passController2.dispose();
    controller.dispose();
  }



  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text("Please Enter Your Registered Email!",style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),),
                    ),
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("OTP Is Sent To Your Registered Email!",style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                      Directionality(
                        // Specify direction if desired
                        textDirection: TextDirection.ltr,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Pinput(
                            controller: pinController,
                            focusNode: focusNode,
                            length: 6,
                            defaultPinTheme: defaultPinTheme,
                            separatorBuilder: (index) => const SizedBox(width: 8),
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            onCompleted: (pin) async{
                              showDialog(context: context, builder: (context){
                                return Center(child: CircularProgressIndicator(color: Colors.white,),);
                              });
                              await AuthController().verifyOTP(emailController.text, int.parse(pin) );
                              Navigator.pop(context);
                              nextPage();
                            },
                            onChanged: (value) {
                              debugPrint('onChanged: $value');
                            },
                            cursor: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 9),
                                  width: 22,
                                  height: 1,
                                  color: focusedBorderColor,
                                ),
                              ],
                            ),
                            focusedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: focusedBorderColor),
                              ),
                            ),
                            submittedPinTheme: defaultPinTheme.copyWith(
                              decoration: defaultPinTheme.decoration!.copyWith(
                                color: fillColor,
                                borderRadius: BorderRadius.circular(19),
                                border: Border.all(color: focusedBorderColor),
                              ),
                            ),
                            errorPinTheme: defaultPinTheme.copyBorderWith(
                              border: Border.all(color: Colors.redAccent),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Didn't receive OTP?",style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),),
                          SizedBox(width: 5,),
                          OtpTimerButton(
                              onPressed: ()async{
                                showDialog(context: context, builder: (context){
                                  return Center(child: CircularProgressIndicator(color: Colors.white,),);
                                });
                                await AuthController().getOTP(emailController.text, context);
                                Navigator.pop(context);
                              },
                              backgroundColor: Colors.green,
                              text: Text("Resend OTP",style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              )),
                              loadingIndicator: CircularProgressIndicator(color: Colors.grey,),
                              duration: 60
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),



                      // Padding(
                      //   padding: const EdgeInsets.all(12.0),
                      //   child: TextFormField(
                      //     controller: controller,
                      //     cursorColor: Colors.white,
                      //     validator: (value)=> value == null || value.isEmpty
                      //         ? "Please confirm your password"
                      //         : null,
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 16,
                      //     ),
                      //     decoration: InputDecoration(
                      //         hintText: "Enter OTP here",
                      //         hintStyle: TextStyle(
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 16,
                      //         ),
                      //         prefixIcon: Icon(Icons.email),
                      //         prefixIconColor: Colors.blue,
                      //         filled: true,
                      //         fillColor: Colors.grey.shade900,
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //           gapPadding: 10,
                      //         )
                      //     ),
                      //   ),
                      // ),

                    ]
                ),
              ),
              SingleChildScrollView(
                child: Form(
                  key: _formKeys[2],
                  child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text("Please Enter Your New Password!",style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
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
                            obscureText: isEnable ? true : false ,
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
                                }, icon: Icon(isEnable==true ? Icons.visibility_off : Icons.remove_red_eye)),
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
                                showSnackBar(context, "Password does not match", "Please confirm your password", ContentType.failure);
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

