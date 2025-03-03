import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/feautures/notes/domain/repositories/notes_repo_impl.dart';
import 'package:my_notes_flutter/feautures/notes/data/models/note.dart';
import 'package:my_notes_flutter/feautures/notes/presentation/providers/notes_provider.dart';

class NotesPage extends ConsumerWidget {
  static const pageName = 'notes';
  static const pagePath = '/notes';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text('My Notes')),
      body: notesAsync.when(
        data:
            (notes) => ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Card(
                  child: ListTile(
                    title: Text(note.content),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editNote(context, ref, note),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteNote(ref, note.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNote(context, ref),
        child: Icon(Icons.add),
      ),
    );
  }

  void _addNote(BuildContext context, WidgetRef ref) {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Add Note'),
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
                    ref
                        .read(notesControllerProvider.notifier)
                        .addNote(
                          Note(
                            id: DateTime.now().toString(),
                            title: title,
                            content: content,
                          ),
                        );
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
    );
  }

  void _editNote(BuildContext context, WidgetRef ref, Note note) {
    TextEditingController titleController = TextEditingController(
      text: note.title,
    );
    TextEditingController contentController = TextEditingController(
      text: note.content,
    );
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Edit Note'),
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
                    ref
                        .read(notesControllerProvider.notifier)
                        .updateNote(
                          Note(id: note.id, title: title, content: content),
                        );
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Update'),
              ),
            ],
          ),
    );
  }

  void _deleteNote(WidgetRef ref, String noteId) {
    ref.read(notesControllerProvider.notifier).deleteNote(noteId);
  }
}
