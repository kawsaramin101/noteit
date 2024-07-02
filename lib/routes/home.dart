import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:notes/componants/note_list.dart';
import 'package:notes/componants/new/note_form.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  final _quillController = QuillController.basic();
  bool _isNotePinned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                contentPadding: const EdgeInsets.all(0),
                actionsPadding:
                    const EdgeInsets.fromLTRB(0.0, 12.0, 16.0, 16.0),
                content: NoteForm(
                  formKey: _formKey,
                  controller: _quillController,
                  onPinnedChanged: (isNotePinned) {
                    setState(() {
                      _isNotePinned = isNotePinned;
                    });
                  },
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      final json = jsonEncode(
                          _quillController.document.toDelta().toJson());
                      debugPrint("$json");
                      debugPrint("$_isNotePinned");
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: const Text(
                      "Save",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: const Column(
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          // NoteForm(),
          SizedBox(
            height: 16.0,
          ),
          // NoteList(),
        ],
      ),
    );
  }
}
