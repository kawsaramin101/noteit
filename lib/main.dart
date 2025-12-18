import 'package:flutter/material.dart';
import './notifiers/search_notifiers.dart';
import './notifiers/theme_notifiers.dart';
import './state/note_notifier.dart';

import 'package:isar/isar.dart';
import './base_layout.dart';
import './data/edit_model.dart';
import './data/note_model.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() async {
  // await YaruWindowTitleBar.ensureInitialized();

  String dbName = "note_it_isar_db";

  if (kReleaseMode) {
    dbName = "note_it_isar_db";
  } else if (kDebugMode) {
    dbName = "note_it_kDebugMode_db";
  } else if (kProfileMode) {
    dbName = "note_it_kProfileMode_db";
  }

  print(dbName);

  final Directory appDir = await getApplicationSupportDirectory();

  final isar = await Isar.open(
    [NoteSchema, EditSchema],
    directory: appDir.path,
    name: dbName,
  );

  // TODone: Add xdg_directories package to get right path for the db (used getApplicationSupportDirectory from path_provider)
  // TODO: add settings page
  //       -light mode/dark mode/system
  //       -pinned notes? (DONE)
  // TODone: app crashes on quill paste - doesn't crash on release build
  // TODone: download and upload data - show confirmation
  // TODO: select note
  // TODone: fix keyboard shortcut conflicting when click ctrl+a in search field
  // Colored note?
  // Labeled note?
  // TODO: Fix reordering issue
  // TODO: fix pinning issue

  runApp(
    WindowBorder(
      color: const Color(0xFF2b2c2d),
      width: 1,
      child: MainWidget(
        isar: isar,
      ),
    ),
  );

  doWhenWindowReady(() {
    const initialSize = Size(900, 600);
    // appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    // appWindow.alignment = Alignment.center;
    appWindow.show();
  });
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
            provider.loadNotes();
            return provider;
          },
        ),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return MaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              quill.FlutterQuillLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
            ],
            home: const BaseLayout(),
            theme: _buildTheme(
              ThemeData.light(useMaterial3: true),
              Brightness.light,
            ),
            darkTheme: _buildTheme(
              ThemeData.dark(useMaterial3: true),
              Brightness.dark,
            ),
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
