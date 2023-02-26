import 'package:flutter/material.dart';
import 'package:qy_notebook/component/float_window.dart';

import 'db/db.dart';
import 'model/note.dart';

class APIPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("list"),
      ),
      body: APIView(),
    );
  }
}

class APIView extends StatefulWidget {
  @override
  State<APIView> createState() => APIState();
}

class APIState extends State<APIView> {
  String text = "tip";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(text),
          TextButton(
            child: Text("ADD NOTE"),
            onPressed: () {
              //导航到新路由
              DBProvider().saveNote(Note(
                  id: 0,
                  title: "test",
                  content: "测试content",
                  createTime: DateTime.now(),
                  updateTime: DateTime.now()));
            },
          ),
          TextButton(
            child: Text("GET NOTE COUNT"),
            onPressed: () async {
              //导航到新路由
              List<Note> noteList = await DBProvider().getNoteList();
              setState(() {
                text = noteList.length.toString();
              });
            },
          ),
          TextButton(
            child: Text("FLOAT"),
            onPressed: () {
              FLOAT(context, ListView()).insert();
            },
          ),
        ],
      ),
    );
  }
}
