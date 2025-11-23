import 'package:flutter/material.dart';
import 'package:sma_physio_game/screens/exercise_game_screen.dart';
import 'package:sma_physio_game/screens/caregiver_dashboard.dart';
import 'package:sma_physio_game/utils/constants.dart';
import 'package:sma_physio_game/services/storage_service.dart';

/// Home screen with welcome message and exercise selection
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService();
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    setState(() => _isLoading = true);
    final stats = await _storage.getStatistics();
    setState(() {
      _stats = stats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.primaryColor.withOpacity(0.8),
              AppConstants.secondaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: Colors.white))
              : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        SizedBox(height: 40),
        
        // App Title
        Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'Make therapy fun!',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white70,
          ),
        ),
        
        SizedBox(height: 40),
        
        // Stats Summary
        if (_stats != null && _stats!['totalSessions'] > 0)
          _buildStatsCard(),
        
        Spacer(),
        
        // Exercise Buttons
        _buildExerciseButton(
          context,
          'Arm Raise Game',
          'Lift your arms to pop bubbles!',
          Icons.emoji_people,
          ExerciseType.armRaise,
        ),
        
        SizedBox(height: 20),
        
        _buildExerciseButton(
          context,
          'Shoulder Rotation',
          'Coming Soon',
          Icons.rotate_right,
          ExerciseType.shoulderRotation,
          isDisabled: true,
        ),
        
        SizedBox(height: 40),
        
        // Dashboard Button
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CaregiverDashboard(),
              ),
            );
          },
          icon: Icon(Icons.bar_chart, size: 28),
          label: Text(
            'View Progress',
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppConstants.primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        
        Spacer(),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Sessions',
            _stats!['totalSessions'].toString(),
            Icons.fitness_center,
          ),
          _buildStatItem(
            'Score',
            _stats!['totalScore'].toString(),
            Icons.star,
          ),
          _buildStatItem(
            'Reps',
            _stats!['totalReps'].toString(),
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppConstants.primaryColor, size: 28),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryColor,
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
    );
  }

  Widget _buildExerciseButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    ExerciseType exerciseType, {
    bool isDisabled = false,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: ElevatedButton(
        onPressed: isDisabled
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExerciseGameScreen(
                      exerciseType: exerciseType,
                    ),
                  ),
                ).then((_) => _loadStats());
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppConstants.primaryColor,
          disabledBackgroundColor: Colors.grey[300],
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDisabled
                    ? Colors.grey[400]
                    : AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                size: 40,
                color: isDisabled
                    ? Colors.grey[600]
                    : AppConstants.primaryColor,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDisabled ? Colors.grey[600] : null,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDisabled
                          ? Colors.grey[500]
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isDisabled ? Icons.lock : Icons.arrow_forward_ios,
              color: isDisabled ? Colors.grey[400] : AppConstants.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
