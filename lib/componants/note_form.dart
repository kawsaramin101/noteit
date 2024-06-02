import 'package:flutter/material.dart';

import 'package:notes/data/note.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteForm extends StatefulWidget {
  final Note? note;

  const NoteForm({super.key, this.note});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final Box<Note> noteBox = Hive.box<Note>('notes');
  final TextEditingController _contentController = TextEditingController();

  void _addNote() {
    addNote(
      content: _contentController.text,
    );
    _contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 450,
          height: 175,
          child: TextFormField(
            controller: _contentController,
            autofocus: true,
            autocorrect: false,
            maxLines: null,
            minLines: 5,
            expands: false,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: 'What\'s on your mind?',
              hintStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Center(
          child: TextButton(
            onPressed: _addNote,
            style: TextButton.styleFrom(
              backgroundColor:
                  Colors.blue, // Bright color for button background
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text(
              widget.note != null ? "Add" : "Edit",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
