import 'package:isar/isar.dart';
import '../data/edit_model.dart';

part 'note_model.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;

  late bool pinned;
  late int order;

  @Backlink(to: 'note')
  final edits = IsarLinks<Edit>();

  Map<String, dynamic> toJson(List<Edit> loadedEdits) {
    return {
      'id': id,
      'pinned': pinned,
      'order': order,
      'edits': loadedEdits.map((e) => e.toJson()).toList(),
    };
  }
}
