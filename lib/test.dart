import 'package:flutter/material.dart';
import 'package:untitled2/utils.dart';

class TestFooterPage extends StatelessWidget {
  TextStyle style = TextStyle();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[200],
          title: Text(
            "自定义实现屏幕底部按钮",
            style: TextStyle(color: Colors.black, fontFamily: 'pinshang'),
          ),
        ),
        body: Container(
          width: paintWidthWithTextStyle(style, "10"),
          child: Expanded(
            child: Column(
              children: [
                TextField(
                  style: style,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "请编辑内容",
                  ),
                  controller: TextEditingController(text: "10"),
                ),
              ],
            ),
          ),
        ));
  }
}
