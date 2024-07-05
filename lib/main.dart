import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:notes/base_layout.dart';
import 'package:notes/data/note_model.dart';

import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
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

  runApp(MainWidget(
    isar: isar,
  ));

  doWhenWindowReady(() {
    const initialSize = Size(1000, 750);
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

          darkTheme: ThemeData(
            // textTheme: Theme.of(context).textTheme.apply(
            //       bodyColor: Colors.pink[400],
            //       displayColor: Colors.pink[400],
            //     ),
            // textTheme: TextTheme(
            //   displayLarge:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[400]),
            //   displayMedium:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   displaySmall:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   headlineLarge:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   headlineMedium:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   headlineSmall:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   titleLarge:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   titleMedium:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   titleSmall:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   bodyLarge:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   bodyMedium:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   bodySmall:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   labelLarge:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   labelMedium:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            //   labelSmall:
            //       TextStyle(fontWeight: fontWeight, color: Colors.grey[100]),
            // ),
            brightness: Brightness.dark,
          ),
          themeMode: ThemeMode.dark,
          // theme: ThemeData(
          //   useMaterial3: true,
          // ),
          debugShowCheckedModeBanner: false,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.05),
              ),
              child: child!,
            );
          },
        ));
  }
}
