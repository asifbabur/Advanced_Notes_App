import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/feautures/home/presentation/pages/notes_page.dart';

class MainScreen extends StatelessWidget {
  static const pagePath = '/main';
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  void _onAddButtonPressed(BuildContext context) {
    context.push(AddEditNotePage.pagePath, extra: {'isEdit': false});
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(systemNavigationBarColor: Colors.black87),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Scaffold(
            body: navigationShell, // This maintains state across tabs
            bottomNavigationBar: GNav(
              tabMargin: const EdgeInsets.all(12),
              backgroundColor: Colors.black87,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              rippleColor: Colors.grey.shade300,
              hoverColor: Colors.grey.shade100,
              haptic: true,
              tabBorderRadius: 30,
              curve: Curves.easeOutExpo,
              duration: const Duration(milliseconds: 300),
              gap: 8,
              color: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              selectedIndex: navigationShell.currentIndex,
              onTabChange: (index) => navigationShell.goBranch(index),
              tabs: [
                GButton(
                  icon: LineIcons.stickyNote,
                  text: 'Notes',
                  iconActiveColor: Colors.yellow.shade800,
                  backgroundColor: Colors.yellow.shade100,
                  textStyle: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                  iconActiveColor: Colors.green.shade800,
                  backgroundColor: Colors.green.shade100,
                  textStyle: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (navigationShell.currentIndex == 0)
            Positioned(
              bottom: 50,
              child: FloatingActionButton(
                mini: true,
                clipBehavior: Clip.antiAlias,
                onPressed: () => _onAddButtonPressed(context),
                backgroundColor: AppColors.greenButtonColor,
                elevation: 1,
                shape: const CircleBorder(eccentricity: .32),
                child: const Icon(
                  LineIcons.folderPlus,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
