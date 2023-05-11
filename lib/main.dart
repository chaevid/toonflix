import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
      ),
      home: const PomodoroTimer(),
    );
  }
}

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});

  @override
  State<PomodoroTimer> createState() => _PomodoroTimerState();
}

class _PomodoroTimerState extends State<PomodoroTimer> {
  final bool _isTest = true; // Test mode, Time unit : min -> sec
  int _timeInSeconds = 2;
  bool _isRunning = false;
  int _completedCycles = 0;
  int _completedRounds = 0;
  Timer? _timer;
  final int _targetTotalRound = 2;
  final int _targetTotalGoal = 2;
  bool _isOnBreak = false;
  int _selectedTimeMin = 2; // selected time in minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POMOTIMER'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(_isOnBreak
              ? 'Rest: ${_timeInSeconds ~/ 60} min ${_timeInSeconds % 60} sec'
              : 'Timer: ${_timeInSeconds ~/ 60} min ${_timeInSeconds % 60} sec'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // children: [15, 20, 25, 30, 35].map((e) => _timerButton(e)).toList(),
            children: [2, 3, 4, 5, 6].map((e) => _timerButton(e)).toList(),
          ),
          _isRunning
              ? IconButton(
                  icon: const Icon(Icons.pause),
                  onPressed: () {
                    setState(() {
                      _isRunning = false;
                      _timer?.cancel();
                    });
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      _isRunning = true;
                      _startTimer(_selectedTimeMin);
                    });
                  },
                ),
          Text('Round: $_completedCycles/$_targetTotalRound'),
          Text('Goal: $_completedRounds/$_targetTotalGoal'),
        ],
      ),
    );
  }

  void _startTimer(int minutes) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeInSeconds > 0) {
          _timeInSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          if (!_isOnBreak) {
            _completedCycles++;
            if (_completedCycles >= _targetTotalRound) {
              _completedRounds++;
              _completedCycles = 0;
              _timeInSeconds = _isTest ? 5 : 5 * 60; // 5 min break
              _isOnBreak = true;
            } else {
              _timeInSeconds = _isTest ? 5 : 5 * 60; // 5 min break
              _isOnBreak = true;
            }

            _isRunning = true;
            _startTimer(_timeInSeconds);
          } else {
            _isOnBreak = false;
            _timeInSeconds = _isTest
                ? _selectedTimeMin
                : _selectedTimeMin * 60; // reset timer
            _isRunning = false;
            _timer?.cancel();
          }
          if (_completedRounds == _targetTotalGoal) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Success!'),
                  content: const Text('You have reached your goal!'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Reset Timer'),
                      onPressed: () {
                        _completedRounds = 00;
                        _completedCycles = 0;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        }
      });
    });
  }

  Widget _timerButton(int minutes) {
    return ElevatedButton(
      child: Text('$minutes'),
      onPressed: () {
        setState(() {
          _isRunning = false;
          _timer?.cancel();
          _timeInSeconds = _isTest ? minutes : minutes * 60;
          _isOnBreak = false;
          _selectedTimeMin = minutes;
        });
      },
    );
  }
}
