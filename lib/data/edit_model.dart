import 'package:isar/isar.dart';
import 'package:notes/data/note_model.dart';

part 'edit_model.g.dart';

@Collection()
class Edit {
  Id id = Isar.autoIncrement;

  late DateTime createdAt;
  late String content;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get contentWords => Isar.splitWords(content);

  final note = IsarLink<Note>();
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'content': content,
    };
  }
}
