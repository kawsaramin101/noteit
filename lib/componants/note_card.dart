import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:isar/isar.dart';
import 'package:notes/componants/note_form.dart';
import 'package:notes/data/edit_model.dart';
import 'package:notes/data/note_model.dart';
import 'package:provider/provider.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final Function deleteNote;

  const NoteCard({
    super.key,
    required this.note,
    required this.deleteNote,
  });

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {
  late Isar isar;

  Edit? edit;
  bool _isHovered = false;

  final _controller = QuillController.basic();
  final _editingController = QuillController.basic();
  bool _isNotePinned = false;

  @override
  void initState() {
    super.initState();
    isar = Provider.of<Isar>(context, listen: false);

    _isNotePinned = widget.note.pinned;
    getNoteEdit();
  }

  void getNoteEdit() async {
    final fetchedEdit = await isar.edits
        .where(sort: Sort.desc)
        .anyId()
        .filter()
        .note((q) => q.idEqualTo(widget.note.id))
        .findFirst();

    setState(() {
      edit = fetchedEdit;
    });

    final json = jsonDecode(edit!.content);

    _controller.document = Document.fromJson(json);
    _controller.readOnly = true;
    _editingController.document = Document.fromJson(json);
  }

  void togglePinnedStatus() async {
    widget.note.pinned = !widget.note.pinned;
    await isar.writeTxn(() async {
      await isar.notes.put(widget.note);
    });
  }

  Future<void> showEditDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteForm(
          controller: _editingController,
          isNotePinned: _isNotePinned,
          togglePinnedStatus: () {
            setState(() {
              _isNotePinned = !_isNotePinned;
            });
            togglePinnedStatus();
          },
          note: widget.note,
          edit: edit,
          changeEdit: changeEdit,
        );
      },
    );
  }

  void changeEdit(Edit edited) {
    setState(() {
      edit = edited;
    });

    final json = jsonDecode(edit!.content);

    _controller.document = Document.fromJson(json);
    _controller.readOnly = true;
    _editingController.document = Document.fromJson(json);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2b2b2b),

      // This causes problem with windows titlebar
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(8), // Optional: for rounded corners
      //   side: BorderSide(
      //     color: Colors.grey[800]!, // Your border color
      //     width: 0.5, // Border width
      //   ),
      // ),
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
          // height: 250.0,
          child: Column(
            children: [
              SizedBox(
                height: 36.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                      child: Text(
                        edit != null ? formatDate(edit!.createdAt) : "Loading",
                        style: TextStyle(
                          color: Colors.grey[200],
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
                                toggleNotePinned(isar, widget.note);
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
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
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
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $amPm, '
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  return formattedDate;
}
