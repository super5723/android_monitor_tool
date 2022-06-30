import 'package:flutter/material.dart';

import 'mem/mem_monitor_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'android monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'android monitor tools'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              child: Container(color: Colors.redAccent,
              padding: EdgeInsetsDirectional.only(start: 10,top: 7,end: 10,bottom: 7),
              child: Text('mem monitor'),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return const MemMonitorPage();
                }));
              },
            ),
          ],),

      ),//
    );
  }
}