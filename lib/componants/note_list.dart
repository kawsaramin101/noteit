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
    noteBox.delete(key);
  }

  void togglePinnedStatus(int key) {
    final note = noteBox.get(key);
    debugPrint("$key");
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
          final pinnedNotes = <Note>[];
          final unpinnedNotes = <Note>[];

          for (var note in box.values) {
            if (note.pinned) {
              pinnedNotes.add(note);
            } else {
              unpinnedNotes.add(note);
            }
          }

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
