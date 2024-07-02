import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final QuillController _controller = QuillController.basic();

  void applyH3Style() {
    const Attribute attribute = Attribute.h3;

    if (_controller.selection.baseOffset ==
        _controller.selection.extentOffset) {
      _controller.formatText(0, _controller.document.length, attribute);
    } else {
      _controller.formatSelection(attribute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QuillToolbar.simple(
          configurations: QuillSimpleToolbarConfigurations(
            customButtons: [
              QuillToolbarCustomButtonOptions(
                icon: const HIcon(),
                tooltip: 'Heading',
                onPressed: applyH3Style,
              ),
            ],
            controller: _controller,
            sharedConfigurations: const QuillSharedConfigurations(),
            showHeaderStyle: false,
          ),
        ),
        Expanded(
          child: QuillEditor.basic(
            configurations: QuillEditorConfigurations(
              controller: _controller,
              sharedConfigurations: const QuillSharedConfigurations(),
            ),
          ),
        )
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
            fontSize: size * 0.7,
            fontWeight: FontWeight.bold,
            color: IconTheme.of(context).color,
          ),
        ),
      ),
    );
  }
}
