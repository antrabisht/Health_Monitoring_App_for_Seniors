import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String role;

  const HomePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isDoctor = role == 'Doctor';

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${isDoctor ? "Doctor" : "User"}'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDoctor ? Icons.medical_services : Icons.favorite,
              size: 80,
              color: Colors.teal,
            ),
            const SizedBox(height: 20),
            Text(
              isDoctor
                  ? '🧑‍⚕️ Hello Doctor!\nYou can now monitor your patients.'
                  : '🧓 Hello User!\nLet\'s take care of your health.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
