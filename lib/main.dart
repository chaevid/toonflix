import 'dart:developer';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const App());
}

const seedColor = Color(0xFFA83DFF);
const avatarImgUrl = 'https://avatars.githubusercontent.com/u/3612017?v=4';
const dayTextStyle = TextStyle(fontSize: 32, color: Colors.white30);

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // textTheme: GoogleFonts.outfitTextTheme(
        //   Theme.of(context).textTheme,
        // ),
        useMaterial3: true,
        colorSchemeSeed: seedColor,
        brightness: Brightness.dark, // For Challenge
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seedColor,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          leadingWidth: 56 + 32,
          leading:
              const CircleAvatar(backgroundImage: NetworkImage(avatarImgUrl)),
          actions: [
            IconButton(
              onPressed: () {
                log('Clicked - Add Button');
              },
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.add, size: 40),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DateRow(),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Column(
                    children: [
                      PlannerCard(
                        cardColor: Colors.yellow.shade500,
                        startTime: DateTime(2023, 5, 9, 11, 30),
                        endTime: DateTime(2023, 5, 9, 12, 20),
                        planTitle: 'Design Meeting',
                        participants: const ['Alex', 'Helena', 'Nana'],
                      ),
                      const SizedBox(height: 16),
                      PlannerCard(
                        cardColor: Colors.purple.shade400,
                        startTime: DateTime(2023, 5, 9, 12, 35),
                        endTime: DateTime(2023, 5, 9, 14, 10),
                        planTitle: 'Daily Project',
                        participants: const ['Me', 'Richard', 'CIRY', '+4'],
                      ),
                      const SizedBox(height: 16),
                      PlannerCard(
                        cardColor: Colors.yellow.shade800,
                        startTime: DateTime(2023, 5, 9, 15, 00),
                        endTime: DateTime(2023, 5, 9, 16, 30),
                        planTitle: 'Weekly Planning',
                        participants: const ['Den', 'Nana', 'Mark'],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateRow extends StatelessWidget {
  const DateRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> days = List<int>.generate(14, (i) => 17 + i);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('MONDAY 16'), // Today's Date
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              const Text('TODAY', style: TextStyle(fontSize: 32)),
              const Text(' · ', style: dayTextStyle),
              ...days.map(
                (day) {
                  return Text(
                    '$day ',
                    style: dayTextStyle,
                  );
                },
              ).toList(),
            ],
          ),
        ),
      ],
    );
  }
}

class PlannerCard extends StatelessWidget {
  final Color cardColor;
  final DateTime startTime;
  final DateTime endTime;
  final String planTitle;
  final List<String> participants;

  const PlannerCard({
    super.key,
    required this.cardColor,
    required this.startTime,
    required this.endTime,
    required this.planTitle,
    required this.participants,
  });
  Map<String, String> _formatTime(DateTime time) {
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    return {'hour': hour, 'minute': minute};
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    Map<String, String> formattedStartTime = _formatTime(startTime);
    Map<String, String> formattedEndTime = _formatTime(endTime);

    return SizedBox(
      width: screenWidth,
      child: Card(
        margin: EdgeInsets.zero,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48), //<-- SEE HERE
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        '${formattedStartTime['hour']}',
                        style: const TextStyle(
                            fontSize: 24,
                            height: 1.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      Text(
                        '${formattedStartTime['minute']}',
                        style: const TextStyle(
                            fontSize: 16,
                            height: 1.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.black,
                          width: 1,
                          height: 24),
                      Text(
                        '${formattedEndTime['hour']}',
                        style: const TextStyle(
                            fontSize: 24,
                            height: 1.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      Text(
                        '${formattedEndTime['minute']}',
                        style: const TextStyle(
                            fontSize: 16,
                            height: 1.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      planTitle.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 52,
                          height: 1.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(48, 0, 0, 0),
                child: Row(
                  children: List.generate(
                    participants.length,
                    (i) => Row(
                      children: [
                        Text(
                          participants[i].toUpperCase(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: (participants[i].toUpperCase() == 'ME')
                                ? Colors.black
                                : Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
