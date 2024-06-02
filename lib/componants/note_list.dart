import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';

import 'package:notes/data/note.dart';
import 'package:notes/componants/note_card.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final Box<Note> noteBox = Hive.box<Note>('notes');

  void _deleteNote(int key) {
    // TODO: show a pop up using AlertDialog widget for confirmation
    showDeleteConfirmationialog(context, key);
  }

  void togglePinnedStatus(int key) {
    final note = noteBox.get(key);
    if (note != null) {
      noteBox.put(
        key,
        Note(
          title: note.title,
          content: note.content,
          createdAt: note.createdAt,
          order: note.order,
          pinned: !note.pinned,
          parent: note.parent,
        ),
      );
    }
  }

  Future<void> showDeleteConfirmationialog(
    BuildContext context,
    int noteKey,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(32.0, 32.0, 32.0, 32.0),
          backgroundColor: Colors.grey[800],
          content: const Text(
            "Are you sure you want to delete this note?",
            style: TextStyle(
              color: Colors.white,
            ),
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
              onPressed: () {
                noteBox.delete(noteKey);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: noteBox.listenable(),
      builder: (context, Box<Note> box, _) {
        if (box.values.isEmpty) {
          return const Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0.0, 180.0, 0, 0),
              child: Text(
                'No notes yet.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          final pinnedNotes =
              box.values.where((item) => item.pinned == true).toList();
          final unpinnedNotes =
              box.values.where((item) => item.pinned == false).toList();

          // for (var note in box.values) {
          //   if (note.pinned) {
          //   //  pinnedNotes.add(note);
          //   } else {
          //     unpinnedNotes.add(note);
          //   }
          // }

          pinnedNotes.sort((a, b) => b.order.compareTo(a.order));
          unpinnedNotes.sort((a, b) => b.order.compareTo(a.order));

          return Expanded(
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
      },
    );
  }
}
