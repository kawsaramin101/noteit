import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:notes/data/edit_model.dart';
import '../data/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteProvider extends ChangeNotifier {
  final Isar _isar;

  NoteProvider(this._isar);

  List<Note> _pinnedNotes = [];
  List<Note> _unpinnedNotes = [];

  List<Note> get pinnedNotes => _pinnedNotes;
  List<Note> get unpinnedNotes => _unpinnedNotes;

  Future<void> loadNotes() async {
    _pinnedNotes = await _isar.notes
        .filter()
        .pinnedEqualTo(true)
        .sortByOrderDesc()
        .findAll();

    _unpinnedNotes = await _isar.notes
        .filter()
        .pinnedEqualTo(false)
        .sortByOrderDesc()
        .findAll();

    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    await _isar.writeTxn(() async {
      await _isar.notes.put(note);
    });

    if (note.pinned) {
      _pinnedNotes.add(note);
    } else {
      _unpinnedNotes.add(note);
    }

    notifyListeners();
  }

  Future<Note> createNote(
      String contentInJson, String contentInPlainText, bool pinned,
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
      ..contentWords = contentInPlainText.split(RegExp(r'[\s\n]+'));

    note.edits.add(newEdit);
    newEdit.note.value = note;

    await _isar.writeTxn(() async {
      await _isar.notes.put(note);
      await _isar.edits.put(newEdit);
      await note.edits.save();
      await newEdit.note.save();
    });

    if (parentNote == null) {
      await prefs.setInt('lastAddedNoteOrder', newOrder);
    }

    if (note.pinned) {
      _pinnedNotes.insert(0, note);
    } else {
      _unpinnedNotes.insert(0, note);
    }

    notifyListeners();

    return note;
  }

  Future<void> updateNote(Note note) async {
    await _isar.writeTxn(() async {
      await _isar.notes.put(note);
    });

    _pinnedNotes.removeWhere((n) => n.id == note.id);
    _unpinnedNotes.removeWhere((n) => n.id == note.id);

    if (note.pinned) {
      _pinnedNotes.add(note);
    } else {
      _unpinnedNotes.add(note);
    }

    notifyListeners();
  }

  Future<void> deleteNote(Note note) async {
    await _isar.writeTxn(() async {
      await _isar.notes.delete(note.id);
    });

    _pinnedNotes.removeWhere((n) => n.id == note.id);
    _unpinnedNotes.removeWhere((n) => n.id == note.id);

    notifyListeners();
  }
}
