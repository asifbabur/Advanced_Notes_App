import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/feautures/notes/data/models/note.dart';
import 'package:my_notes_flutter/feautures/notes/presentation/providers/notes_provider.dart';

class AddEditNoteDialog extends StatefulWidget {
  final WidgetRef ref;
  final Note? note;
  final bool isEdit;

  const AddEditNoteDialog({
    required this.ref,
    this.note,
    required this.isEdit,
    Key? key,
  }) : super(key: key);

  @override
  _AddEditNoteDialogState createState() => _AddEditNoteDialogState();
}

class _AddEditNoteDialogState extends State<AddEditNoteDialog> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  final TextEditingController tagController = TextEditingController();
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(
      text: widget.isEdit ? widget.note?.title : '',
    );
    contentController = TextEditingController(
      text: widget.isEdit ? widget.note?.content : '',
    );
    if (widget.isEdit && widget.note != null) {
      tags = List.from(widget.note!.tags);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    tagController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    final trimmed = tag.trim();
    if (trimmed.isEmpty) return;
    if (tags.length < 3 && !tags.contains(trimmed)) {
      setState(() {
        tags.add(trimmed);
      });
      tagController.clear();
    }
  }

  void _removeTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: MyText(
        widget.isEdit ? 'Edit Note' : 'Add Note',
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter title',
                border: OutlineInputBorder(),
              ),
            ),
            8.height,
            TextField(
              controller: contentController,
              decoration: const InputDecoration(
                hintText: 'Enter content',
                border: OutlineInputBorder(),
              ),
            ),
            8.height,
            Align(
              alignment: Alignment.centerLeft,
              child: MyText('Tags', fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 4),
            // Wrap to display added tags as chips
            Wrap(
              spacing: 8.0,
              children:
                  tags
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          onDeleted: () => _removeTag(tag),
                        ),
                      )
                      .toList(),
            ),
            // Display the tag input field only if less than 3 tags are added
            if (tags.length < 3)
              TextField(
                controller: tagController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 12),
                  border: OutlineInputBorder(),
                  hintText: 'Enter a tag',
                  suffix: IconButton(
                    onPressed: () {
                      _addTag(tagController.text);
                    },
                    icon: Icon(Icons.add_circle),
                  ),
                ),
                onSubmitted: _addTag,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final title = titleController.text.trim();
            final content = contentController.text.trim();
            if (title.isNotEmpty && content.isNotEmpty) {
              if (widget.isEdit) {
                widget.ref
                    .read(notesControllerProvider.notifier)
                    .updateNote(
                      Note(
                        id: widget.note!.id,
                        title: title,
                        content: content,
                        createdAt: DateTime.now(),
                        tags: tags,
                      ),
                    );
              } else {
                widget.ref
                    .read(notesControllerProvider.notifier)
                    .addNote(
                      Note(
                        id: UniqueKey().toString(),
                        title: title,
                        content: content,
                        createdAt: DateTime.now(),
                        tags: tags,
                      ),
                    );
              }
              Navigator.of(context).pop();
            }
          },
          child: MyText(
            widget.isEdit ? 'Update' : 'Add',
            color: AppColors.primaryBlueColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
