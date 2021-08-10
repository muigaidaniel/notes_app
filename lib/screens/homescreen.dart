import 'package:animations/animations.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/components/backcard.dart';
import 'package:notes/components/card.dart';
import 'package:notes/database/note.dart';
import 'package:notes/database/notes.dart';
import 'package:notes/screens/add_and_edit.dart';
import 'package:notes/screens/note_details.dart';
import 'package:showcaseview/showcaseview.dart';

class Homescreen extends StatefulWidget {
  final Note? note;

  const Homescreen({Key? key, this.note}) : super(key: key);
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    //firstNote();
    refreshNotes();
  }

  void firstNote() {
    final note = Note(
      title: 'Example',
      favourite: false,
      number: 1,
      content: 'This is an example of a note',
      created: DateTime.now(),
    );

    Notes.instance.create(note);
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);
    this.notes = await Notes.instance.readAll();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Notes',
            style: TextStyle(fontSize: 24),
          ),
          centerTitle: true,
          /*actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            SizedBox(width: 12)
          ],*/
        ),
        body: Center(
          child: isLoading
              ? SpinKitRotatingCircle(
                  color: Colors.deepOrange,
                )
              : notes.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No notes here',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              'Tip:Long press on a note to see the magic!',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    )
                  : StaggeredGridView.countBuilder(
                      padding: EdgeInsets.all(8),
                      itemCount: notes.length,
                      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
                      crossAxisCount: 4,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  NoteDetailPage(noteId: note.id!),
                            ));
                            refreshNotes();
                          },
                          child: FlipCard(
                            back: BackNoteCard(note: note, index: index),
                            front: NoteCard(note: note, index: index),
                          ),
                        );
                      },
                    ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddEditNotePage()),
            );
            refreshNotes();
          },
        ),
      );
}
