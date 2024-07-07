import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/routes/home.dart';
import 'package:notes/componants/note_form.dart';

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  final _quillController = QuillController.basic();

  bool _isNotePinned = false;

  void showNoteForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteForm(
          controller: _quillController,
          isNotePinned: _isNotePinned,
          togglePinnedStatus: () {
            debugPrint("RUn");
            setState(() {
              _isNotePinned = !_isNotePinned;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDarkMode = theme.brightness == Brightness.dark;
    // final backgroundColor = isDarkMode ? Colors.grey[850] : Colors.white;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final hoverColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];
    final pressColor = isDarkMode ? Colors.grey[600] : Colors.grey[400];
    final borderColor = isDarkMode ? Colors.grey[800] : Colors.grey[300];

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

    return Scaffold(
      body: WindowBorder(
        color: borderColor!,
        child: Column(
          children: [
            Container(
              color: const Color(0xFF1b1e20),
              height: 40.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  Expanded(child: MoveWindow()),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 350,
                      height: 34.0,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          hintText: 'Search',
                          prefixIcon:
                              Icon(Icons.search, color: iconColor, size: 18.0),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                      ),
                    ),
                  ),
                  Expanded(child: MoveWindow()),
                  WindowButtons(
                    buttonColors: buttonColors,
                    closeButtonColors: closeButtonColors,
                  ),
                ],
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
      this.size = 18});

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
