import 'package:flutter/material.dart';

class FLOAT {
  OverlayEntry? overlayEntry;
  BuildContext context;
  FLOAT(this.context) {
    //建立一个OverlayEntry对象
    overlayEntry = OverlayEntry(builder: (context) {
      //外层使用Positioned进行定位，控制在Overlay中的位置
      return Positioned(
          top: MediaQuery.of(context).size.height * 0.2,
          left: MediaQuery.of(context).size.width * 0.15,
          child: Material(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.7,
              color: Colors.amberAccent,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                    child: ListView()
                  ),
                  TextButton(
                    onPressed: () {
                      overlayEntry?.remove();
                    },
                    child: Text("关闭"),
                  ),
                ],
              ),
            ),
          ));
    });
  }

  void insert(){
    Overlay.of(context)?.insert(overlayEntry!);
  }
}
