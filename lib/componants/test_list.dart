import 'package:flutter/material.dart';

class NotesScreen extends StatelessWidget {
  final List<int> pinnedNotes = List.generate(10, (index) => index);
  final List<int> unpinnedNotes = List.generate(20, (index) => index);
  final int crossAxisCount = 2;
  final double itemWidth = 100;
  final double itemHeight = 150;

  NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
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
              GridView.count(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                crossAxisCount: crossAxisCount,
                childAspectRatio: (itemWidth / itemHeight),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: pinnedNotes.map((note) {
                  return Card(
                    child: Center(child: Text('Item $note')),
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
              GridView.count(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                crossAxisCount: crossAxisCount,
                childAspectRatio: (itemWidth / itemHeight),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: unpinnedNotes.map((note) {
                  return Card(
                    child: Center(child: Text('Item $note')),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 14.0,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
