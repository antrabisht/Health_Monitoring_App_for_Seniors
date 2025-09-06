import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'profile_screen.dart';
import 'appointment_page.dart';
import 'vitals_page.dart';


class BloodPressure {
  final int systolic;
  final int diastolic;

  BloodPressure({required this.systolic, required this.diastolic});
}

enum ActivityType { medication, appointment, vitals }

class Activity {
  final String title;
  final String time;
  final bool completed;
  final ActivityType type;

  Activity({
    required this.title,
    required this.time,
    required this.completed,
    required this.type,
  });

  Activity copyWith({
    String? title,
    String? time,
    bool? completed,
    ActivityType? type,
  }) {
    return Activity(
      title: title ?? this.title,
      time: time ?? this.time,
      completed: completed ?? this.completed,
      type: type ?? this.type,
    );
  }
}

class UserDashboard extends StatefulWidget {
  final String userName;
  final String email;

  const UserDashboard({Key? key, required this.userName, required this.email})
      : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;
  String _currentTime = '';
  String _currentDate = '';
  String _greeting = '';

  // New variables for enhanced functionality
  int _todayMedicationCount = 3;
  int _todayAppointmentCount = 2;
  int _totalHealthRecords = 15;
  BloodPressure _latestBP = BloodPressure(systolic: 120, diastolic: 80);
  double _latestWeight = 68.5;
  double _previousWeight = 70.2;
  DateTime? _birthDate;
  List<Activity> _recentActivities = [
    Activity(
      title: "Medication taken",
      time: "8:00 AM",
      completed: true,
      type: ActivityType.medication,
    ),
    Activity(
      title: "Appointment booked",
      time: "10:30 AM",
      completed: false,
      type: ActivityType.appointment,
    ),
    Activity(
      title: "BP recorded",
      time: "2:00 PM",
      completed: false,
      type: ActivityType.vitals,
    ),
  ];

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _birthDate = DateTime(1985, 3, 15); // Example birthdate
    _updateTime();
    _loadHealthData();

    // Initialize pages
    _pages = [
      _buildHomePage(),
      _buildVitalsPage(),
      _buildAppointmentsPage(),
      ProfileScreen(userName: widget.userName, email: widget.email),
    ];

   
    Future.delayed(const Duration(minutes: 1), () {
      if (mounted) {
        setState(() {
          _updateTime();
        });
      }
    });
  }

  Future<void> _loadHealthData() async {
    // Simulate loading data from database/API
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _todayMedicationCount = 3;
      _todayAppointmentCount = 2;
      _totalHealthRecords = 15;
      _latestBP = BloodPressure(systolic: 120, diastolic: 80);
      _latestWeight = 68.5;
      _previousWeight = 70.2;
    });
  }

  void _updateTime() {
    final now = DateTime.now();

    // Set time in 12-hour format with AM/PM
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final amPm = now.hour < 12 ? 'AM' : 'PM';
    setState(() {
      _currentTime = '$hour:$minute $amPm';
    });

  
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    setState(() {
      _currentDate = '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}';
    });

   
    if (now.hour < 12) {
      setState(() {
        _greeting = 'Good Morning';
      });
    } else if (now.hour < 17) {
      setState(() {
        _greeting = 'Good Afternoon';
      });
    } else {
      setState(() {
        _greeting = 'Good Evening';
      });
    }
  }


  Widget _buildStatCard(IconData icon, String value, String label, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Icon(icon, color: Colors.teal, size: 28),
                const SizedBox(height: 6),
                Text(value,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text(label,
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopRowCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard(
            Icons.medical_services,
            _todayMedicationCount.toString(),
            "Medications\nToday",
            onTap: () => _showMedicationList(),
          ),
          _buildStatCard(
            Icons.calendar_today,
            _todayAppointmentCount.toString(),
            "Appointments\nToday",
            onTap: () => _showAppointmentDetails(),
          ),
          _buildStatCard(
            Icons.folder,
            _totalHealthRecords.toString(),
            "Health\nRecords",
            onTap: () => _browseHealthRecords(),
          ),
        ],
      ),
    );
  }

  void _showMedicationList() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Today\'s Medications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('$_todayMedicationCount medications scheduled for today'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppointmentDetails() {
   
    setState(() => _selectedIndex = 2);
  }

  void _browseHealthRecords() {
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Health Records'),
        content: Text('You have $_totalHealthRecords health records available.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }


  Widget _buildHealthSummaryCard(IconData icon, Widget valueWidget, String label) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: Colors.teal, size: 28),
              const SizedBox(height: 6),
              valueWidget,
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBPWithTrend() {
    final trend = _latestBP.systolic <= 120 && _latestBP.diastolic <= 80
        ? Icons.arrow_downward
        : Icons.arrow_upward;
    final trendColor = _latestBP.systolic <= 120 && _latestBP.diastolic <= 80
        ? Colors.green
        : Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${_latestBP.systolic}/${_latestBP.diastolic}",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(width: 4),
        Icon(trend, size: 16, color: trendColor),
      ],
    );
  }

  Widget _buildWeightWithChange() {
    final weightChange = _latestWeight - _previousWeight;
    final trendIcon = weightChange <= 0 ? Icons.arrow_downward : Icons.arrow_upward;
    final trendColor = weightChange <= 0 ? Colors.green : Colors.red;
    final changeText = weightChange.abs().toStringAsFixed(1);

    return Column(
      children: [
        Text("${_latestWeight} kg",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(trendIcon, size: 12, color: trendColor),
            SizedBox(width: 2),
            Text("$changeText kg", style: TextStyle(fontSize: 10, color: trendColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildDynamicAge() {
    if (_birthDate == null) return Text("0", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));

    final age = DateTime.now().difference(_birthDate!).inDays ~/ 365;
    return Text("$age", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildHealthSummaryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHealthSummaryCard(Icons.favorite, _buildBPWithTrend(), "Blood Pressure"),
          _buildHealthSummaryCard(Icons.monitor_weight, _buildWeightWithChange(), "Weight"),
          _buildHealthSummaryCard(Icons.cake, _buildDynamicAge(), "Age"),
        ],
      ),
    );
  }

 
  Widget _buildActivityItem(Activity activity, int index) {
    return Dismissible(
      key: Key(activity.title + index.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.check_circle, color: Colors.white, size: 36),
      ),
      onDismissed: (direction) {
        setState(() {
          _recentActivities[index] = activity.copyWith(
            completed: true,
            time: DateFormat('h:mm a').format(DateTime.now()),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${activity.title} marked as completed')),
        );
      },
      child: ListTile(
        leading: Icon(
          _getActivityIcon(activity.type),
          color: activity.completed ? Colors.teal : Colors.grey,
        ),
        title: Text(
          activity.title,
          style: TextStyle(
            decoration: activity.completed ? TextDecoration.lineThrough : TextDecoration.none,
            color: activity.completed ? Colors.grey : Colors.black,
          ),
        ),
        trailing: Text(
          activity.time,
          style: TextStyle(
            color: activity.completed ? Colors.teal : Colors.grey,
          ),
        ),
        onTap: () {
          setState(() {
            _recentActivities[index] = activity.copyWith(
              completed: !activity.completed,
              time: activity.completed ? activity.time : DateFormat('h:mm a').format(DateTime.now()),
            );
          });
        },
      ),
    );
  }

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.medication:
        return Icons.medical_services;
      case ActivityType.appointment:
        return Icons.calendar_today;
      case ActivityType.vitals:
        return Icons.favorite;
      default:
        return Icons.check_circle;
    }
  }

  Widget _buildRecentActivities() {
    return Column(
      children: _recentActivities.asMap().entries.map((entry) {
        return _buildActivityItem(entry.value, entry.key);
      }).toList(),
    );
  }

  
  Widget _buildHomePage() {
    return RefreshIndicator(
      onRefresh: _loadHealthData,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with real-time date and time
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$_greeting, ${widget.userName}!",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$_currentDate – $_currentTime",
                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

           
            _buildTopRowCards(),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Today's Health Summary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 10),

            // Enhanced Health Summary
            _buildHealthSummaryRow(),

            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Recent Activities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

           
            _buildRecentActivities(),
          ],
        ),
      ),
    );
  }

  Widget _buildVitalsPage() {
    return VitalsPage(
      role: widget.userName,
      userName: widget.userName,
      email: widget.email,
    );
  }


  Widget _buildAppointmentsPage() {
    return const AppointmentPage();
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Vitals"),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Appointments"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
