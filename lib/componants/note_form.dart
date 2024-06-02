import 'package:flutter/material.dart';

import 'package:notes/data/note.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NoteForm extends StatefulWidget {
  final Note? note;
  final BuildContext? dialogContext;

  const NoteForm({super.key, this.note, this.dialogContext});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final Box<Note> noteBox = Hive.box<Note>('notes');
  TextEditingController? _contentController;

  @override
  void initState() {
    super.initState();
    _contentController =
        TextEditingController(text: widget.note?.content ?? "");
  }

  void _addNote() {
    if (widget.note == null) {
      addNote(
        content: _contentController?.text,
      );
    } else {
      final note = noteBox.get(widget.note?.key);
      if (note != null) {
        noteBox.put(
          widget.note?.key,
          Note(
            title: note.title,
            content: _contentController?.text,
            createdAt: note.createdAt,
            order: note.order,
            pinned: note.pinned,
            parent: note.parent,
          ),
        );
      }
      Navigator.of(context).pop();
    }

    _contentController?.clear();
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
              widget.note == null ? "Add" : "Save",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
