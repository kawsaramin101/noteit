import 'package:flutter/material.dart';

import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:notes/componants/note_card.dart';
import 'package:notes/data/note.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<int> _items = List<int>.generate(20, (int index) => index);

  bool _onReorder(Key itemKey, Key newPositionKey) {
    final int oldIndex = _items.indexWhere((item) => ValueKey(item) == itemKey);
    final int newIndex =
        _items.indexWhere((item) => ValueKey(item) == newPositionKey);

    if (oldIndex != newIndex) {
      setState(() {
        final int item = _items.removeAt(oldIndex);
        _items.insert(newIndex, item);
      });
      return true;
    }
    return false;
  }

  List<Note> notes = [
    Note(
      content: "Remember to buy groceries.",
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      order: 1,
      pinned: false,
    ),
    Note(
      content: "Complete the project report and send it to the manager by EOD.",
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      order: 2,
      pinned: true,
    ),
    Note(
      content: "Check email for the new software update announcement.",
      createdAt: DateTime.now().subtract(Duration(hours: 6)),
      order: 3,
      pinned: false,
    ),
    Note(
      content: "Pick up dry cleaning.",
      createdAt: DateTime.now().subtract(Duration(hours: 12)),
      order: 4,
      pinned: false,
    ),
    Note(
      content:
          "Read the book 'The Pragmatic Programmer' by Andrew Hunt and David Thomas.",
      createdAt: DateTime.now().subtract(Duration(days: 3)),
      order: 5,
      pinned: true,
    ),
    Note(
      content:
          "Organize the team meeting for next Monday at 10 AM and prepare the agenda.",
      createdAt: DateTime.now().subtract(Duration(days: 4)),
      order: 6,
      pinned: false,
    ),
    Note(
      content:
          "Review the quarterly financial statements before the board meeting.",
      createdAt: DateTime.now().subtract(Duration(days: 5)),
      order: 7,
      pinned: true,
    ),
    Note(
      content:
          "Plan the weekend getaway to the mountains. Don't forget to book the cabin.",
      createdAt: DateTime.now().subtract(Duration(days: 6)),
      order: 8,
      pinned: false,
    ),
    Note(
      content:
          "Call the maintenance service to fix the leaking faucet in the kitchen.",
      createdAt: DateTime.now().subtract(Duration(days: 7)),
      order: 9,
      pinned: false,
    ),
    Note(
      content:
          "Update the resume and apply for the job opening at the tech company.",
      createdAt: DateTime.now().subtract(Duration(days: 8)),
      order: 10,
      pinned: true,
    ),
  ];

  void _deleteNote() {}
  void togglePinnedStatus() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Masonry Animated Drag-and-Drop List')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                final item = _items.removeAt(oldIndex);
                _items.insert(newIndex, item);
              });
            },
            children: notes
                .asMap()
                .map((index, item) =>
                    MapEntry(index, buildMasonryItem(item, index)))
                .values
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget buildMasonryItem(Note note, int index) {
    return MasonryView(
      key: ValueKey(note),
      listOfItem: [note],
      numberOfColumn: 1,
      itemBuilder: (item) {
        return Image.asset(item);
      },
    );
  }
}
