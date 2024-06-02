import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import "package:notes/routes/home.dart";
import 'package:notes/data/note.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');

  // TODO: add a top search bar
  // TODO: add settings page
  //       -light mode/dark mode/system
  //       -title field
  //       -pinned notes?
  //       -

  runApp(MaterialApp(
    routes: {
      "/": (context) => const Home(),

      // "/settings": (context) => Settings(),
    },
  ));
}
