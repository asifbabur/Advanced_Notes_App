import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
abstract class Note with _$Note {
  const factory Note({
    required String id,
    String? ownerId, // Made optional (nullable)
    required String title,
    required String content,
    required String category,
    DateTime? createdAt,
    @Default([]) List<String> tags,
    @Default([]) List<String> sharedWith,
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}

extension NoteX on Note {
  bool get isOwner  => ownerId == FirebaseAuth.instance.currentUser?.uid;
}
