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

  @Index()
  late List<String> contentWords;
}

void createNote(Isar isar, String contentInJson, String contentInPlainText,
    bool pinned) async {
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
  });

  await prefs.setInt('lastAddedNoteOrder', newOrder);
}
