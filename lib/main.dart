import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

const seedColor = Color(0xFFA83DFF);

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
        useMaterial3: true,
        colorSchemeSeed: seedColor,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: seedColor,
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hello World'),
        ),
        body: Center(
          child: Text("Hello"),
        ),
      ),
    );
  }
}

// class App extends StatelessWidget {
//   const App({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           useMaterial3: true,
//           colorScheme: ColorScheme.fromSwatch(
//             primarySwatch: Colors.purple,
//           )
//           // colorScheme: ColorScheme(``)
//           ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Hello World'),
//         ),
//         body: const Center(
//           child: Text('Hello World'),
//         ),
//       ),
//     );
//   }
// }
