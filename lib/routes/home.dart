import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';

import 'package:notes/data/note.dart';
import 'package:notes/componants/note_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Box<Note> noteBox = Hive.box<Note>('notes');
  final TextEditingController _contentController = TextEditingController();

  void _addNote() {
    addNote(
      content: _contentController.text,
    );
    _contentController.clear();
  }

  void _deleteNote(int key) {
    // TODO: show a pop up using AlertDialog widget for confirmation
    noteBox.delete(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 8.0,
          ),
          Center(
            child: SizedBox(
              width: 450,
              height: 175,
              child: TextFormField(
                controller: _contentController,
                autofocus: true,
                autocorrect: false,
                maxLines: null,
                minLines: 5,
                expands: false,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: 'What\'s on your mind?',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Center(
            child: TextButton(
              onPressed: _addNote,
              style: TextButton.styleFrom(
                backgroundColor:
                    Colors.blue, // Bright color for button background
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          ValueListenableBuilder(
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
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Pinned Notes',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          MasonryView(
                            listOfItem: pinnedNotes,
                            numberOfColumn: 3,
                            itemBuilder: (item) {
                              return NoteCard(
                                note: item,
                                deleteNote: _deleteNote,
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
                                  color: Colors.white),
                            ),
                          ),
                          MasonryView(
                            listOfItem: unpinnedNotes,
                            numberOfColumn: 3,
                            itemBuilder: (item) {
                              return NoteCard(
                                note: item,
                                deleteNote: _deleteNote,
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
          ),
        ],
      ),
    );
  }
}
