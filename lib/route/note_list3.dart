import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/config/global_config.dart';

import '../db/db.dart';
import '../model/note.dart';
import 'note_edit.dart';

class NoteListPage extends StatefulWidget {
  @override
  State<NoteListPage> createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage>{
  final GlobalKey<AnimatedListState> _listKey = GlobalKey(); // backing data
  final List<Note> _note_list = <Note>[];


  @override
  void initState() {
    _loadNoteData();
    print("initState");
  }

  void _loadNoteData() async {
    var newItems = await DBProvider().getNoteList();
    print(newItems.length);
    _note_list.insertAll(0, newItems);
    print(_note_list.length);
    for(int i=0;i<_note_list.length;i++){
      _listKey.currentState!.insertItem(i);
    }
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
      body: AnimatedList(
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return _buildItem(_note_list[index], index, animation);
        },
        // separatorBuilder: (context, index) => const Divider(height: .0),
        initialItemCount: _note_list.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //导航到新路由
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return NoteEditPage(0, true);
            }),
          );//todo 拦截返回，带参数是否刷新页面
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItem(Note note, int removeIndex, Animation<double> animation) {
    //因为AnimatedListRemovedItemBuilder也会调用这个方法，最好不要用index，remove调用时index所指向的位置已经不是要删除的item了
    return SizeTransition(
        sizeFactor: animation,
        child: ListItem(note, removeIndex, (removeIndex) => removeItem(removeIndex)),
      );
  }

  removeItem(int index){
    var removeNote = _note_list.removeAt(index);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removeNote, index, animation);
    };
    _listKey.currentState!.removeItem(index, builder);
  }
}

class ListItem extends StatefulWidget {
  Note note;
  int index;
  final delete_fun;
  ListItem(this.note, this.index, this.delete_fun);

  @override
  State<StatefulWidget> createState() => ListItemState();

}

class ListItemState extends State<ListItem> {
  bool deleteMode = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(widget.note.title),
        subtitle: Text(getSummary(widget.note.content)),
        trailing: !deleteMode ? Text(widget.note.createTime.toString()) : TextButton(onPressed: delete, child: Text("删除" + widget.index.toString())),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return NoteEditPage(widget.note.id, false);
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
    await DBProvider().deleteNote(widget.note.id);
    setState(() {
      deleteMode = false;
    });
    widget.delete_fun(widget.index);
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


