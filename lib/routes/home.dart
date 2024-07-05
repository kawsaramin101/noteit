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
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 12.0,
          ),
          NoteList(),
        ],
      ),
    );
  }
}
