import 'package:android_monitor_tool/common_dialog.dart';
import 'package:android_monitor_tool/generated/l10n.dart';
import 'package:android_monitor_tool/mem/mem_chart_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'mem/mem_info.dart';

/// @Author wangyang
/// @Description
/// @Date 2022/6/28
class Util {
  static int parseInt(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return defaultValue;
      }
    }
    if (value is int) return value;
    if (value is double) return value.toInt();
    return defaultValue;
  }

  ///y轴以GB为单位
  static double getMemoryChartYValue(int kb) {
    String gb = (kb / 1024.0 / 1024.0).toStringAsFixed(3);
    return double.parse(gb);
  }

  ///x轴以分为单位
  static double getMemoryChartXValue(int timeMs) {
    String minute = (timeMs / 1000.0 / 60.0).toStringAsFixed(2);
    return double.parse(minute);
  }

  static String twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static String threeDigits(int n) {
    if (n >= 100) return "$n";
    if (n >= 10) return "0$n";
    return "00$n";
  }

  static String getMemExportFileName() {
    DateTime now = DateTime.now();
    return '${now.year}-${twoDigits(now.month)}-${twoDigits(now.day)} ${twoDigits(now.hour)}-${twoDigits(now.minute)}-${twoDigits(now.second)}.json';
  }

  static showMemChartDialog(
      {required BuildContext context,
      required List<MemoryInfo> memInfoList}) async {
    LineChartData chartData = MemChartModel(memInfoList).getLineChartData();
    await showDialog(
        context: context,
        builder: (_) {
          return CommonDialog(
            content: Builder(
              builder: (_) {
                return Container(
                  width: 600,
                  height: 400,
                  padding: const EdgeInsetsDirectional.all(35),
                  child: LineChart(chartData),
                );
              },
            ),
          );
        });
  }

  static showConfirmDialog(
      {required BuildContext context,
      required String message,
      String? confirmText,
      VoidCallback? confirmCallBack,
      String? cancelText,
      VoidCallback? cancelCallBack}) async {
    await showDialog(
        context: context,
        builder: (_) {
          return CommonDialog(
            content: Builder(
              builder: (_) {
                return Container(
                  padding: const EdgeInsetsDirectional.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 100,
                          maxWidth: 300,
                        ),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: MacosTheme.of(context).typography.headline,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (cancelCallBack != null) ...[
                            PushButton(
                              buttonSize: ButtonSize.small,
                              child: Text(cancelText ?? S.current.cancel),
                              onPressed: () {
                                Navigator.pop(context);
                                cancelCallBack.call();
                              },
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                          ],
                          PushButton(
                            buttonSize: ButtonSize.small,
                            child: Text(confirmText ?? S.current.confirm),
                            onPressed: () {
                              Navigator.pop(context);
                              confirmCallBack?.call();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }

  static showInputDialog(BuildContext context, String hint,
      ValueChanged<String> valueCallBack) async {
    await showDialog(
        context: context,
        builder: (_) {
          return CommonDialog(
            content: Builder(
              builder: (_) {
                TextEditingController controller = TextEditingController();
                return Container(
                  padding: const EdgeInsetsDirectional.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 200,
                        child: MacosTextField(
                          autofocus: true,
                          controller: controller,
                          placeholder: hint,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      PushButton(
                        buttonSize: ButtonSize.small,
                        child: Text(S.current.submit),
                        onPressed: () {
                          Navigator.pop(context);
                          valueCallBack.call(controller.text);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        });
  }
}
