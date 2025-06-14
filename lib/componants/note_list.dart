import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes/componants/note_list_section.dart';
import 'package:notes/data/edit_model.dart';

import 'package:notes/data/note_model.dart';
import 'package:notes/notifiers/search_notifiers.dart';
import 'package:notes/state/note_notifier.dart';
import 'package:provider/provider.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  late Isar isar;

  late Stream<void>? notesStream;

  StreamSubscription<void>? notesSubscription;

  Iterable<Note> allNotes = Iterable<Note>.empty();

  List<Note> searchedNotes = [];

  String _searchTerm = "";
  bool watcherSuppressed = false;

  @override
  void initState() {
    super.initState();
    isar = Provider.of<Isar>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final searchNotifierProvider = Provider.of<SearchNotifierProvider>(context);
    final valueNotifier = searchNotifierProvider.valueNotifier;

    valueNotifier.addListener(() {
      if (valueNotifier.value != null && valueNotifier.value != "") {
        searchNotes(valueNotifier.value!);
      }
      setState(() {
        _searchTerm = valueNotifier.value!;
      });
    });
  }

  void _deleteNote(Id id) {
    showDeleteConfirmationDialog(context, id);
  }

  void searchNotes(String searchTerm) async {
    if (searchTerm.isNotEmpty) {
      final queryParts = searchTerm.toLowerCase().split(' ');

      var query =
          isar.edits.filter().contentWordsElementStartsWith(queryParts[0]);
      for (var i = 1; i < queryParts.length; i++) {
        query = query.or().contentWordsElementStartsWith(queryParts[i]);
      }
      final edits = await query.findAll();

      for (final edit in edits) {
        await edit.note.load();
        final note = edit.note.value;
        if (note != null) {
          if (!searchedNotes.any((n) => n.id == note.id)) {
            searchedNotes.add(note);
          }
        }
      }
      setState(() {});
    } else {
      setState(() {
        searchedNotes = [];
      });
    }
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
              onPressed: () {
                context.read<NoteProvider>().deleteNote(id);
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
    final pinnedNotes = context.watch<NoteProvider>().pinnedNotes;
    final unpinnedNotes = context.watch<NoteProvider>().unpinnedNotes;

    allNotes = context
        .watch<NoteProvider>()
        .pinnedNotes
        .followedBy(context.watch<NoteProvider>().unpinnedNotes);

    return Expanded(
      child: (pinnedNotes.isEmpty && unpinnedNotes.isEmpty)
          ? const Center(
              child: Text(
                'No notes yet.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_searchTerm.isEmpty) ...[
                        if (pinnedNotes.isNotEmpty)
                          NoteListSection(
                            title: "Pinned Notes",
                            notes: pinnedNotes,
                            deleteNote: _deleteNote,
                            onReorder: (oldIndex, newIndex) async {
                              context
                                  .read<NoteProvider>()
                                  .reOrderNote(true, newIndex, oldIndex);
                            },
                            shouldReorder: true,
                          ),
                        if (unpinnedNotes.isNotEmpty)
                          NoteListSection(
                            title: "All Notes",
                            notes: unpinnedNotes,
                            deleteNote: _deleteNote,
                            onReorder: (oldIndex, newIndex) async {
                              context
                                  .read<NoteProvider>()
                                  .reOrderNote(false, newIndex, oldIndex);
                            },
                            shouldReorder: true,
                          ),
                      ] else ...[
                        if (searchedNotes.isNotEmpty) ...[
                          NoteListSection(
                            title: "Search result for \"$_searchTerm\"",
                            notes: searchedNotes,
                            deleteNote: _deleteNote,
                            shouldReorder: false,
                          ),
                        ] else ...[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 8.0),
                            child: Text(
                              "No search result for \"$_searchTerm\"",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ]
                      ]
                    ],
                  )),
            ),
    );
  }
}
