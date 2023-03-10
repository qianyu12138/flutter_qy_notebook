import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

import 'db/db.dart';


class InfiniteListPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("list"),
      ),
      body: InfiniteListView(),
    );
  }

}

class InfiniteListView extends StatefulWidget {
  @override
  InfiniteListViewState createState() => InfiniteListViewState();
}

class InfiniteListViewState extends State<InfiniteListView> {
  static const loadingTag = "##loading##"; //表尾标记
  var _words = <String>[loadingTag];

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _words.length,
      itemBuilder: (context, index) {
        //如果到了表尾
        if (_words[index] == loadingTag) {
          //不足100条，继续获取数据
          if (_words.length - 1 < 100) {
            //获取数据
            _retrieveData();
            //加载时显示loading
            return Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            );
          } else {
            //已经加载了100条数据，不再获取数据。
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                "没有更多了",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
        }
        //显示单词列表项
        return ListItem();
      },
      separatorBuilder: (context, index) => const Divider(height: .0),
    );
  }

  void _retrieveData() async {
    Future.delayed(const Duration(seconds: 2)).then((e) {
      setState(() {
        //重新构建列表
        _words.insertAll(
          _words.length - 1,
          //每次生成20个单词
          generateWordPairs().take(20).map((e) => e.asPascalCase).toList(),
        );
      });
    });
  }
}

class ListItem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ListItemState();
}

class ListItemState extends State<ListItem>{
  bool deleteMode = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // child: ListTile(title: Text(_words[index])),
      // onLongPress: ,
    );
  }
}