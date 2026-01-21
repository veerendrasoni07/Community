import 'dart:ui';

import 'package:codingera2/provider/auth_manager_provider.dart';
import 'package:codingera2/views/nav_screen/club_screen.dart';
import 'package:codingera2/views/nav_screen/hackathon_screen.dart';
import 'package:codingera2/views/nav_screen/notes_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../provider/user_provider.dart';
import '../nav_screen/home_screen.dart';
import '../nav_screen/profile/profile_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late final PageController _controller;
  int _selectedIndex = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController(initialPage: _selectedIndex);

  }

  void onPageChanged(int index){
    if(_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }
  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    _controller.jumpToPage(index);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: PageView(
        controller: _controller,
        onPageChanged: onPageChanged,
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          const HomeScreen(),
          const NotesScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: SafeArea(
          top: false,
          child: _buildGlassNavBar()
      )
    );
  }
  Widget _buildGlassNavBar() {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.10),
            Colors.white.withOpacity(0.04)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            //Frosted Blur
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: const SizedBox(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icon(FontAwesomeIcons.houseCrack, size: 20,color: Colors.white,), Icon(FontAwesomeIcons.house, size: 20,color: Colors.white,), 0),
                  _navItem(Icon(FontAwesomeIcons.noteSticky, size: 20,color: Colors.white,), Icon(FontAwesomeIcons.peopleGroup,size: 20,color: Colors.white,), 1),
                  _navItem(Icon(FontAwesomeIcons.personFalling, size: 20,color: Colors.white,), Icon(FontAwesomeIcons.person,color: Colors.white,size: 20), 2),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget _navItem(Icon inactive, Icon activeIcon, int index) {
    final isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
          width: isActive ? 100 : 50,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: isActive ? 10 : 0),
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 10,
              )
            ]

          ),
          duration: const Duration(milliseconds: 350),
          child: isActive ? activeIcon : inactive
      ),
    );
  }
}
