import 'package:flutter/material.dart';
import 'package:notes/componants/note_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1E1F20),
      body: Column(
        children: <Widget>[
          NoteList(),
        ],
      ),
    );
  }
}
