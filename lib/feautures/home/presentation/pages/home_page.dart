import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/feautures/home/presentation/pages/notes_page.dart';
import 'package:my_notes_flutter/feautures/home/presentation/widgets/no_notes_widget.dart';
import 'package:my_notes_flutter/feautures/home/presentation/widgets/profile_header.dart';

import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:my_notes_flutter/feautures/home/presentation/providers/notes_provider.dart';
import 'package:my_notes_flutter/feautures/home/presentation/widgets/notes_list.dart';
import 'package:searchfield/searchfield.dart';

class HomePage extends ConsumerStatefulWidget {
  static const pageName = 'notes';
  static const pagePath = '/notes';

  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  void addNewNote() {
    context.push(AddEditNotePage.pagePath, extra: {'isEdit': false});
  }

  @override
  Widget build(BuildContext context) {
    final notesAsync = ref.watch(notesControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeader(),
              20.height,
              SearchField(
                hint: 'Search',
                suggestions: [SearchFieldListItem('Search')],
                searchInputDecoration: SearchInputDecoration(
                  prefixIcon: Icon(LineIcons.search),
                  hintStyle: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  contentPadding: EdgeInsets.all(2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.yellow, width: 2),
                  ),
                ),
              ),
              20.height,
              if (notesAsync.value != null && notesAsync.value!.isNotEmpty) ...[
                Flexible(
                  child: notesAsync.when(
                    data: (notes) => NotesPage(),
                    loading:
                        () => const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                    error: (err, _) => Center(child: Text('Error: $err')),
                  ),
                ),
              ] else
                Expanded(child: NoNotes()),
            ],
          ),
        ),
      ),
    );
  }
}
