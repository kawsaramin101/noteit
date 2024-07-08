import 'package:flutter/material.dart';
import 'package:notes/componants/note_card.dart';
import 'package:notes/data/note_model.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class MyWidget extends StatelessWidget {
  final String header;
  final List<Note> notes;
  final Function? onReorder;
  final bool shouldReorder;
  final Function deleteNote;
  const MyWidget(
      {super.key,
      required this.header,
      required this.notes,
      this.onReorder,
      this.shouldReorder = false,
      required this.deleteNote});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    int crossAxisCount = 3;

    final double itemWidth =
        (size.width - (crossAxisCount - 1) * 10) / crossAxisCount;
    const double itemHeight = 250.0;
    return Column(children: [
      if (notes.isNotEmpty) ...[
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
          children: notes.map((note) {
            return NoteCard(
              key: ValueKey(note),
              note: note,
              deleteNote: deleteNote,
            );
          }).toList(),
        ),
        const SizedBox(
          height: 14.0,
        ),
      ],
    ]);
  }
}
