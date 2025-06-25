import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'pre-home/splash_screen.dart';
import 'home/home_page.dart';
import 'scanner/scanner_page.dart';
import 'services/weather_provider.dart';
import 'temp.dart';
import 'video/video.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherProvider(), // Registering the provider
      child: MaterialApp(
        title: 'Farmelon',
        theme: ThemeData(
          primaryColor: const Color(0xFFE66A6C),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE66A6C),
            primary: const Color(0xFFE66A6C),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFE66A6C),
            foregroundColor: Colors.white,
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/home': (context) => const HomePage(),
          '/videos': (context) => const VideoPage(),
          '/scanner': (context) => const ScannerPage(),
          '/store': (context) => const Home(),
        },
      ),
    );
  }
}
