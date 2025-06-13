import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuillTest extends StatefulWidget {
  const QuillTest({super.key});

  @override
  State<QuillTest> createState() => _QuillTestState();
}

class _QuillTestState extends State<QuillTest> {
  final _quillController = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        // decoration: const BoxDecoration(
        //   border: Border(
        //     top: BorderSide(width: 0.8, color: Color.fromRGBO(97, 97, 97, 1)),
        //     bottom:
        //         BorderSide(width: 0.8, color: Color.fromRGBO(97, 97, 97, 1)),
        //   ),
        // ),
        child: QuillEditor.basic(
          controller: _quillController,
          config: const QuillEditorConfig(
            autoFocus: true,
            disableClipboard: true,
            dialogTheme: QuillDialogTheme(
              dialogBackgroundColor: Colors.white,
            ),

            // sharedConfig: QuillSharedConfigurations(

            // ),
          ),
        ),
      ),
    );
  }
}
