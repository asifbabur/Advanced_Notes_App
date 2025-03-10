import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/feautures/home/data/models/note.dart';
import 'package:my_notes_flutter/feautures/home/presentation/pages/notes_page.dart';
import 'package:my_notes_flutter/feautures/home/presentation/providers/notes_provider.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final WidgetRef ref;

  const NoteCard({super.key, required this.note, required this.ref});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _editNote(context, ref, note),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greenButtonColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .15),
              blurRadius: 5,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  note.title,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                Spacer(),
                PopupMenuButton<String>(
                  borderRadius: BorderRadius.circular(33),
                  color: Colors.lightGreen.shade700,
                  padding: EdgeInsets.zero,
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editNote(context, ref, note);
                    } else if (value == 'delete') {
                      _deleteNote(ref, note.id);
                    } else if (value == 'share') {
                      _shareNote(ref, note.id);
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: MyText('Edit', fontWeight: FontWeight.w600),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: MyText('Delete', fontWeight: FontWeight.w600),
                        ),
                        const PopupMenuItem(
                          value: 'share',
                          child: MyText('Share', fontWeight: FontWeight.w600),
                        ),
                      ],
                  child: LineIcon(Icons.more_horiz),
                ),
              ],
            ),
            MyText(
              note.content.length > 50
                  ? '${note.content.substring(0, 50)}...'
                  : note.content,
              fontSize: 12,
              maxLines: 2,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            const SizedBox(height: 8),

            MyText(
              fontWeight: FontWeight.w400,
              DateFormat(
                'MMM dd, yyyy',
              ).format(note.createdAt ?? DateTime.now()),
              fontSize: 12,
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );
  }

  void _editNote(BuildContext context, WidgetRef ref, Note note) {
    context.push(
      AddEditNotePage.pagePath,
      extra: {'isEdit': true, 'note': note},
    );
  }

  void _deleteNote(WidgetRef ref, String noteId) {
    ref.read(notesControllerProvider.notifier).deleteNote(noteId);
  }

  void _shareNote(WidgetRef ref, String noteId) {
    ref.read(notesControllerProvider.notifier).deleteNote(noteId);
  }
}
