import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'note_model.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;

  late String content;
  late DateTime createdAt;
  late int order;
  late bool pinned;

  final parent = IsarLink<Note>();

  @Backlink(to: 'parent')
  final edits = IsarLinks<Note>();

  @Index()
  late List<String> contentWords;
}

Future<Note> createNote(
    Isar isar, String contentInJson, String contentInPlainText, bool pinned,
    {Note? parentNote}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int lastOrder = prefs.getInt('lastAddedNoteOrder') ?? 0;

  int newOrder = lastOrder + 1;

  final newNote = Note()
    ..content = contentInJson
    ..createdAt = DateTime.now()
    ..order = newOrder
    ..pinned = pinned
    ..contentWords = contentInPlainText.split(' ');

  await isar.writeTxn(() async {
    await isar.notes.put(newNote);

    if (parentNote != null) {
      newNote.order = parentNote.order;
      newNote.parent.value = parentNote;
      parentNote.edits.add(newNote);
      debugPrint("${parentNote.edits}");
      debugPrint("${newNote.parent}");

      await parentNote.edits.save();
      await newNote.parent.save();
    }
  });

  await prefs.setInt('lastAddedNoteOrder', newOrder);

  return newNote;
}

Future<void> updateNote(Isar isar, Note oldNote, String contentInJson,
    String contentInPlainText, bool pinned) async {
  await createNote(isar, contentInJson, contentInPlainText, pinned,
      parentNote: oldNote);
}
