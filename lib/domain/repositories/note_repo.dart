import '../entities/note.dart';

abstract class NoteRepository {
  Future<List<Note>> fetchNotes(String uid);
  Future<void> addNote(String uid, String text);
  Future<void> updateNote(String uid, String id, String text);
  Future<void> deleteNote(String uid, String id);
}
