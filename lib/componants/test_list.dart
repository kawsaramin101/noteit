// import 'package:flutter/material.dart';
// import 'package:notes/componants/note_card.dart';
// import 'package:notes/data/note_model.dart';
// import 'package:reorderable_grid_view/reorderable_grid_view.dart';

// class NotesScreen extends StatefulWidget {
//   const NotesScreen({super.key});

//   @override
//   State<NotesScreen> createState() => _NotesScreenState();
// }

// class _NotesScreenState extends State<NotesScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final List<int> pinnedNotes = List.generate(10, (index) => index);
//     const int crossAxisCount = 3;
//     const double itemWidth = 50;
//     const double itemHeight = 50;
//     return Expanded(
//       child: ReorderableGridView.count(
//         padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
//         crossAxisCount: crossAxisCount,
//         childAspectRatio: (itemWidth / itemHeight),
//         mainAxisSpacing: 10,
//         crossAxisSpacing: 10,
//         onReorder: (oldIndex, newIndex) {
//           setState(() {
//             final item = pinnedNotes.removeAt(oldIndex);
//             pinnedNotes.insert(newIndex, item);
//           });
//           debugPrint("$oldIndex $newIndex");
//         },
//         children: pinnedNotes.map((note) {
//           return Card(
//             key: ValueKey(note),
//             child: Text("$note"),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
