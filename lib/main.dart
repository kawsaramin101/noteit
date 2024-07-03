import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes/base_layout.dart';
import 'package:notes/data/note_model.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // await Hive.initFlutter();
  // Hive.registerAdapter(NoteAdapter());
  // await Hive.openBox<Note>('notes');

  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [NoteSchema],
    directory: dir.path,
  );

  // TODO: Keyboard shortcut to save a note
  // TODO: add a top search bar
  // TODO: add settings page
  //       -light mode/dark mode/system
  //       -title field
  //       -pinned notes?
  //       -

  runApp(
    MultiProvider(
      providers: [
        Provider<Isar>.value(value: isar),
      ],
      child: MaterialApp(
        home: const BaseLayout(),
        darkTheme: ThemeData(
          textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 24.0, fontWeight: FontWeight.w200),
            displayMedium:
                TextStyle(fontSize: 20.0, fontWeight: FontWeight.w200),
            displaySmall:
                TextStyle(fontSize: 16.0, fontWeight: FontWeight.w200),
            headlineLarge:
                TextStyle(fontSize: 14.0, fontWeight: FontWeight.w200),
            headlineMedium:
                TextStyle(fontSize: 12.0, fontWeight: FontWeight.w200),
            headlineSmall:
                TextStyle(fontSize: 10.0, fontWeight: FontWeight.w200),
            titleLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
            titleMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100),
            titleSmall: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w100),
            bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
            bodyMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100),
            bodySmall: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w100),
            labelLarge: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100),
            labelMedium: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w100),
            labelSmall: TextStyle(fontSize: 8.0, fontWeight: FontWeight.w100),
          ),
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );

  doWhenWindowReady(() {
    const initialSize = Size(1000, 750);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}
