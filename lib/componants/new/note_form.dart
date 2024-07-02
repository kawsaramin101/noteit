import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class NoteForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final QuillController controller;
  final ValueChanged<bool> onPinnedChanged;

  const NoteForm({
    super.key,
    required this.formKey,
    required this.controller,
    required this.onPinnedChanged,
  });

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  bool notePinned = false;
  bool isHeadingSelected = true;

  void togglePinnedStatus() {
    setState(() {
      notePinned = !notePinned;
    });
    widget.onPinnedChanged(notePinned);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                      notePinned ? Icons.push_pin : Icons.push_pin_outlined,
                      size: 20.0,
                    ),
                    tooltip: notePinned ? "Unpin Note" : "Pin Note",
                    onPressed: togglePinnedStatus,
                  )
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
