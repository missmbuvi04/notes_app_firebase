import '../../domain/entities/note.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel extends Note {
  NoteModel({required super.id, required super.text});

  factory NoteModel.fromDoc(DocumentSnapshot doc) =>
      NoteModel(id: doc.id, text: doc['text']);

  Map<String, dynamic> toMap() => {'text': text};
}
