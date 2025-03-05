import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_notes_flutter/common/my_button.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/feautures/notes/presentation/providers/notes_provider.dart';
import 'package:my_notes_flutter/feautures/notes/presentation/widgets/note_dialog.dart';

class NoNotes extends ConsumerWidget {
  const NoNotes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(LineIcons.stickyNoteAlt, size: 80, color: Colors.grey[400]),
        SizedBox(height: 16),
        MyText(
          'No recent notes found!',
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700]!,
        ),
        SizedBox(height: 8),
        MyText(
          maxLines: 2,
          'Start by adding your first note to keep track of your ideas.',
          fontSize: 16,
          color: Colors.grey[600]!,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        MyButton(
          fontSize: 14,
          buttonColor: AppColors.greenButtonColor,
          text: 'Create a Note',
          onPressed: () {
            showPlatformDialog(
              context: context,
              builder: (context) => AddEditNoteDialog(ref: ref, isEdit: false),
            );
            ref.invalidate(notesControllerProvider);
          },
        ),
      ],
    );
  }
}
