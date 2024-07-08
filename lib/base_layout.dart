import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/routes/home.dart';
import 'package:notes/componants/note_form.dart';
import 'package:yaru/yaru.dart';

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
    return Scaffold(
      appBar: YaruWindowTitleBar(
        backgroundColor: const Color(0xFF18191a),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            YaruIcons.menu,
          ),
        ),
        title: const SizedBox(
          width: 350,
          height: 34.0,
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              hintText: 'Search',
              prefixIcon: Icon(
                YaruIcons.search,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
            ),
            textAlignVertical: TextAlignVertical.center,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(YaruIcons.plus),
            onPressed: showNoteForm,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF18191a),
      body: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext context) => const Home();
              break;

            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }
}
