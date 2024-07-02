import 'package:isar/isar.dart';

part 'note_model.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;

  String? title;
  late String content;
  late DateTime createdAt;
  late int order;
  late bool pinned;

  final parent = IsarLink<Note>();

  @Index()
  List<String> get titleWords => title?.split(' ') ?? [];

  @Index()
  List<String> get contentWords => content.split(' ');
}
