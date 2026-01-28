import 'dart:ui';
import 'package:codingera2/views/nav_screen/notes_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  double _rotateX = 0.0;
  double _rotateY = 0.0;
  double _scale = 1.0;

  double _nx = 0;
  double _ny = 0;


  void _reset() {
    setState(() {
      _rotateX = 0;
      _rotateY = 0;
      _scale = 1;
    });
  }
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
    return GestureDetector(
      onPanEnd: (_) => _reset(),
      onPanCancel: _reset,
      onPanUpdate: (details){
        final box = context.findRenderObject() as RenderBox;
        final local = box.globalToLocal(details.globalPosition);

        final dx = local.dx - box.size.width / 2;
        final dy = local.dy - box.size.height / 2;

        final nx = (dx / (box.size.width / 2)).clamp(-1.0, 1.0);
        final ny = (dy / (box.size.height / 2)).clamp(-1.0, 1.0);
        setState(() {
          _rotateY = nx * 0.18;     // controlled rotation
          _rotateX = -ny * 0.18;
          _scale = 1.05;
        });
      },
      child: TweenAnimationBuilder(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        builder: (context,s,child){
          return Transform(
            alignment: Alignment.center,
            transform:  Matrix4.identity()..setEntry(3, 2, 0.0006)..rotateX(_rotateX)..rotateY(_rotateY)..scale(_scale),
            child: child,
          );
        },
          child: Container(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(child: _navItem(Icon(Icons.home_outlined, size: 20,color: Colors.white,), Icon(Icons.home_rounded, size: 20,color: Colors.white,), 0,"Home")),
                        Expanded(child: _navItem(Icon(FontAwesomeIcons.noteSticky, size: 20,color: Colors.white,), Icon(FontAwesomeIcons.solidNoteSticky,size: 20,color: Colors.white,), 1,"Notes")),
                        Expanded(child: _navItem(Icon(Icons.person_2_outlined, size: 20,color: Colors.white,), Icon(Icons.person_4_rounded,color: Colors.white,size: 20), 2,"Profile")),
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
      ),
    );
  }

  Widget _navItem(Icon inactive, Icon activeIcon, int index,String title) {
    final isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 6),
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
          child:Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, anim) =>
                  FadeTransition(opacity: anim, child: child),
              child: isActive
                  ? Row(
                key: const ValueKey('active'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  activeIcon,
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
                  : inactive,
            ),)
      ),
    );
  }
}
