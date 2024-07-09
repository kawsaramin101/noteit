import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:isar/isar.dart';
import 'package:notes/data/edit_model.dart';
import 'package:notes/data/note_model.dart';
import 'package:provider/provider.dart';

class NoteForm extends StatefulWidget {
  final QuillController controller;
  final bool isNotePinned;
  final VoidCallback? togglePinnedStatus;
  final Note? note;
  final Edit? edit;
  final void Function(Edit)? changeEdit;

  const NoteForm({
    super.key,
    required this.controller,
    required this.isNotePinned,
    required this.togglePinnedStatus,
    this.note,
    this.edit,
    this.changeEdit,
  });

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  late Isar isar;
  bool isHeadingSelected = true;
  bool _isNotePinned = false;
  bool undoExists = false;
  bool redoExists = false;

  late QuillController _controller;

  Edit? currentEdit;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    isar = Provider.of<Isar>(context, listen: false);
    _isNotePinned = widget.isNotePinned;

    if (widget.edit != null) {
      currentEdit = widget.edit;
    }

    if (widget.note != null) {
      _setUpController(widget.edit!);
      _setUndoRedoExists();
    }
  }

  void _setUpController(Edit edit) {
    final json = jsonDecode(edit.content);
    _controller.document = Document.fromJson(json);
  }

  void _createOrUpdateNote() async {
    final jsonEncodedData = jsonEncode(_controller.document.toDelta().toJson());
    final contentInPlainText = _controller.document.toPlainText();

    if (widget.note == null) {
      createNote(isar, jsonEncodedData, contentInPlainText, _isNotePinned);
    } else {
      final parent = widget.note!;
      final newEdit = await updateNote(
          isar, parent, jsonEncodedData, contentInPlainText, _isNotePinned);
      widget.changeEdit!(newEdit);
      if (_isNotePinned != widget.isNotePinned) {
        widget.togglePinnedStatus!();
      }
    }

    _controller.clear();
    widget.controller.clear();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _undo() async {
    if (!undoExists) return;
    final previousEdit = await isar.edits
        .where(sort: Sort.desc)
        .idLessThan(currentEdit!.id)
        .filter()
        .note((q) => q.idEqualTo(widget.note!.id))
        .findFirst();

    if (previousEdit != null) {
      _setUpController(previousEdit);
      currentEdit = previousEdit;
    }
    _setUndoRedoExists();
  }

  void _redo() async {
    if (!redoExists) return;
    final nextEdit = await isar.edits
        .where(sort: Sort.asc)
        .idGreaterThan(currentEdit!.id)
        .filter()
        .note((q) => q.idEqualTo(widget.note!.id))
        .findFirst();

    if (nextEdit != null) {
      currentEdit = nextEdit;
      _setUpController(nextEdit);
    }

    _setUndoRedoExists();
  }

  void _setUndoRedoExists() async {
    final previousEdit = await isar.edits
        .where(sort: Sort.desc)
        .idLessThan(currentEdit!.id)
        .filter()
        .note((q) => q.idEqualTo(widget.note!.id))
        .findFirst();
    if (previousEdit != null) {
      setState(() {
        undoExists = true;
      });
    } else {
      setState(() {
        undoExists = false;
      });
    }

    final nextEdit = await isar.edits
        .where(sort: Sort.asc)
        .idGreaterThan(currentEdit!.id)
        .filter()
        .note((q) => q.idEqualTo(widget.note!.id))
        .findFirst();
    if (nextEdit != null) {
      setState(() {
        redoExists = true;
      });
    } else {
      setState(() {
        redoExists = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      contentPadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 16.0),
      content: SizedBox(
        width: 500.0,
        height: 400.0,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  customButtons: [
                    QuillToolbarCustomButtonOptions(
                      icon: const HIcon(),
                      tooltip: 'Heading',
                      onPressed: () {
                        final currentHeading = _controller
                            .getSelectionStyle()
                            .attributes[Attribute.h3.key];

                        if (currentHeading != null) {
                          _controller.formatSelection(
                              Attribute.clone(Attribute.h3, null));
                        } else {
                          _controller.formatSelection(Attribute.h3);
                        }
                      },
                    ),
                    if (widget.note != null) ...[
                      QuillToolbarCustomButtonOptions(
                        icon: Icon(
                          Icons.undo,
                          color: !undoExists ? Colors.grey[700] : null,
                        ),
                        tooltip: 'Undo',
                        onPressed: _undo,
                      ),
                      QuillToolbarCustomButtonOptions(
                        icon: Icon(
                          Icons.redo,
                          color: !redoExists ? Colors.grey[700] : null,
                        ),
                        tooltip: 'Redo',
                        onPressed: _redo,
                      ),
                    ],
                    QuillToolbarCustomButtonOptions(
                        icon: Icon(
                          _isNotePinned
                              ? Icons.push_pin
                              : Icons.push_pin_outlined,
                          size: 20.0,
                        ),
                        tooltip: _isNotePinned ? "Unpin Note" : "Pin Note",
                        onPressed: () {
                          setState(() {
                            _isNotePinned = !_isNotePinned;
                          });
                        })
                  ],
                  controller: _controller,
                  sharedConfigurations: const QuillSharedConfigurations(),
                  multiRowsDisplay: false,
                  showHeaderStyle: false,
                  showBackgroundColorButton: false,
                  showCenterAlignment: false,
                  showClipboardCopy: false,
                  showClipboardCut: false,
                  showClipboardPaste: false,
                  showDirection: false,
                  showClearFormat: false,
                  showIndent: false,
                  showDividers: false,
                  showInlineCode: false,
                  showRedo: false,
                  showSubscript: false,
                  showSuperscript: false,
                  showAlignmentButtons: false,
                  showColorButton: false,
                  showJustifyAlignment: false,
                  showUndo: false,
                  showFontFamily: false,
                  showFontSize: false,
                  showSearchButton: false,
                  showRightAlignment: false,
                  showQuote: false,
                  showUnderLineButton: false,
                  showItalicButton: false,
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        width: 0.8, color: Color.fromRGBO(97, 97, 97, 1)),
                    bottom: BorderSide(
                        width: 0.8, color: Color.fromRGBO(97, 97, 97, 1)),
                  ),
                ),
                child: QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    autoFocus: true,
                    controller: _controller,
                    sharedConfigurations: const QuillSharedConfigurations(
                      dialogBarrierColor: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.start,
      actions: <Widget>[
        ElevatedButton(
          onPressed: _createOrUpdateNote,
          child: const Text(
            "Save",
          ),
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[800],
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[800],
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onPressed: () {
            widget.controller.clear();
            Navigator.of(context).pop();
          },
          child: const Text(
            'Discard',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class HIcon extends StatelessWidget {
  final double size;

  const HIcon({
    super.key,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconTheme.of(context).copyWith(
        size: size,
      ),
      child: Center(
        child: Text(
          'H',
          style: TextStyle(
            fontSize: size * 0.7, // Adjust font size as needed
            fontWeight: FontWeight.bold,
            color: IconTheme.of(context).color, // Default icon color
          ),
        ),
      ),
    );
  }
}
