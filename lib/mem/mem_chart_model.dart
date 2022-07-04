import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'mem_info.dart';

/// @Author wangyang
/// @Description
/// @Date 2022/6/30
class MemChartModel {
  static const Color totalSizeColor = Colors.redAccent;
  static const Color nativeSizeColor = Colors.deepPurpleAccent;
  static const Color javaSizeColor = Colors.greenAccent;
  static const Color graphicSizeColor = Colors.orangeAccent;
  final List<MemoryInfo> _memInfoList;
  late final int _xMultiple;
  MemChartModel(this._memInfoList) {
    _xMultiple = ((_memInfoList.last.time / (1.0 * 1000 * 60)) / 8.0).ceil();
  }

  LineChartData getLineCharData() {
    return LineChartData(
      lineTouchData: _getLineTouchData(),
      gridData: _getGridData(),
      titlesData: _getTitlesData(),
      borderData: _getBorderData(),
      lineBarsData: _getLineBarsData(_memInfoList),
      minX: 0.0,
      maxX: 8.0 * _xMultiple,
      minY: 0,
      maxY: 2.0,
    );
  }

  List<LineChartBarData> _getLineBarsData(List<MemoryInfo> memInfoList) {
    List<FlSpot> totalSizeSpotList = [];
    List<FlSpot> nativeSizeSpotList = [];
    List<FlSpot> javaSizeSpotList = [];
    List<FlSpot> graphicSizeSpotList = [];
    for (var memInfo in memInfoList) {
      double x = _getMemoryChartXValue(memInfo.time);
      totalSizeSpotList.add(FlSpot(x, _getMemoryChartYValue(memInfo.totalSize)));
      nativeSizeSpotList.add(FlSpot(x, _getMemoryChartYValue(memInfo.nativeHeapSize)));
      javaSizeSpotList.add(FlSpot(x, _getMemoryChartYValue(memInfo.javaHeapSize)));
      graphicSizeSpotList.add(FlSpot(x, _getMemoryChartYValue(memInfo.graphicSize)));
    }
    return [
      _getLineChartBarData(totalSizeColor, totalSizeSpotList),
      _getLineChartBarData(graphicSizeColor, graphicSizeSpotList),
      _getLineChartBarData(javaSizeColor, javaSizeSpotList),
      _getLineChartBarData(nativeSizeColor, nativeSizeSpotList),
    ];
  }

  ///y轴以GB为单位
  double _getMemoryChartYValue(int kb) {
    String gb = (kb / 1024.0 / 1024.0).toStringAsFixed(3);
    return double.parse(gb);
  }

  ///x轴以分为单位
  double _getMemoryChartXValue(int timeMs) {
    String minute = (timeMs / 1000.0 / 60.0).toStringAsFixed(2);
    return double.parse(minute);
  }

  ///每条折线的配置
  LineChartBarData _getLineChartBarData(Color color, List<FlSpot> spots) {
    return LineChartBarData(
      isCurved: false,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: true),
      spots: spots,
    );
  }

  ///接触折线时，提示的样式
  LineTouchData _getLineTouchData() {
    return LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = TextStyle(
                color: touchedSpot.bar.gradient?.colors.first ?? touchedSpot.bar.color ?? Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return LineTooltipItem(
                  '${getLineChartBarDescByIndex(touchedSpot.barIndex)}:${touchedSpot.y * 1000}MB', textStyle);
            }).toList();
          },
        ),
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((int index) {
            /// Indicator Line
            var lineColor = Colors.brown;
            const lineStrokeWidth = 2.0;
            final flLine = FlLine(color: lineColor, strokeWidth: lineStrokeWidth);
            var dotSize = 3.0;
            final dotData = FlDotData(
                getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                      radius: dotSize,
                      color: bar.color,
                      strokeColor: Colors.white,
                    ));

            return TouchedSpotIndicatorData(flLine, dotData);
          }).toList();
        });
  }

  ///是否显示表格线
  FlGridData _getGridData() {
    return FlGridData(show: true, drawVerticalLine: false, drawHorizontalLine: true, horizontalInterval: 0.25);
  }

  ///坐标轴标题配置
  FlTitlesData _getTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: _getBottomTitles(),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: _getLeftTitles(),
      ),
    );
  }

  ///x轴：时间
  SideTitles _getBottomTitles() {
    return SideTitles(
      showTitles: true,
      reservedSize: 32,
      interval: 0.5 * _xMultiple,
      getTitlesWidget: (value, meta) {
        var style = const TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        );
        return SideTitleWidget(
          axisSide: meta.axisSide,
          space: 10,
          angle: pi / 2,
          child: Text('$value', style: style),
        );
      },
    );
  }

  ///y轴：GB
  SideTitles _getLeftTitles() {
    return SideTitles(
      getTitlesWidget: (value, meta) {
        const style = TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );
        return Text('$value', style: style, textAlign: TextAlign.center);
      },
      showTitles: true,
      interval: 0.25,
      reservedSize: 40,
    );
  }

  ///只展示左边和下边的两条轴线
  FlBorderData _getBorderData() {
    return FlBorderData(
      show: true,
      border: const Border(
        bottom: BorderSide(color: Colors.black, width: 4),
        left: BorderSide(color: Colors.black, width: 4),
        right: BorderSide(color: Colors.transparent),
        top: BorderSide(color: Colors.transparent),
      ),
    );
  }

  getLineChartBarDescByIndex(int index) {
    if (index == 0) {
      return 'total';
    } else if (index == 1) {
      return 'graphic';
    } else if (index == 2) {
      return 'java';
    } else {
      return 'native';
    }
  }
}
