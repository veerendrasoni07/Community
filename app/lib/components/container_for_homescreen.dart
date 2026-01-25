import 'package:codingera2/components/alert_dialog_warning.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContainerForHomescreen extends StatefulWidget {
  const ContainerForHomescreen({super.key});

  @override
  State<ContainerForHomescreen> createState() => _ContainerForHomescreenState();
}

class _ContainerForHomescreenState extends State<ContainerForHomescreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlinmentAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    );

    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        weight: 1,
      ),
    ]).animate(_controller);

    _bottomAlinmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomRight,
          end: Alignment.bottomLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.bottomLeft,
          end: Alignment.topLeft,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween<Alignment>(
          begin: Alignment.topRight,
          end: Alignment.bottomRight,
        ),
        weight: 1,
      ),
    ]).animate(_controller);

    _controller.repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose _
    _controller.dispose();
    super.dispose();
  }

  void onSave(Uri url) async{

    await launchUrl(
      url,
      mode: LaunchMode.inAppWebView,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Container(
                  height: 550,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 44, 181, 212),
                        Color.fromARGB(255, 14, 71, 128),
                      ],
                      begin: _topAlignmentAnimation.value,
                      end: _bottomAlinmentAnimation.value,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            height: 200,
                            width: 200,
                            "assets/images/coding era logo.jpg",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Text(
                        "Welcome to\nCoding Era!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Your gateway to exciting hackathon\nand tech news.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async{
                          showDialog(context: context, builder: (context){
                            return AlertDialogWarning(
                                title: Text("Do you really want to join community"),
                                content: Text("Tap Confirm To Join Community!"),
                                onSave:()=> onSave(Uri.parse(
                                    "https://chat.whatsapp.com/HXlBHOhjgnfGiZUOS2erAO"
                                ))
                            );
                          });
                        },
                        child: Container(
                          height: 60,
                          width: 300,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blueAccent, Colors.cyanAccent],
                              begin: _topAlignmentAnimation.value,
                              end: _bottomAlinmentAnimation.value,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "Join Our Community On Whatsapp",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap:(){showDialog(context: context, builder: (context){
                               return AlertDialogWarning(title: Text("Do Yoy Really Want To Open Instagram"), content: Text("Press Confirm To Open Instagram!"),onSave: ()=>onSave(Uri.parse("https://www.instagram.com/codingeracommunity/")),);
                             });
                            },
                            child: CircleAvatar(
                              backgroundColor: const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ),
                              radius: 30,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/images/instapng.png",
                                  fit: BoxFit.fill,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: (){
                              showDialog(context: context, builder: (context){
                                return AlertDialogWarning(title: Text("Do Yoy Really Want To Open Link-din"), content: Text("Press Confirm To Open Link-din!"),onSave: ()=>onSave(Uri.parse("https://www.linkedin.com/company/106917834/admin/dashboard/")),);
                              });
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 30,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/images/linkdinpng.webp",
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        SizedBox(height: 50),

        //HomeContent(),
      ],
    );
  }
}
