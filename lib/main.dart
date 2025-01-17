import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tebak_gambar/utils/progressprovider.dart';
import 'utils/splash.dart'; // Import the SplashScreen

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProgressProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DenkMeister',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Disable debug banner
      home: const Splash(), // Set SplashScreen as the home widget
    );
  }
}
