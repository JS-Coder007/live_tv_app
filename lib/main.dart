import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/channel_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const LiveTVApp());
}

class LiveTVApp extends StatelessWidget {
  const LiveTVApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChannelProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Live TV',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.deepPurple,
              scaffoldBackgroundColor: Colors.white,
              textTheme: GoogleFonts.outfitTextTheme(ThemeData.light().textTheme),
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
              scaffoldBackgroundColor: const Color(0xFF121212),
              textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.tealAccent,
                brightness: Brightness.dark,
                surface: const Color(0xFF1E1E1E),
              ),
            ),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
