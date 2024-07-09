import 'package:flutter/material.dart';
import 'package:notes/notifiers/search_notifiers.dart';

import 'package:yaru/yaru.dart';

import 'package:isar/isar.dart';
import 'package:notes/base_layout.dart';
import 'package:notes/data/edit_model.dart';
import 'package:notes/data/note_model.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  await YaruWindowTitleBar.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [NoteSchema, EditSchema],
    directory: dir.path,
  );

  // await clearDatabase(isar);

  // TODO: Keyboard shortcut to save a note
  // TODO: add settings page
  //       -light mode/dark mode/system
  //       -title field
  //       -pinned notes?
  // TODO: Delete parent and edits after deleting a note
  // TODO: app crashes on quill paste
  // Colored note?
  // Labeled note?

  runApp(MainWidget(
    isar: isar,
  ));
}

class MainWidget extends StatelessWidget {
  final Isar isar;
  const MainWidget({super.key, required this.isar});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Isar>.value(value: isar),
        Provider<SearchNotifierProvider>(
          create: (_) => SearchNotifierProvider(),
        ),
      ],
      child: YaruTheme(
          data: const YaruThemeData(
              themeMode: ThemeMode.dark, useMaterial3: true),
          builder: (context, yaru, child) {
            final ThemeData lightTheme = yaru.theme ?? ThemeData.light();
            final ThemeData darkTheme = yaru.darkTheme ?? ThemeData.dark();

            return MaterialApp(
              home: const BaseLayout(),
              theme: _buildTheme(lightTheme, Brightness.light),
              darkTheme: _buildTheme(darkTheme, Brightness.dark),
              themeMode: ThemeMode.dark,
              debugShowCheckedModeBanner: false,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  child: child!,
                );
              },
            );
          }),
    );
  }
}

ThemeData _buildTheme(ThemeData base, Brightness brightness) {
  const String fontFamily = 'RobotoMono';

  return base.copyWith(
    brightness: brightness,
    splashFactory: NoSplash.splashFactory,
    textTheme: Typography().white.apply(
          fontFamily: fontFamily,
        ),
  );
}

Future<void> clearDatabase(Isar isar) async {
  await isar.writeTxn(() async {
    await isar.notes.clear();
    await isar.edits.clear();
  });
}
