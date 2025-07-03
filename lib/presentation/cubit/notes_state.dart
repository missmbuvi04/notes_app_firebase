part of 'notes_cubit.dart';

sealed class NotesState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class NotesLoading extends NotesState {}

final class NotesLoaded extends NotesState {
  final List<Note> notes;
  NotesLoaded(this.notes);
  @override
  List<Object?> get props => [notes];
}

final class NotesError extends NotesState {
  final String msg;
  NotesError(this.msg);
  @override
  List<Object?> get props => [msg];
}
