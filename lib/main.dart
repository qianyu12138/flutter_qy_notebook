import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/api_widget.dart';
import 'package:untitled2/config/global_config.dart';
import 'package:untitled2/route/note_list3.dart';
import 'package:untitled2/test2.dart';

import 'list.dart';
import 'route/note_edit.dart';
import 'note_edit_layout2.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => GlobalConfig()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              child: Text("NOTE_LIST"),
              onPressed: () {
                //导航到新路由
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NoteListPage();
                  }),
                );
              },
            ),
            TextButton(
              child: Text("list"),
              onPressed: () {
                //导航到新路由
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return InfiniteListPage();
                  }),
                );
              },
            ),
            TextButton(
              child: Text("API_WIDGET"),
              onPressed: () {
                //导航到新路由
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return APIPage();
                  }),
                );
              },
            ),
            TextButton(
              child: Text("NOTE EDIT"),
              onPressed: () {
                //导航到新路由
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return NoteEditPage(1, true);
                  }),
                );
              },
            ),
            TextButton(
              child: Text("layout2"),
              onPressed: () {
                //导航到新路由
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return TestPage();
                  }),
                );
              },
            ),
            TextButton(
              child: Text("test2"),
              onPressed: () {
                //导航到新路由
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return FitTextPage();
                  }),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
