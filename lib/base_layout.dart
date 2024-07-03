import 'dart:convert';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/routes/home.dart';
import 'package:notes/routes/second.dart';
import 'package:notes/componants/new/note_form.dart';

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  final _formKey = GlobalKey<FormState>();

  final _quillController = QuillController.basic();

  bool _isNotePinned = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final hoverColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
    final pressColor = isDarkMode ? Colors.grey[600] : Colors.grey[400];
    final borderColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];

    final buttonColors = WindowButtonColors(
      iconNormal: iconColor,
      mouseOver: hoverColor,
      mouseDown: pressColor,
      iconMouseOver: iconColor,
      iconMouseDown: iconColor,
    );

    final closeButtonColors = WindowButtonColors(
      mouseOver: Colors.red,
      mouseDown: Colors.red[700],
      iconNormal: iconColor,
      iconMouseOver: Colors.white,
      iconMouseDown: Colors.white,
    );

    void showNoteForm() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0))),
            contentPadding: const EdgeInsets.all(0),
            actionsPadding: const EdgeInsets.fromLTRB(0.0, 12.0, 16.0, 16.0),
            content: NoteForm(
              formKey: _formKey,
              controller: _quillController,
              onPinnedChanged: (isNotePinned) {
                setState(() {
                  _isNotePinned = isNotePinned;
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                onPressed: () {
                  final json =
                      jsonEncode(_quillController.document.toDelta().toJson());
                  debugPrint("$json");
                  debugPrint("$_isNotePinned");
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          );
        },
      );
    }

    return Scaffold(
      body: WindowBorder(
        color: borderColor!,
        width: 1,
        child: Column(
          children: [
            SizedBox(
              height: 40.0,
              child: MoveWindow(
                child: Container(
                  color: backgroundColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.menu,
                              color: iconColor,
                              weight: 0.5,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: iconColor),
                            onPressed: showNoteForm,
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 350,
                        height: 32.0,
                        child: TextField(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[200],
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: iconColor,
                            ),
                            suffixIcon: Icon(Icons.search,
                                color: iconColor, size: 16.0),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 8.0,
                            ),
                          ),
                          style: TextStyle(
                            color: iconColor,
                            fontSize: 12.0,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 8.0),
                          WindowButtons(
                            buttonColors: buttonColors,
                            closeButtonColors: closeButtonColors,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Navigator(
                onGenerateRoute: (RouteSettings settings) {
                  WidgetBuilder builder;
                  switch (settings.name) {
                    case '/':
                      builder = (BuildContext context) => const Home();
                      break;
                    case '/second':
                      builder = (BuildContext context) => const SecondPage();
                      break;
                    default:
                      throw Exception('Invalid route: ${settings.name}');
                  }
                  return MaterialPageRoute(
                      builder: builder, settings: settings);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  final WindowButtonColors buttonColors;
  final WindowButtonColors closeButtonColors;
  final double size;

  const WindowButtons(
      {super.key,
      required this.buttonColors,
      required this.closeButtonColors,
      this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomMinimizeWindowButton(buttonColors: buttonColors, size: size),
        CustomMaximizeWindowButton(
          buttonColors: buttonColors,
          size: size,
        ),
        CustomCloseWindowButton(
          buttonColors: closeButtonColors,
          size: size,
        ),
      ],
    );
  }
}

class CustomMinimizeWindowButton extends StatelessWidget {
  final WindowButtonColors buttonColors;
  final double size;
  const CustomMinimizeWindowButton(
      {super.key, required this.buttonColors, required this.size});

  @override
  Widget build(BuildContext context) {
    return WindowButton(
      onPressed: () => appWindow.minimize(),
      colors: buttonColors,
      iconBuilder: (buttonContext) => FittedBox(
        fit: BoxFit.none,
        child: Icon(Icons.remove, size: size),
      ),
    );
  }
}

class CustomMaximizeWindowButton extends StatelessWidget {
  final WindowButtonColors buttonColors;
  final double size;
  const CustomMaximizeWindowButton(
      {super.key, required this.buttonColors, required this.size});

  @override
  Widget build(BuildContext context) {
    return WindowButton(
      onPressed: () => appWindow.maximizeOrRestore(),
      colors: buttonColors,
      iconBuilder: (buttonContext) => FittedBox(
        fit: BoxFit.none,
        child: Icon(Icons.crop_square, size: size),
      ),
    );
  }
}

class CustomCloseWindowButton extends StatelessWidget {
  final WindowButtonColors buttonColors;
  final double size;
  const CustomCloseWindowButton(
      {super.key, required this.buttonColors, required this.size});

  @override
  Widget build(BuildContext context) {
    return WindowButton(
      onPressed: () => appWindow.close(),
      colors: buttonColors,
      iconBuilder: (buttonContext) => FittedBox(
        fit: BoxFit.none,
        child: Icon(Icons.close, size: size),
      ),
    );
  }
}
