import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/notifiers/search_notifiers.dart';
import 'package:notes/routes/home.dart';
import 'package:notes/componants/note_form.dart';
import 'package:provider/provider.dart';
import 'package:yaru/yaru.dart';

class BaseLayout extends StatefulWidget {
  const BaseLayout({super.key});

  @override
  State<BaseLayout> createState() => _BaseLayoutState();
}

class _BaseLayoutState extends State<BaseLayout> {
  Timer? _debounce;
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
    final searchNotifierProvider = Provider.of<SearchNotifierProvider>(context);

    void onSearchChanged(String newValue) {
      if (newValue.isEmpty) {
        searchNotifierProvider.valueNotifier.value = newValue;
        _debounce?.cancel();
      } else {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () {
          searchNotifierProvider.valueNotifier.value = newValue;
        });
      }
    }

    return Scaffold(
      appBar: YaruWindowTitleBar(
        backgroundColor: const Color(0xFF28292A),
        leading: MenuAnchor(
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return YaruIconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(
                  YaruIcons.menu,
                ),
                tooltip: 'Show menu',
              );
            },
            menuChildren: [
              MenuItemButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
                ),
                onPressed: () => {},
                leadingIcon: const Icon(YaruIcons.settings),
                child: const Text('Settings'),
              ),
              MenuItemButton(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
                ),
                onPressed: () => {},
                leadingIcon: const Icon(YaruIcons.information),
                child: const Text('About'),
              ),
            ]),
        title: SizedBox(
          width: 350,
          height: 34.0,
          child: TextField(
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
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
          YaruIconButton(
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
