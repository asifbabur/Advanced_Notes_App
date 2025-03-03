import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/feautures/notes/data/models/note.dart';
import 'package:my_notes_flutter/feautures/notes/presentation/providers/notes_provider.dart';

class AddEditNoteDialog extends StatelessWidget {
  final WidgetRef ref;
  final Note? note;
  final bool isEdit;

  const AddEditNoteDialog({required this.ref, this.note, required this.isEdit});

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(
      text: isEdit ? note?.title : '',
    );
    TextEditingController contentController = TextEditingController(
      text: isEdit ? note?.content : '',
    );

    return AlertDialog(
      title: MyText(isEdit ? 'Edit Note' : 'Add Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Enter title'),
          ),
          SizedBox(height: 8),
          TextField(
            controller: contentController,
            decoration: InputDecoration(hintText: 'Enter content'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final title = titleController.text;
            final content = contentController.text;
            if (title.isNotEmpty && content.isNotEmpty) {
              if (isEdit) {
                ref
                    .read(notesControllerProvider.notifier)
                    .updateNote(
                      Note(
                        id: note!.id,
                        title: title,
                        createdAt: DateTime.now(),
                        content: content,
                      ),
                    );
              } else {
                ref
                    .read(notesControllerProvider.notifier)
                    .addNote(
                      Note(
                        id: UniqueKey().toString(),
                        createdAt: DateTime.now(),
                        title: title,
                        content: content,
                      ),
                    );
              }
              Navigator.of(context).pop();
            }
          },
          child: MyText(isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
