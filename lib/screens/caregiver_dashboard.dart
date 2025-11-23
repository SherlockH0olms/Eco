import 'package:flutter/material.dart';
import 'package:sma_physio_game/models/exercise_session.dart';
import 'package:sma_physio_game/services/storage_service.dart';
import 'package:sma_physio_game/widgets/progress_chart.dart';
import 'package:sma_physio_game/utils/constants.dart';
import 'package:sma_physio_game/utils/helpers.dart';

/// Dashboard for caregivers to track patient progress
class CaregiverDashboard extends StatefulWidget {
  const CaregiverDashboard({Key? key}) : super(key: key);

  @override
  State<CaregiverDashboard> createState() => _CaregiverDashboardState();
}

class _CaregiverDashboardState extends State<CaregiverDashboard> {
  final StorageService _storage = StorageService();
  
  List<ExerciseSession> _allSessions = [];
  List<ExerciseSession> _recentSessions = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = true;
  int _selectedDays = 7;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final sessions = await _storage.getSessions();
      final recentSessions = await _storage.getRecentSessions(_selectedDays);
      final stats = await _storage.getStatistics();
      
      setState(() {
        _allSessions = sessions;
        _recentSessions = recentSessions;
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Error loading data: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text('Progress Tracking'),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildDashboard(),
    );
  }

  Widget _buildDashboard() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time period selector
          _buildTimePeriodSelector(),
          
          SizedBox(height: 20),
          
          // Summary stats
          _buildSummaryCards(),
          
          SizedBox(height: 24),
          
          // Progress chart
          if (_recentSessions.isNotEmpty)
            ProgressChartWidget(
              sessions: _recentSessions,
              title: 'Correct Reps (Last $_selectedDays Days)',
            ),
          
          SizedBox(height: 24),
          
          // Recent sessions list
          _buildRecentSessionsList(),
          
          SizedBox(height: 24),
          
          // Overall statistics
          _buildOverallStats(),
        ],
      ),
    );
  }

  Widget _buildTimePeriodSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Text(
              'Show last:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(width: 12),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [7, 14, 30, 90].map((days) {
                    final isSelected = _selectedDays == days;
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('$days days'),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedDays = days);
                            _loadData();
                          }
                        },
                        selectedColor: AppConstants.primaryColor,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    if (_stats == null) return SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Sessions',
            value: '${_recentSessions.length}',
            icon: Icons.fitness_center,
            color: AppConstants.primaryColor,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Total Reps',
            value: '${_calculateTotalReps()}',
            icon: Icons.trending_up,
            color: AppConstants.secondaryColor,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: StatCard(
            title: 'Avg Score',
            value: '${_calculateAverageScore().toStringAsFixed(0)}',
            icon: Icons.star,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  int _calculateTotalReps() {
    return _recentSessions.fold(0, (sum, session) => sum + session.correctReps);
  }

  double _calculateAverageScore() {
    if (_recentSessions.isEmpty) return 0.0;
    final totalScore = _recentSessions.fold(0, (sum, session) => sum + session.totalScore);
    return totalScore / _recentSessions.length;
  }

  Widget _buildRecentSessionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Sessions',
          style: AppConstants.subtitleStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        if (_recentSessions.isEmpty)
          Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.event_busy, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No sessions in the last $_selectedDays days',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ..._recentSessions.reversed.take(10).map((session) {
            return _buildSessionCard(session);
          }).toList(),
      ],
    );
  }

  Widget _buildSessionCard(ExerciseSession session) {
    final successRate = session.successRate;
    Color rateColor;
    if (successRate >= 80) {
      rateColor = AppConstants.correctColor;
    } else if (successRate >= 60) {
      rateColor = AppConstants.tryAgainColor;
    } else {
      rateColor = AppConstants.incorrectColor;
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8),
                    Text(
                      Helpers.formatDate(session.startTime),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    SizedBox(width: 8),
                    Text(
                      Helpers.formatTime(session.startTime),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: rateColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${successRate.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: rateColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildStatItem(
                  'Reps',
                  '${session.correctReps}/${session.totalReps}',
                  Icons.fitness_center,
                ),
                SizedBox(width: 24),
                _buildStatItem(
                  'Score',
                  '${session.totalScore}',
                  Icons.star,
                ),
                SizedBox(width: 24),
                _buildStatItem(
                  'Duration',
                  Helpers.formatDuration(session.duration),
                  Icons.timer,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppConstants.primaryColor),
        SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOverallStats() {
    if (_stats == null) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overall Statistics',
          style: AppConstants.subtitleStyle.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildOverallStatRow(
                  'Total Sessions',
                  '${_stats!['totalSessions']}',
                  Icons.event_available,
                ),
                Divider(),
                _buildOverallStatRow(
                  'Total Score',
                  '${_stats!['totalScore']}',
                  Icons.emoji_events,
                ),
                Divider(),
                _buildOverallStatRow(
                  'Total Reps',
                  '${_stats!['totalReps']}',
                  Icons.trending_up,
                ),
                Divider(),
                _buildOverallStatRow(
                  'Average Score per Session',
                  '${(_stats!['avgScore'] as double).toStringAsFixed(1)}',
                  Icons.analytics,
                ),
                if (_stats!['lastSession'] != null) ...[
                  Divider(),
                  _buildOverallStatRow(
                    'Last Session',
                    Helpers.formatDate(_stats!['lastSession']),
                    Icons.history,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverallStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryColor, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
