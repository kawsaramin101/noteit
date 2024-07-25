import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/componants/menu_dialogs/menu.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final _quillController = QuillController.basic();

  late SearchNotifierProvider searchNotifierProvider;
  final FocusNode _searchFocusNode = FocusNode();

  bool _isNotePinned = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    searchNotifierProvider = Provider.of<SearchNotifierProvider>(context);
  }

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

  void _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (/*event.logicalKey == LogicalKeyboardKey.control &&*/
          event.logicalKey == LogicalKeyboardKey.keyA) {
        showNoteForm();
      } else if (event.logicalKey == LogicalKeyboardKey.keyF) {
        _searchFocusNode.requestFocus();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        debugPrint('Right arrow pressed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: YaruWindowTitleBar(
        titleSpacing: 0.0,
        backgroundColor: const Color(0xFF28292A),
        leading: const Menu(),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            YaruIconButton(
              icon: const Icon(YaruIcons.plus),
              onPressed: showNoteForm,
              tooltip: "Create note",
            ),
            SizedBox(
              width: 350,
              height: 34.0,
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
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
            const SizedBox(
              width: 8.0,
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF18191a),
      body: const Home(),
    );
  }
}
