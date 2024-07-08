import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes/componants/note_list_section.dart';
import 'package:notes/data/edit_model.dart';

import 'package:notes/data/note_model.dart';
import 'package:notes/notifiers/search_notifiers.dart';
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

  List<Note> notes = [];
  List<Note> pinnedNotes = [];
  List<Note> unpinnedNotes = [];
  List<Note> searchedNotes = [];

  String _searchTerm = "";

  @override
  void initState() {
    super.initState();
    isar = Provider.of<Isar>(context, listen: false);
    fetchNotes();
    setupWatcher();
  }

  void setupWatcher() {
    notesStream = isar.notes.watchLazy();

    notesSubscription = notesStream?.listen((_) {
      fetchNotes();
    });
  }

  void fetchNotes() async {
    final fetchedNotes = await isar.notes.where().sortByOrderDesc().findAll();
    setState(() {
      notes = fetchedNotes;
    });
  }

  void _deleteNote(Id id) {
    showDeleteConfirmationDialog(context, id);
  }

  void searchNotes(String searchTerm) async {
    if (searchTerm.isNotEmpty) {
      final queryParts = searchTerm.toLowerCase().split(' ');

      List<Note> searchResults = [];
      for (var note in notes) {
        final latestEdit = await isar.edits
            .where(sort: Sort.desc)
            .filter()
            .note((q) => q.idEqualTo(note.id))
            .findFirst();

        if (latestEdit != null) {
          final containsAllParts = queryParts.every((part) => latestEdit
              .contentWords
              .any((word) => word.toLowerCase().contains(part)));
          if (containsAllParts) {
            searchResults.add(note);
          }
        }
      }

      setState(() {
        searchedNotes = searchResults;
      });
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

    pinnedNotes = notes.where((note) => note.pinned).toList();
    unpinnedNotes = notes.where((note) => !note.pinned).toList();

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
                            onReorder: (oldIndex, newIndex) {},
                            shouldReorder: true,
                          ),
                        if (unpinnedNotes.isNotEmpty)
                          NoteListSection(
                            title: "All Notes",
                            notes: unpinnedNotes,
                            deleteNote: _deleteNote,
                            onReorder: (oldIndex, newIndex) {},
                            shouldReorder: true,
                          ),
                      ] else ...[
                        NoteListSection(
                          title: "Search result for \"$_searchTerm\"",
                          notes: searchedNotes,
                          deleteNote: _deleteNote,
                          shouldReorder: false,
                        ),
                      ]
                    ],
                  )),
            ),
    );
  }
}
