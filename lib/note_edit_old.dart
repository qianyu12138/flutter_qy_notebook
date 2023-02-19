import 'package:flutter/material.dart';
import 'package:untitled2/db/db.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled2/utils.dart';

import 'model/note.dart';

class NoteEditPage extends StatefulWidget {
  int noteId;
  bool newly;

  NoteEditPage(this.noteId, this.newly);

  @override
  State<NoteEditPage> createState() => NoteEditPageState(noteId, newly);
}

class NoteEditPageState extends State<NoteEditPage> {
  int noteId;
  bool newly;
  TextEditingController titleController = TextEditingController();
  TextEditingController editLineNumController = TextEditingController();
  double editLineNumWidth = 100;
  TextEditingController editController = TextEditingController();

  final TextStyle EDIT_STYLE = TextStyle(

  );

  NoteEditPageState(this.noteId, this.newly);

  @override
  void initState() {
    super.initState();
    editController.addListener(() {
      int lineCount = '\n'
          .allMatches(editController.text)
          .length + 1;
      String lineNumText = "";
      for (int i = 1; i <= lineCount; i++) {
        lineNumText = lineNumText + i.toString() + "\n";
      }
      lineNumText = lineNumText.replaceAll(RegExp(r'\n$'), "");
      editLineNumController.text = lineNumText;
      setState(() {
        editLineNumWidth = paintWidthWithTextStyle(EDIT_STYLE, lineCount.toString());
        print(editLineNumWidth);
      });
    });
    if (!newly) {
      _initText();
    }
    editLineNumWidth = paintWidthWithTextStyle(EDIT_STYLE, editController.text);
    print("init width:" + editLineNumWidth.toString());
  }

  _initText() async {
    Note note = await getNote(noteId);
    titleController.text = note.title;
    editController.text = note.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("笔记详情"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "标题",
                  ),
                  //title
                  controller: titleController,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Row(
                children: [
                  Container(
                    // alignment: Alignment.topRight,
                    width: editLineNumWidth,
                    child: TextField(
                      controller: editLineNumController,
                      style: EDIT_STYLE,
                      enabled: false,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "1",
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                        controller: editController,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: InputBorder.none)),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  maxLines: null,
                  enabled: false,
                  textAlign: TextAlign.end,
                  controller: TextEditingController(text: "2022\n2023\n2024"),
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () {},
                  child: Text("取消"),
                ),
              ),
              Expanded(
                flex: 1,
                child: TextButton(
                  onPressed: () async {
                    if (widget.newly) {
                      int? id = await saveNote(
                          titleController.text, editController.text);
                      setState(() {
                        noteId = id!;
                        newly = false;
                      });
                    } else {
                      await updateNote(
                          noteId, titleController.text, editController.text);
                    }
                    Fluttertoast.showToast(
                        msg: "保存成功",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                  child: Text("保存"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<Note> getNote(int noteId) async {
    assert(!widget.newly);
    Note? note = await DBProvider().getNote(widget.noteId);
    if (note == null) throw Exception("note note exist");
    return note;
  }

  Future<String> getText() async {
    assert(!widget.newly);
    Note? note = await DBProvider().getNote(widget.noteId);
    if (note == null) throw Exception("note note exist");
    return note.content;
  }

  Future<int?> saveNote(String title, String text) async {
    Note note = Note(
        id: 0,
        title: title,
        content: text,
        createTime: DateTime.now(),
        updateTime: DateTime.now());
    return await DBProvider().saveNote(note);
  }

  updateNote(int noteId, String title, String content) async {
    Note note = Note(
        id: noteId,
        title: title,
        content: content,
        createTime: DateTime.now(),
        updateTime: DateTime.now());
    DBProvider().updateNoteById(note);
  }
}
