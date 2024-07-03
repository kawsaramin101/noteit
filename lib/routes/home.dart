import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 8.0,
          ),
          // NoteForm(),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              child: Text("Go to second page")),
          const SizedBox(
            height: 16.0,
          ),
          // NoteList(),
        ],
      ),
    );
  }
}
