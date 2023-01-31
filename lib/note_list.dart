import 'package:flutter/material.dart';

import 'db.dart';
import 'note.dart';
import 'note_edit.dart';

class NoteListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("list"),
      ),
      body: const NoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          //导航到新路由
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return NoteEditPage(0, true);
            }),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListState();
}

class _NoteListState extends State<NoteListView> {
  static const loadingTag = "##loading##"; //表尾标记
  bool loadFinish = false;
  final List<Note> _note_list = <Note>[Note.newNote(loadingTag)];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
          //显示单词列表项
          return ListItem(_note_list[index]);
        },
        separatorBuilder: (context, index) => const Divider(height: .0),
        itemCount: _note_list.length);
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

class ListItem extends StatelessWidget {
  Note note;

  ListItem(this.note);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(getSummary(note.content)),
        trailing: Text(note.createTime.toString()),
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
        print("onLongPress");
      },
    );
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
                    "qinayu",
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
                    leading: const Icon(Icons.import_contacts),
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
