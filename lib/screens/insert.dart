import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nid_notes/arguments/editnote.dart';
import 'package:nid_notes/helper/database.dart';

import '../models/note.dart';

class InsertScreen extends StatefulWidget {
  @override
  _InsertScreenState createState() => _InsertScreenState();
}

class _InsertScreenState extends State<InsertScreen> {

  final _insertFormKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  String? _title;
  String? _content;
  String? _image;

  File? _imageFile;
  String? _imagePath;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as EditNoteArguments;

    if(args.note != null) {
      print(args.note!.title);
      titleController.text = args.note!.title;
      contentController.text = args.note!.content ?? '';
      _image = args.note!.image;
    } else {
      print('Nessun titolo');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Crea nota'),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  if (_insertFormKey.currentState!.validate()) {
                    _insertFormKey.currentState!.save();
                    Note note = Note(_title!, _content);
                    if (_image != null) {
                      note.image = _image;
                    }
                    DatabaseHelper db = DatabaseHelper();
                    if(args.note!.id != null){
                      note.id = args.note!.id;
                      db.update(note).then((value) => Navigator.of(context).pushReplacementNamed('/home'));
                    } else{
                      db.insert(note).then((value) => Navigator.of(context).pushReplacementNamed('/home'));
                    }
                  }
                },
                child: Icon(
                  Icons.check,  // add custom icons also
                ),
              ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _insertFormKey,
              child: Column(
                children: [
                  _imageContainer(),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Titolo'
                    ),
                    onSaved: (value) {
                      _title = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci un titolo';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: contentController,
                    decoration: InputDecoration(
                        labelText: 'Contenuto'
                    ),
                    onSaved: (value) {
                      _content = value;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _getImageFromGallery();
                    },
                    child: Text('Aggiungi immagine da galleria'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _getImageFromCamera();
                    },
                    child: Text('Aggiungi immagine da camera'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _getImageFromCamera() async => _getImage(ImageSource.camera);

  Future _getImageFromGallery() async => _getImage(ImageSource.gallery);

  Future _getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _image = base64.encode(_imageFile!.readAsBytesSync());
      }
    });
  }

  Widget _imageContainer() {
    return _image == null
        ? Text('No image selected.')
        : Image.memory(base64.decode(_image!));
  }

}