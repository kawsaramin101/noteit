import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes/componants/note_card.dart';

import 'package:notes/data/note_model.dart';
import 'package:provider/provider.dart';

import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  late Isar isar;
  late Stream<void>? pinnedNotesStream;
  late Stream<void>? unpinnedNotesStream;

  StreamSubscription<void>? pinnedNotesSubscription;
  StreamSubscription<void>? unpinnedNotesSubscription;

  List<Note> pinnedNotes = [];
  List<Note> unpinnedNotes = [];

  @override
  void initState() {
    super.initState();
    isar = Provider.of<Isar>(context, listen: false);
    initializeIsar();
    setupWatcher();
  }

  Future<void> initializeIsar() async {
    fetchPinnedNotes();
    fetchUnpinnedNotes();
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

    setState(() {
      unpinnedNotes = fetchedUnpinnedNotes;
    });
  }

  void _deleteNote(Id id) {
    showDeleteConfirmationDialog(context, id);
  }

  Future<void> showDeleteConfirmationDialog(BuildContext context, Id id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
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
    var size = MediaQuery.of(context).size;

    int crossAxisCount = 3;

    final double itemWidth =
        (size.width - (crossAxisCount - 1) * 10) / crossAxisCount;
    const double itemHeight = 250.0;

    return (pinnedNotes.isEmpty && unpinnedNotes.isEmpty)
        ? const Center(
            child: Text(
              'No notes yet.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          )
        : Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (pinnedNotes.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 8.0),
                        child: Text(
                          'Pinned Notes',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ReorderableGridView.count(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        crossAxisCount: crossAxisCount,
                        physics: const ClampingScrollPhysics(),
                        childAspectRatio: (itemWidth / itemHeight),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        shrinkWrap: true,
                        onReorder: (oldIndex, newIndex) {
                          debugPrint("$oldIndex $newIndex");
                        },
                        children: pinnedNotes.map((note) {
                          return NoteCard(
                            key: ValueKey(note),
                            note: note,
                            deleteNote: _deleteNote,
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 14.0,
                      ),
                    ],
                    if (unpinnedNotes.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 8.0),
                        child: Text(
                          'All Notes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ReorderableGridView.count(
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                        crossAxisCount: crossAxisCount,
                        physics: const ClampingScrollPhysics(),
                        childAspectRatio: (itemWidth / itemHeight),
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        shrinkWrap: true,
                        onReorder: (oldIndex, newIndex) {
                          debugPrint("$oldIndex $newIndex");
                        },
                        children: unpinnedNotes.map((note) {
                          return NoteCard(
                            key: ValueKey(note),
                            note: note,
                            deleteNote: _deleteNote,
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 14.0,
                      )
                    ],
                  ],
                ),
              ),
            ),
          );
  }
}
