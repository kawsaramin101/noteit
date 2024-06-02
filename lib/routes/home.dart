import 'package:flutter/material.dart';

import 'package:notes/componants/note_list.dart';
import 'package:notes/componants/note_form.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: const Column(
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          NoteForm(),
          SizedBox(
            height: 16.0,
          ),
          NoteList(),
        ],
      ),
    );
  }
}
