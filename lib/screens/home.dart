import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nid_notes/arguments/editnote.dart';
import 'package:nid_notes/helper/database.dart';
import 'package:nid_notes/blocs/user_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nid_notes/models/note.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Lista di oggetti mappa stringa per il primo valore e dynamic per il secondo.
  List<Map<String, dynamic>> notes = [];

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Ciao ' + userBloc.currentUser!.username! ),
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  userBloc.logout();
                  Navigator.of(context).pushReplacementNamed('/login');
                },
              ),
            ],
          ),
        ),
      appBar: AppBar(
        title: Text('Home'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/insert');
        },
      ),
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: _gridView(),
            ),
          ),

        ],
      ),
    );
  }

  //Metodo che istanzia il dbhelper(della cartella helper)
  //interroga il dp ed estrae tutti gli oggetti che ci sono, tutte mappe chiave-valore
  refreshList() async {
    DatabaseHelper db = DatabaseHelper();
    notes = await db.queryAllRows();
    setState(() {});//set state solo per refresh della schermata
  }

  Widget _imageContainer(String? _imagePath) {
    if (_imagePath != null) {
      return Image.memory(base64.decode(_imagePath));
    }
    return SizedBox.shrink();
  }

  Widget _gridView() {
    return new StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: notes.length,
      itemBuilder: (BuildContext context, int index) => _cardNote(index),
      staggeredTileBuilder: (int index) =>
      new StaggeredTile.fit(2),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget _cardNote(int index){
    return Card(
      child: Column(
        children: [
          _imageContainer(notes[index]["image"]),
          Text(notes[index]["id"].toString() +
              ' ' +
              notes[index]["title"].toString()),
          Text(notes[index]["content"].toString()),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              DatabaseHelper db = DatabaseHelper();
              await db.delete(notes[index]["id"]);
              refreshList();
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              Navigator.of(context).pushNamed('/insert',
                  arguments: EditNoteArguments(
                      Note(
                        notes[index]['title'].toString(),
                        notes[index]['content'].toString(),
                        id: notes[index]['id'],
                        image: notes[index]['image']
                      )
                  )

              );
            },
          ),
          IconButton(
            icon: Icon(notes[index]['favorite'] == 1 ? Icons.star : Icons.star_outline),
            onPressed: () async {
              DatabaseHelper db = DatabaseHelper();
             var note = Note(
                  notes[index]['title'].toString(),
                  notes[index]['content'].toString(),
                  id: notes[index]['id'],
                  image: notes[index]['image'],
                  favorite : notes[index]['favorite'] == 1
              );
              await db.favorite(note);
              refreshList();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }


}



