import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note.dart';
import '../cubit/notes_cubit.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotesCubit>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Colors.black12,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        title: Text(note.text),
        trailing: Wrap(
          spacing: 8,
          children: [
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                cubit.deleteNote(note.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note deleted')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showEditDialog(context, cubit),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────────── edit dialog ──────────────────────
  void _showEditDialog(BuildContext context, NotesCubit cubit) {
    final ctrl = TextEditingController(text: note.text);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit note'),
        content: TextField(controller: ctrl, maxLines: 5),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final txt = ctrl.text.trim();
              if (txt.isNotEmpty) cubit.updateNote(note.id, txt);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
