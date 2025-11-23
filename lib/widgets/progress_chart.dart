import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sma_physio_game/models/exercise_session.dart';
import 'package:sma_physio_game/utils/constants.dart';

/// Widget to display progress chart
class ProgressChartWidget extends StatelessWidget {
  final List<ExerciseSession> sessions;
  final String title;

  const ProgressChartWidget({
    Key? key,
    required this.sessions,
    this.title = 'Progress Over Time',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return _buildEmptyState();
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppConstants.subtitleStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(_createChartData()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No data yet',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
              Text(
                'Start exercising to see your progress!',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LineChartData _createChartData() {
    final spots = sessions.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value.correctReps.toDouble(),
      );
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 5,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= sessions.length) {
                return SizedBox.shrink();
              }
              return Text(
                '${value.toInt() + 1}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              );
            },
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppConstants.primaryColor,
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: AppConstants.primaryColor,
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppConstants.primaryColor.withOpacity(0.1),
          ),
        ),
      ],
      minY: 0,
      maxY: _getMaxY(),
    );
  }

  double _getMaxY() {
    if (sessions.isEmpty) return 10;
    
    final maxReps = sessions
        .map((s) => s.correctReps)
        .reduce((a, b) => a > b ? a : b);
    
    return (maxReps + 5).toDouble();
  }
}

/// Simple statistics card
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
