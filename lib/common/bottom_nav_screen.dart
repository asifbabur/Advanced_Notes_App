import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_notes_flutter/feautures/notes/presentation/pages/notes_page.dart';
import 'package:my_notes_flutter/feautures/profile/presentation/profile_screen.dart';

class MainScreen extends StatefulWidget {
  static const pagePath = '/main';

  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  // If you plan to call functions from NotesPage, convert it to a stateful widget with a GlobalKey.
  final GlobalKey<NotesPageState> notesPageKey = GlobalKey<NotesPageState>();

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      // Ensure your NotesPage is converted to a ConsumerStatefulWidget that provides a NotesPageState
      NotesPage(key: notesPageKey),
      const ProfileScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(systemNavigationBarColor: Colors.black87),
      child: Scaffold(
        body: SafeArea(child: _screens[_selectedIndex]),
        bottomNavigationBar: GNav(
          tabMargin: EdgeInsets.all(12),
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
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
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
    );
    // Optionally, add a floating action button in the middle of the nav bar if desired\n      // For instance, if you want an "Add Note" button:\n      // floatingActionButton: FloatingActionButton(\n      //   onPressed: () => notesPageKey.currentState?.addNewNote(),\n      //   child: Icon(Icons.add),\n      // ),\n      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,\n    );\n  }\n}\n```
  }
}
