import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> appointments = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _bookAppointment() async {
    TextEditingController doctorController = TextEditingController();
    TextEditingController purposeController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Book Appointment"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: doctorController,
                    decoration: const InputDecoration(
                      labelText: "Doctor's Name",
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: purposeController,
                    decoration: const InputDecoration(
                      labelText: "Purpose",
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text(selectedDate == null
                        ? "Pick Date"
                        : "Date: ${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}"),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Text(selectedTime == null
                        ? "Pick Time"
                        : "Time: ${selectedTime!.format(context)}"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (doctorController.text.isNotEmpty &&
                      purposeController.text.isNotEmpty &&
                      selectedDate != null &&
                      selectedTime != null) {
                   
                    setState(() {
                      DateTime appointmentDateTime = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                      appointments.add({
                        "doctor": doctorController.text,
                        "purpose": purposeController.text,
                        "dateTime": appointmentDateTime,
                        "status": "Upcoming",
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Book"),
              ),
            ],
          );
        },
      ),
    );
  }

  void _cancelAppointment(int index) {
    setState(() {
      appointments[index]["status"] = "Cancelled";
    });
  }

  void _updateAppointmentStatus() {
    DateTime now = DateTime.now();
    for (var appointment in appointments) {
      if (appointment["status"] == "Upcoming" &&
          appointment["dateTime"].isBefore(now)) {
        appointment["status"] = "Completed";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateAppointmentStatus();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Appointments"),
        automaticallyImplyLeading: false, 
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Upcoming"),
            Tab(text: "Completed"),
            Tab(text: "Cancelled"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentList("Upcoming"),
          _buildAppointmentList("Completed"),
          _buildAppointmentList("Cancelled"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bookAppointment,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAppointmentList(String status) {
    List<Map<String, dynamic>> filteredAppointments = appointments
        .where((appointment) => appointment["status"] == status)
        .toList();

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Text(
          "No $status appointments",
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        var appointment = filteredAppointments[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: ListTile(
            title: Text("Dr. ${appointment["doctor"]}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Purpose: ${appointment["purpose"]}"),
                Text(
                    "Date: ${appointment["dateTime"].day}-${appointment["dateTime"].month}-${appointment["dateTime"].year}"),
                Text(
                    "Time: ${TimeOfDay.fromDateTime(appointment["dateTime"]).format(context)}"),
                Text("Status: ${appointment["status"]}",
                    style: TextStyle(
                      color: appointment["status"] == "Upcoming"
                          ? Colors.orange
                          : appointment["status"] == "Completed"
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            trailing: status == "Upcoming"
                ? IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red),
              onPressed: () =>
                  _cancelAppointment(appointments.indexOf(appointment)),
            )
                : null,
          ),
        );
      },
    );
  }
}
