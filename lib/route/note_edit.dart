import 'package:flutter/material.dart';
import 'package:untitled2/db/db.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled2/utils.dart';

import '../model/note.dart';

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
  bool editMode = false;
  int created_id = -1;
  TextEditingController titleController = TextEditingController();
  TextEditingController editLineNumController = TextEditingController();
  TextEditingController footerTextController = TextEditingController();
  TextEditingController editController = TextEditingController();
  FocusNode editFocusNode = FocusNode();

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

  NoteEditPageState(this.noteId, this.newly){
    if(newly) editMode = true;
  }

  @override
  void initState() {
    super.initState();
    editLineNumController.text = "1";
    editController.addListener(() {
      int lineCount = '\n'.allMatches(editController.text).length + 1;
      String lineNumText = "";
      for (int i = 1; i <= lineCount; i++) {
        lineNumText = lineNumText + i.toString() + "\n";
      }
      lineNumText = lineNumText.replaceAll(RegExp(r'\n$'), "");
      editLineNumController.text = lineNumText;
    });
    if (!newly) {
      _initText();
    }
  }

  _initText() async {
    Note note = await getNote();
    titleController.text = note.title;
    editController.text = note.content;
    footerTextController.text = "创建于:${note.createTime}\n更新于:${note.updateTime}";
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, created_id);
        return false;
      }, child: Scaffold(
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
                                  //行号
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
                                //编辑区域
                                controller: editController,
                                maxLines: null,
                                style: EDIT_STYLE,
                                enabled: editMode,
                                focusNode: editFocusNode,
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
                    //编辑/保存
                    onPressed: () => edit_button_fun(context),
                    child: Text(editMode ? "保存" : "编辑"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void edit_button_fun(BuildContext context) async {
    if(editMode){
      //保存
      String showmsg;
      if (newly) {
        int? id = await saveNote(
          titleController.text,
          editController.text,
        );
        setState(() {
          noteId = id!;
          newly = false;
          created_id = id;
        });
        showmsg = "保存成功";
      } else {
        await updateNote(
          noteId,
          titleController.text,
          editController.text,
        );
        showmsg = "更新成功";
      }
      Fluttertoast.showToast(
          msg: showmsg,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        editMode = false;
      });
      editFocusNode.unfocus();
    } else {
      //编辑
      setState(() {
        editMode = true;
      });
      FocusScope.of(context).requestFocus(editFocusNode);
    }
  }

  Future<Note> getNote() async {
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
