import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../database/database_helper.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _setsController = TextEditingController();
  final TextEditingController _repetitionsController = TextEditingController();

  void _addWorkout() async {
    if (_formKey.currentState!.validate()) {
      final workout = Workout(
        name: _nameController.text,
        sets: int.parse(_setsController.text),
        repetitions: int.parse(_repetitionsController.text),
        date: DateTime.now(),
      );

      await DatabaseHelper.instance.insertWorkout(workout);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم تسجيل التمرين بنجاح')),
      );

      _nameController.clear();
      _setsController.clear();
      _repetitionsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إضافة تمرين جديد')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'اسم التمرين'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم التمرين';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _setsController,
                decoration: InputDecoration(labelText: 'عدد المجموعات'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال عدد المجموعات';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _repetitionsController,
                decoration: InputDecoration(labelText: 'عدد التكرارات'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال عدد التكرارات';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addWorkout,
                child: Text('حفظ التمرين'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
