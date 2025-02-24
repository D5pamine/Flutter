import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.0,  // ✅ 차트 비율 조정
      child: BarChart(
        BarChartData(
          maxY: 2000, // ✅ 최대값 2000
          barGroups: _chartData(),
          borderData: FlBorderData(show: false),  // ✅ 테두리 제거
          gridData: const FlGridData(show: true, drawVerticalLine: false,),  // ✅ 가로선 표시
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false, reservedSize: 40),
            ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true, interval: 1000, reservedSize: 40), // ✅ 500 단위
              ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const days = ['월', '화', '수', '목', '금', '토', '일'];
                  return Text(days[value.toInt()], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500));
                },
                reservedSize: 24,
              ),
            ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false))
          ),
        ),
      ),
    );
  }

  /// ✅ 차트 데이터 설정
  List<BarChartGroupData> _chartData() {
    final List<double> values = [1200, 2000, 500, 1500, 2100, 600, 1300];

    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index].toDouble(),
            color: Colors.orangeAccent,
            width: 8,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    });
  }
}
