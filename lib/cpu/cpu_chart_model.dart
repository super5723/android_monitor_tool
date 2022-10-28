import 'dart:math';

import 'package:android_monitor_tool/cpu/cpu_info.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../util.dart';

/// @Author wangyang
/// @Description
/// @Date 2022/10/28
class CpuChartModel {
  final List<CpuInfo> cpuInfoList;
  late final int _xMultiple;
  CpuChartModel(this.cpuInfoList) {
    if (cpuInfoList.length > 1) {
      _xMultiple = ((cpuInfoList.last.time / (1.0 * 1000 * 60)) / 8.0).ceil();
    } else {
      _xMultiple = 1;
    }
  }

  LineChartData getLineChartData() {
    return LineChartData(
      lineTouchData: _getLineTouchData(),
      gridData: _getGridData(),
      titlesData: _getTitlesData(),
      borderData: _getBorderData(),
      lineBarsData: cpuInfoList.isEmpty ? null : _getLineBarsData(cpuInfoList),
      minX: 0.0,
      maxX: 8.0 * _xMultiple,
      minY: 0.0,
      maxY: 100.0,
    );
  }

  List<LineChartBarData> _getLineBarsData(List<CpuInfo> cpuInfoList) {
    List<FlSpot> spotList = [];
    for (var cpuInfo in cpuInfoList) {
      double x = Util.getMemoryChartXValue(cpuInfo.time);
      spotList.add(FlSpot(x, cpuInfo.usage));
    }
    return [
      LineChartBarData(
        isCurved: false,
        color: Colors.redAccent,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: true),
        spots: spotList,
      ),
    ];
  }

  ///接触折线时，提示的样式
  LineTouchData _getLineTouchData() {
    return LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          maxContentWidth: 130,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = TextStyle(
                color: touchedSpot.bar.gradient?.colors.first ?? touchedSpot.bar.color ?? Colors.blueGrey,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );
              return LineTooltipItem('${touchedSpot.y.round()}%', textStyle);
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
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      drawHorizontalLine: true,
    );
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

  ///y轴：cpu使用率
  SideTitles _getLeftTitles() {
    return SideTitles(
      getTitlesWidget: (value, meta) {
        const style = TextStyle(
          color: Color(0xff75729e),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        );
        return Text(value == 0 ? '' : '$value', style: style, textAlign: TextAlign.center);
      },
      showTitles: true,
      interval: 20,
      reservedSize: 40,
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
          fontSize: 12.0,
        );
        return SideTitleWidget(
          axisSide: meta.axisSide,
          space: 12,
          angle: pi / 2,
          child: Text(value == 0 ? '' : '$value', style: style),
        );
      },
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
}
