import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nid_notes/helper/database.dart';
import 'package:nid_notes/blocs/user_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


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
          Flexible(
            flex: 1,
            child: ElevatedButton(
              onPressed: () {
                userBloc.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              },
              child: Text('Logout'),
            ),
          )
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

  Widget _imageContainer(String? image) {
    if (image != null) {
      return Image.memory(base64.decode(image));
    }
    return SizedBox.shrink();
  }

  //Widget per card diverse
  Widget _gridView(){
    return new StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) => new Container(
          color: Colors.green,
          child: new Center(
            child: new CircleAvatar(
              backgroundColor: Colors.white,
              child: new Text('$index'),
            ),
          )),
      staggeredTileBuilder: (int index) =>
      new StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

}
