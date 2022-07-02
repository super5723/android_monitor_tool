import 'dart:async';
import 'dart:core';
import 'package:android_monitor_tool/mem/mem_chart_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../util.dart';
import 'mem_info.dart';

/// @Author wywy
/// @Description
/// @Date 2022/6/28

class MemMonitorPage extends StatefulWidget {
  const MemMonitorPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MemMonitorPage();
  }
}

class _MemMonitorPage extends State<MemMonitorPage> {
  final String packageName = 'com.havefun.android';
  final int _shellInterval = 2000;
  late Timer _shellTimer;
  final List<MemoryInfo> _memInfoList = [];
  LineChartData? _chartData;
  int _firstTimeMs = 0;

  @override
  void initState() {
    super.initState();
    _shellTimer = Timer.periodic(Duration(milliseconds: _shellInterval), (timer) {
      _shellCommand();
    });
  }

  _shellCommand() async {
    try {
      ProcessResult result = await Process.run(
        'adb',
        // ['shell', 'dumpsys', 'meminfo', packageName, '|', 'grep', '-E', '\'Java Heap:|Native Heap:|Graphics:|TOTAL:\''],
        [
          'shell',
          'dumpsys',
          'meminfo',
          '-s',
          packageName,
        ],
      );
      if (result.stderr != null && result.stderr is String && (result.stderr as String).isNotEmpty) {
        print('wywy-->run error:${result.stderr}');
      } else if (result.stdout != null && result.stdout is String) {
        // print('wywy-->run success:${result.stdout}');
        MemoryInfo? memoryInfo = _parseCommandResult(result.stdout);
        // print('wywy--->memoryInfo=$memoryInfo');
        if (memoryInfo != null) {
          _memInfoList.add(memoryInfo);
          _refreshCharData();
          setState(() {});
        }
      }
    } catch (e) {
      print('wywy--->run exception:$e');
    }
  }

  MemoryInfo? _parseCommandResult(String result) {
    List<String> split = result.split('\n');
    if (split != null) {
      int javaHeapSize = 0;
      int nativeHeapSize = 0;
      int graphicSize = 0;
      int totalSize = 0;
      for (var line in split) {
        int index = line.indexOf(':');
        if (index >= 0) {
          if (line.contains('Java Heap:')) {
            javaHeapSize = Util.parseInt(line.substring(index + 1).trim());
          } else if (line.contains('Native Heap:')) {
            nativeHeapSize = Util.parseInt(line.substring(index + 1).trim());
          } else if (line.contains('Graphics:')) {
            graphicSize = Util.parseInt(line.substring(index + 1).trim());
          } else if (line.contains('TOTAL:')) {
            int end = line.indexOf('TOTAL SWAP');
            totalSize = Util.parseInt(line.substring(index + 1, end).trim());
            break;
          }
        }
      }
      if (totalSize > 0 && javaHeapSize > 0 && nativeHeapSize > 0) {
        int curTime = DateTime.now().millisecondsSinceEpoch;
        if (_firstTimeMs == 0) {
          _firstTimeMs = curTime;
        }
        return MemoryInfo(javaHeapSize, nativeHeapSize, graphicSize, totalSize, curTime - _firstTimeMs);
      }
    }

    return null;
  }

  _refreshCharData() {
    _chartData = MemChartModel(_memInfoList).getLineCharData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('memory monitor'),
      ),
      body: Center(
        child: _chartData == null
            ? const SizedBox.shrink()
            : Container(
                padding: const EdgeInsets.all(35.0),
                child: LineChart(
                  _chartData!,
                  swapAnimationDuration: const Duration(milliseconds: 250),
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _shellTimer?.cancel();
    super.dispose();
  }
}
