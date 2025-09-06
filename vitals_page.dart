import 'package:flutter/material.dart';

class VitalsPage extends StatefulWidget {
  final String role;
  final String userName;
  final String email;

  const VitalsPage({Key? key, required this.role, this.userName = '', this.email = ''}) : super(key: key);

  @override
  State<VitalsPage> createState() => _VitalsPageState();
}

class _VitalsPageState extends State<VitalsPage> {
  final TextEditingController systolicController = TextEditingController();
  final TextEditingController diastolicController = TextEditingController();
  final TextEditingController sleepController = TextEditingController();
  final TextEditingController waterController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  void _checkReport() {
    String report = "Health Report:\n\n";
    report += "Blood Pressure: ${systolicController.text}/${diastolicController.text} mmHg\n";
    report += "Weight: ${weightController.text} kg\n";
    report += "Sleep Hours: ${sleepController.text}\n";
    report += "Water Intake: ${waterController.text} glasses\n";
    report += "Medical Condition: ${conditionController.text}\n";
    report += "Symptoms/Notes: ${symptomsController.text}\n";

    showDialog(
      context: context, 
      builder: (BuildContext context) { // 
        return AlertDialog(
          title: const Text("Your Health Report"),
          content: Text(report),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  void _emergencyAlert() {
    showDialog(
      context: context, 
      builder: (BuildContext context) { 
        return AlertDialog(
          title: const Text("🚨 Emergency Alert"),
          content: const Text("Critical vitals detected! Please seek help."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vitals"),
        backgroundColor: Colors.teal,
        
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: systolicController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Systolic (mmHg)"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: diastolicController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Diastolic (mmHg)"),
                  ),
                ),
              ],
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Weight (kg)"),
            ),
            TextField(
              controller: sleepController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Sleep Hours (per night)"),
            ),
            TextField(
              controller: waterController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Water Intake (glasses per day)"),
            ),
            TextField(
              controller: conditionController,
              decoration: const InputDecoration(labelText: "Medical Condition"),
            ),
            TextField(
              controller: symptomsController,
              decoration: const InputDecoration(labelText: "Symptoms"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: _checkReport,
              child: const Text("Check Your Report"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _emergencyAlert,
              child: const Text("🚨 Emergency Alert"),
            ),
          ],
        ),
      ),
    );
  }
}
