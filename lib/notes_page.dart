import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesPage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser!;
  final notesRef = FirebaseFirestore.instance.collection('notes');

  void showAddNoteDialog(BuildContext context, [DocumentSnapshot? doc]) {
    final controller = TextEditingController(text: doc?.get('text') ?? '');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(doc == null ? 'Add Note' : 'Edit Note'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () async {
              final text = controller.text.trim();
              if (text.isEmpty) return;
              if (doc == null) {
                await notesRef.add({'text': text, 'uid': user.uid});
              } else {
                await notesRef.doc(doc.id).update({'text': text});
              }
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteNote(String id) async {
    await notesRef.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [IconButton(onPressed: () => FirebaseAuth.instance.signOut(), icon: Icon(Icons.logout))],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: notesRef.where('uid', isEqualTo: user.uid).snapshots(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return Center(child: Text('Nothing here yet—tap ➕ to add a note.'));
          return ListView(
            children: docs.map((doc) {
              final text = doc.get('text');
              return Card(
                child: ListTile(
                  title: Text(text),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: Icon(Icons.edit), onPressed: () => showAddNoteDialog(context, doc)),
                    IconButton(icon: Icon(Icons.delete), onPressed: () => deleteNote(doc.id)),
                  ]),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddNoteDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
