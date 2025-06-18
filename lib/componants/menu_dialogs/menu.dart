import 'package:flutter/material.dart';
import '../../componants/menu_dialogs/keyboard_shortcuts_dialog.dart';
import '../../componants/menu_dialogs/settings_dialog.dart';
import 'package:yaru/yaru.dart';

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
            constraints: const BoxConstraints(maxHeight: 10.0, maxWidth: 10.0),
            splashRadius: 20.0,
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
            onPressed: showSettings,
            leadingIcon: const Icon(YaruIcons.settings),
            child: const Text('Settings'),
          ),
          MenuItemButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
            ),
            onPressed: showKeyboardShortcutsDialog,
            leadingIcon: const Icon(YaruIcons.keyboard_shortcuts),
            child: const Text('Keyboard Shortcuts'),
          ),
          MenuItemButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(const EdgeInsets.all(16.0)),
            ),
            onPressed: () => {},
            leadingIcon: const Icon(YaruIcons.information),
            child: const Text('About'),
          ),
        ]);
  }
}
