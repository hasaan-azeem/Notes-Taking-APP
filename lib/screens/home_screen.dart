import 'package:flutter/material.dart';
import 'package:notes_app/Services/note_database.dart';
import '../models/note_model.dart';
import 'note_editor_screen.dart';
import '../widgets/note_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final data = await NoteDatabase.instance.getNotes();
    setState(() => notes = data);
  }

  void deleteNote(int id) async {
    await NoteDatabase.instance.deleteNote(id);
    fetchNotes();
  }

  void openEditor({Note? note}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)),
    );
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Notes'), centerTitle: true),
      body:
          notes.isEmpty
              ? Center(child: Text('No notes yet. Tap + to add one!'))
              : ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteCard(
                    note: note,
                    onTap: () => openEditor(note: note),
                    onDelete: () => deleteNote(note.id!),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openEditor(),
        child: Icon(Icons.add),
      ),
    );
  }
}
