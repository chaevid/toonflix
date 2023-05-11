import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.red),
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
  final bool _isTest = false; // Test mode, Time unit : min -> sec
  int _timeInSeconds = 15 * 60;
  bool _isRunning = false;
  int _completedCycles = 0;
  int _completedRounds = 0;
  Timer? _timer;
  final int _targetTotalRound = 4;
  final int _targetTotalGoal = 12;
  bool _isOnBreak = false;
  int _selectedTimeMin = 15 * 60; // selected time in minutes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[500],
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 24,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('POMOTIMER'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.white,
                child: SizedBox(
                  width: 120,
                  height: 160,
                  child: Center(
                    child: Text(
                      '${_timeInSeconds ~/ 60}',
                      style: TextStyle(
                        color: Colors.red[500],
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const Text(
                ":",
                style: TextStyle(color: Colors.white54, fontSize: 64),
              ),
              Card(
                color: Colors.white,
                child: SizedBox(
                  width: 120,
                  height: 160,
                  child: Center(
                    child: Text(
                      '${_timeInSeconds % 60}',
                      style: TextStyle(
                        color: Colors.red[500],
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            _isOnBreak ? 'Rest Time 😎' : 'Focus Time 🔥',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [15, 20, 25, 30, 35]
                  .map((e) => Padding(
                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                        child: _timerButton(e),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 48),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.black26,
            child: _isRunning
                ? IconButton(
                    iconSize: 48,
                    color: Colors.white,
                    icon: const Icon(Icons.pause),
                    onPressed: () {
                      setState(() {
                        _isRunning = false;
                        _timer?.cancel();
                      });
                    },
                  )
                : IconButton(
                    iconSize: 48,
                    color: Colors.white,
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        _isRunning = true;
                        _startTimer(_selectedTimeMin);
                      });
                    },
                  ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    '$_completedCycles / $_targetTotalRound',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "ROUND",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Text(
                    '$_completedRounds / $_targetTotalGoal',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "GOAL",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ],
          ),
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
                  actions: [
                    TextButton(
                      child: const Text('Reset Timer'),
                      onPressed: () {
                        _completedRounds = 0;
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
    return _selectedTimeMin == minutes
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red[500],
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              setState(() {
                _isRunning = false;
                _timer?.cancel();
                _timeInSeconds = _isTest ? minutes : minutes * 60;
                _isOnBreak = false;
                _selectedTimeMin = minutes;
              });
            },
            child: Text('$minutes'),
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              side: const BorderSide(width: 2, color: Colors.white60),
            ),
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
