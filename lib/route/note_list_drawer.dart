import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../component/common_toast.dart';
import '../component/file_selector.dart';
import '../component/float_window.dart';
import '../component/list_component.dart';
import '../config/global_config.dart';
import '../constants/Constants.dart';

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
                    onTap: () => import_backup(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.output),
                    title: const Text('导出'),
                    onTap: () => export_backup(),
                  ),
                  ListTile(
                    leading: const Icon(Icons.save),
                    title: const Text('备份'),
                    onTap: () => FLOAT(context, BackupFileList()).insert(),
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

  Future<void> export_backup() async {
    String backup_file_name =
        DateTime.now().toString() + "." + Constants.BACKUP_FILE_EXT;
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path =
        join(documentsDirectory.path, Constants.BACKUP_PATH, backup_file_name);
    File file = File(path);
    file.create();
    file.writeAsString("backup");

    CommonToast.show("导出成功");
  }

  Future<void> import_backup() async {
    String? path = await FileSelector.getDocument();
    if (path == null) {
      CommonToast.show("导入取消");
    } else {
      //todo import
      CommonToast.show("导入取消");
    }
  }
}

class BackupFileList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BackupFileListState();
}

class BackupFileListState extends State<BackupFileList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey(); // backing data
  final List<String> _file_list = <String>[];

  @override
  void initState() {
    load_file();
  }

  void load_file() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, Constants.BACKUP_PATH);
    Directory backup_dir = Directory(path);
    if (!backup_dir.existsSync()) backup_dir.create();
    List<FileSystemEntity> lists = backup_dir.listSync();
    for (int i = 0; i < lists.length; i++) {
      FileSystemEntity entity = lists[i];
      if (entity is File && entity.path.endsWith(Constants.BACKUP_FILE_EXT)) {
        File file = entity;
        _file_list.add(file.path.split("/").last);
        _listKey.currentState?.insertItem(i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MyBehavior(), //自定义behavior
      child: AnimatedList(
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return _buildItem(_file_list[index], index, animation);
        },
        initialItemCount: _file_list.length,
      ),
    );
  }

  Widget _buildItem(String file, int removeIndex, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: _FileRowItem(
          file, removeIndex, (removeIndex) => removeItem(removeIndex)),
    );
  }

  removeItem(int index) {
    var removeNote = _file_list.removeAt(index);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(removeNote, index, animation);
    };
    _listKey.currentState!.removeItem(index, builder);
  }
}

class _FileRowItem extends StatefulWidget {
  String file_name;
  int index;
  final delete_fun;

  _FileRowItem(this.file_name, this.index, this.delete_fun);

  @override
  State<StatefulWidget> createState() => _FileRowItemState();
}

class _FileRowItemState extends State<_FileRowItem> {
  String? absolute_path = null;

  Future<void> load_data() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    absolute_path =
        join(documentsDirectory.path, Constants.BACKUP_PATH, widget.file_name);
  }

  @override
  void initState() {
    load_data();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        title: Text(widget.file_name),
        trailing: TextButton(
          onPressed: delete,
          child: Text("删除"),
        ),
      ),
      onTap: () {
        OpenFile.open(absolute_path!);
      },
    );
  }

  Future<void> delete() async {
    File backup_file = File(absolute_path!);
    if (backup_file.existsSync()) {
      backup_file.deleteSync();
      CommonToast.show("删除备份成功");
    } else {
      CommonToast.show("文件不存在");
    }
    widget.delete_fun(widget.index);
  }
}
