import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import './componants/menu_dialogs/menu.dart';
import './notifiers/search_notifiers.dart';
import './routes/home.dart';
import './componants/note_form.dart';
import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

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
          LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
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
              backgroundColor: isDarkMode
                  ? const Color(0xFF18191a)
                  : const Color(0xFFF7F7F7),
              body: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 0.5),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 48, // Set height here
                      child: WindowTitleBarBox(
                        child: Container(
                          color: isDarkMode
                              ? const Color(0xFF28292A)
                              : const Color(0xFFF0F0F0),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Menu(),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 20),
                                      onPressed: showNoteForm,
                                      tooltip: "Create note",
                                      padding: const EdgeInsets.all(8),
                                      constraints: const BoxConstraints(),
                                      iconSize: 20,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: MoveWindow(
                                  child: Center(
                                    child: SizedBox(
                                      width: 450,
                                      height: 36.0,
                                      child: TextField(
                                        controller: _searchController,
                                        focusNode: _searchFocusNode,
                                        onChanged: onSearchChanged,
                                        style: const TextStyle(fontSize: 14),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: isDarkMode
                                              ? const Color(0xFF3A3B3C)
                                              : const Color(0xFFFFFFFF),
                                          hintText: 'Search',
                                          hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: isDarkMode
                                                ? Colors.grey[500]
                                                : Colors.grey[600],
                                          ),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            size: 20,
                                            color: isDarkMode
                                                ? Colors.grey[500]
                                                : Colors.grey[600],
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 12.0,
                                            vertical: 10.0,
                                          ),
                                          isDense: true,
                                        ),
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Window buttons (non-draggable)
                              WindowButtons(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Home(),
                    ),
                  ],
                ),
              ),
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

class WindowButtons extends StatefulWidget {
  const WindowButtons({super.key});

  @override
  State<WindowButtons> createState() => _WindowButtonsState();
}

class _WindowButtonsState extends State<WindowButtons> {
  void maximizeOrRestore() {
    setState(() {
      appWindow.maximizeOrRestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black87;

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove, size: 15),
          color: iconColor,
          hoverColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
          // splashRadius: 14,
          onPressed: () => appWindow.minimize(),
        ),
        IconButton(
          icon: Icon(
            appWindow.isMaximized ? Icons.fullscreen_exit : Icons.crop_square,
            size: 15,
          ),
          color: iconColor,
          hoverColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
          // splashRadius: 14,
          onPressed: maximizeOrRestore,
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 15),
          color: iconColor,
          hoverColor: const Color(0xFFD32F2F),
          // splashRadius: 14,
          onPressed: () => appWindow.close(),
        ),
      ],
    );
  }
}
