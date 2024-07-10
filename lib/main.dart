import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helpers/notification_helper.dart';
import 'package:uas_pbp/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await NotificationHelper().initNotifications();
  }

  // Inisiasi username dan password di shared preferences
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('username') && !prefs.containsKey('password')) {
    await prefs.setString('username', 'satrio');
    await prefs.setString('password', 'mukti');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
