import 'package:flutter/material.dart';
import 'package:notes/components/form.dart';
import 'package:notes/database/note.dart';
import 'package:notes/database/notes.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;

  const AddEditNotePage({
    Key? key,
    this.note,
  }) : super(key: key);
  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool favourite;
  late int number;
  late String title;
  late String content;

  @override
  void initState() {
    super.initState();

    favourite = widget.note?.favourite ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    content = widget.note?.content ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: NoteForm(
            favourite: favourite,
            number: number,
            title: title,
            content: content,
            onChangedFavourite: (favourite) =>
                setState(() => this.favourite = favourite),
            onChangedNumber: (number) => setState(() => this.number = number),
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedContent: (content) =>
                setState(() => this.content = content),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && content.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateNote,
        child: Text('Save'),
      ),
    );
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      final isUpdating = widget.note != null;
      if (isUpdating) {
        await addNote();
      } else {
        await addNote();
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  Future updateNote() async {
    final note = widget.note!.copy(
      favourite: favourite,
      number: number,
      title: title,
      content: content,
    );
    await Notes.instance.update(note);
  }

  Future addNote() async {
    final note = Note(
      title: title,
      favourite: favourite,
      number: number,
      content: content,
      created: DateTime.now(),
    );

    await Notes.instance.create(note);
  }
}
