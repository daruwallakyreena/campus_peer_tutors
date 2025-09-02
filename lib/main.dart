import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'providers/tutor_provider.dart';
import 'screens/tutorregister.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://iizssydbqavuweidefbf.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlpenNzeWRicWF2dXdlaWRlZmJmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUxMTExNTYsImV4cCI6MjA3MDY4NzE1Nn0.gh1dZ6nFn2DvP-0KxjKnjaw0bFWJrW_UR0bofFrHk7Y',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TutorProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tutor Finder',
      home: const HomeScreen(),
    );
  }
}
