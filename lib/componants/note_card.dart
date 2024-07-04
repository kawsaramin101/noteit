import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/data/note_model.dart';

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

  final _controller = QuillController.basic();

  @override
  void initState() {
    super.initState();

    final json = jsonDecode(widget.note.content);

    _controller.document = Document.fromJson(json);
    _controller.readOnly = true;
  }

  Future<void> showEditDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button to dismiss the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          content: const SizedBox(
            height: 230,
            // child: NoteForm(note: widget.note),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text(
                'Cancel',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
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
        child: SizedBox(
          height: 250.0,
          child: Column(
            children: [
              SizedBox(
                height: 36.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Date placeholder
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                      child: Text(
                        formatDate(widget.note.createdAt),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Tooltip(
                          message: widget.note.pinned ? "Unpin" : "Pin",
                          child: Visibility(
                            visible: _isHovered,
                            child: IconButton(
                              onPressed: () {
                                widget.togglePinnedStatus(widget.note.id);
                              },
                              icon: Icon(
                                widget.note.pinned
                                    ? Icons.push_pin
                                    : Icons.push_pin_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                          message: "Edit",
                          child: Visibility(
                            visible: _isHovered,
                            child: IconButton(
                              onPressed: () {
                                showEditDialog(context);
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                          message: "Delete",
                          child: Visibility(
                            visible: _isHovered,
                            child: IconButton(
                              onPressed: () {
                                widget.deleteNote(widget.note.id);
                              },
                              icon: const Icon(
                                Icons.delete_outline_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                    child: QuillEditor.basic(
                      configurations: QuillEditorConfigurations(
                        controller: _controller,
                        enableSelectionToolbar: false,
                        sharedConfigurations: const QuillSharedConfigurations(
                          dialogBarrierColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatDate(DateTime date) {
  int hour = date.hour;
  int minute = date.minute;
  String amPm = hour >= 12 ? 'PM' : 'AM';

  if (hour == 0) {
    hour = 12;
  } else if (hour > 12) {
    hour -= 12;
  }
  String formattedDate =
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $amPm '
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  return formattedDate;
}
