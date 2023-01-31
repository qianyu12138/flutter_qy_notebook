import 'package:flutter/material.dart';
import 'package:untitled2/db.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled2/utils.dart';

import 'note.dart';

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
  TextEditingController footerTextController = TextEditingController();
  TextEditingController editController = TextEditingController();

  final TextStyle UNABLE_STYLE = TextStyle(
    color: Colors.grey,
    fontFamily: 'Courier_New',
  );

  final TextStyle EDIT_STYLE = TextStyle(
    fontFamily: 'Courier_New',
  );
  final StrutStyle EDIT_STRUT_STYLE = StrutStyle(
    forceStrutHeight: true,
    leading: 0.4,
  );

  NoteEditPageState(this.noteId, this.newly);

  @override
  void initState() {
    super.initState();
    editController.addListener(() {
      int lineCount = '\n'.allMatches(editController.text).length + 1;
      String lineNumText = "";
      for (int i = 1; i <= lineCount; i++) {
        lineNumText = lineNumText + i.toString() + "\n";
      }
      lineNumText = lineNumText.replaceAll(RegExp(r'\n$'), "");
      editLineNumController.text = lineNumText;
      // setState(() {
      // editLineNumWidth = paintWidthWithTextStyle(EDIT_STYLE, lineCount.toString());
      // });
    });
    if (!newly) {
      _initText();
    }
    // editLineNumWidth = paintWidthWithTextStyle(EDIT_STYLE, "1");
  }

  _initText() async {
    Note note = await getNote(noteId);
    titleController.text = note.title;
    editController.text = note.content;
    footerTextController.text =
        "创建于:${note.createTime}\n更新于:${note.updateTime}";
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "标题",
                    ),
                    style: EDIT_STYLE,
                    controller: titleController,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: IntrinsicWidth(
                              // width: editLineNumWidth,
                              child: TextField(
                                textAlign: TextAlign.right,
                                controller: editLineNumController,
                                style: UNABLE_STYLE,
                                strutStyle: EDIT_STRUT_STYLE,
                                enabled: false,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "中",
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: editController,
                              maxLines: null,
                              style: EDIT_STYLE,
                              strutStyle: EDIT_STRUT_STYLE,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "请编辑内容",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextField(
                    //footer
                    style: UNABLE_STYLE,
                    maxLines: null,
                    enabled: false,
                    textAlign: TextAlign.end,
                    controller: footerTextController,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {},
                  child: Text("取消"),
                ),
              ),
              Expanded(
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
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  },
                  child: Text("保存"),
                ),
              ),
            ],
          ),
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