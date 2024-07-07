import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes/base_layout.dart';
import 'package:notes/data/edit_model.dart';
import 'package:notes/data/note_model.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [NoteSchema, EditSchema],
    directory: dir.path,
  );

  // await clearDatabase(isar);

  // TODO: Keyboard shortcut to save a note
  // TODO: implement search
  // TODO: add settings page
  //       -light mode/dark mode/system
  //       -title field
  //       -pinned notes?
  // TODO: implement order changing when pining/unpinning
  // TODO: Delete parent and edits after deleting a note

  runApp(MainWidget(
    isar: isar,
  ));

  doWhenWindowReady(() {
    const initialSize = Size(1200, 750);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MainWidget extends StatelessWidget {
  final Isar isar;
  const MainWidget({super.key, required this.isar});

  // Color? textColor = Colors.blueGrey[100];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Isar>.value(value: isar),
      ],
      child: MaterialApp(
        home: const BaseLayout(),
        theme: _buildTheme(Brightness.light),
        darkTheme: _buildTheme(Brightness.dark),
        themeMode: ThemeMode.dark,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.05),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}

ThemeData _buildTheme(brightness) {
  const fontWeight = FontWeight.w300;

  return ThemeData(
      brightness: brightness,
      fontFamily: 'NotoSans',
      splashFactory: NoSplash.splashFactory,
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontWeight: fontWeight),
        displayMedium: TextStyle(fontWeight: fontWeight),
        displaySmall: TextStyle(fontWeight: fontWeight),
        headlineLarge: TextStyle(fontWeight: fontWeight),
        headlineMedium: TextStyle(fontWeight: fontWeight),
        headlineSmall: TextStyle(fontWeight: fontWeight),
        titleLarge: TextStyle(fontWeight: fontWeight),
        titleMedium: TextStyle(fontWeight: fontWeight),
        titleSmall: TextStyle(fontWeight: fontWeight),
        bodyLarge: TextStyle(fontWeight: fontWeight),
        bodyMedium: TextStyle(fontWeight: fontWeight),
        bodySmall: TextStyle(fontWeight: fontWeight),
        labelLarge: TextStyle(fontWeight: fontWeight),
        labelMedium: TextStyle(fontWeight: fontWeight),
        labelSmall: TextStyle(fontWeight: fontWeight),
      ));
}

Future<void> clearDatabase(Isar isar) async {
  await isar.writeTxn(() async {
    await isar.notes.clear();
    await isar.edits.clear();
  });
}
