import 'package:flutter/material.dart';
import 'package:notes/notifiers/search_notifiers.dart';
import 'package:notes/notifiers/theme_notifiers.dart';
import 'package:notes/state/note_notifier.dart';

import 'package:yaru/yaru.dart';

import 'package:isar/isar.dart';
import 'package:notes/base_layout.dart';
import 'package:notes/data/edit_model.dart';
import 'package:notes/data/note_model.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';

void main() async {
  await YaruWindowTitleBar.ensureInitialized();

  String dbName = "note_it_isar_db";

  if (kReleaseMode) {
    dbName = "note_it_isar_db";
  } else if (kDebugMode) {
    dbName = "note_it_kDebugMode_db";
  } else if (kProfileMode) {
    dbName = "note_it_kProfileMode_db";
  }

  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [NoteSchema, EditSchema],
    directory: dir.path,
    name: dbName,
  );

  // TODO: Add xdg_directories package to get right path for the db
  // TODO: add settings page
  //       -light mode/dark mode/system
  //       -pinned notes? (DONE)
  // TODone: app crashes on quill paste - doesn't crash on release build
  // TODone: download and upload data - show confirmation
  // TODO: select note
  // TODone: fix keyboard shortcut conflicting when click ctrl+a in search field
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
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
        ChangeNotifierProvider<NoteProvider>(
          create: (context) {
            final isar = context.read<Isar>();
            final provider = NoteProvider(isar);
            provider.loadNotes(); // Load initial notes
            return provider;
          },
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return YaruTheme(
            data: const YaruThemeData(
              themeMode: ThemeMode.dark,
              useMaterial3: true,
            ),
            builder: (context, yaru, child) {
              final ThemeData lightTheme = yaru.theme ?? ThemeData.light();
              final ThemeData darkTheme = yaru.darkTheme ?? ThemeData.dark();

              return MaterialApp(
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  quill.FlutterQuillLocalizations
                      .delegate, // <-- This is the required line
                ],
                supportedLocales: const [
                  Locale('en'), // Or any locales your app supports
                  // Add more locales if you need
                ],
                home: const BaseLayout(),
                theme: _buildTheme(lightTheme, Brightness.light),
                darkTheme: _buildTheme(darkTheme, Brightness.dark),
                themeMode: _getThemeMode(themeNotifier),
                debugShowCheckedModeBanner: false,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(0.9),
                    ),
                    child: child!,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  ThemeMode _getThemeMode(ThemeNotifier themeNotifier) {
    switch (themeNotifier.themeMode) {
      case ThemeModeOption.darkMode:
        return ThemeMode.dark;
      case ThemeModeOption.lightMode:
        return ThemeMode.light;
      case ThemeModeOption.systemDefault:
        return ThemeMode.system;
    }
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
