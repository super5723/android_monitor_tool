import 'dart:async';
import 'dart:math';

import 'package:android_monitor_tool/shell.dart';
import 'package:android_monitor_tool/util.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'mem_chart_model.dart';
import 'mem_info.dart';

/// @Author wangyang
/// @Description
/// @Date 2022/7/7
class MemInfoPage extends StatefulWidget {
  const MemInfoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MemInfoPageState();
  }
}

class _MemInfoPageState extends State<MemInfoPage> {
  String? _curProcessName;
  int _commandIntervalMs = 2000;
  Timer? _commandTimer;
  final List<MemoryInfo> _memInfoList = [];
  int _firstTimeMs = 0;
  String _statusText = 'stopped';
  late LineChartData _chartData;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _refreshChartData();
  }

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: Text(_getTitle()),
        titleWidth: 300,
        actions: [
          ToolBarIconButton(
            label: 'control',
            icon: MacosIcon(
              _isRunning ? CupertinoIcons.stop : CupertinoIcons.play,
            ),
            tooltipMessage: _isRunning ? "stop" : "start",
            onPressed: _switchRunning,
            showLabel: false,
          ),
          ToolBarPullDownButton(
            label: "setting",
            tooltipMessage: "setting",
            icon: CupertinoIcons.settings,
            items: [
              MacosPulldownMenuItem(
                title: const Text("Set interval"),
                onTap: _inputCommandInterval,
              ),
              MacosPulldownMenuItem(
                title: const Text("Set process"),
                onTap: _inputProcessName,
              ),
            ],
          ),
          ToolBarPullDownButton(
            label: "File",
            icon: CupertinoIcons.doc,
            tooltipMessage: "file",
            items: [
              MacosPulldownMenuItem(
                label: "import",
                title: const Text("Import"),
                onTap: _importFile,
              ),
              MacosPulldownMenuItem(
                label: "export",
                title: const Text("Export"),
                onTap: _exportFile,
              ),
            ],
          ),
          const ToolBarSpacer(),
        ],
      ),
      children: [
        ContentArea(
          builder: ((context, scrollController) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getCurrentMemInfoWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      _getMemTypeTipWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: LineChart(_chartData),
                      ),
                    ],
                  ),
                ),
                PositionedDirectional(
                  child: Text(
                    _getWrapStatusText(_statusText),
                    style: MacosTheme.of(context).typography.footnote,
                  ),
                  bottom: 10,
                  end: 30,
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  _refreshChartData() {
    _chartData = MemChartModel(_memInfoList).getLineChartData();
  }

  _getTitle() {
    if (_curProcessName == null || _curProcessName!.isEmpty) {
      return 'Memory Usage';
    }
    return 'Process :  $_curProcessName';
  }

  _inputProcessName() {
    Util.showInputDialog(context, 'input process name', (value) {
      _onSetProcessName(value);
    });
  }

  _inputCommandInterval() {
    Future.delayed(const Duration(milliseconds: 10), () {
      Util.showInputDialog(context, 'input interval', (value) {
        try {
          int interval = int.parse(value);
          if (interval < 1000) {
            Util.showConfirmDialog(context: context, message: 'interval must greater than 1000');
          } else {
            _commandIntervalMs = interval;
            if (_commandTimer?.isActive ?? false) {
              if (_isRunning) {
                _start();
              }
            }
          }
        } catch (e) {
          Util.showConfirmDialog(context: context, message: 'interval must be type of int');
        }
      });
    });
  }

  _switchRunning() {
    if (_isRunning) {
      _stop();
    } else {
      _start();
    }
  }

  _start() {
    if (_curProcessName == null || _curProcessName!.isEmpty) {
      _inputProcessName();
      return;
    }

    _commandTimer?.cancel();
    _commandTimer = Timer.periodic(Duration(milliseconds: _commandIntervalMs), (timer) {
      _requestMemInfo();
    });
    _isRunning = true;
    _refreshUi();
  }

  _stop() {
    _commandTimer?.cancel();
    _statusText = 'stopped';
    _isRunning = false;
    _refreshUi();
  }

  _requestMemInfo() async {
    if (_curProcessName == null || _curProcessName!.isEmpty) {
      _statusText = 'run fail:processName is empty';
      _refreshUi();
      return;
    }
    ShellCommand command = ShellCommand(
      'adb',
      // ['shell', 'dumpsys', 'meminfo', packageName, '|', 'grep', '-E', '\'Java Heap:|Native Heap:|Graphics:|TOTAL:\''],
      [
        'shell',
        'dumpsys',
        'meminfo',
        '-s',
        _curProcessName!,
      ],
    );

    CommandResult commandResult = await command.run();
    if (commandResult.success) {
      MemoryInfo? memInfo = _parseMemInfo(commandResult.result);
      if (memInfo != null) {
        _statusText = 'success';
        _memInfoList.add(memInfo);
        _refreshChartData();
      } else {
        _statusText = '${commandResult.result}';
      }
    } else {
      _statusText = '${commandResult.errorMsg}';
    }
    _refreshUi();
  }

  MemoryInfo? _parseMemInfo(String? result) {
    if (result == null) {
      return null;
    }
    List<String> split = result.split('\n');
    if (split.length < 4) {
      return null;
    }
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

    return null;
  }

  _getWrapStatusText(String text) {
    DateTime now = DateTime.now();
    String h = Util.twoDigits(now.hour);
    String min = Util.twoDigits(now.minute);
    String sec = Util.twoDigits(now.second);
    String ms = Util.threeDigits(now.millisecond);
    return "$h:$min:$sec.$ms : $text";
  }

  _getCurrentMemInfoWidget() {
    if (_memInfoList.isEmpty) {
      return const SizedBox.shrink();
    }
    MemoryInfo currentMemInfo = _memInfoList.last;
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MemSizeWidget(text: Util.getMemoryChartYValue(currentMemInfo.totalSize).toString(), color: totalSizeColor),
        const SizedBox(
          width: 20,
        ),
        MemSizeWidget(
            text: Util.getMemoryChartYValue(currentMemInfo.nativeHeapSize).toString(), color: nativeSizeColor),
        const SizedBox(
          width: 20,
        ),
        MemSizeWidget(text: Util.getMemoryChartYValue(currentMemInfo.javaHeapSize).toString(), color: javaSizeColor),
        const SizedBox(
          width: 20,
        ),
        MemSizeWidget(text: Util.getMemoryChartYValue(currentMemInfo.graphicSize).toString(), color: graphicSizeColor),
      ],
    );
  }

  _getMemTypeTipWidget() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        MemColorTipWidget(text: 'total', color: totalSizeColor),
        SizedBox(
          width: 10,
        ),
        MemColorTipWidget(text: 'native', color: nativeSizeColor),
        SizedBox(
          width: 10,
        ),
        MemColorTipWidget(text: 'java', color: javaSizeColor),
        SizedBox(
          width: 10,
        ),
        MemColorTipWidget(text: 'graphic', color: graphicSizeColor),
      ],
    );
  }

  _onSetProcessName(String? processName) async {
    if (processName == null || processName.isEmpty) {
      await Util.showConfirmDialog(context: context, message: 'processName invalid');
    } else {
      if (_curProcessName != processName) {
        _memInfoList.clear();
      }
      _curProcessName = processName;
      _start();
    }
  }

  _importFile() async {}

  _exportFile() async {}

  _refreshUi() {
    if (mounted) {
      setState(() {});
    }
  }
}

class MemSizeWidget extends StatelessWidget {
  final String text;
  final Color color;

  const MemSizeWidget({Key? key, required this.text, required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        const SizedBox(
          width: 5,
        ),
        Text('${text}GB'),
      ],
    );
  }
}

class MemColorTipWidget extends StatelessWidget {
  final String text;
  final Color color;

  const MemColorTipWidget({Key? key, required this.text, required this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 50,
          height: 30,
          child: CustomPaint(
            painter: MemColorTypePainter(color),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(text),
      ],
    );
  }
}

class MemColorTypePainter extends CustomPainter {
  final Color color;

  MemColorTypePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    double width = size.width;
    double height = size.height;
    canvas.drawLine(
        Offset(
          0,
          height / 2,
        ),
        Offset(width, height / 2),
        paint);
    canvas.drawCircle(Offset(width / 2, height / 2), min(width, height) / 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
