import '../../domain/repositories/note_repo.dart';
import '../../domain/entities/note.dart';
import '../datasources/note_remote_ds.dart';

class NoteRepositoryImpl extends NoteRepository {
  final NoteRemoteDataSource remote;
  NoteRepositoryImpl(this.remote);

  @override
  Future<List<Note>> fetchNotes(String uid) => remote.fetchNotes(uid);

  @override
  Future<void> addNote(String uid, String text) => remote.addNote(uid, text);

  @override
  Future<void> updateNote(String uid, String id, String text) =>
      remote.updateNote(uid, id, text);

  @override
  Future<void> deleteNote(String uid, String id) =>
      remote.deleteNote(uid, id);
}
