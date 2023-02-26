import 'package:flutter/material.dart';
import 'package:qy_notebook/db/db.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qy_notebook/component/float_window.dart';

import 'model/note.dart';

class TestPage extends StatefulWidget {
  @override
  State<TestPage> createState() => TestState();
}

class TestState extends State<TestPage> {
  TextStyle style = TextStyle();

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
                    controller: TextEditingController(text: "title"),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Row(
                        children: [
                          IntrinsicWidth(
                            child: TextField(
                              style: style,
                              decoration: InputDecoration(
                                fillColor: Colors.red,
                                //背景颜色，必须结合filled: true,才有效
                                filled: true,
                                //重点，必须设置为true，fillColor才有效
                                isCollapsed: true,
                                //重点，相当于高度包裹的意思，必须设置为true，不然有默认奇妙的最小高度
                                border: InputBorder.none,
                              ),
                              controller: TextEditingController(text: "10"),
                              maxLines: null,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              maxLines: null,
                              controller: TextEditingController(text: "text"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  TextField(
                    maxLines: null,
                    controller: TextEditingController(text: "footer"),
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
                  onPressed: () async {},
                  child: Text("保存"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
