import 'package:flutter/material.dart';
import '../componants/note_card.dart';
import '../data/note_model.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class NoteListSection extends StatelessWidget {
  final String title;
  final List<Note> notes;
  final void Function(int, int)? onReorder;
  final bool shouldReorder;
  final Function deleteNote;
  const NoteListSection({
    super.key,
    required this.title,
    required this.notes,
    this.onReorder,
    this.shouldReorder = false,
    required this.deleteNote,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    const int crossAxisCount = 3;

    final double itemWidth =
        (size.width - (crossAxisCount - 1) * 10) / crossAxisCount;
    const double itemHeight = 250.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (notes.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          shouldReorder
              ? ReorderableGridView.count(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  crossAxisCount: crossAxisCount,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: (itemWidth / itemHeight),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
                  dragStartDelay: const Duration(microseconds: 600),
                  onReorder: onReorder!,
                  children: notes.map((note) {
                    return NoteCard(
                      key: ValueKey(note),
                      note: note,
                      deleteNote: deleteNote,
                    );
                  }).toList(),
                )
              : GridView.count(
                  padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  crossAxisCount: crossAxisCount,
                  physics: const ClampingScrollPhysics(),
                  childAspectRatio: (itemWidth / itemHeight),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  shrinkWrap: true,
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
      ],
    );
  }
}
