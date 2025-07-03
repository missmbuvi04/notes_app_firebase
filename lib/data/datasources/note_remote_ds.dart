import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class NoteRemoteDataSource {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Path: users/<uid>/notes
  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('notes');

  Future<List<NoteModel>> fetchNotes(String uid) async {
    final snap = await _col(uid)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs.map(NoteModel.fromDoc).toList();
  }

  Future<void> addNote(String uid, String text) => _col(uid).add({
        'text': text,
        'createdAt': FieldValue.serverTimestamp(),
      });

  Future<void> updateNote(String uid, String id, String text) =>
      _col(uid).doc(id).update({
        'text': text,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  Future<void> deleteNote(String uid, String id) =>
      _col(uid).doc(id).delete();
}
