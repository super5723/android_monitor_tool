import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:android_monitor_tool/generated/l10n.dart';
import 'package:android_monitor_tool/shell.dart';
import 'package:android_monitor_tool/util.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart' as Path;
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
  int _commandIntervalMs = 1500;
  Timer? _commandTimer;
  final List<MemoryInfo> _memInfoList = [];
  int _firstTimeMs = 0;
  String _statusText = S.current.stop;
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
            label: S.current.control,
            icon: MacosIcon(
              _isRunning ? CupertinoIcons.stop : CupertinoIcons.play,
            ),
            tooltipMessage: _isRunning ? S.current.stop : S.current.start,
            onPressed: _switchRunning,
            showLabel: false,
          ),
          ToolBarPullDownButton(
            label: S.current.setting,
            tooltipMessage: S.current.setting,
            icon: CupertinoIcons.settings,
            items: [
              MacosPulldownMenuItem(
                title: Text(S.current.set_command_interval),
                onTap: _inputCommandInterval,
              ),
              MacosPulldownMenuItem(
                title: Text(S.current.set_process_name),
                onTap: _inputProcessName,
              ),
              MacosPulldownMenuItem(
                title: Text(S.current.clear),
                onTap: _clearChart,
              ),
            ],
          ),
          ToolBarPullDownButton(
            label: S.current.file,
            icon: CupertinoIcons.doc,
            tooltipMessage: S.current.file,
            items: [
              MacosPulldownMenuItem(
                label: S.current.import,
                title: Text(S.current.import),
                onTap: _importFile,
              ),
              MacosPulldownMenuItem(
                label: S.current.export,
                title: Text(S.current.export),
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
      return S.current.memory_page_title_default;
    }
    return S.current.memory_page_title_common(_curProcessName!);
  }

  _inputProcessName() {
    Future.delayed(const Duration(milliseconds: 10), () {
      Util.showInputDialog(context, S.current.hint_input_process_name, (value) {
        _onSetProcessName(value);
      });
    });
  }

  _clearChart() {
    _memInfoList.clear();
    _refreshChartData();
    _firstTimeMs = 0;
    _refreshUi();
  }

  _inputCommandInterval() {
    Future.delayed(const Duration(milliseconds: 10), () {
      Util.showInputDialog(context, S.current.hint_input_interval, (value) {
        try {
          int interval = int.parse(value);
          if (interval < 1000) {
            Util.showConfirmDialog(context: context, message: S.current.input_interval_not_valid);
          } else {
            _commandIntervalMs = interval;
            if (_commandTimer?.isActive ?? false) {
              if (_isRunning) {
                _start();
              }
            }
          }
        } catch (e) {
          Util.showConfirmDialog(context: context, message: S.current.input_interval_not_valid);
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
    _statusText = S.current.stop;
    _isRunning = false;
    _refreshUi();
  }

  _requestMemInfo() async {
    if (_curProcessName == null || _curProcessName!.isEmpty) {
      _statusText = S.current.status_error_process_name_empty;
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
        _statusText = S.current.success;
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
    return '${now.year}-${Util.twoDigits(now.month)}-${Util.twoDigits(now.day)} ${Util.twoDigits(now.hour)}-${Util.twoDigits(now.minute)}-${Util.twoDigits(now.second)}: $text';
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
        MemSizeWidget(size: currentMemInfo.totalSize, color: totalSizeColor),
        const SizedBox(
          width: 20,
        ),
        MemSizeWidget(size: currentMemInfo.nativeHeapSize, color: nativeSizeColor),
        const SizedBox(
          width: 20,
        ),
        MemSizeWidget(size: currentMemInfo.javaHeapSize, color: javaSizeColor),
        const SizedBox(
          width: 20,
        ),
        MemSizeWidget(size: currentMemInfo.graphicSize, color: graphicSizeColor),
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
          width: 15,
        ),
        MemColorTipWidget(text: 'native', color: nativeSizeColor),
        SizedBox(
          width: 15,
        ),
        MemColorTipWidget(text: 'java', color: javaSizeColor),
        SizedBox(
          width: 15,
        ),
        MemColorTipWidget(text: 'graphic', color: graphicSizeColor),
      ],
    );
  }

  _onSetProcessName(String? processName) async {
    if (processName == null || processName.isEmpty) {
      await Util.showConfirmDialog(context: context, message: S.current.status_error_process_name_empty);
    } else {
      if (_curProcessName != processName) {
        _memInfoList.clear();
      }
      _curProcessName = processName;
      _start();
    }
  }

  _importFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(dialogTitle: S.current.select_import_file);

    if (result != null && result.files.single.path != null) {
      String? path = result.files.single.path;
      if (path != null) {
        List<MemoryInfo> memInfoList = [];
        File file = File(path);
        try {
          String content = await file.readAsString();
          List? result = jsonDecode(content);
          if (result != null && result.isNotEmpty) {
            for (var element in result) {
              MemoryInfo memoryInfo = MemoryInfo.fromJson(element);
              memInfoList.add(memoryInfo);
            }
          }
          if (memInfoList.isNotEmpty) {
            Util.showMemChartDialog(context: context, memInfoList: memInfoList);
          }
        } catch (e) {
          _statusText = '$e';
          _refreshUi();
        }
      }
    }
  }

  _exportFile() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath(dialogTitle: S.current.select_export_path);
    // print('selectedDirector-->$selectedDirectory');
    if (selectedDirectory != null) {
      File file = File(Path.join(selectedDirectory, Util.getMemExportFileName()));
      String content = jsonEncode(_memInfoList);
      try {
        await file.writeAsString(content);
        await Util.showConfirmDialog(context: context, message: S.current.exporting_success(file));
      } catch (e) {
        await Util.showConfirmDialog(context: context, message: S.current.exporting_fail(e));
      }
    }
  }

  _refreshUi() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _commandTimer?.cancel();
    super.dispose();
  }
}

class MemSizeWidget extends StatelessWidget {
  final int size;
  final Color color;

  const MemSizeWidget({Key? key, required this.size, required this.color}) : super(key: key);
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
        Text('${(size / 1024.0).round()}MB'),
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
          width: 5,
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
