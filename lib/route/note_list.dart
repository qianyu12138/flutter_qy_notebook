import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/config/global_config.dart';
import 'package:untitled2/list.dart';

import '../db/db.dart';
import '../model/note.dart';
import 'note_edit.dart';

class NoteListPage extends StatefulWidget {
  @override
  State<NoteListPage> createState() => _NoteListState();
}

class _NoteListState extends State<NoteListPage> {
  static const loadingTag = "##loading##"; //表尾标记
  bool loadFinish = false;
  final List<Note> _note_list = <Note>[Note.newNote(loadingTag)];

  @override
  void initState() {
    super.initState();
  }

  void refresh() async{
    setState(() {
      _note_list.clear();
      _note_list.add(Note.newNote(loadingTag));
      loadFinish = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Consumer<GlobalConfig>(
        builder: (ctx, global_config, child){
          return MyDrawer();
        },
      ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("list"),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          if (_note_list[index].title == loadingTag) {
            //不足100条，继续获取数据
            if (!loadFinish) {
              //获取数据
              _loadNoteData(_note_list.length - 1);
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
          return ListItem(_note_list[index]);
        },
        separatorBuilder: (context, index) => const Divider(height: .0),
        itemCount: _note_list.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //导航到新路由
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return NoteEditPage(0, true);
            }),
          ).then((val) =>  refresh());
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _loadNoteData(int offset) async {
    var newItems = await DBProvider().getNoteListPage(offset, 10);
    setState(() {
      if (newItems.isEmpty) {
        loadFinish = true;
      } else {
        //重新构建列表
        _note_list.insertAll(
          _note_list.length - 1,
          //每次生成20个单词
          newItems,
        );
      }
    });
  }
}

class ListItem extends StatefulWidget {
  Note note;
  ListItem(this.note);

  @override
  State<StatefulWidget> createState() => ListItemState(note);

}

class ListItemState extends State<ListItem> {
  Note note;
  bool deleteMode = false;
  ListItemState(this.note);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(getSummary(note.content)),
        trailing: !deleteMode ? Text(note.createTime.toString()) : TextButton(onPressed: delete, child: Text("删除")),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return NoteEditPage(note.id, false);
          }),
        );
      },
      onLongPress: () {
        setState(() {
          deleteMode = true;
        });
      },
    );
  }

  Future<void> delete() async {
    await DBProvider().deleteNote(note.id);
    setState(() {
      deleteMode = false;
    });
    //todo 动画
  }

  String getSummary(String text) {
    if (text.indexOf("\n") > 0) text = text.substring(0, text.indexOf("\n"));
    if (text.length < 10) return text;
    return text.substring(0, 10) + "...";
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipOval(
                      child: Image.asset(
                        "assert/img/head.jpeg",
                        width: 80,
                      ),
                    ),
                  ),
                  Text(
                    Provider.of<GlobalConfig>(context).user_name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.account_circle_rounded),
                    title: const Text('账户'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.input),
                    title: const Text('导入'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.output),
                    title: const Text('导出'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.cloud),
                    title: const Text('云'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('设置'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("v0.0.1"),
            ),
          ],
        ),
      ),
    );
  }
}
