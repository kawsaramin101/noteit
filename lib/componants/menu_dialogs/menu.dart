import 'package:flutter/material.dart';
import '../../componants/menu_dialogs/keyboard_shortcuts_dialog.dart';
import '../../componants/menu_dialogs/settings_dialog.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  void showSettings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SettingsDialog();
      },
    );
  }

  void showKeyboardShortcutsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const KeyboardShortcutsDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
          splashRadius: 20.0,
          iconSize: 20, // Added this
          icon: const Icon(
            Icons.menu,
            size: 20, // Added this
          ),
          tooltip: 'Show menu',
        );
      },
      menuChildren: [
        MenuItemButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
          ),
          onPressed: showSettings,
          leadingIcon: const Icon(Icons.settings),
          child: const Text('Settings'),
        ),
        MenuItemButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
          ),
          onPressed: showKeyboardShortcutsDialog,
          leadingIcon: const Icon(Icons.keyboard),
          child: const Text('Keyboard Shortcuts'),
        ),
        MenuItemButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
          ),
          onPressed: () => {},
          leadingIcon: const Icon(Icons.info_rounded),
          child: const Text('About'),
        ),
      ],
    );
  }
}
