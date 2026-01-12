import 'package:flutter/material.dart';

class AdminNotes extends StatefulWidget {
  const AdminNotes({super.key});

  @override
  State<AdminNotes> createState() => _AdminQuizState();
}

class _AdminQuizState extends State<AdminNotes> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          GestureDetector(
            onTap: (){},
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)
              ),
              child: const Center(
                child: Text("Tap To Upload Notes PDF"),
              ),
            ),
          ),
          const SizedBox(height: 20,),
        ],
      )
    );
  }
}
