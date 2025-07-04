import '../../domain/entities/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel extends Note {
  NoteModel({required super.id, required super.text});

  factory NoteModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      NoteModel(id: doc.id, text: doc.data()?['text'] ?? '');

  Map<String, dynamic> toMap() => {'text': text};
}
