import 'package:isar/isar.dart';
import 'package:notes/data/note_model.dart';

part 'edit_model.g.dart';

@Collection()
class Edit {
  Id id = Isar.autoIncrement;

  late DateTime createdAt;
  late String content;

  @Index()
  late List<String> contentWords;

  final note = IsarLink<Note>();
}
