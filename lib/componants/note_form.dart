import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:isar/isar.dart';
import 'package:notes/data/note_model.dart';
import 'package:provider/provider.dart';

class NoteForm extends StatefulWidget {
  final QuillController controller;
  final bool isNotePinned;
  final VoidCallback? togglePinnedStatus;
  final Note? note;

  const NoteForm(
      {super.key,
      required this.controller,
      required this.isNotePinned,
      required this.togglePinnedStatus,
      this.note});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  bool isHeadingSelected = true;
  bool _isNotePinned = false;

  @override
  void initState() {
    super.initState();
    _isNotePinned = widget.isNotePinned;
  }

  void _createOrUpdateNote() {
    final isar = Provider.of<Isar>(context, listen: false);
    final jsonEncodedData =
        jsonEncode(widget.controller.document.toDelta().toJson());
    final contentInPlainText = widget.controller.document.toPlainText();

    if (widget.note == null) {
      createNote(isar, jsonEncodedData, contentInPlainText, _isNotePinned);
    } else {
      updateNote(isar, widget.note!, jsonEncodedData, contentInPlainText,
          _isNotePinned);
    }

    widget.controller.clear();
    Navigator.of(context).pop();
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
              width: 400.0,
              padding: const EdgeInsets.all(8.0),
              child: QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  customButtons: [
                    QuillToolbarCustomButtonOptions(
                      icon: const HIcon(),
                      tooltip: 'Heading',
                      onPressed: () {
                        final currentHeading = widget.controller
                            .getSelectionStyle()
                            .attributes[Attribute.h3.key];

                        if (currentHeading != null) {
                          widget.controller.formatSelection(
                              Attribute.clone(Attribute.h3, null));
                        } else {
                          widget.controller.formatSelection(Attribute.h3);
                        }
                      },
                    ),
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
                          widget.togglePinnedStatus!();
                        })
                  ],
                  controller: widget.controller,
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
                    controller: widget.controller,
                    sharedConfigurations: const QuillSharedConfigurations(
                        dialogBarrierColor: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.start,
      actions: <Widget>[
        TextButton(
          onPressed: _createOrUpdateNote,
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue[800],
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          child: const Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
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
        TextButton(
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
