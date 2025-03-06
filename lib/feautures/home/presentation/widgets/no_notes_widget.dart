import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_notes_flutter/common/my_button.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/feautures/home/presentation/pages/notes_page.dart';
import 'package:my_notes_flutter/feautures/home/presentation/providers/notes_provider.dart';

class NoNotes extends ConsumerWidget {
  const NoNotes({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          LineIcons.stickyNoteAlt,
          size: 80,
          color: Colors.yellowAccent[700],
        ),   
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
          size: Size(150, 45),
          buttonColor: AppColors.greenButtonColor,
          text: 'Create a Note',
          onPressed: () {
            context.push(
  AddEditNotePage.pagePath,
  extra: {'isEdit': false},
);
           
            ref.invalidate(notesControllerProvider);
          },
        ),
      ],
    );
  }
}
