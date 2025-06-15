import 'package:flutter/material.dart';
import 'package:notes/componants/utils/floatingtext.dart';
import 'package:notes/data/edit_model.dart';
import 'package:notes/notifiers/theme_notifiers.dart';
import 'package:notes/state/note_notifier.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:isar/isar.dart';
import 'package:file_saver/file_saver.dart';
import '../../data/note_model.dart';
import 'dart:io';

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

  Future<void> exportNotesAsJson(Isar isar) async {
    final notes = await isar.notes.where().findAll();

    final List<Map<String, dynamic>> notesJson = [];

    for (final note in notes) {
      await note.edits.load();
      final loadedEdits = note.edits.toList();
      notesJson.add(note.toJson(loadedEdits));
    }

    final jsonString = jsonEncode(notesJson);
    final Uint8List bytes = Uint8List.fromList(utf8.encode(jsonString));

    final result = await FileSaver.instance.saveFile(
      name: "notes_export",
      bytes: bytes,
      ext: "json",
      mimeType: MimeType.json,
    );
    print(result);
  }

  void showImportNoteDialog() {
    showDialog(
      context: context,
      builder: (_) => JsonPathDialog(
        isImporting: true,
      ),
    ).then((importedPath) {
      if (importedPath != null) {
        importNotesFromJsonFile(importedPath);
        print('Importing from: $importedPath');
        // Handle import logic here
      }
    });
  }

  Future<void> importNotesFromJsonFile(String filePath) async {
    final isar = Provider.of<Isar>(context, listen: false);

    try {
      final file = File(filePath);

      if (!await file.exists()) {
        if (mounted) {
          showFloatingText(context, 'File does not exist at path: $filePath');
        }

        return;
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);

      int importedCount = 0;

      await isar.writeTxn(() async {
        for (var noteJson in jsonData) {
          final note = Note()
            ..id = Isar.autoIncrement
            ..pinned = noteJson['pinned'] ?? false
            ..order = noteJson['order'] ?? 0;

          await isar.notes.put(note);

          final editsJson = noteJson['edits'] as List<dynamic>? ?? [];
          for (var editJson in editsJson) {
            final edit = Edit()
              ..createdAt = DateTime.parse(editJson['createdAt'])
              ..content = editJson['content']
              ..note.value = note;

            await isar.edits.put(edit);
            note.edits.add(edit);
          }

          await note.edits.save();
          importedCount++;
        }
      });

      if (mounted) {
        showFloatingText(
            context, 'Import complete. Imported $importedCount new notes.');
      }

      if (mounted) {
        await context.read<NoteProvider>().loadNotes();
      }
    } catch (e) {
      if (mounted) {
        showFloatingText(context, 'Failed to import notes: $e');
      }
    }
  }

  void showDeleteAllDataDialog(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text(
              "Are you sure you want to delete all app data? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                clearDatabase();
              },
              child: const Text("Delete All"),
            ),
          ],
        );
      },
    );
  }

  Future<void> clearDatabase() async {
    final isar = Provider.of<Isar>(context, listen: false);

    await isar.writeTxn(() async {
      await isar.notes.clear();
      await isar.edits.clear();
    });

    if (mounted) {
      await context.read<NoteProvider>().loadNotes();
    }

    if (mounted) {
      showFloatingText(context, 'Deleted all data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isar = context.read<Isar>();

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
                        onPressed: () async {
                          await exportNotesAsJson(isar);
                        },
                        icon: const Icon(Icons.download_rounded),
                        label: const Text("Download Data"),
                      ),
                      const SizedBox(width: 10.0),
                      ElevatedButton.icon(
                        onPressed: () {
                          showImportNoteDialog();
                        },
                        icon: const Icon(Icons.upload_rounded),
                        label: const Text("Upload Data"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDeleteAllDataDialog(context, () {});
                    },
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

class JsonPathDialog extends StatefulWidget {
  final bool isImporting;
  final void Function(String path)? onExport;

  const JsonPathDialog({
    super.key,
    required this.isImporting,
    this.onExport,
  });

  @override
  State<JsonPathDialog> createState() => _JsonPathDialogState();
}

class _JsonPathDialogState extends State<JsonPathDialog> {
  final TextEditingController _jsonPathController = TextEditingController();
  String? _errorText;
  bool _isProcessing = false;

  Future<void> _handleSubmit() async {
    final path = _jsonPathController.text.trim();

    setState(() {
      _errorText = null;
      _isProcessing = true;
    });

    if (path.isEmpty) {
      setState(() {
        _errorText = 'Please enter a path';
        _isProcessing = false;
      });
      return;
    }

    if (!path.endsWith('.json')) {
      setState(() {
        _errorText = 'File must be a JSON file';
        _isProcessing = false;
      });
      return;
    }

    final file = File(path);

    if (widget.isImporting) {
      final exists = await file.exists();
      if (!exists) {
        setState(() {
          _errorText = 'File does not exist';
          _isProcessing = false;
        });
        return;
      }
      if (mounted) {
        Navigator.of(context).pop(path); // valid import path
      }
    } else {
      if (!await file.exists()) {
        await file.create(recursive: true);
      }
      widget.onExport?.call(path); // handle export
      if (mounted) {
        Navigator.of(context).pop(); // done
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isImporting ? 'Import JSON File' : 'Export JSON File'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _jsonPathController,
            decoration: InputDecoration(
              labelText: 'Path to JSON file',
              border: OutlineInputBorder(),
              errorText: _errorText,
            ),
          ),
          if (_isProcessing)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isProcessing ? null : _handleSubmit,
          child: Text('OK'),
        ),
      ],
    );
  }
}
