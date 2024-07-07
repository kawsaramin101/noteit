import 'package:isar/isar.dart';
import 'package:notes/data/edit_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'note_model.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;

  late bool pinned;
  late int order;

  @Backlink(to: 'note')
  final edits = IsarLinks<Edit>();
}

Future<Note> createNote(
    Isar isar, String contentInJson, String contentInPlainText, bool pinned,
    {Note? parentNote}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  int lastOrder = prefs.getInt('lastAddedNoteOrder') ?? 0;

  int newOrder = lastOrder + 1;

  final note = parentNote ?? Note()
    ..order = newOrder
    ..pinned = pinned;

  final newEdit = Edit()
    ..content = contentInJson
    ..createdAt = DateTime.now()
    ..contentWords = contentInPlainText.split(' ');

  note.edits.add(newEdit);
  newEdit.note.value = note;

  await isar.writeTxn(() async {
    await isar.notes.put(note);
    await isar.edits.put(newEdit);
    await note.edits.save();
    await newEdit.note.save();
  });

  if (parentNote != null) {
    await prefs.setInt('lastAddedNoteOrder', newOrder);
  }

  return note;
}

Future<Edit> updateNote(Isar isar, Note note, String contentInJson,
    String contentInPlainText, bool pinned) async {
  final newEdit = Edit()
    ..content = contentInJson
    ..createdAt = DateTime.now()
    ..contentWords = contentInPlainText.split(' ')
    ..note.value = note;

  note.edits.add(newEdit);

  await isar.writeTxn(() async {
    await isar.edits.put(newEdit);
    await newEdit.note.save();
    await note.edits.save();
  });

  return newEdit;
}

Future<void> deleteNote(Isar isar, int noteId) async {}

Future<void> toggleNotePinned(Isar isar, Note note) async {
  note.pinned = !note.pinned;

  await isar.writeTxn(() async {
    await isar.notes.put(note);
  });
}
