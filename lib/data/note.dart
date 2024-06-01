import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String? title;

  @HiveField(1)
  String? content;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  int order;

  @HiveField(4)
  Note? parent;

  @HiveField(5)
  bool pinned;

  Note({
    this.title,
    this.content,
    required this.createdAt,
    required this.order,
    this.parent,
    this.pinned = false,
  });
}

Future<void> addNote({String? title, String? content, Note? parent}) async {
  final prefs = await SharedPreferences.getInstance();

  int currentOrder = prefs.getInt('note_order') ?? 0;

  final newNote = Note(
    title: title,
    content: content,
    createdAt: DateTime.now(),
    order: currentOrder,
    parent: parent,
    pinned: false,
  );

  var box = await Hive.openBox<Note>('notes');

  await box.add(newNote);

  await prefs.setInt('note_order', currentOrder + 1);
}
