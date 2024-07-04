import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:notes/componants/note_card.dart';

import 'package:notes/data/note_model.dart';
import 'package:provider/provider.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  late Isar isar;
  late Stream<List<Note>> noteStream;
  late Stream<void>? pinnedNotesStream;
  late Stream<void>? unpinnedNotesStream;

  StreamSubscription<void>? pinnedNotesSubscription;
  StreamSubscription<void>? unpinnedNotesSubscription;

  List<Note> pinnedNotes = [];
  List<Note> unpinnedNotes = [];

  @override
  void initState() {
    super.initState();
    initializeIsar();
    setupWatcher();
  }

  Future<void> initializeIsar() async {
    isar = Provider.of<Isar>(context, listen: false);
    fetchPinnedNotes();
    fetchUnpinnedNotes();
    setState(() {
      noteStream = isar.notes.where().watch(fireImmediately: true);
    });
  }

  void setupWatcher() {
    pinnedNotesStream =
        isar.notes.filter().pinnedEqualTo(true).sortByOrderDesc().watchLazy();

    unpinnedNotesStream =
        isar.notes.filter().pinnedEqualTo(false).sortByOrderDesc().watchLazy();

    pinnedNotesSubscription = pinnedNotesStream?.listen((_) {
      fetchPinnedNotes();
    });

    unpinnedNotesSubscription = unpinnedNotesStream?.listen((_) {
      fetchUnpinnedNotes();
    });
  }

  void fetchPinnedNotes() async {
    final fetchedPinnedNotes = await isar.notes
        .filter()
        .pinnedEqualTo(true)
        .sortByOrderDesc()
        .findAll();

    debugPrint("$fetchedPinnedNotes");

    setState(() {
      pinnedNotes = fetchedPinnedNotes;
    });
  }

  void fetchUnpinnedNotes() async {
    final fetchedUnpinnedNotes = await isar.notes
        .filter()
        .pinnedEqualTo(false)
        .sortByOrderDesc()
        .findAll();

    debugPrint("$fetchedUnpinnedNotes");

    setState(() {
      unpinnedNotes = fetchedUnpinnedNotes;
    });
  }

  void _deleteNote(Id id) {
    showDeleteConfirmationDialog(context, id);
  }

  void togglePinnedStatus(Id id) async {
    final note = await isar.notes.get(id);
    if (note != null) {
      note.pinned = !note.pinned;
      await isar.writeTxn(() async {
        await isar.notes.put(note);
      });
    }
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context, Id id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
          backgroundColor: Colors.grey[900],
          content: const Text(
            "Are you sure you want to delete this note?",
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await isar.writeTxn(() async {
                  await isar.notes.delete(id);
                });
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return (pinnedNotes.isEmpty && unpinnedNotes.isEmpty)
        ? const Expanded(
            child: Center(
              child: Text(
                'No notes yet.',
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
          )
        : Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (pinnedNotes.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Pinned Notes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MasonryView(
                      listOfItem: pinnedNotes,
                      numberOfColumn: 3,
                      itemBuilder: (item) {
                        return NoteCard(
                          note: item,
                          deleteNote: _deleteNote,
                          togglePinnedStatus: togglePinnedStatus,
                        );
                      },
                    ),
                  ],
                  if (unpinnedNotes.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'All Notes',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MasonryView(
                      listOfItem: unpinnedNotes,
                      numberOfColumn: 3,
                      itemBuilder: (item) {
                        return NoteCard(
                          note: item,
                          deleteNote: _deleteNote,
                          togglePinnedStatus: togglePinnedStatus,
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
  }
}
