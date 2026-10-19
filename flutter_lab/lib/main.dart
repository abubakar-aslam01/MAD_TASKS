// main.dart - Study Tracker lab
import 'dart:async';

import 'package:flutter/material.dart';

const String studentName = 'ABUBAKAR';
const String rollNo = '04072313027'; // e.g. '21F-0347'

// ===== Seeded settings (generated from YOUR roll number). Do not edit. =====
final int seed = int.parse(rollNo.substring(rollNo.length - 2));
final int t = seed ~/ 10; // tens digit
final int u = seed % 10; // units digit

const List<String> courses = [
  'Mobile Dev',
  'Data Structures',
  'Operating Systems',
  'Databases',
  'Networks',
  'Software Eng',
  'AI',
  'Web Engineering',
  'Graphics',
  'Security',
];

final String course = courses[u]; // your course name
final int startCount = 3 + u; // where the tally starts
final int stepSize = 1 + t % 4; // how much + and - change the tally
final int maxCount = 20 + 2 * t; // the tally may never go above this
final int startSeconds = 5 + (t + u) % 6; // where the countdown starts
final int bugStep = 1 + u % 4; // used by BuggyCounter in Step 7
// ===========================================================================

// Step 9 writes to this list from initState and dispose.
final List<String> lifecycleLog = <String>[];

void main() => runApp(const LabApp());

// Keep the name LabApp and its const constructor: the checker uses them.
class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Think (Step 1): runApp receives the ROOT widget of the whole app (LabApp),
    // while MaterialApp receives `home`, which is just the first screen/page
    // that MaterialApp shows inside itself.
    return const MaterialApp(title: 'Study Tracker', home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Think (Step 3): LabApp -> MaterialApp -> HomePage -> Scaffold ->
    // SingleChildScrollView -> Column -> Row -> Text('Max: ..')
    // count the levels on your own paper tree.
    return Scaffold(
      appBar: AppBar(title: Text('Study Tracker: $course')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StudentCard(name: studentName, roll: rollNo, course: course),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Start: $startCount', key: const Key('info-start')),
                Text('Step: $stepSize', key: const Key('info-step')),
                Text('Max: $maxCount', key: const Key('info-max')),
              ],
            ),
            const SizedBox(height: 12),
            const Tally(),
            const SizedBox(height: 12),
            const Countdown(),
            const SizedBox(height: 12),
            const BuggyCounter(),
          ],
        ),
      ),
    );
  }
}

class StudentCard extends StatelessWidget {
  // Think (Step 2): fields are final because a StatelessWidget is immutable;
  // without final the analyzer complains that a class with a const
  // constructor must only have final fields.
  final String name;
  final String roll;
  final String course;

  const StudentCard({
    super.key,
    required this.name,
    required this.roll,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', key: const Key('student-name')),
            Text('Roll no: $roll', key: const Key('student-roll')),
            Text('Course: $course', key: const Key('student-course')),
          ],
        ),
      ),
    );
  }
}

class GoalBanner extends StatelessWidget {
  // Think (Step 4): no setState needed because it holds no changing data.
  // To show a new count the parent rebuilds and passes a new count.
  final int count;
  final int max;

  const GoalBanner({super.key, required this.count, required this.max});

  @override
  Widget build(BuildContext context) {
    final percent = count * 100 ~/ max;
    return Text(
      'Progress: $count of $max ($percent%)',
      key: const Key('progress'),
    );
  }
}

class Tally extends StatefulWidget {
  // Think (Step 5): two classes because the widget is immutable configuration
  // (recreated on rebuild), while the State object lives on and keeps the
  // memory (_count) between rebuilds.
  const Tally({super.key});

  @override
  State<Tally> createState() => _TallyState();
}

class _TallyState extends State<Tally> {
  int _count = startCount;

  void _plus() {
    setState(() {
      _count += stepSize;
      if (_count > maxCount) _count = maxCount;
    });
  }

  void _minus() {
    setState(() {
      _count -= stepSize;
      if (_count < 0) _count = 0;
    });
  }

  void _reset() {
    setState(() {
      _count = startCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Think (Step 6): hot reload keeps the State, so the count stays 12
    // (only the widget code is updated). Hot restart throws the State away
    // and starts the app again, so the count goes back to startCount.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Count: $_count', key: const Key('count')),
        GoalBanner(count: _count, max: maxCount),
        Row(
          children: [
            ElevatedButton(
              key: const Key('plus'),
              onPressed: _plus,
              child: Text('+$stepSize'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              key: const Key('minus'),
              onPressed: _minus,
              child: Text('-$stepSize'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              key: const Key('reset'),
              onPressed: _reset,
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}

class Countdown extends StatefulWidget {
  const Countdown({super.key});

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late int _left;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _left = startSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _left--);
      if (_left <= 0) timer.cancel(); // stop at zero
    });
  }

  @override
  void dispose() {
    // Think (Step 8): without cancel, the timer keeps firing after the widget
    // is removed and calls setState() on a disposed State:
    // "setState() called after dispose()".
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _left > 0
        ? Text('Time left: $_left s', key: const Key('time-left'))
        : const Text('Time is up!', key: Key('time-left'));
  }
}

// ---- Provided for Step 7. It has a bug on purpose. Do not rename anything.
class BuggyCounter extends StatefulWidget {
  const BuggyCounter({super.key});

  @override
  State<BuggyCounter> createState() => _BuggyCounterState();
}

class _BuggyCounterState extends State<BuggyCounter> {
  int _clicks = 0;

  @override
  Widget build(BuildContext context) {
    // Think (Step 7): before the fix, after 3 taps _clicks inside the State
    // was 3 * bugStep, but the screen still showed 0 (no rebuild happened).
    return Row(
      children: [
        Text('Bug clicks: $_clicks', key: const Key('bug-text')),
        const SizedBox(width: 12),
        ElevatedButton(
          key: const Key('bug-button'),
          onPressed: () {
            setState(() {
              _clicks += bugStep;
            });
          },
          child: Text('+$bugStep'),
        ),
      ],
    );
  }
}
