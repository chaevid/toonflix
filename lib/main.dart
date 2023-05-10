import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:toonflix/style/color_schemes.g.dart';
// import 'package:toonflix/theme.dart';

void main() {
  // GoogleFonts.config.allowRuntimeFetching = false;
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(const App());
}

const primaryColor = Color(0xFF000000);
const secondaryColor = Color(0xFFFFD118); // arowse-gold

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeMode themeMode = ThemeMode.system;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return SchedulerBinding.instance.window.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final appBarTheme = AppBarTheme(
    //   titleTextStyle: Theme.of(context).textTheme.bodyLarge,
    // );

    // final textTheme = Theme.of(context).textTheme;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        brightness: Brightness.light,
        // textTheme: toonflixTextTheme(textTheme),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        brightness: Brightness.dark,
        // textTheme: toonflixTextTheme(textTheme, brightness: Brightness.dark),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('arowse'),
        ),
        body: Column(
          children: [
            // Switch(value: useLightMode, onChanged: handleBrightnessChange),
            IconButton(
              icon: useLightMode
                  ? const Icon(Icons.dark_mode_outlined)
                  : const Icon(Icons.light_mode_outlined),
              onPressed: () => handleBrightnessChange(!useLightMode),
            ),
            FilledButton(onPressed: () {}, child: const Text('arowse')),
            FilledButton.tonal(onPressed: () {}, child: const Text('arowse')),
            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
            const Text(
              'Blog Title',
              // style: toonflixTextTheme(textTheme).headlineLarge,
            ),
            const Text(
              'Augmented Reality (AR) has been on the rise in recent years, offering a new way for consumers to engage with products and services. AR technology overlays digital information onto the real world, allowing consumers to see products in their own space, making it easier to understand the size, shape, and look of the product. With AR technology, consumers can engage with products in a more immersive way, which has led to the emergence of AR commerce.',
            ),
          ],
        ),
      ),
    );
  }
}
