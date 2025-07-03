import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repo.dart';

part 'notes_state.dart';

class NotesCubit extends Cubit<NotesState> {
  final NoteRepository repo;
  final String uid;
  NotesCubit(this.repo, this.uid) : super(NotesLoading()) {
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    emit(NotesLoading());
    try {
      final notes = await repo.fetchNotes(uid);
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> addNote(String text) async {
    try {
      await repo.addNote(uid, text);
      fetchNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> updateNote(String id, String text) async {
    try {
      await repo.updateNote(uid, id, text);
      fetchNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await repo.deleteNote(uid, id);
      fetchNotes();
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }
}
