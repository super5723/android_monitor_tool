import 'package:android_monitor_tool/cpu/cpu_info_page.dart';
import 'package:android_monitor_tool/generated/l10n.dart';
import 'package:android_monitor_tool/mem/mem_info_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:macos_ui/macos_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,  //支持的国际化语言
      locale: const Locale('zh',),                       //当前的语言
      localeListResolutionCallback: (locales, supportedLocales) {
        // print('当前系统语言环境$locales');
        return;
      },
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
        topOffset: 10,
        builder: (context, scrollController) {
          return SidebarItems(
            currentIndex: _pageIndex,
            onChanged: (index) {
              setState(() => _pageIndex = index);
            },
            items:  [
              SidebarItem(
                leading: const MacosIcon(CupertinoIcons.graph_square),
                label: Text(S.current.sidebar_name_memory),
              ),
              SidebarItem(
                leading: const MacosIcon(CupertinoIcons.graph_circle),
                label: Text(S.current.sidebar_name_cpu),
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
