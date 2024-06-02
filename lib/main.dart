import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import "package:notes/routes/home.dart";
import 'package:notes/data/note.dart';
import 'package:notes/routes/test.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');

  runApp(MaterialApp(
    routes: {
      "/": (context) => const Home(),
      "/home": (context) => const Test(),

      // "/settings": (context) => ChooseLocation(),
    },
  ));
}
