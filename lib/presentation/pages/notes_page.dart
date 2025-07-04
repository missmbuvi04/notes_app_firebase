import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../cubit/notes_cubit.dart';
import '../cubit/auth_cubit.dart';
import '../../data/datasources/note_remote_ds.dart';
import '../../data/repositories/note_repo_impl.dart';
import '../widgets/note_card.dart';
import '../../domain/entities/note.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return RepositoryProvider(
      create: (_) => NoteRepositoryImpl(NoteRemoteDataSource()),
      child: BlocProvider(
        create: (ctx) => NotesCubit(ctx.read<NoteRepositoryImpl>(), uid),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Your Notes'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => context.read<AuthCubit>().signOut(),
              ),
            ],
          ),
          body: BlocConsumer<NotesCubit, NotesState>(
            listener: (ctx, state) {
              if (state is NotesError) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(state.msg)),
                );
              }
            },
            builder: (ctx, state) {
              if (state is NotesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is NotesLoaded) {
                final notes = state.notes;
                if (notes.isEmpty) {
                  return const Center(
                    child: Text('Nothing here yet—tap ➕ to add a note.'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: notes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => NoteCard(note: notes[i]),
                );
              } else if (state is NotesError) {
                return const Center(child: Text('Something went wrong'));
              } else {
                return const SizedBox.shrink(); // fallback
              }
            },
          ),

          // ─── FAB wrapped in Builder so its context contains the NotesCubit ───
          floatingActionButton: Builder(
            builder: (fabCtx) {
              final notesCubit = fabCtx.read<NotesCubit>();
              return FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => _showAddOrEditDialog(
                  fabCtx,
                  cubit: notesCubit,
                  note: null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Add Edit Dialog 
  Future<void> _showAddOrEditDialog(
    BuildContext context, {
    required NotesCubit cubit,
    Note? note,
  }) async {
    final ctrl = TextEditingController(text: note?.text);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(note == null ? 'New note' : 'Edit note'),
        content: TextField(
          controller: ctrl,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'Enter your note…'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final txt = ctrl.text.trim();
              if (txt.isEmpty) return;

              note == null
                  ? cubit.addNote(txt)
                  : cubit.updateNote(note.id, txt);

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(note == null ? 'Note added!' : 'Note updated!'),
                ),
              );
            },
            child: Text(note == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }
}
// Note: The above code is a complete implementation of a NotesPage in a Flutter application.
// It includes a Scaffold with an AppBar, a body that displays notes, and a FloatingActionButton to add or edit notes.
// The `_showAddOrEditDialog` function is used to show a dialog for adding or editing notes.
// The dialog contains a TextField for entering the note text and buttons to cancel or save the note.
// The NotesCubit is used to manage the state of the notes, including loading, adding, and updating notes.
//// The code also handles displaying error messages using a SnackBar when there are issues with loading or modifying notes.
//// The `NotesPage` is wrapped in a `BlocProvider` to provide the `NotesCubit` to the widget tree.

