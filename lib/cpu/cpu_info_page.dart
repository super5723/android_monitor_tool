import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:path/path.dart' as Path;
import '../generated/l10n.dart';
import '../shell.dart';
import '../util.dart';
import 'cpu_chart_model.dart';
import 'cpu_info.dart';

/// @Author wangyang
/// @Description
/// @Date 2022/7/7
class CpuInfoPage extends StatefulWidget {
  const CpuInfoPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CpuInfoPageState();
  }
}

class _CpuInfoPageState extends State<CpuInfoPage> {
  int _commandIntervalMs = 1000;
  Timer? _commandTimer;
  final List<CpuInfo> _cpuInfoList = [];
  int _firstTimeMs = 0;
  String _statusText = S.current.stop;
  late LineChartData _chartData;
  bool _isRunning = false;
  int? _lastCpuSum;
  int? _lastCpuIdle;

  @override
  void initState() {
    super.initState();
    _refreshChartData();
  }

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: ToolBar(
        title: Text(S.current.cpu_page_title),
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
                      _getCurrentCpuInfoWidget(),
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

  _getWrapStatusText(String text) {
    DateTime now = DateTime.now();
    return '${now.year}-${Util.twoDigits(now.month)}-${Util.twoDigits(now.day)} ${Util.twoDigits(now.hour)}-${Util.twoDigits(now.minute)}-${Util.twoDigits(now.second)}: $text';
  }

  _getCurrentCpuInfoWidget() {
    if (_cpuInfoList.isEmpty) {
      return const SizedBox.shrink();
    }
    CpuInfo currentCpuInfo = _cpuInfoList.last;
    return Text(S.current.realtime_cpu_usage(currentCpuInfo.usage.toInt()));
  }

  _clearChart() {
    _cpuInfoList.clear();
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
    _commandTimer?.cancel();
    _commandTimer = Timer.periodic(Duration(milliseconds: _commandIntervalMs), (timer) {
      _requestCpuInfo();
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

  _requestCpuInfo() async {
    ShellCommand command = ShellCommand(
      'adb',
      [
        'shell',
        'cat',
        '/proc/stat',
        '|',
        'sed',
        '-n',
        '1p',
      ],
    );

    CommandResult commandResult = await command.run();
    if (commandResult.success) {
      CpuInfo? cpuInfo = _parseCpuInfo(commandResult.result);
      if (cpuInfo != null) {
        _statusText = S.current.success;
        _cpuInfoList.add(cpuInfo);
        _refreshChartData();
      } else {
        _statusText = '${commandResult.result}';
      }
    } else {
      _statusText = '${commandResult.errorMsg}';
    }
    _refreshUi();
  }

  _refreshChartData() {
    _chartData = CpuChartModel(_cpuInfoList).getLineChartData();
  }

  //https://www.idnt.net/en-US/kb/941772:/proc/stat
  //cpu  9729822 1066597 6458550 28434787 16652 1413625 874319 0 0 0
  CpuInfo? _parseCpuInfo(String? result) {
    if (result == null) {
      return null;
    }
    var cpuDataList = result.split(RegExp('\\s+'));
    if (cpuDataList.length > 7) {
      //remove cpu string
      cpuDataList.removeAt(0);
      //get cpu sum
      int currentCpuSum = 0;
      int currentCpuIdle = 0;
      for (int i = 0; i < cpuDataList.length; i++) {
        int time = int.parse(cpuDataList[i]);
        if (i == 3) {
          currentCpuIdle = time;
        }
        currentCpuSum += time;
      }
      if (_lastCpuSum != null && _lastCpuIdle != null) {
        int cpuDelta = currentCpuSum - _lastCpuSum!;
        int cpuIdleDelta = currentCpuIdle - _lastCpuIdle!;
        int cpuUsed = cpuDelta - cpuIdleDelta;
        double cpuUsage = 100.0 * (cpuUsed / cpuDelta);
        int curTime = DateTime.now().millisecondsSinceEpoch;
        if (_firstTimeMs == 0) {
          _firstTimeMs = curTime;
        }
        _lastCpuSum = currentCpuSum;
        _lastCpuIdle = currentCpuIdle;
        return CpuInfo(curTime - _firstTimeMs, cpuUsage);
      } else {
        _lastCpuSum = currentCpuSum;
        _lastCpuIdle = currentCpuIdle;
      }
    }
    return null;
  }

  _refreshUi() {
    if (mounted) {
      setState(() {});
    }
  }

  _importFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(dialogTitle: S.current.select_import_file);

    if (result != null && result.files.single.path != null) {
      String? path = result.files.single.path;
      if (path != null) {
        List<CpuInfo> cpuInfoList = [];
        File file = File(path);
        try {
          String content = await file.readAsString();
          List? result = jsonDecode(content);
          if (result != null && result.isNotEmpty) {
            for (var element in result) {
              CpuInfo cpuInfo = CpuInfo.fromJson(element);
              cpuInfoList.add(cpuInfo);
            }
          }
          if (cpuInfoList.isNotEmpty) {
            Util.showCpuChartDialog(context: context, cpuInfoList: cpuInfoList);
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
      File file = File(Path.join(selectedDirectory, Util.getCpuExportFileName()));
      String content = jsonEncode(_cpuInfoList);
      try {
        await file.writeAsString(content);
        await Util.showConfirmDialog(context: context, message: S.current.exporting_success(file));
      } catch (e) {
        await Util.showConfirmDialog(context: context, message: S.current.exporting_fail(e));
      }
    }
  }

  @override
  void dispose() {
    _commandTimer?.cancel();
    super.dispose();
  }
}
