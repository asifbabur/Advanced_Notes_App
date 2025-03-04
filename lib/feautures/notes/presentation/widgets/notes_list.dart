import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/feautures/notes/data/models/note.dart';
import 'package:my_notes_flutter/feautures/notes/presentation/providers/notes_provider.dart';
import 'package:my_notes_flutter/feautures/notes/presentation/widgets/note_dialog.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class NotesList extends StatelessWidget {
  final List<Note> notes;
  final WidgetRef ref;
  final RefreshController refreshController;

  const NotesList({
    Key? key,
    required this.notes,
    required this.ref,
    required this.refreshController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: false,
      header: WaterDropHeader(),
      onRefresh: () async {
        ref.invalidate(notesControllerProvider);
        refreshController.refreshCompleted();
      },
      child: ListView.separated(
        physics:
            AlwaysScrollableScrollPhysics(), // ensures pull-to-refresh even with few items
        padding: const EdgeInsets.all(8),
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final colors = [
            Colors.teal.shade700,
            Colors.indigo.shade700,
            Colors.deepPurple.shade700,
            Colors.brown.shade700,
            Colors.blueGrey.shade700,
            Colors.deepOrange.shade700,
          ];
          return NoteCard(
            key: ValueKey(note.id),
            note: note,
            color: colors[index % colors.length],
            ref: ref,
          );
        },
      ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final Note note;
  final Color color;
  final WidgetRef ref;

  const NoteCard({
    Key? key,
    required this.note,
    required this.color,
    required this.ref,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      height: 175,
      child: Stack(
        children: [
          // Title (using ListTile for simplicity)
          ListTile(title: MyText(note.title)),
          // Tags: Displayed in a Wrap below the title. Adjust the top offset as needed.
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Wrap(
              spacing: 4.0,
              runSpacing: 2.0,
              children:
                  note.tags.map((tag) {
                    return Chip(
                      label: MyText(tag, fontSize: 12),
                      backgroundColor: Colors.white.withOpacity(0.8),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
            ),
          ),
          // Date at bottom left
          Positioned(
            bottom: 8,
            left: 16,
            child: MyText(
              DateFormat(
                'yyyy-MM-dd – kk:mm',
              ).format(note.createdAt ?? DateTime.now()),
              fontSize: 12,
            ),
          ),
          // Edit and Delete buttons at bottom right
          Positioned(
            bottom: 8,
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 16),
                  onPressed: () => _editNoteDialog(context, ref, note),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white, size: 16),
                  onPressed: () => _deleteNote(ref, note.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editNoteDialog(BuildContext context, WidgetRef ref, Note note) {
    showDialog(
      context: context,
      builder:
          (context) => AddEditNoteDialog(ref: ref, note: note, isEdit: true),
    );
  }

  void _deleteNote(WidgetRef ref, String noteId) {
    ref.read(notesControllerProvider.notifier).deleteNote(noteId);
  }
}
