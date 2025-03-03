import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:my_notes_flutter/feautures/notes/presentation/providers/notes_provider.dart';
import 'package:my_notes_flutter/feautures/notes/data/models/note.dart';
import 'package:my_notes_flutter/feautures/notes/presentation/widgets/note_dialog.dart';
import 'package:my_notes_flutter/feautures/notes/presentation/widgets/notes_list.dart';

class NotesPage extends ConsumerWidget {
  static const pageName = 'notes';
  static const pagePath = '/notes';

  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesControllerProvider);
    final RefreshController refreshController = RefreshController(
      initialRefresh: false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('My Notes')),
      body: notesAsync.when(
        data:
            (notes) => NotesList(
              notes: notes,
              ref: ref,
              refreshController: refreshController,
            ),
        loading:
            () => const Center(child: CircularProgressIndicator.adaptive()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNoteDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNoteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AddEditNoteDialog(ref: ref, isEdit: false),
    );
  }
}
