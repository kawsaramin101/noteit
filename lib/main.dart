import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes/data/note_model.dart';

import "package:notes/routes/home.dart";
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
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => const Home(),

          // "/settings": (context) => Settings(),
        },
        initialRoute: "/",
      ),
    ),
  );
}
