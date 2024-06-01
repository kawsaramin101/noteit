import 'package:flutter/material.dart';
import 'package:notes/data/note.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final Function deleteNote;
  final Function togglePinnedStatus;

  const NoteCard({
    super.key,
    required this.note,
    required this.deleteNote,
    required this.togglePinnedStatus,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
          });
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: 100.0,
            maxHeight: 300.0,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Column(
                  children: [
                    // Ensure the Container respects the minimum height
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
                          width: double.infinity,
                          child: SelectableText(
                            "${widget.note.content}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Visibility(
                    visible: _isHovered,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: widget.note.pinned ? "Unpin" : "Pin",
                          child: IconButton(
                            onPressed: () {
                              widget.togglePinnedStatus(widget.note.key);
                            },
                            icon: Icon(
                              (widget.note.pinned
                                  ? Icons.push_pin
                                  : Icons.push_pin_outlined),
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Tooltip(
                          message: "Edit",
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Tooltip(
                          message: "Delete",
                          child: IconButton(
                            onPressed: () {
                              widget.deleteNote(widget.note.key);
                            },
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
