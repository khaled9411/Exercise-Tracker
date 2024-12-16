import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/workout.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Workout> _recentWorkouts = [];

  @override
  void initState() {
    super.initState();
    _loadRecentWorkouts();
  }

  void _loadRecentWorkouts() async {
    final workouts = await DatabaseHelper.instance.getAllWorkouts();
    setState(() {
      _recentWorkouts = workouts.take(5).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تطبيق تتبع التمارين')),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.fitness_center,
                  size: 60,
                  color: Colors.blue,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مرحبًا بك',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'نظرة عامة على تمارينك الأخيرة',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _recentWorkouts.isEmpty
                ? Center(
                    child: Text(
                      'لا توجد تمارين مسجلة بعد',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _recentWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = _recentWorkouts[index];
                      return ListTile(
                        title: Text(workout.name),
                        subtitle: Text(
                          'المجموعات: ${workout.sets} | التكرارات: ${workout.repetitions}',
                        ),
                        trailing: Text(
                          '${workout.date.toLocal().toString().split(' ')[0]}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
