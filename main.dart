import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'user_dashboard.dart';
import 'vitals_page.dart';
import 'appointment_page.dart';
import 'app_theme.dart';

void main() {
  runApp(const MediSafeApp());
}

class MediSafeApp extends StatefulWidget {
  const MediSafeApp({super.key});

  @override
  State<MediSafeApp> createState() => _MediSafeAppState();
}

class _MediSafeAppState extends State<MediSafeApp> {
  final AppTheme _appTheme = AppTheme();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appTheme,
      builder: (context, child) {
        return MaterialApp(
          title: 'MediSafe',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.teal,
            fontFamily: 'Roboto',
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.teal[700],
            colorScheme: ColorScheme.dark(primary: Colors.teal[700]!),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.teal[700],
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          ),
          themeMode: _appTheme.themeMode,

          initialRoute: '/home',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => SignupScreen(),
            '/home': (context) => const HomeScreen(),
            '/dashboard': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map?;
              return UserDashboard(
                userName: args?['userName'] ?? '',
                email: args?['email'] ?? '',
              );
            },
            '/profile': (context) => const ProfileScreen(),
            '/vitals': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as Map?;
              return VitalsPage(role: args?['role'] ?? 'User');
            },
            '/appointment': (context) => const AppointmentPage(),

          },
        );
      },
    );
  }
}
