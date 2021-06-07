import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/components/card.dart';
import 'package:notes/database/note.dart';
import 'package:notes/database/notes.dart';
import 'package:notes/screens/add_and_edit.dart';
import 'package:notes/screens/note_details.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
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
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: Search());
                }),
            SizedBox(width: 12)
          ],
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : notes.isEmpty
                  ? Text(
                      'No Notes',
                      style: TextStyle(color: Colors.white, fontSize: 24),
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
                          child: NoteCard(note: note, index: index),
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

class Search extends SearchDelegate<String> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: theme.primaryColor,
    );
  }

  late List<Note> notes = [];
  final win = ["Dan", "Sarah", "Nathan", "Philip", "Mum", "Dad", "Feli"];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionlist = query.isEmpty
        ? notes
        : notes
            .where((element) => Fields.title.toLowerCase().startsWith(query))
            .toList();
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(8),
      itemCount: suggestionlist.length,
      staggeredTileBuilder: (index) => StaggeredTile.fit(2),
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemBuilder: (context, index) {
        final note = notes[index];
        return GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoteDetailPage(noteId: note.id!),
            ));
            this.notes = await Notes.instance.readAll();
          },
          child: NoteCard(note: note, index: index),
        );
      },
    );
  }
}
