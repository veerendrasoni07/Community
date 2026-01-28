import 'package:codingera2/components/alert_dialog_warning.dart';
import 'package:codingera2/components/home_content.dart';
import 'package:codingera2/components/inside_app_button.dart';
import 'package:codingera2/controllers/auth_controller.dart';
import 'package:codingera2/views/admin/screens/admin_home_screen.dart';
import 'package:codingera2/views/admin/widgets/admin_club.dart';
import 'package:codingera2/views/admin/widgets/admin_hackathon.dart';
import 'package:codingera2/views/admin/widgets/admin_upload_banner.dart';
import 'package:codingera2/views/admin/widgets/admin_upload_notes.dart';
import 'package:codingera2/views/nav_screen/club_screen.dart';
import 'package:codingera2/views/nav_screen/hackathon_screen.dart';
import 'package:codingera2/views/screens/quiz/quiz_first_page.dart';
import 'package:codingera2/views/widgets/banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';


import '../../provider/user_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin{
  final AuthController _authController = AuthController();

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Length is the number of tabs you want
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void logOut(){
    showDialog(context: context, builder: (context){
      return AlertDialogWarning(title: Text("Do You Really Want To LogOut?"), content: Text("Press Confirm To LogOut!"), onSave: (){
        //_authController.signOutUser(context: context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final role = user?.role == null ? "user": user!.role;
    return Scaffold(
      extendBody: true,
      appBar:  AppBar(
      toolbarHeight: 64,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(35),
        ),
      ),
      title:  Text(
        "Coding Era",
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.white,
          letterSpacing: 2,
        ),
      ),
      clipBehavior: Clip.hardEdge,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorSize:  TabBarIndicatorSize.tab,
              indicatorColor: Colors.white,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.white70,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow:  [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ]
              ),
              tabs: const [
                Tab(icon: Icon(FontAwesomeIcons.house, size: 16), text: "Home"),
                Tab(icon: Icon(FontAwesomeIcons.code, size: 16), text: "Hackathon"),
                Tab(icon: Icon(FontAwesomeIcons.users, size: 16), text: "Club"),
              ],
            ),
          ),
        ),
      ),
    ),

      extendBodyBehindAppBar: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        children: [

          // TabBarView takes the remaining space in the Column
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                role == "admin" ? AdminHomeScreen() : _homeScreen(),
                const HackathonScreen(),
                const ClubScreen()
              ],
            ),
          )
        ],
      ),
      floatingActionButton: role == "admin" ?
          Padding(
            padding:  EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.12),
            child: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              direction: SpeedDialDirection.up,
              icon: Icons.upload_rounded,
              activeIcon: Icons.upload_rounded,
              elevation: 8.0,
              activeChild: Icon(Icons.upload_rounded),
              closeManually: false,
              spaceBetweenChildren: 12,
              overlayColor: Colors.black,
              animatedIconTheme: const IconThemeData(size: 22.0),
              backgroundColor: Colors.blue,
              visible: true,
              curve: Curves.bounceIn,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.image),
                  backgroundColor: Colors.blue,
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>AdminUploadBanner())),
                  label: 'Upload Banner',
                ),
                SpeedDialChild(
                  child: const Icon(Icons.code),
                  backgroundColor: Colors.blue,
                  onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>AdminHackathon())),
                  label: 'Upload Hackathon',
                ),
                SpeedDialChild(
                  child: const Icon(Icons.people),
                  backgroundColor: Colors.blue,
                  onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (_)=>AdminClub())),
                  label: 'Upload Club',
                ),
                SpeedDialChild(
                  child: const Icon(Icons.person),
                  backgroundColor: Colors.blue,
                  onTap: ()=> Navigator.push(context,MaterialPageRoute(builder: (_)=>AdminNotes())),
                  label: 'Upload Notes',
                )
              ]
            ),
          )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }





  Widget _homeScreen(){
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          children: [
            _todayQuiz(),
            // _yourStats(),
            _ongoingEvents(),
            // leaderBoardPreview()
            HomeContent()
          ],
        ),
      ),
    );
  }


  Widget _todayQuiz(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.5)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🔥 Today’s Challenge",
              style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),
          SizedBox(height: 8),
          Text("DSA Daily Quiz",
              style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white)),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>QuizFirstPage())),
            child: Text("Start Now"),
          )
        ],
      ),
    );
  }
  
  
  Widget _yourStats(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text("Your Stats",style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.white.withValues(alpha: 0.8,),
          ),),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _stats("🔥 Streak", "5 days",[Colors.pink.shade100, Colors.deepPurple.shade100]),
            _stats("⭐ Points", "120",[Colors.yellow.shade100, Colors.amber.shade100]),
            _stats("🏆 Rank", "#12",[Colors.green.shade100, Colors.teal.shade100]),

          ],
        ),
      ],
    );
  }
  
  Widget _stats(String text,String iconWithText,List<Color> gradientColors){
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100,
            blurRadius: 4,
          )
        ]

      ),
      child: Column(
        children: [
          Text(text),
          Text(iconWithText),
        ],
      ),
    );
  }

  Widget _ongoingEvents(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left:12.0),
          child: Text("Ongoing Events",style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha: 0.8,),
            letterSpacing: 2
          ),),
        ),
        BannerWidget(),
      ],
    );
  }

  Widget leaderBoardPreview(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Text("Leader Board",style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha: 0.8)
          ),),
        ),
        ListView.builder(
          itemCount: 5,
            shrinkWrap:  true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(8),
            itemBuilder: (context,index){
         return _leaderBoardPersonTile();
        }),


      ],
    );
  }

  Widget _leaderBoardPersonTile(){
    return Container(

      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.white.withValues(alpha: 0.2), Colors.white.withValues(alpha: 0.5)],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 35,
          ),
          Text("Name Name",style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),),
          TextButton(
              onPressed: (){},
              child: Text("View",style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),)
          )
        ],
      )
    );
  }

  _adminHomeWidget(){
    return Column(
      children: [
        Text("Admin Home"),
      ],
    );
  }


}
