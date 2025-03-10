import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:my_notes_flutter/common/my_button.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/common/my_textformfield.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/feautures/home/data/models/note.dart';
import 'package:my_notes_flutter/feautures/home/presentation/providers/notes_provider.dart';

class AddEditNotePage extends ConsumerStatefulWidget {
  static const pageName = 'notes';
  static const pagePath = '/notes';
  final Note? note;
  final bool isEdit;

  const AddEditNotePage({super.key, this.note, required this.isEdit});

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends ConsumerState<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController contentController;
  final TextEditingController tagController = TextEditingController();
  List<String> tags = [];
  String selectedCategory = categories.first;

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
      selectedCategory =
          widget.note!.category.isNotEmpty
              ? widget.note!.category
              : categories.first;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = tagController.text.trim();
    if (tag.isEmpty || tags.contains(tag)) return;
    setState(() {
      tags.add(tag);
    });
    tagController.clear();
  }

  void _removeTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      if (tags.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one tag.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final title = titleController.text.trim();
      final content = contentController.text.trim();

      if (widget.isEdit) {
        ref
            .read(notesControllerProvider.notifier)
            .updateNote(
              Note(
                id: widget.note!.id,
                title: title,
                content: content,
                createdAt: DateTime.now(),
                tags: tags,
                category: selectedCategory,
              ),
            );
      } else {
        ref
            .read(notesControllerProvider.notifier)
            .addNote(
              Note(
                id: UniqueKey().toString(),
                title: title,
                content: content,
                createdAt: DateTime.now(),
                tags: tags,
                category: selectedCategory,
              ),
            );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MyText(
          widget.isEdit ? 'Edit Note' : 'Add Note',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MyTextFormField(
                fillColor: Colors.grey.shade300,
                hintText: 'Enter title',
                controller: titleController,
                validator:
                    (value) =>
                        value!.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 12),
              MyTextFormField(
                fillColor: Colors.grey.shade300,

                hintText: 'Enter content',
                maxLines: 5,
                controller: contentController,
                validator:
                    (value) =>
                        value!.trim().isEmpty ? 'Content is required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  labelText: 'Category',
                  labelStyle: GoogleFonts.openSans(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                items:
                    categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: MyText(category, fontWeight: FontWeight.w600),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 12),
              MyText('Tags', fontSize: 16, fontWeight: FontWeight.w600),
              Wrap(
                spacing: 8.0,
                children:
                    tags
                        .map(
                          (tag) => Chip(
                            label: MyText(tag),
                            onDeleted: () => _removeTag(tag),
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: MyTextFormField(
                      fillColor: Colors.grey.shade300,

                      hintText: 'Enter a tag',
                      controller: tagController,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      LineIcons.plusCircle,
                      size: 28,
                      color: Colors.blue,
                    ),
                    onPressed: _addTag,
                  ),
                ],
              ),
              const Spacer(),
              MyButton(
                text: widget.isEdit ? 'Update' : 'Add',
                onPressed: _saveNote,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
