import 'package:flutter/material.dart';
import 'package:notes/notifiers/theme_notifiers.dart';
import 'package:provider/provider.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  ThemeModeOption _selectedThemeMode = ThemeModeOption.systemDefault;

  String _getThemeModeText(ThemeModeOption themeMode) {
    switch (themeMode) {
      case ThemeModeOption.systemDefault:
        return 'System Default';
      case ThemeModeOption.darkMode:
        return 'Dark Mode';
      case ThemeModeOption.lightMode:
        return 'Light Mode';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0))),
      contentPadding: const EdgeInsets.all(0),
      actionsPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 0.0, 16.0),
      titleTextStyle: const TextStyle(fontSize: 20.0),
      title: const Center(child: Text("Settings")),
      content: SizedBox(
        width: 400.0,
        height: 300.0,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Theme mode",
                    style: TextStyle(color: Colors.white),
                  ),
                  DropdownButton<ThemeModeOption>(
                    value: _selectedThemeMode,
                    onChanged: (ThemeModeOption? newValue) {
                      setState(() {
                        _selectedThemeMode = newValue!;
                      });
                      if (newValue != null) {
                        themeNotifier.themeMode = newValue;
                      }
                    },
                    items: ThemeModeOption.values.map((ThemeModeOption value) {
                      return DropdownMenuItem<ThemeModeOption>(
                        value: value,
                        child: Text(_getThemeModeText(value)),
                      );
                    }).toList(),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download_rounded),
                        label: const Text("Download Data"),
                      ),
                      const SizedBox(width: 10.0),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.upload_rounded),
                        label: const Text("Upload Data"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Delete all data"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.start,
      actions: <Widget>[
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.red,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Defaults',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[800],
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
