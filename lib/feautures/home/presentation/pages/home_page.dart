import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/feautures/home/presentation/pages/notes_page.dart';
import 'package:my_notes_flutter/feautures/home/presentation/widgets/no_notes_widget.dart';
import 'package:my_notes_flutter/feautures/home/presentation/widgets/profile_header.dart';
import 'package:my_notes_flutter/feautures/home/presentation/widgets/recent_note.dart';
import 'package:my_notes_flutter/feautures/home/presentation/widgets/tags_scroll.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:my_notes_flutter/feautures/home/presentation/providers/notes_provider.dart';
import 'package:my_notes_flutter/feautures/home/presentation/widgets/notes_list.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeader(),
              20.height,
              if (notesAsync.value != null && notesAsync.value!.isNotEmpty) ...[
                RecentNote(),
                20.height,
                TagsScroll(),
                20.height,
                Flexible(
                  child: notesAsync.when(
                    data:
                        (notes) => NotesList(
                          notes: notes,
                          ref: ref,
                          refreshController: refreshController,
                        ),
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
