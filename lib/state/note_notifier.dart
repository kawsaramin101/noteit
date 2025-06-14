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
      ..createdAt = DateTime.now();

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

  // Future<void> updateNote(Note note) async {
  //   await _isar.writeTxn(() async {
  //     await _isar.notes.put(note);
  //   });

  //   _pinnedNotes.removeWhere((n) => n.id == note.id);
  //   _unpinnedNotes.removeWhere((n) => n.id == note.id);

  //   if (note.pinned) {
  //     _pinnedNotes.add(note);
  //   } else {
  //     _unpinnedNotes.add(note);
  //   }

  //   notifyListeners();
  // }

  Future<Edit> updateNote(Isar isar, Note note, String contentInJson,
      String contentInPlainText, bool pinned) async {
    final newEdit = Edit()
      ..content = contentInJson
      ..createdAt = DateTime.now()
      ..note.value = note;

    note.edits.add(newEdit);

    await isar.writeTxn(() async {
      await isar.edits.put(newEdit);
      await newEdit.note.save();
      await note.edits.save();
    });

    return newEdit;
  }

  Future<void> deleteNote(int noteId) async {
    await _isar.writeTxn(() async {
      await _isar.edits.filter().note((q) => q.idEqualTo(noteId)).deleteAll();

      await _isar.notes.delete(noteId);
    });

    _pinnedNotes.removeWhere((n) => n.id == noteId);
    _unpinnedNotes.removeWhere((n) => n.id == noteId);

    notifyListeners();
  }

  Future<void> toggleNotePinned(Note note) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int lastOrder = prefs.getInt('lastAddedNoteOrder') ?? 0;

    int newOrder = lastOrder + 1;

    note.pinned = !note.pinned;
    note.order = newOrder;

    await _isar.writeTxn(() async {
      await _isar.notes.put(note);
    });
    await prefs.setInt('lastAddedNoteOrder', newOrder);

    if (note.pinned) {
      _unpinnedNotes.removeWhere((n) => n.id == note.id);
      _pinnedNotes.insert(0, note);
    } else {
      _pinnedNotes.removeWhere((n) => n.id == note.id);
      _unpinnedNotes.insert(0, note);
    }
  }

  Future<void> reOrderNote(bool isPinned, int newIndex, int oldIndex) async {
    if (isPinned) {
      _reOrder(newIndex, oldIndex, pinnedNotes);
    } else {
      _reOrder(newIndex, oldIndex, unpinnedNotes);
    }

    notifyListeners();
  }

  void _reOrder(int newIndex, int oldIndex, List<Note> noteList) async {
    if (newIndex == oldIndex) return;

    if (oldIndex < newIndex) {
      // Moving down in the list
      final firstItem = noteList[newIndex].order;
      for (int i = newIndex; i > oldIndex; i--) {
        noteList[i].order = noteList[i - 1].order;
      }
      noteList[oldIndex].order = firstItem;
    } else {
      // Moving up in the list
      final firstItem = noteList[newIndex].order;
      for (int i = newIndex; i < oldIndex; i++) {
        noteList[i].order = noteList[i + 1].order;
      }
      noteList[oldIndex].order = firstItem;
    }

    final item = noteList.removeAt(oldIndex);
    noteList.insert(newIndex, item);

    await _isar.writeTxn(() async {
      await _isar.notes.putAll(noteList);
    });
  }
}
