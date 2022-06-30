import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'mem_info.dart';

/// @Author wangyang
/// @Description
/// @Date 2022/6/30
class MemCharUtil {
  static LineChartData getLineCharData(List<MemoryInfo> memInfoList) {
    return LineChartData(
      lineTouchData: getLineTouchData(),
      gridData: getGridData(),
      titlesData: getTitlesData(),
      borderData: getBorderData(),
      lineBarsData: getLineBarsData(memInfoList),
      minX: 0.0,
      maxX: 8,
      minY: 0,
      maxY: 2.0,
    );
  }

  static List<LineChartBarData> getLineBarsData(List<MemoryInfo> memInfoList) {
    List<FlSpot> totalSizeSpotList = [];
    List<FlSpot> nativeSizeSpotList = [];
    for (var memInfo in memInfoList) {
      totalSizeSpotList.add(FlSpot(getMemoryChartXValue(memInfo.time), getMemoryChartYValue(memInfo.totalSize)));
      nativeSizeSpotList.add(FlSpot(getMemoryChartXValue(memInfo.time), getMemoryChartYValue(memInfo.nativeHeapSize)));
    }
    return [
      getLineChartBarData(Colors.red, totalSizeSpotList),
      getLineChartBarData(Colors.greenAccent, nativeSizeSpotList),
    ];
  }

  static double getMemoryChartYValue(int kb){
    String gb=(kb/1024.0/1024.0).toStringAsFixed(3);
    return double.parse(gb);
  }

  static double getMemoryChartXValue(int timeMs){
    String minute=(timeMs/1000.0/60.0).toStringAsFixed(2);
    return double.parse(minute);
  }

  static LineChartBarData getLineChartBarData(Color color, List<FlSpot> spots) {
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
  static LineTouchData getLineTouchData() {
    return LineTouchData(
      handleBuiltInTouches: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
      ),
    );
  }

  ///是否显示表格线
  static FlGridData getGridData() {
    return FlGridData(show: false);
  }

  ///坐标轴标题
  static FlTitlesData getTitlesData() {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: getBottomTitles(),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: getLeftTitles(),
      ),
    );
  }

  static SideTitles getBottomTitles() {
    return SideTitles(
      showTitles: true,
      reservedSize: 32,
      interval: 0.5,
      getTitlesWidget: (value, meta) {
        const style = TextStyle(
          color: Color(0xff72719b),
          fontWeight: FontWeight.bold,
          fontSize: 16,
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

  static SideTitles getLeftTitles() {
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

  static FlBorderData getBorderData() {
    return FlBorderData(
      show: true,
      border: const Border(
        bottom: BorderSide(color: Color(0xff4e4965), width: 4),
        left: BorderSide(color: Color(0xff4e4965), width: 4),
        right: BorderSide(color: Colors.transparent),
        top: BorderSide(color: Colors.transparent),
      ),
    );
  }
}
