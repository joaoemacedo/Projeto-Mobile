import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './provider/reservation_provider.dart';
import './models/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: const Color(0xFF8B322C),
          hintColor: const Color(0xFF8B322C),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          buttonTheme: const ButtonThemeData(
            buttonColor: Color(0xFF8B322C),
            textTheme: ButtonTextTheme.primary,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF8B322C),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
