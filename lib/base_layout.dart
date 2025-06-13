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

  final FocusNode _scaffoldFocusNode = FocusNode();
  final FocusNode _searchFocusNode = FocusNode();

  late BuildContext noteFormDialogContext;

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

  void _focusOrUnfocusSearchField() {
    try {
      if (_searchFocusNode.hasFocus) {
        _searchFocusNode.unfocus();
        _scaffoldFocusNode.requestFocus();
      } else {
        _searchFocusNode.requestFocus();
      }
    } catch (e) {
      debugPrint("Error focusing/unfocusing search field: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: {
        OpenNoteFormIntent: CallbackAction<OpenNoteFormIntent>(
          onInvoke: (intent) {
            showNoteForm();
            return null;
          },
        ),
        FocusOrUnfocusSearchFieldIntent:
            CallbackAction<FocusOrUnfocusSearchFieldIntent>(onInvoke: (intent) {
          _focusOrUnfocusSearchField();
          return null;
        })
      },
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyA):
              const OpenNoteFormIntent(),
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF):
              const FocusOrUnfocusSearchFieldIntent(),
        },
        child: Focus(
          autofocus: true,
          focusNode: _scaffoldFocusNode,
          child: Builder(builder: (BuildContext context) {
            final theme = Theme.of(context);
            final isDarkMode = theme.brightness == Brightness.dark;

            return Scaffold(
              appBar: YaruWindowTitleBar(
                titleSpacing: 0.0,
                backgroundColor: isDarkMode
                    ? const Color(0xFF28292A)
                    : const Color(0xFFF0F0F0),
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
                          contentPadding:
                              EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
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
          }),
        ),
      ),
    );
  }
}

class OpenNoteFormIntent extends Intent {
  const OpenNoteFormIntent();
}

class FocusOrUnfocusSearchFieldIntent extends Intent {
  const FocusOrUnfocusSearchFieldIntent();
}
