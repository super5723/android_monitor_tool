import 'package:android_monitor_tool/cpu/cpu_info_page.dart';
import 'package:android_monitor_tool/mem/mem_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MacosWindow(
      sidebar: Sidebar(
        minWidth: 200,
        builder: (context, scrollController) {
          return SidebarItems(
            currentIndex: _pageIndex,
            onChanged: (index) {
              setState(() => _pageIndex = index);
            },
            items: const [
              SidebarItem(
                leading: MacosIcon(CupertinoIcons.graph_square),
                label: Text('Memory'),
              ),
              SidebarItem(
                leading: MacosIcon(CupertinoIcons.graph_circle),
                label: Text('CPU'),
              ),
            ],
          );
        },
      ),
      child: IndexedStack(
        index: _pageIndex,
        children: const [
          MemInfoPage(),
          CpuInfoPage(),
        ],
      ),
    );
  }
}
