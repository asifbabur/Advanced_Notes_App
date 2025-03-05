import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_notes_flutter/common/my_text.dart';
import 'package:my_notes_flutter/core/constants.dart';
import 'package:my_notes_flutter/feautures/home/presentation/providers/notes_provider.dart';
import 'package:my_notes_flutter/feautures/home/presentation/widgets/notes_list.dart';

class RecentNote extends ConsumerStatefulWidget {
  const RecentNote({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RecentNoteState();
}

class _RecentNoteState extends ConsumerState<RecentNote> {
  @override
  Widget build(BuildContext context) {
    var recentNote = ref.watch(recentNoteProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,

        MyText('Recent', fontSize: 22, fontWeight: FontWeight.w400),

        NoteCard(note: recentNote!, color: Colors.green, ref: ref),
      ],
    );
  }
}
