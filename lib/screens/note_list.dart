import 'package:flutter/material.dart';
import 'package:notekeeperflite/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';
import '../models/note.dart';
import '../utils/database_helper.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note>? noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    noteList ??= <Note>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB Clicked');
          navigateToDetail('Add Note');
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        final note = noteList![position];

        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(note.priority),
              child: getPriorityIcon(note.priority),
            ),
            title: Text(note.title),
            subtitle: Text(note.date),
            trailing: GestureDetector(
              child: const Icon(Icons.delete, color: Colors.grey),
              onTap: () {
                _delete(context, note);
              },
            ),
            onTap: () {
              debugPrint('ListTile Tapped');
              navigateToDetail('Edit Note');
            },
          ),
        );
      },
    );
  }

  // 🔴 Priority Color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  // 🟡 Priority Icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return const Icon(Icons.play_arrow);
      case 2:
        return const Icon(Icons.keyboard_arrow_right);
      default:
        return const Icon(Icons.keyboard_arrow_right);
    }
  }

  // 🗑️ Delete Note
  void _delete(BuildContext context, Note note) async {
    int result = await _databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully');
      setState(() {
        noteList!.remove(note);
        count = noteList!.length;
      });
    }
  }

  // 🧁 SnackBar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // ➕ Navigate to Add/Edit Note Screen
  void navigateToDetail(String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetail(appBarTitle: title),
      ),
    );
  }

  voidupdateListView(){
    final Future<Database>dbFuture=databaseHelper.initializeDatabase();
    dbFuture.then(database){

    }
  }
}
