import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/feautures/home/data/models/note.dart';
import 'package:my_notes_flutter/feautures/home/presentation/pages/notes_page.dart';
import 'package:my_notes_flutter/feautures/home/presentation/providers/notes_provider.dart';
import 'package:my_notes_flutter/feautures/notifications/presentation/providers/notification_provider.dart';

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
          color: note.isOwner ? AppColors.greenButtonColor : Colors.amberAccent,
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
                      _shareNote(ref, note, context);
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

  void _shareNote(WidgetRef ref, Note note, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController emailController = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Share Note',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final email = emailController.text;
                if (email.isNotEmpty) {
                  ref
                      .read(notesControllerProvider.notifier)
                      .shareNote(note, email);

                  // Save notification in Firestore
                  ref
                      .read(notificationRepositoryProvider)
                      .saveNotificationToFirestore(note.title, note.id);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email invitation has been sent')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenButtonColor,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Share',
                style: GoogleFonts.openSans(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
