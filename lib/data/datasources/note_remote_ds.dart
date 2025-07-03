import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class NoteRemoteDataSource {
  final _db = FirebaseFirestore.instance;

  CollectionReference _col(String uid) => _db.collection('users').doc(uid).collection('notes');

  Future<List<NoteModel>> fetchNotes(String uid) async {
    final snap = await _col(uid).orderBy('text').get();
    return snap.docs.map(NoteModel.fromDoc).toList();
  }

  Future<void> addNote(String uid, String text) => _col(uid).add({'text': text});
  Future<void> updateNote(String uid, String id, String text) => _col(uid).doc(id).update({'text': text});
  Future<void> deleteNote(String uid, String id) => _col(uid).doc(id).delete();
}
